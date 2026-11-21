// FILE: src/pdf_canvas.h
// PURPOSE: Core PDF rendering using pdfgen.
// 🚀 FAANG FIX: Lazy Page-Buffer Replay (0 MB RAM overhead for standard PDFs!), Multi-Page Slicing & CMYK!

#pragma once
#include <string>
#include <vector>
#include <iostream>
#include <cstring>
#include <cstdint>
#include <cmath>
#include <sstream>
#include <algorithm>
#include "render_engine.h"
#include "image_engine.h"
#include "font_engine.h"
#include "clip_engine.h"
#include "svg_engine.h"

#ifdef CANVAS_ENABLE_PDF
extern "C" {
#include "pdfgen.h"
}
#endif

namespace CoreCanvas {

#ifdef CANVAS_ENABLE_PDF
    class PdfCanvas : public IRenderTarget {
    private:
        struct SolidFillRecord {
            double x = 0.0;
            double localY = 0.0;
            double w = 0.0;
            double segH = 0.0;
            double fullH = 0.0;
            double sliceOffsetY = 0.0;
            int shape = 0;
            std::optional<EdgeInsets> borderRadius;
            uint8_t r = 255, g = 255, b = 255;
        };

        struct pdf_doc* pdf;
        std::vector<struct pdf_object*> pages;
        std::vector<int> clipPageStack;
        std::vector<int> transformPageStack;
        double pageHeight;
        double pageWidth;
        int colorSpace = 0;

        // Lazy page buffers: only allocated on pages that actually invoke a non-normal BlendMode!
        std::vector<std::vector<uint8_t>> pageBuffers;
        std::vector<std::vector<SolidFillRecord>> pageSolidFills;
        int bufW = 0;
        int bufH = 0;

        // Applies Grayscale (1) or CMYK Print Gamut (2) to any 0xAARRGGBB color
        uint32_t applyColorSpaceIfRequired(uint32_t argb) const {
            if (colorSpace == 0) return argb;
            uint8_t a = (argb >> 24) & 0xFF;
            uint8_t r = (argb >> 16) & 0xFF;
            uint8_t g = (argb >> 8) & 0xFF;
            uint8_t b = argb & 0xFF;

            if (colorSpace == 1) {
                uint8_t gray = static_cast<uint8_t>(0.299 * r + 0.587 * g + 0.114 * b);
                return (static_cast<uint32_t>(a) << 24) | (static_cast<uint32_t>(gray) << 16) |
                       (static_cast<uint32_t>(gray) << 8) | gray;
            } else if (colorSpace == 2) {
                uint8_t px[4] = {r, g, b, a};
                ImageEngine::applyColorSpace(px, 1, 1, 2);
                return (static_cast<uint32_t>(a) << 24) | (static_cast<uint32_t>(px[0]) << 16) |
                       (static_cast<uint32_t>(px[1]) << 8) | px[2];
            }
            return argb;
        }

        uint32_t toPdfColorText(uint32_t argb) const {
            argb = applyColorSpaceIfRequired(argb);
            uint8_t r = (argb >> 16) & 0xFF;
            uint8_t g = (argb >> 8) & 0xFF;
            uint8_t b = argb & 0xFF;
            return PDF_RGB(r, g, b);
        }

        struct pdf_object* getOrCreatePage(int pageIndex) {
            if (pageIndex < 0) pageIndex = 0;
            while (pageIndex >= static_cast<int>(pages.size())) {
                pages.push_back(pdf_append_page(pdf));
                pageBuffers.emplace_back();
                pageSolidFills.emplace_back();
            }
            return pages[pageIndex];
        }

        static bool isInsideRoundedOrCircle(
                double px,
                double py,
                double w,
                double h,
                int shape,
                const std::optional<EdgeInsets>& borderRadius
        ) {
            double maxR = std::min(w, h) / 2.0;
            double tl = 0, tr = 0, br = 0, bl = 0;
            if (shape == 1) {
                double cx = w / 2.0, cy = h / 2.0;
                double dx = px - cx, dy = py - cy;
                return (dx * dx + dy * dy) <= (maxR * maxR);
            } else if (borderRadius.has_value()) {
                tl = std::min(borderRadius->top, maxR);
                tr = std::min(borderRadius->right, maxR);
                br = std::min(borderRadius->bottom, maxR);
                bl = std::min(borderRadius->left, maxR);
            }

            if (tl > 0 && px < tl && py < tl) return (px - tl)*(px - tl) + (py - tl)*(py - tl) <= tl*tl;
            if (tr > 0 && px > w - tr && py < tr) return (px - (w - tr))*(px - (w - tr)) + (py - tr)*(py - tr) <= tr*tr;
            if (br > 0 && px > w - br && py > h - br) return (px - (w - br))*(px - (w - br)) + (py - (h - br))*(py - (h - br)) <= br*br;
            if (bl > 0 && px < bl && py > h - bl) return (px - bl)*(px - bl) + (py - (h - bl))*(py - (h - bl)) <= bl*bl;
            return true;
        }

        static bool isInsideBoxShape(double px, double py, double w, double h, const BoxDecoration& d) {
            return isInsideRoundedOrCircle(px, py, w, h, d.shape, d.borderRadius);
        }

        void rasterizeSolidRecordIntoBuffer(std::vector<uint8_t>& pageBuf, const SolidFillRecord& rec) const {
            int pw = std::max(1, static_cast<int>(std::ceil(rec.w)));
            int ph = std::max(1, static_cast<int>(std::ceil(rec.segH)));
            for (int iy = 0; iy < ph; ++iy) {
                int gy = static_cast<int>(std::round(rec.localY)) + iy;
                if (gy < 0 || gy >= bufH) continue;
                double fullBoxY = rec.sliceOffsetY + iy + 0.5;
                for (int ix = 0; ix < pw; ++ix) {
                    int gx = static_cast<int>(std::round(rec.x)) + ix;
                    if (gx < 0 || gx >= bufW) continue;
                    if (isInsideRoundedOrCircle(ix + 0.5, fullBoxY, rec.w, rec.fullH, rec.shape, rec.borderRadius)) {
                        int pIdx = (gy * bufW + gx) * 4;
                        pageBuf[pIdx + 0] = rec.r;
                        pageBuf[pIdx + 1] = rec.g;
                        pageBuf[pIdx + 2] = rec.b;
                        pageBuf[pIdx + 3] = 255;
                    }
                }
            }
        }

        // Allocates 2 MB RGBA page buffer ONLY when BlendMode != 0 is actually encountered,
        // and replays any previously drawn solid fills onto it for exact blend accuracy.
        std::vector<uint8_t>& ensurePageBufferWithReplay(int pageIndex) {
            getOrCreatePage(pageIndex);
            if (pageBuffers[pageIndex].empty()) {
                pageBuffers[pageIndex].assign(static_cast<size_t>(bufW) * static_cast<size_t>(bufH) * 4, 255);
                for (const auto& rec : pageSolidFills[pageIndex]) {
                    rasterizeSolidRecordIntoBuffer(pageBuffers[pageIndex], rec);
                }
                pageSolidFills[pageIndex].clear();
            }
            return pageBuffers[pageIndex];
        }

        static bool containsNonAsciiBytes(const std::string& text) {
            for (unsigned char c : text) {
                if (c > 127) return true;
            }
            return false;
        }

        static bool isStandardPdfFontName(const std::string& fontName) {
            if (fontName.empty()) return true;
            std::string lower = fontName;
            std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);
            return (lower == "helvetica" || lower == "times" || lower == "times-roman" || lower == "courier");
        }

        static std::string resolveBuiltInPdfFont(const std::string& baseFamily, int weight, int style) {
            std::string lower = baseFamily;
            std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);
            bool isBold = (weight >= 600);
            bool isItalic = (style == 1 || style == 2);

            if (lower == "times" || lower == "times-roman") {
                if (isBold && isItalic) return "Times-BoldItalic";
                if (isBold) return "Times-Bold";
                if (isItalic) return "Times-Italic";
                return "Times-Roman";
            }
            if (lower == "courier") {
                if (isBold && isItalic) return "Courier-BoldOblique";
                if (isBold) return "Courier-Bold";
                if (isItalic) return "Courier-Oblique";
                return "Courier";
            }
            if (isBold && isItalic) return "Helvetica-BoldOblique";
            if (isBold) return "Helvetica-Bold";
            if (isItalic) return "Helvetica-Oblique";
            return "Helvetica";
        }

        static std::string extractCopyableAscii(const std::string& text) {
            std::string out;
            out.reserve(text.size());
            for (unsigned char c : text) {
                if (c >= 32 && c <= 126) {
                    if (c == '(' || c == ')' || c == '\\') out.push_back('\\');
                    out.push_back(static_cast<char>(c));
                } else if (c == '\n' || c == '\t') {
                    out.push_back(' ');
                }
            }
            return out;
        }

        static double projectGradientAngle(double nx, double ny, double angleDeg) {
            if (std::abs(angleDeg) < 1e-4) {
                return std::clamp(nx * 0.65 + ny * 0.35, 0.0, 1.0);
            }
            double rad = angleDeg * (3.14159265358979323846 / 180.0);
            double dx = std::cos(rad);
            double dy = std::sin(rad);
            double maxProj = (std::abs(dx) + std::abs(dy)) * 0.5;
            if (maxProj < 1e-5) maxProj = 0.5;
            double proj = ((nx - 0.5) * dx + (ny - 0.5) * dy) / (2.0 * maxProj) + 0.5;
            return std::clamp(proj, 0.0, 1.0);
        }

        static uint32_t sampleGradient(const std::vector<int>& stops, double t) {
            if (stops.empty()) return 0xFF000000;
            if (stops.size() == 1) return static_cast<uint32_t>(stops[0]);
            t = std::clamp(t, 0.0, 1.0);
            double scaled = t * (stops.size() - 1);
            size_t idx = static_cast<size_t>(std::floor(scaled));
            if (idx >= stops.size() - 1) return static_cast<uint32_t>(stops.back());
            double frac = scaled - idx;

            uint32_t c1 = static_cast<uint32_t>(stops[idx]);
            uint32_t c2 = static_cast<uint32_t>(stops[idx + 1]);

            uint8_t a1 = (c1 >> 24) & 0xFF, r1 = (c1 >> 16) & 0xFF, g1 = (c1 >> 8) & 0xFF, b1 = c1 & 0xFF;
            uint8_t a2 = (c2 >> 24) & 0xFF, r2 = (c2 >> 16) & 0xFF, g2 = (c2 >> 8) & 0xFF, b2 = c2 & 0xFF;

            uint8_t a = static_cast<uint8_t>(a1 + (a2 - a1) * frac);
            uint8_t r = static_cast<uint8_t>(r1 + (r2 - r1) * frac);
            uint8_t g = static_cast<uint8_t>(g1 + (g2 - g1) * frac);
            uint8_t b = static_cast<uint8_t>(b1 + (b2 - b1) * frac);

            return (static_cast<uint32_t>(a) << 24) | (static_cast<uint32_t>(r) << 16) |
                   (static_cast<uint32_t>(g) << 8) | static_cast<uint32_t>(b);
        }

        static uint8_t blendChannel(int mode, uint8_t s, uint8_t d) {
            double sf = s / 255.0, df = d / 255.0, res = sf;
            switch (mode) {
                case 1: res = sf * df; break;
                case 2: res = 1.0 - (1.0 - sf) * (1.0 - df); break;
                case 3: res = (df < 0.5) ? (2.0 * sf * df) : (1.0 - 2.0 * (1.0 - sf) * (1.0 - df)); break;
                case 4: res = std::min(sf, df); break;
                case 5: res = std::max(sf, df); break;
                case 6: res = (sf >= 1.0) ? 1.0 : std::min(1.0, df / (1.0 - sf)); break;
                case 7: res = (sf <= 0.0) ? 0.0 : (1.0 - std::min(1.0, (1.0 - df) / sf)); break;
                case 8: res = (sf < 0.5) ? (2.0 * sf * df) : (1.0 - 2.0 * (1.0 - sf) * (1.0 - df)); break;
                case 9: res = (1.0 - 2.0 * sf) * df * df + 2.0 * sf * df; break;
                case 10: res = std::abs(df - sf); break;
                case 11: res = df + sf - 2.0 * df * sf; break;
                default: res = sf; break;
            }
            return static_cast<uint8_t>(std::clamp(std::round(res * 255.0), 0.0, 255.0));
        }

        // Open-ended sliced border: draws topEdge only on startPage and bottomEdge only on endPage
        void drawVectorBorder(
                struct pdf_object* currentPage,
                double x,
                double y,
                double w,
                double h,
                const BoxDecoration& d,
                bool drawTopEdge = true,
                bool drawBottomEdge = true
        ) {
            if (!d.borderColor.has_value() || !d.borderWidth.has_value()) return;
            const auto& bw = d.borderWidth.value();
            bool hasAnyBorder = (bw.top > 0.0 || bw.right > 0.0 || bw.bottom > 0.0 || bw.left > 0.0);
            if (!hasAnyBorder) return;

            uint32_t bc = applyColorSpaceIfRequired(d.borderColor.value());
            uint8_t r = (bc >> 16) & 0xFF, g = (bc >> 8) & 0xFF, b = bc & 0xFF;

            double localY = y - (std::floor(y / pageHeight) * pageHeight);
            double pdfY = pageHeight - localY - h;

            bool isSlicedAcrossPages = (!drawTopEdge || !drawBottomEdge);
            bool isUniform = (std::abs(bw.top - bw.right) < 1e-3 &&
                              std::abs(bw.top - bw.bottom) < 1e-3 &&
                              std::abs(bw.top - bw.left) < 1e-3);

            std::ostringstream cmd;
            cmd << "q\n";
            cmd << (r / 255.0) << " " << (g / 255.0) << " " << (b / 255.0) << " RG\n";

            double maxStrokeW = std::max({bw.top, bw.right, bw.bottom, bw.left});
            if (d.borderDash.has_value() && !d.borderDash->empty()) {
                cmd << "[ ";
                for (double val : d.borderDash.value()) cmd << val << " ";
                cmd << "] 0 d\n0 J\n";
            } else if (d.borderStyle == 1) {
                cmd << "[ " << (maxStrokeW * 3.0) << " " << (maxStrokeW * 2.0) << " ] 0 d\n0 J\n";
            } else if (d.borderStyle == 2) {
                cmd << "[ " << maxStrokeW << " " << (maxStrokeW * 1.6) << " ] 0 d\n1 J\n";
            }

            if (isSlicedAcrossPages || (!isUniform && d.shape == 0 && !d.borderRadius.has_value())) {
                if (drawTopEdge && bw.top > 0) {
                    cmd << bw.top << " w\n" << x << " " << (pdfY + h) << " m " << (x + w) << " " << (pdfY + h) << " l S\n";
                }
                if (bw.right > 0) {
                    cmd << bw.right << " w\n" << (x + w) << " " << (pdfY + h) << " m " << (x + w) << " " << pdfY << " l S\n";
                }
                if (drawBottomEdge && bw.bottom > 0) {
                    cmd << bw.bottom << " w\n" << x << " " << pdfY << " m " << (x + w) << " " << pdfY << " l S\n";
                }
                if (bw.left > 0) {
                    cmd << bw.left << " w\n" << x << " " << pdfY << " m " << x << " " << (pdfY + h) << " l S\n";
                }
                cmd << "Q\n";
                pdf_inject_raw(pdf, currentPage, cmd.str().c_str());
                return;
            }

            cmd << maxStrokeW << " w\n";

            if (d.shape == 1 || d.borderRadius.has_value()) {
                std::string pathCmd = ClipEngine::generateClipPath(w, h, x, y, pageHeight, d);
                if (!pathCmd.empty()) {
                    cmd << pathCmd << "S\n";
                } else {
                    cmd << x << " " << pdfY << " " << w << " " << h << " re S\n";
                }
            } else {
                cmd << x << " " << pdfY << " " << w << " " << h << " re S\n";
            }

            cmd << "Q\n";
            pdf_inject_raw(pdf, currentPage, cmd.str().c_str());
        }

        static std::vector<std::string> wrapParagraphLines(const std::string& text, const std::string& fontName, double fontSize, double maxWidth) {
            std::vector<std::string> outLines;
            std::stringstream ss(text);
            std::string rawParagraph;

            while (std::getline(ss, rawParagraph, '\n')) {
                if (rawParagraph.empty()) {
                    outLines.push_back("");
                    continue;
                }
                if (maxWidth <= 0) {
                    outLines.push_back(rawParagraph);
                    continue;
                }

                std::istringstream wordStream(rawParagraph);
                std::string word;
                std::string currentLine;

                while (wordStream >> word) {
                    std::string candidate = currentLine.empty() ? word : (currentLine + " " + word);
                    YGSize sz = FontEngine::getInstance().measureText(candidate, fontName, fontSize, -1.0);
                    if (sz.width > maxWidth && !currentLine.empty()) {
                        outLines.push_back(currentLine);
                        currentLine = word;
                    } else {
                        currentLine = candidate;
                    }
                }
                if (!currentLine.empty()) {
                    outLines.push_back(currentLine);
                }
            }
            if (outLines.empty()) outLines.push_back(text);
            return outLines;
        }

    public:
        PdfCanvas(const CanvasConfig& config, const std::optional<DocumentInfo>& info) {
            pageWidth = config.w;
            pageHeight = config.h;
            colorSpace = config.colorSpace;
            bufW = std::max(1, static_cast<int>(std::ceil(pageWidth)));
            bufH = std::max(1, static_cast<int>(std::ceil(pageHeight)));

            struct pdf_info pdfInfo;
            std::memset(&pdfInfo, 0, sizeof(pdfInfo));

            if (info.has_value()) {
                if (info->creator.has_value()) std::strncpy(pdfInfo.creator, info->creator.value().c_str(), 63);
                if (info->producer.has_value()) std::strncpy(pdfInfo.producer, info->producer.value().c_str(), 63);
                if (info->title.has_value()) std::strncpy(pdfInfo.title, info->title.value().c_str(), 63);
                if (info->author.has_value()) std::strncpy(pdfInfo.author, info->author.value().c_str(), 63);
                if (info->subject.has_value()) std::strncpy(pdfInfo.subject, info->subject.value().c_str(), 63);
                if (info->creationDate.has_value()) std::strncpy(pdfInfo.date, info->creationDate.value().c_str(), 63);
            } else {
                std::strncpy(pdfInfo.creator, "Core Canvas Engine", 63);
            }

            pdf = pdf_create(pageWidth, pageHeight, &pdfInfo);
            pdf_set_font(pdf, "Helvetica");
            pages.push_back(pdf_append_page(pdf));
            pageBuffers.emplace_back();
            pageSolidFills.emplace_back();
        }

        ~PdfCanvas() {
            if (pdf) pdf_destroy(pdf);
        }

        bool saveToFile(const std::string& path) {
            return pdf_save(pdf, path.c_str()) == 0;
        }

        int getPageCount() const {
            return static_cast<int>(pages.size());
        }

        double getPageHeight() override {
            return pageHeight;
        }

        void addBookmark(double y, const std::string& title) override {
            if (title.empty()) return;
            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            pdf_add_bookmark(pdf, currentPage, -1, title.c_str());
        }

        // Clickable PDF Hyperlinks (Invisible URI layer for viewer link detection)
        void addLink(double x, double y, double w, double h, const std::string& url) override {
            if (url.empty() || w <= 0 || h <= 0) return;
            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double localY = y - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - h;

            std::string safeUrl = extractCopyableAscii(url);
            if (safeUrl.empty()) return;

            double linkFontSize = std::clamp(h * 0.45, 6.0, 14.0);
            double baselineY = pdfY + (h / 2.0) - (linkFontSize * 0.35);

            std::ostringstream linkCmd;
            linkCmd << "q\nBT\n3 Tr\n/F1 " << linkFontSize << " Tf\n"
                    << x << " " << baselineY << " Td\n(" << safeUrl << ") Tj\nET\nQ\n";
            pdf_inject_raw(pdf, currentPage, linkCmd.str().c_str());
        }

        void drawBox(double x, double y, double w, double h, const std::optional<BoxDecoration>& deco) override {
            if (!deco.has_value() || w <= 0 || h <= 0) return;
            const auto& d = deco.value();

            bool hasFill = d.backgroundColor.has_value();
            bool hasGradient = d.gradient.has_value() && !d.gradient->empty();
            bool hasBgImage = d.backgroundImage.has_value() && !d.backgroundImage->empty();
            bool hasBorder = d.borderColor.has_value() && d.borderWidth.has_value() &&
                             (d.borderWidth->top > 0 || d.borderWidth->right > 0 || d.borderWidth->bottom > 0 || d.borderWidth->left > 0);

            if (!hasFill && !hasGradient && !hasBgImage && !hasBorder) return;

            int startPage = static_cast<int>(std::floor(y / pageHeight));
            int endPage = static_cast<int>(std::floor((y + std::max(0.001, h - 0.001)) / pageHeight));

            for (int pageIdx = startPage; pageIdx <= endPage; ++pageIdx) {
                struct pdf_object* currentPage = getOrCreatePage(pageIdx);
                double pageTopY = pageIdx * pageHeight;
                double pageBottomY = (pageIdx + 1) * pageHeight;

                double segTopY = std::max(y, pageTopY);
                double segBottomY = std::min(y + h, pageBottomY);
                double segH = segBottomY - segTopY;
                if (segH <= 0.001) continue;

                double localY = segTopY - pageTopY;
                double pdfY = pageHeight - localY - segH;
                double sliceOffsetY = segTopY - y;

                uint8_t fillA = hasFill ? ((d.backgroundColor.value() >> 24) & 0xFF) : 255;
                double effectiveOpacity = std::clamp(d.opacity, 0.0, 1.0);
                bool needsRasterFill = hasGradient || hasBgImage || (d.blendMode != 0) ||
                                       (effectiveOpacity < 0.999) || (hasFill && fillA < 255);

                if (hasFill || hasGradient || hasBgImage) {
                    int pw = std::max(1, static_cast<int>(std::ceil(w)));
                    int ph = std::max(1, static_cast<int>(std::ceil(segH)));

                    if (needsRasterFill) {
                        // Only allocate the 2 MB page buffer if BlendMode != 0 is requested (or if already allocated)
                        std::vector<uint8_t>* activePageBuf = nullptr;
                        if (d.blendMode != 0) {
                            activePageBuf = &ensurePageBufferWithReplay(pageIdx);
                        } else if (!pageBuffers[pageIdx].empty()) {
                            activePageBuf = &pageBuffers[pageIdx];
                        }

                        std::vector<uint8_t> boxPixels(static_cast<size_t>(pw) * static_cast<size_t>(ph) * 4, 0);
                        ImageBuffer bgImg;
                        if (hasBgImage) {
                            bgImg = ImageEngine::decodeImage(d.backgroundImage.value());
                        }

                        for (int iy = 0; iy < ph; ++iy) {
                            double fullBoxY = sliceOffsetY + iy + 0.5;
                            for (int ix = 0; ix < pw; ++ix) {
                                if (!isInsideBoxShape(ix + 0.5, fullBoxY, w, h, d)) continue;

                                uint8_t sR = 0, sG = 0, sB = 0, sA = 0;

                                if (hasGradient) {
                                    double t = projectGradientAngle(ix / std::max(1.0, w), fullBoxY / std::max(1.0, h), d.gradientAngle);
                                    uint32_t gc = applyColorSpaceIfRequired(sampleGradient(d.gradient.value(), t));
                                    sA = (gc >> 24) & 0xFF;
                                    sR = (gc >> 16) & 0xFF;
                                    sG = (gc >> 8) & 0xFF;
                                    sB = gc & 0xFF;
                                } else if (hasFill) {
                                    uint32_t fc = applyColorSpaceIfRequired(d.backgroundColor.value());
                                    sA = (fc >> 24) & 0xFF;
                                    sR = (fc >> 16) & 0xFF;
                                    sG = (fc >> 8) & 0xFF;
                                    sB = fc & 0xFF;
                                }

                                if (bgImg.pixels && bgImg.width > 0 && bgImg.height > 0) {
                                    ImageProps coverProps;
                                    coverProps.fit = 3;
                                    coverProps.alignment = 0;
                                    ImageDrawRect fitRect = ImageEngine::calculateFit(w, h, bgImg.width, bgImg.height, coverProps);
                                    double relX = (ix - fitRect.x) / std::max(1.0, fitRect.w);
                                    double relY = (fullBoxY - fitRect.y) / std::max(1.0, fitRect.h);
                                    int imgX = std::clamp(static_cast<int>(relX * bgImg.width), 0, bgImg.width - 1);
                                    int imgY = std::clamp(static_cast<int>(relY * bgImg.height), 0, bgImg.height - 1);
                                    int imgIdx = (imgY * bgImg.width + imgX) * 4;
                                    uint8_t iA = bgImg.pixels[imgIdx + 3];
                                    if (iA > 0) {
                                        double ia = iA / 255.0;
                                        sR = static_cast<uint8_t>(bgImg.pixels[imgIdx + 0] * ia + sR * (1.0 - ia));
                                        sG = static_cast<uint8_t>(bgImg.pixels[imgIdx + 1] * ia + sG * (1.0 - ia));
                                        sB = static_cast<uint8_t>(bgImg.pixels[imgIdx + 2] * ia + sB * (1.0 - ia));
                                        sA = std::max(sA, iA);
                                    }
                                }

                                sA = static_cast<uint8_t>(std::clamp(std::round(sA * effectiveOpacity), 0.0, 255.0));
                                if (sA == 0) continue;

                                if (activePageBuf) {
                                    int gx = static_cast<int>(std::round(x)) + ix;
                                    int gy = static_cast<int>(std::round(localY)) + iy;

                                    if (gx >= 0 && gx < bufW && gy >= 0 && gy < bufH) {
                                        int pIdx = (gy * bufW + gx) * 4;
                                        uint8_t dR = (*activePageBuf)[pIdx + 0];
                                        uint8_t dG = (*activePageBuf)[pIdx + 1];
                                        uint8_t dB = (*activePageBuf)[pIdx + 2];
                                        if (d.blendMode != 0) {
                                            sR = blendChannel(d.blendMode, sR, dR);
                                            sG = blendChannel(d.blendMode, sG, dG);
                                            sB = blendChannel(d.blendMode, sB, dB);
                                        }
                                        double aNorm = sA / 255.0;
                                        (*activePageBuf)[pIdx + 0] = static_cast<uint8_t>(sR * aNorm + dR * (1.0 - aNorm));
                                        (*activePageBuf)[pIdx + 1] = static_cast<uint8_t>(sG * aNorm + dG * (1.0 - aNorm));
                                        (*activePageBuf)[pIdx + 2] = static_cast<uint8_t>(sB * aNorm + dB * (1.0 - aNorm));
                                    }
                                }

                                int outIdx = (iy * pw + ix) * 4;
                                boxPixels[outIdx + 0] = sR;
                                boxPixels[outIdx + 1] = sG;
                                boxPixels[outIdx + 2] = sB;
                                boxPixels[outIdx + 3] = sA;
                            }
                        }

                        ImageEngine::applyColorSpace(boxPixels.data(), pw, ph, colorSpace);
                        pdf_add_rgba_raw_image(pdf, currentPage, x, pdfY, w, segH, boxPixels.data(), pw, ph);
                    } else if (hasFill) {
                        uint32_t fc = applyColorSpaceIfRequired(d.backgroundColor.value());
                        uint8_t r = (fc >> 16) & 0xFF, g = (fc >> 8) & 0xFF, b = fc & 0xFF;

                        // Zero-RAM fast path: record tiny 64-byte geometry instead of allocating a 2 MB buffer!
                        SolidFillRecord rec{x, localY, w, segH, h, sliceOffsetY, d.shape, d.borderRadius, r, g, b};
                        if (!pageBuffers[pageIdx].empty()) {
                            rasterizeSolidRecordIntoBuffer(pageBuffers[pageIdx], rec);
                        } else {
                            pageSolidFills[pageIdx].push_back(std::move(rec));
                        }

                        if ((d.shape == 1 || d.borderRadius.has_value()) && startPage == endPage) {
                            std::string pathCmd = ClipEngine::generateClipPath(w, segH, x, segTopY, pageHeight, d);
                            if (!pathCmd.empty()) {
                                std::ostringstream cmd;
                                cmd << "q\n" << (r / 255.0) << " " << (g / 255.0) << " " << (b / 255.0) << " rg\n";
                                cmd << pathCmd << "f\nQ\n";
                                pdf_inject_raw(pdf, currentPage, cmd.str().c_str());
                            } else {
                                pdf_add_filled_rectangle(pdf, currentPage, x, pdfY, w, segH, 0.0, toPdfColorText(fc), 0);
                            }
                        } else {
                            pdf_add_filled_rectangle(pdf, currentPage, x, pdfY, w, segH, 0.0, toPdfColorText(fc), 0);
                        }
                    }
                }

                if (hasBorder) {
                    bool isFirstSlice = (pageIdx == startPage);
                    bool isLastSlice = (pageIdx == endPage);
                    drawVectorBorder(currentPage, x, segTopY, w, segH, d, isFirstSlice, isLastSlice);
                }
            }
        }

        void drawText(double x, double y, double w, double h, const std::string& text, const std::optional<Typography>& typo) override {
            drawText(x, y, w, h, text, typo, std::nullopt);
        }

        void drawText(
                double x,
                double y,
                double w,
                double h,
                const std::string& text,
                const std::optional<Typography>& typo,
                const std::optional<std::string>& rasterMask
        ) override {
            if (text.empty() || w <= 0 || h <= 0) return;

            double fontSize = 12.0;
            double lineHeightMult = 1.2;
            double baselineOffset = 0.0;
            uint32_t rawColor = 0xFF000000;
            int align = 0, weight = 400, style = 0, textDeco = 0;
            std::string fontName = "Helvetica";

            if (typo.has_value()) {
                rawColor = applyColorSpaceIfRequired(typo.value().color);
                fontSize = typo.value().fontSize;
                lineHeightMult = typo.value().lineHeight;
                baselineOffset = typo.value().baselineOffset;
                align = typo.value().align;
                weight = typo.value().weight;
                style = typo.value().style;
                textDeco = typo.value().decoration;
                if (typo.value().fontFamily.has_value()) fontName = typo.value().fontFamily.value();
            }

            uint8_t tA = (rawColor >> 24) & 0xFF;
            bool isNonAscii = containsNonAsciiBytes(text);
            bool isCustomOrIconFont = !isStandardPdfFontName(fontName);
            bool hasRuns = typo.has_value() && typo->runs.has_value() && !typo->runs->empty();

            if (rasterMask.has_value() && !rasterMask->empty() && (isNonAscii || isCustomOrIconFont || hasRuns)) {
                ImageBuffer img = ImageEngine::decodeImage(rasterMask.value());
                if (img.pixels && img.width > 0 && img.height > 0) {
                    if (tA < 255) {
                        double opFactor = tA / 255.0;
                        for (int i = 0; i < img.width * img.height; ++i) {
                            img.pixels[i * 4 + 3] = static_cast<uint8_t>(std::round(img.pixels[i * 4 + 3] * opFactor));
                        }
                    }
                    ImageEngine::applyColorSpace(img.pixels, img.width, img.height, colorSpace);

                    int startPage = static_cast<int>(std::floor(y / pageHeight));
                    int endPage = static_cast<int>(std::floor((y + std::max(0.001, h - 0.001)) / pageHeight));

                    if (startPage == endPage) {
                        struct pdf_object* currentPage = getOrCreatePage(startPage);
                        double localY = y - (startPage * pageHeight);
                        double pdfY = pageHeight - localY - h;
                        pdf_add_rgba_raw_image(pdf, currentPage, x, pdfY, w, h, img.pixels, img.width, img.height);

                        bool isIconGlyph = (fontName.find("Icons") != std::string::npos);
                        std::string copyable = extractCopyableAscii(text);
                        if (!isIconGlyph && !copyable.empty()) {
                            double baselineY = pdfY + (h / 2.0) - (fontSize / 2.0) + (fontSize * 0.22) + baselineOffset;
                            std::ostringstream invCmd;
                            invCmd << "q\nBT\n3 Tr\n/F1 " << fontSize << " Tf\n"
                                   << x << " " << baselineY << " Td\n(" << copyable << ") Tj\nET\nQ\n";
                            pdf_inject_raw(pdf, currentPage, invCmd.str().c_str());
                        }
                    } else {
                        for (int pIdx = startPage; pIdx <= endPage; ++pIdx) {
                            struct pdf_object* curPage = getOrCreatePage(pIdx);
                            double pTop = pIdx * pageHeight;
                            double pBot = (pIdx + 1) * pageHeight;
                            double segTop = std::max(y, pTop);
                            double segBot = std::min(y + h, pBot);
                            double segH = segBot - segTop;
                            if (segH <= 0.001) continue;

                            int rowStart = std::clamp(static_cast<int>(std::floor(((segTop - y) / h) * img.height)), 0, img.height - 1);
                            int rowEnd = std::clamp(static_cast<int>(std::ceil(((segBot - y) / h) * img.height)), rowStart + 1, img.height);
                            int sliceRows = rowEnd - rowStart;

                            const uint8_t* slicePtr = img.pixels + (rowStart * img.width * 4);
                            double localY = segTop - pTop;
                            double pdfY = pageHeight - localY - segH;
                            pdf_add_rgba_raw_image(pdf, curPage, x, pdfY, w, segH, slicePtr, img.width, sliceRows);
                        }
                    }
                    return;
                }
            }

            std::string activePdfFont = resolveBuiltInPdfFont(fontName, weight, style);
            pdf_set_font(pdf, activePdfFont.c_str());

            std::vector<std::string> lines = wrapParagraphLines(text, fontName, fontSize, w);

            uint8_t tR = (rawColor >> 16) & 0xFF;
            uint8_t tG = (rawColor >> 8) & 0xFF;
            uint8_t tB = rawColor & 0xFF;

            double naturalLineH = fontSize * std::max(1.0, lineHeightMult);
            double lineH = (lines.size() == 1) ? h : std::min(naturalLineH, h / static_cast<double>(lines.size()));
            double descent = fontSize * 0.22;

            for (size_t i = 0; i < lines.size(); ++i) {
                double lineGlobalY = y + (i * lineH);
                int linePageIdx = static_cast<int>(std::floor(lineGlobalY / pageHeight));
                double lineLocalY = lineGlobalY - (linePageIdx * pageHeight);

                if (lineLocalY + lineH > pageHeight + 0.5 && lines.size() > 1) {
                    linePageIdx++;
                    lineLocalY = 4.0;
                }

                struct pdf_object* linePage = getOrCreatePage(linePageIdx);
                double linePdfY = pageHeight - lineLocalY - lineH;
                double baselineY = linePdfY + (lineH / 2.0) - (fontSize / 2.0) + descent + baselineOffset;
                double drawX = x;

                YGSize exactSize = FontEngine::getInstance().measureText(lines[i], fontName, fontSize, -1.0);
                if (align == 1) drawX = x + (w / 2.0) - (exactSize.width / 2.0);
                else if (align == 2) drawX = x + w - exactSize.width;

                uint32_t pdfColor = PDF_RGB(tR, tG, tB);
                pdf_add_text(pdf, linePage, lines[i].c_str(), fontSize, drawX, baselineY, pdfColor);

                if (textDeco >= 1 && textDeco <= 3 && exactSize.width > 0) {
                    double decoY = baselineY - (fontSize * 0.12);
                    if (textDeco == 2) decoY = baselineY + (fontSize * 0.28);
                    else if (textDeco == 3) decoY = baselineY + (fontSize * 0.78);

                    double strokeW = std::max(1.0, fontSize * 0.06);
                    std::ostringstream decoCmd;
                    decoCmd << "q\n" << (tR / 255.0) << " " << (tG / 255.0) << " " << (tB / 255.0) << " RG\n"
                            << strokeW << " w\n"
                            << drawX << " " << decoY << " m " << (drawX + exactSize.width) << " " << decoY << " l S\nQ\n";
                    pdf_inject_raw(pdf, linePage, decoCmd.str().c_str());
                }
            }

            pdf_set_font(pdf, "Helvetica");
        }

        void drawImage(double x, double y, double w, double h, const std::string& base64, const std::optional<ImageProps>& props) override {
            drawImage(x, y, w, h, base64, props, std::nullopt);
        }

        void drawImage(
                double x,
                double y,
                double w,
                double h,
                const std::string& base64,
                const std::optional<ImageProps>& props,
                const std::optional<BoxDecoration>& deco
        ) override {
            if (base64.empty() || w <= 0 || h <= 0) return;

            ImageBuffer img = ImageEngine::decodeImage(base64);
            if (!img.pixels || img.width <= 0 || img.height <= 0) return;

            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);

            ImageProps activeProps = props.value_or(ImageProps{3, 0, std::nullopt});
            ImageDrawRect fitRect = ImageEngine::calculateFit(w, h, img.width, img.height, activeProps);

            std::string customClipPath = "";
            if (deco.has_value() && (deco->shape == 1 || deco->borderRadius.has_value() || deco->isClip)) {
                customClipPath = ClipEngine::generateClipPath(w, h, x, y, pageHeight, deco.value());
            }

            bool needsClip = !customClipPath.empty() ||
                             (fitRect.w > w + 0.5 || fitRect.h > h + 0.5 || fitRect.x < -0.5 || fitRect.y < -0.5);
            if (needsClip) {
                pushClip(x, y, w, h, customClipPath);
            }

            double drawX = x + fitRect.x;
            double drawY = y + fitRect.y;
            double localY = drawY - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - fitRect.h;

            std::vector<unsigned char> rawBytes = ImageEngine::decodeBase64(base64);
            bool isJpeg = (colorSpace == 0 && rawBytes.size() > 2 && rawBytes[0] == 0xFF && rawBytes[1] == 0xD8);

            if (isJpeg) {
                pdf_add_image_data(pdf, currentPage, drawX, pdfY, fitRect.w, fitRect.h, rawBytes.data(), rawBytes.size());
            } else {
                ImageEngine::applyColorSpace(img.pixels, img.width, img.height, colorSpace);
                pdf_add_rgba_raw_image(pdf, currentPage, drawX, pdfY, fitRect.w, fitRect.h, img.pixels, img.width, img.height);
            }

            if (needsClip) {
                popClip();
            }

            if (deco.has_value() && deco->borderColor.has_value() && deco->borderWidth.has_value()) {
                drawVectorBorder(currentPage, x, y, w, h, deco.value(), true, true);
            }
        }

        void drawSvg(double x, double y, double w, double h, const std::string& svgXml, const std::optional<SvgProps>& props) override {
            if (svgXml.empty() || w <= 0 || h <= 0) return;
            NSVGimage* image = SvgEngine::parseSvg(svgXml);
            if (!image) return;

            float minX = 1e6f, minY = 1e6f, maxX = -1e6f, maxY = -1e6f;
            for (NSVGshape* shape = image->shapes; shape != NULL; shape = shape->next) {
                if (!(shape->flags & NSVG_FLAGS_VISIBLE)) continue;
                if (shape->bounds[0] < minX) minX = shape->bounds[0];
                if (shape->bounds[1] < minY) minY = shape->bounds[1];
                if (shape->bounds[2] > maxX) maxX = shape->bounds[2];
                if (shape->bounds[3] > maxY) maxY = shape->bounds[3];
            }

            double actualW = (maxX > minX) ? (maxX - minX) : (image->width > 0 ? image->width : w);
            double actualH = (maxY > minY) ? (maxY - minY) : (image->height > 0 ? image->height : h);
            if (maxX <= minX) { minX = 0; minY = 0; }

            double scaleX = w / std::max(1.0, actualW);
            double scaleY = h / std::max(1.0, actualH);
            double scale = std::min(scaleX, scaleY);

            double offsetX = x + (w - actualW * scale) / 2.0 - (minX * scale);
            double offsetY = y + (h - actualH * scale) / 2.0 - (minY * scale);

            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double pageTopY = pageIndex * pageHeight;

            std::ostringstream pdfCmd;
            pdfCmd << "q\n";

            if (props.has_value()) {
                pdfCmd << std::clamp(props->strokeCap, 0, 2) << " J\n";
                pdfCmd << std::clamp(props->strokeJoin, 0, 2) << " j\n";
            }

            for (NSVGshape* shape = image->shapes; shape != NULL; shape = shape->next) {
                if (!(shape->flags & NSVG_FLAGS_VISIBLE)) continue;

                bool hasFill = (shape->fill.type != NSVG_PAINT_NONE);
                bool hasStroke = (shape->stroke.type != NSVG_PAINT_NONE && shape->strokeWidth > 0);

                uint8_t fR = 0, fG = 0, fB = 0;
                if (props.has_value() && props->fill.has_value()) {
                    uint32_t c = applyColorSpaceIfRequired(static_cast<uint32_t>(props->fill.value()));
                    fR = (c >> 16) & 0xFF; fG = (c >> 8) & 0xFF; fB = c & 0xFF;
                    hasFill = true;
                } else if (hasFill) {
                    uint32_t c = shape->fill.color;
                    fR = c & 0xFF; fG = (c >> 8) & 0xFF; fB = (c >> 16) & 0xFF;
                    uint32_t argb = (0xFF000000U) | (static_cast<uint32_t>(fR) << 16) | (static_cast<uint32_t>(fG) << 8) | fB;
                    argb = applyColorSpaceIfRequired(argb);
                    fR = (argb >> 16) & 0xFF; fG = (argb >> 8) & 0xFF; fB = argb & 0xFF;
                }

                uint8_t sR = 0, sG = 0, sB = 0;
                double sW = shape->strokeWidth * scale;
                if (props.has_value() && props->stroke.has_value()) {
                    uint32_t c = applyColorSpaceIfRequired(static_cast<uint32_t>(props->stroke.value()));
                    sR = (c >> 16) & 0xFF; sG = (c >> 8) & 0xFF; sB = c & 0xFF;
                    sW = (props->strokeWidth > 0 ? props->strokeWidth : shape->strokeWidth) * scale;
                    hasStroke = (sW > 0);
                } else if (hasStroke) {
                    uint32_t c = shape->stroke.color;
                    sR = c & 0xFF; sG = (c >> 8) & 0xFF; sB = (c >> 16) & 0xFF;
                    uint32_t argb = (0xFF000000U) | (static_cast<uint32_t>(sR) << 16) | (static_cast<uint32_t>(sG) << 8) | sB;
                    argb = applyColorSpaceIfRequired(argb);
                    sR = (argb >> 16) & 0xFF; sG = (argb >> 8) & 0xFF; sB = argb & 0xFF;
                }

                if (!hasFill && !hasStroke) continue;

                if (hasFill) pdfCmd << (fR / 255.0) << " " << (fG / 255.0) << " " << (fB / 255.0) << " rg\n";
                if (hasStroke) {
                    pdfCmd << (sR / 255.0) << " " << (sG / 255.0) << " " << (sB / 255.0) << " RG\n";
                    pdfCmd << sW << " w\n";
                }

                for (NSVGpath* path = shape->paths; path != NULL; path = path->next) {
                    for (int i = 0; i < path->npts - 1; i += 3) {
                        float* p = &path->pts[i * 2];
                        if (i == 0) {
                            double px0 = offsetX + p[0] * scale;
                            double py0 = pageHeight - ((offsetY + p[1] * scale) - pageTopY);
                            pdfCmd << px0 << " " << py0 << " m\n";
                        }
                        double px1 = offsetX + p[2] * scale;
                        double py1 = pageHeight - ((offsetY + p[3] * scale) - pageTopY);
                        double px2 = offsetX + p[4] * scale;
                        double py2 = pageHeight - ((offsetY + p[5] * scale) - pageTopY);
                        double px3 = offsetX + p[6] * scale;
                        double py3 = pageHeight - ((offsetY + p[7] * scale) - pageTopY);
                        pdfCmd << px1 << " " << py1 << " " << px2 << " " << py2 << " " << px3 << " " << py3 << " c\n";
                    }
                    if (path->closed) pdfCmd << "h\n";
                }

                bool evenOdd = (shape->fillRule == NSVG_FILLRULE_EVENODD);
                if (hasFill && hasStroke) pdfCmd << (evenOdd ? "B*\n" : "B\n");
                else if (hasFill) pdfCmd << (evenOdd ? "f*\n" : "f\n");
                else if (hasStroke) pdfCmd << "S\n";
            }

            pdfCmd << "Q\n";
            pdf_inject_raw(pdf, currentPage, pdfCmd.str().c_str());
            SvgEngine::freeSvg(image);
        }

        void pushTransform(double x, double y, double w, double h, const TransformMatrix& tm) override {
            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double localY = y - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - h;

            transformPageStack.push_back(pageIndex);

            double pivotX = x + w * tm.originX;
            double pivotY = pdfY + h * (1.0 - tm.originY);

            double rad = -tm.rotateZ * (3.14159265358979323846 / 180.0);
            double cosA = std::cos(rad);
            double sinA = std::sin(rad);

            double a = tm.scaleX * cosA;
            double b = tm.scaleX * sinA + std::tan(tm.skewY * 3.14159265358979323846 / 180.0);
            double c = -tm.scaleY * sinA + std::tan(tm.skewX * 3.14159265358979323846 / 180.0);
            double d = tm.scaleY * cosA;

            std::ostringstream cmd;
            cmd << "q\n";
            cmd << "1 0 0 1 " << pivotX << " " << pivotY << " cm\n";
            cmd << a << " " << b << " " << c << " " << d << " " << tm.translateX << " " << (-tm.translateY) << " cm\n";
            cmd << "1 0 0 1 " << (-pivotX) << " " << (-pivotY) << " cm\n";

            pdf_inject_raw(pdf, currentPage, cmd.str().c_str());
        }

        void popTransform() override {
            if (transformPageStack.empty()) return;
            int pageIndex = transformPageStack.back();
            transformPageStack.pop_back();

            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            pdf_inject_raw(pdf, currentPage, "Q\n");
        }

        void drawFormField(double x, double y, double w, double h, const FormFieldData& field, const std::optional<Typography>& typo) override {
            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double localY = y - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - h;

            if (field.fieldType == 1 && (field.value == "true" || field.value == "1")) {
                std::ostringstream cmd;
                cmd << "q\n1 1 1 RG\n2.2 w\n1 J 1 j\n"
                    << (x + w * 0.22) << " " << (pdfY + h * 0.50) << " m "
                    << (x + w * 0.42) << " " << (pdfY + h * 0.28) << " l "
                    << (x + w * 0.78) << " " << (pdfY + h * 0.74) << " l S\nQ\n";
                pdf_inject_raw(pdf, currentPage, cmd.str().c_str());
            } else if (field.fieldType == 0 && !field.value.empty()) {
                drawText(x + 6.0, y, std::max(1.0, w - 12.0), h, field.value, typo, std::nullopt);
            }
        }

        void drawRasterShadow(double x, double y, double w, double h, const std::vector<uint8_t>& pixels, uint32_t parentBgColor) override {
            (void)parentBgColor;
            if (pixels.empty() || w <= 0 || h <= 0) return;

            int pixelW = static_cast<int>(w);
            int pixelH = static_cast<int>(h);

            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double localY = y - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - h;

            if (colorSpace != 0) {
                std::vector<uint8_t> convPx = pixels;
                ImageEngine::applyColorSpace(convPx.data(), pixelW, pixelH, colorSpace);
                pdf_add_rgba_raw_image(pdf, currentPage, x, pdfY, w, h, convPx.data(), pixelW, pixelH);
            } else {
                pdf_add_rgba_raw_image(pdf, currentPage, x, pdfY, w, h, pixels.data(), pixelW, pixelH);
            }
        }

        void pushClip(double x, double y, double w, double h, const std::string& nativePdfPath) override {
            int pageIndex = static_cast<int>(std::floor(y / pageHeight));
            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            double localY = y - (pageIndex * pageHeight);
            double pdfY = pageHeight - localY - h;

            clipPageStack.push_back(pageIndex);

            std::ostringstream pdfCommand;
            pdfCommand << "q\n";

            if (nativePdfPath.empty()) {
                pdfCommand << x << " " << pdfY << " " << w << " " << h << " re W n\n";
            } else if (nativePdfPath.find("W* n") != std::string::npos) {
                pdfCommand << nativePdfPath;
            } else {
                pdfCommand << nativePdfPath;
                pdfCommand << "W n\n";
            }

            pdf_inject_raw(pdf, currentPage, pdfCommand.str().c_str());
        }

        void popClip() override {
            if (clipPageStack.empty()) return;
            int pageIndex = clipPageStack.back();
            clipPageStack.pop_back();

            struct pdf_object* currentPage = getOrCreatePage(pageIndex);
            pdf_inject_raw(pdf, currentPage, "Q\n");
        }
    };
#endif // CANVAS_ENABLE_PDF

} // namespace CoreCanvas