// FILE: src/render_engine.h
// PURPOSE: Core rendering loop, Subtree Offscreen Compositor, 2D Transforms, RLottie, Tweeny & Smart Pagination.
// Features: True multi-page repeating headers/footers, {{page}}/{{totalPages}} tokens & opt-in shadow guards.

#pragma once
#include <string>
#include <vector>
#include <algorithm>
#include <optional>
#include <sstream>
#include <cmath>
#include <cstdlib>
#include <cstring>

#ifdef __ANDROID__
#include <android/log.h>
#ifndef NDEBUG
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "CANVAS_ENGINE", __VA_ARGS__)
#else
#define LOGD(...) ((void)0)
#endif
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN, "CANVAS_ENGINE", __VA_ARGS__)
#else
#include <cstdio>
#ifndef NDEBUG
#define LOGD(...) do { fprintf(stdout, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stdout, "\n"); } while(0)
#else
#define LOGD(...) ((void)0)
#endif
#define LOGW(...) do { fprintf(stderr, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stderr, "\n"); } while(0)
#endif

#include "config.h"
#include "layout_engine.h"
#include "clip_engine.h"
#ifdef CANVAS_ENABLE_SHADOWS
#include "shadow_engine.h"
#endif
#include "font_engine.h"
#include "lottie_gif_engine.h"

namespace CoreCanvas {

    class IRenderTarget {
    public:
        virtual ~IRenderTarget() = default;
        virtual void drawBox(double x, double y, double w, double h, const std::optional<BoxDecoration>& deco) = 0;
        virtual void drawText(double x, double y, double w, double h, const std::string& text, const std::optional<Typography>& typo) = 0;

        virtual void drawText(
                double x,
                double y,
                double w,
                double h,
                const std::string& text,
                const std::optional<Typography>& typo,
                const std::optional<std::string>& rasterMask
        ) {
            (void)rasterMask;
            drawText(x, y, w, h, text, typo);
        }

        virtual void drawImage(double x, double y, double w, double h, const std::string& base64, const std::optional<ImageProps>& props) = 0;

        virtual void drawImage(
                double x,
                double y,
                double w,
                double h,
                const std::string& base64,
                const std::optional<ImageProps>& props,
                const std::optional<BoxDecoration>& deco
        ) {
            (void)deco;
            drawImage(x, y, w, h, base64, props);
        }

        virtual void drawSvg(double x, double y, double w, double h, const std::string& svgXml, const std::optional<SvgProps>& props) = 0;
        virtual void drawRasterShadow(double x, double y, double w, double h, const std::vector<uint8_t>& pixels, uint32_t parentBgColor) = 0;

        virtual void drawLottie(
                double x,
                double y,
                double w,
                double h,
                const std::string& lottieJson,
                const std::optional<LottieProps>& props,
                double animProgress = 0.0,
                uint32_t parentBgColor = 0xFFFFFFFF
        ) {
#ifdef CANVAS_ENABLE_LOTTIE
            if (lottieJson.empty() || w <= 0 || h <= 0) return;
            int rw = std::max(1, static_cast<int>(std::ceil(w)));
            int rh = std::max(1, static_cast<int>(std::ceil(h)));
            ImageBuffer frame = LottieGifEngine::renderLottieFrame(lottieJson, rw, rh, props, animProgress);
            if (frame.pixels && frame.width > 0 && frame.height > 0) {
                std::vector<uint8_t> px(frame.pixels, frame.pixels + (frame.width * frame.height * 4));
                drawRasterShadow(x, y, w, h, px, parentBgColor);
            }
#else
            (void)x; (void)y; (void)w; (void)h; (void)lottieJson; (void)props; (void)animProgress; (void)parentBgColor;
#endif
        }

        virtual void pushClip(double x, double y, double w, double h, const std::string& clipSvgPath) = 0;

        virtual void pushClip(
                double x,
                double y,
                double w,
                double h,
                const std::string& clipSvgPath,
                const std::optional<BoxDecoration>& deco
        ) {
            (void)deco;
            pushClip(x, y, w, h, clipSvgPath);
        }

        virtual void popClip() = 0;

        virtual void pushTransform(double x, double y, double w, double h, const TransformMatrix& tm) {
            (void)x; (void)y; (void)w; (void)h; (void)tm;
        }
        virtual void popTransform() {}

        virtual void drawFormField(double x, double y, double w, double h, const FormFieldData& field, const std::optional<Typography>& typo) {
            (void)x; (void)y; (void)w; (void)h; (void)field; (void)typo;
        }
        virtual void addLink(double x, double y, double w, double h, const std::string& url) {
            (void)x; (void)y; (void)w; (void)h; (void)url;
        }
        virtual void addBookmark(double y, const std::string& title) {
            (void)y; (void)title;
        }

        virtual double getPageHeight() = 0;
    };

    class RenderEngine {
    public:
        struct ZNode {
            const SuperContainer* container;
            YGNodeRef yogaNode;
            int zIndex;
        };

    private:
        static bool hasActiveTransform(const TransformMatrix& t) {
            return std::abs(t.scaleX - 1.0) > 1e-4 ||
                   std::abs(t.scaleY - 1.0) > 1e-4 ||
                   std::abs(t.rotateZ) > 1e-4 ||
                   std::abs(t.translateX) > 1e-4 ||
                   std::abs(t.translateY) > 1e-4 ||
                   std::abs(t.skewX) > 1e-4 ||
                   std::abs(t.skewY) > 1e-4;
        }

        // Dynamic token resolver for repeating Headers & Footers:
        // Supports "{{page}}" (1-based) and "{{totalPages}}"
        static std::string resolvePageTokens(
                const std::string& text,
                int currentPageNum,
                int totalPagesCount,
                bool& didReplace
        ) {
            didReplace = false;
            if (currentPageNum <= 0 || text.find("{{") == std::string::npos) {
                return text;
            }
            std::string result = text;
            auto replaceAll = [&](const std::string& token, const std::string& replacement) {
                size_t pos = 0;
                while ((pos = result.find(token, pos)) != std::string::npos) {
                    result.replace(pos, token.length(), replacement);
                    pos += replacement.length();
                    didReplace = true;
                }
            };
            replaceAll("{{page}}", std::to_string(currentPageNum));
            replaceAll("{{totalPages}}", std::to_string(std::max(1, totalPagesCount)));
            return result;
        }

#ifdef CANVAS_ENABLE_SHADOWS
        static double projectGradientCoord(double nx, double ny, double angleDeg) {
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

        static void blendBufferOnto(
                unsigned char* dst,
                int dstW,
                int dstH,
                const ImageBuffer& src,
                int offsetX,
                int offsetY,
                int targetW,
                int targetH
        ) {
            if (!dst || !src.pixels || src.width <= 0 || src.height <= 0 || targetW <= 0 || targetH <= 0) return;

            double scaleX = static_cast<double>(src.width) / targetW;
            double scaleY = static_cast<double>(src.height) / targetH;

            for (int iy = 0; iy < targetH; ++iy) {
                int dy = offsetY + iy;
                if (dy < 0 || dy >= dstH) continue;
                int sy = std::clamp(static_cast<int>(iy * scaleY), 0, src.height - 1);

                for (int ix = 0; ix < targetW; ++ix) {
                    int dx = offsetX + ix;
                    if (dx < 0 || dx >= dstW) continue;
                    int sx = std::clamp(static_cast<int>(ix * scaleX), 0, src.width - 1);

                    int sIdx = (sy * src.width + sx) * 4;
                    uint8_t sA = src.pixels[sIdx + 3];
                    if (sA == 0) continue;

                    int dIdx = (dy * dstW + dx) * 4;
                    uint8_t sR = src.pixels[sIdx + 0], sG = src.pixels[sIdx + 1], sB = src.pixels[sIdx + 2];
                    uint8_t dR = dst[dIdx + 0], dG = dst[dIdx + 1], dB = dst[dIdx + 2], dA = dst[dIdx + 3];

                    double alpha = sA / 255.0;
                    double invAlpha = 1.0 - alpha;

                    dst[dIdx + 0] = static_cast<uint8_t>(sR * alpha + dR * invAlpha);
                    dst[dIdx + 1] = static_cast<uint8_t>(sG * alpha + dG * invAlpha);
                    dst[dIdx + 2] = static_cast<uint8_t>(sB * alpha + dB * invAlpha);
                    dst[dIdx + 3] = static_cast<uint8_t>(std::min(255.0, sA + dA * invAlpha));
                }
            }
        }

        static std::string injectEvenOddIfRequired(const std::string& svgXml, const BoxDecoration& deco) {
            if (deco.clipRule == 1 && svgXml.find("fill-rule") == std::string::npos) {
                size_t pos = svgXml.find("<path ");
                if (pos != std::string::npos) {
                    std::string modified = svgXml;
                    modified.insert(pos + 6, "fill-rule=\"evenodd\" ");
                    return modified;
                }
            }
            return svgXml;
        }

        static void applyNodeClipMask(ImageBuffer& buf, const BoxDecoration& deco) {
            if (!buf.pixels || buf.width <= 0 || buf.height <= 0) return;
            int w = buf.width, h = buf.height;

            if (deco.isClip && (deco.clipSvgPath.has_value() || deco.clipMath.has_value())) {
                std::string svgXml = injectEvenOddIfRequired(ClipEngine::generateClipSvgXml(w, h, deco), deco);
                NSVGimage* svgImg = SvgEngine::parseSvg(svgXml);
                if (svgImg) {
                    std::vector<uint8_t> maskPx = SvgEngine::rasterizeSvg(svgImg, w, h, 0xFFFFFFFF);
                    SvgEngine::freeSvg(svgImg);
                    if (maskPx.size() == static_cast<size_t>(w * h * 4)) {
                        for (int i = 0; i < w * h; ++i) {
                            uint8_t mA = maskPx[i * 4 + 3];
                            buf.pixels[i * 4 + 3] = static_cast<uint8_t>((buf.pixels[i * 4 + 3] * mA) / 255);
                        }
                    }
                }
                return;
            }

            if (deco.shape == 1 || deco.borderRadius.has_value()) {
                double maxR = std::min(w, h) / 2.0;
                double tl = 0, tr = 0, br = 0, bl = 0;
                if (deco.shape == 1) {
                    tl = tr = br = bl = maxR;
                } else if (deco.borderRadius.has_value()) {
                    tl = std::min(deco.borderRadius->top, maxR);
                    tr = std::min(deco.borderRadius->right, maxR);
                    br = std::min(deco.borderRadius->bottom, maxR);
                    bl = std::min(deco.borderRadius->left, maxR);
                }

                for (int iy = 0; iy < h; ++iy) {
                    for (int ix = 0; ix < w; ++ix) {
                        double px = ix + 0.5, py = iy + 0.5;
                        double cov = 1.0;
                        if (deco.shape == 1) {
                            double cx = w / 2.0, cy = h / 2.0;
                            double dist = std::sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
                            cov = std::clamp(maxR + 0.5 - dist, 0.0, 1.0);
                        } else {
                            if (tl > 0 && px < tl && py < tl) cov = std::clamp(tl + 0.5 - std::sqrt((px - tl)*(px - tl) + (py - tl)*(py - tl)), 0.0, 1.0);
                            else if (tr > 0 && px > w - tr && py < tr) cov = std::clamp(tr + 0.5 - std::sqrt((px - (w - tr))*(px - (w - tr)) + (py - tr)*(py - tr)), 0.0, 1.0);
                            else if (br > 0 && px > w - br && py > h - br) cov = std::clamp(br + 0.5 - std::sqrt((px - (w - br))*(px - (w - br)) + (py - (h - br))*(py - (h - br))), 0.0, 1.0);
                            else if (bl > 0 && px < bl && py > h - bl) cov = std::clamp(bl + 0.5 - std::sqrt((px - bl)*(px - bl) + (py - (h - bl))*(py - (h - bl))), 0.0, 1.0);
                        }
                        if (cov < 1.0) {
                            int aIdx = (iy * w + ix) * 4 + 3;
                            buf.pixels[aIdx] = static_cast<uint8_t>(std::round(buf.pixels[aIdx] * cov));
                        }
                    }
                }
            }
        }

        static ImageBuffer rasterizeNodeSubtree(const SuperContainer& node, YGNodeRef yogaNode, int w, int h, double animProgress = 0.0) {
            ImageBuffer buf;
            if (w <= 0 || h <= 0 || !yogaNode) return buf;

            if (node.type == 1) {
                if (node.rasterMask.has_value() && !node.rasterMask->empty()) {
                    return ImageEngine::decodeImage(node.rasterMask.value());
                }
                if (node.content.has_value()) {
                    std::string fontName = "Helvetica";
                    double fontSize = 12.0, letterSpacing = 0.0, wordSpacing = 0.0;
                    uint32_t color = 0xFFFFFFFF;
                    int weight = 400, align = 0;
                    if (node.typography.has_value()) {
                        fontSize = node.typography->fontSize;
                        color = node.typography->color;
                        weight = node.typography->weight;
                        align = node.typography->align;
                        letterSpacing = node.typography->letterSpacing;
                        wordSpacing = node.typography->wordSpacing;
                        if (node.typography->fontFamily.has_value()) fontName = node.typography->fontFamily.value();
                    }
                    return FontEngine::getInstance().renderTextToImage(node.content.value(), fontName, fontSize, w, h, color, weight, align, letterSpacing, wordSpacing);
                }
                return buf;
            }
            if (node.type == 2 && node.content.has_value()) {
                ImageBuffer decoded = ImageEngine::decodeImage(node.content.value());
                if (!decoded.pixels || decoded.width <= 0 || decoded.height <= 0) return buf;

                buf = ImageBuffer::allocate(w, h);
                if (!buf.pixels) return buf;

                ImageProps activeProps = node.imageProps.value_or(ImageProps{3, 0, std::nullopt});
                ImageDrawRect fitRect = ImageEngine::calculateFit(w, h, decoded.width, decoded.height, activeProps);

                blendBufferOnto(
                        buf.pixels, w, h, decoded,
                        static_cast<int>(std::round(fitRect.x)),
                        static_cast<int>(std::round(fitRect.y)),
                        std::max(1, static_cast<int>(std::round(fitRect.w))),
                        std::max(1, static_cast<int>(std::round(fitRect.h)))
                );

                if (node.decoration.has_value()) {
                    applyNodeClipMask(buf, node.decoration.value());
                }
                return buf;
            }
            if (node.type == 3 && node.content.has_value()) {
                NSVGimage* svgImg = SvgEngine::parseSvg(node.content.value());
                if (svgImg) {
                    std::optional<uint32_t> fillOverride = std::nullopt;
                    if (node.svgProps.has_value() && node.svgProps->fill.has_value()) {
                        fillOverride = static_cast<uint32_t>(node.svgProps->fill.value());
                    }
                    std::vector<uint8_t> px = SvgEngine::rasterizeSvg(svgImg, w, h, fillOverride);
                    SvgEngine::freeSvg(svgImg);
                    if (!px.empty()) {
                        buf = ImageBuffer::allocate(w, h);
                        if (buf.pixels) std::memcpy(buf.pixels, px.data(), static_cast<size_t>(w) * static_cast<size_t>(h) * 4);
                    }
                }
                return buf;
            }
            if (node.type == 4 && node.content.has_value()) {
                return LottieGifEngine::renderLottieFrame(node.content.value(), w, h, node.lottieProps, animProgress);
            }

            buf = ImageBuffer::allocate(w, h);
            if (!buf.pixels) return buf;

            if (node.decoration.has_value()) {
                const auto& deco = node.decoration.value();

                if (deco.gradient.has_value() && !deco.gradient->empty()) {
                    const auto& stops = deco.gradient.value();
                    for (int iy = 0; iy < h; ++iy) {
                        for (int ix = 0; ix < w; ++ix) {
                            double t = projectGradientCoord(
                                    ix / std::max(1.0, (double)w),
                                    iy / std::max(1.0, (double)h),
                                    deco.gradientAngle
                            );
                            double scaled = t * (stops.size() - 1);
                            size_t idx = static_cast<size_t>(std::floor(scaled));
                            double frac = scaled - idx;
                            uint32_t c1 = static_cast<uint32_t>(stops[idx]);
                            uint32_t c2 = static_cast<uint32_t>(stops[std::min(idx + 1, stops.size() - 1)]);
                            int pIdx = (iy * w + ix) * 4;
                            buf.pixels[pIdx + 0] = static_cast<uint8_t>(((c1 >> 16) & 0xFF) + (((int)((c2 >> 16) & 0xFF) - (int)((c1 >> 16) & 0xFF)) * frac));
                            buf.pixels[pIdx + 1] = static_cast<uint8_t>(((c1 >> 8) & 0xFF) + (((int)((c2 >> 8) & 0xFF) - (int)((c1 >> 8) & 0xFF)) * frac));
                            buf.pixels[pIdx + 2] = static_cast<uint8_t>((c1 & 0xFF) + (((int)(c2 & 0xFF) - (int)(c1 & 0xFF)) * frac));
                            buf.pixels[pIdx + 3] = 255;
                        }
                    }
                } else if (deco.backgroundColor.has_value()) {
                    uint32_t bg = deco.backgroundColor.value();
                    uint8_t a = (bg >> 24) & 0xFF, r = (bg >> 16) & 0xFF, g = (bg >> 8) & 0xFF, b = bg & 0xFF;
                    for (int i = 0; i < w * h; ++i) {
                        buf.pixels[i * 4 + 0] = r;
                        buf.pixels[i * 4 + 1] = g;
                        buf.pixels[i * 4 + 2] = b;
                        buf.pixels[i * 4 + 3] = a;
                    }
                }

                if (deco.backgroundImage.has_value() && !deco.backgroundImage->empty()) {
                    ImageBuffer bgImg = ImageEngine::decodeImage(deco.backgroundImage.value());
                    if (bgImg.pixels) {
                        blendBufferOnto(buf.pixels, w, h, bgImg, 0, 0, w, h);
                    }
                }
            }

            std::vector<ZNode> zNodes;
            zNodes.reserve(node.children.size());
            for (size_t i = 0; i < node.children.size(); ++i) {
                int z = 0;
                if (node.children[i].position.has_value()) z = node.children[i].position.value().zIndex;
                zNodes.push_back({&node.children[i], YGNodeGetChild(yogaNode, i), z});
            }
            std::stable_sort(zNodes.begin(), zNodes.end(), [](const ZNode& a, const ZNode& b) {
                return a.zIndex < b.zIndex;
            });

            for (const auto& zn : zNodes) {
                if (!zn.yogaNode) continue;
                int cx = static_cast<int>(std::round(YGNodeLayoutGetLeft(zn.yogaNode)));
                int cy = static_cast<int>(std::round(YGNodeLayoutGetTop(zn.yogaNode)));
                int cw = static_cast<int>(std::ceil(YGNodeLayoutGetWidth(zn.yogaNode)));
                int ch = static_cast<int>(std::ceil(YGNodeLayoutGetHeight(zn.yogaNode)));
                if (cw <= 0 || ch <= 0) continue;

                ImageBuffer childBuf = rasterizeNodeSubtree(*zn.container, zn.yogaNode, cw, ch, animProgress);
                if (childBuf.pixels) {
                    blendBufferOnto(buf.pixels, w, h, childBuf, cx, cy, cw, ch);
                }
            }

            if (node.decoration.has_value()) {
                applyNodeClipMask(buf, node.decoration.value());
            }

            return buf;
        }
#endif // CANVAS_ENABLE_SHADOWS

        static void processAndDrawShadow(const SuperContainer& node, YGNodeRef yogaNode, double x, double y, double w, double h, IRenderTarget* target, uint32_t parentBgColor, double animProgress = 0.0) {
#ifdef CANVAS_ENABLE_SHADOWS
            if (!node.decoration.has_value() || !node.decoration->shadow.has_value()) return;

            const CanvasShadow& shadowProps = node.decoration->shadow.value();
            ShadowResult shadow;

            if (node.decoration->isClip && (node.decoration->clipSvgPath.has_value() || node.decoration->clipMath.has_value())) {
                std::string svgXml = injectEvenOddIfRequired(ClipEngine::generateClipSvgXml(w, h, node.decoration.value()), node.decoration.value());
                shadow = ShadowEngine::generateSvgShadow(svgXml, w, h, x, y, shadowProps);
            } else {
                switch (node.type) {
                    case 0:
                        shadow = ShadowEngine::generateBoxShadow(w, h, x, y, shadowProps, node.decoration->borderRadius, node.decoration->shape);
                        break;
                    case 1:
                        if (node.rasterMask.has_value() && !node.rasterMask->empty()) {
                            ImageBuffer img = ImageEngine::decodeImage(node.rasterMask.value());
                            shadow = ShadowEngine::generateImageShadow(img, w, h, x, y, shadowProps);
                        } else if (node.content.has_value()) {
                            std::string fontName = "Helvetica";
                            double fontSize = 12.0, letterSpacing = 0.0, wordSpacing = 0.0;
                            uint32_t color = 0xFFFFFFFF;
                            int weight = 400, align = 0;
                            if (node.typography.has_value()) {
                                fontSize = node.typography->fontSize;
                                color = node.typography->color;
                                weight = node.typography->weight;
                                align = node.typography->align;
                                letterSpacing = node.typography->letterSpacing;
                                wordSpacing = node.typography->wordSpacing;
                                if (node.typography->fontFamily.has_value()) fontName = node.typography->fontFamily.value();
                            }
                            ImageBuffer img = FontEngine::getInstance().renderTextToImage(
                                    node.content.value(), fontName, fontSize,
                                    std::max(1, static_cast<int>(std::ceil(w))),
                                    std::max(1, static_cast<int>(std::ceil(h))),
                                    color, weight, align, letterSpacing, wordSpacing
                            );
                            if (img.pixels) {
                                shadow = ShadowEngine::generateImageShadow(img, w, h, x, y, shadowProps);
                            } else {
                                shadow = ShadowEngine::generateBoxShadow(w, h, x, y, shadowProps, std::nullopt);
                            }
                        }
                        break;
                    case 2:
                        if (node.content.has_value()) {
                            if (node.decoration->shape == 1 || node.decoration->borderRadius.has_value()) {
                                shadow = ShadowEngine::generateBoxShadow(
                                        w, h, x, y, shadowProps, node.decoration->borderRadius, node.decoration->shape
                                );
                            } else {
                                int bw = std::max(1, static_cast<int>(std::ceil(w)));
                                int bh = std::max(1, static_cast<int>(std::ceil(h)));
                                ImageBuffer fittedImg = rasterizeNodeSubtree(node, yogaNode, bw, bh, animProgress);
                                if (fittedImg.pixels) {
                                    shadow = ShadowEngine::generateImageShadow(fittedImg, w, h, x, y, shadowProps);
                                }
                            }
                        }
                        break;
                    case 3:
                        if (node.content.has_value()) {
                            shadow = ShadowEngine::generateSvgShadow(node.content.value(), w, h, x, y, shadowProps);
                        }
                        break;
                    case 4:
                        if (node.content.has_value()) {
                            ImageBuffer lottieImg = LottieGifEngine::renderLottieFrame(
                                    node.content.value(),
                                    std::max(1, static_cast<int>(std::ceil(w))),
                                    std::max(1, static_cast<int>(std::ceil(h))),
                                    node.lottieProps, animProgress
                            );
                            if (lottieImg.pixels) {
                                shadow = ShadowEngine::generateImageShadow(lottieImg, w, h, x, y, shadowProps);
                            }
                        }
                        break;
                }
            }

            if (!shadow.pixels.empty() && shadow.width > 0 && shadow.height > 0) {
                target->drawRasterShadow(shadow.drawX, shadow.drawY, shadow.width, shadow.height, shadow.pixels, parentBgColor);
            }
#else
            (void)node; (void)yogaNode; (void)x; (void)y; (void)w; (void)h; (void)target; (void)parentBgColor; (void)animProgress;
#endif
        }

        static void processAndDrawMirror(const SuperContainer& node, YGNodeRef yogaNode, double x, double y, double w, double h, IRenderTarget* target, uint32_t parentBgColor, double animProgress = 0.0) {
#ifdef CANVAS_ENABLE_SHADOWS
            if (!node.decoration.has_value() || !node.decoration->mirror.has_value()) return;

            const CanvasReflection& mirrorProps = node.decoration->mirror.value();
            ShadowResult mirror;

            int boxW = std::max(1, static_cast<int>(std::ceil(w)));
            int boxH = std::max(1, static_cast<int>(std::ceil(h)));

            ImageBuffer snapshot = rasterizeNodeSubtree(node, yogaNode, boxW, boxH, animProgress);
            if (snapshot.pixels) {
                mirror = ShadowEngine::generateImageMirror(snapshot, w, h, x, y, mirrorProps);
            }

            if (!mirror.pixels.empty() && mirror.width > 0 && mirror.height > 0) {
                target->drawRasterShadow(mirror.drawX, mirror.drawY, mirror.width, mirror.height, mirror.pixels, parentBgColor);
            }
#else
            (void)node; (void)yogaNode; (void)x; (void)y; (void)w; (void)h; (void)target; (void)parentBgColor; (void)animProgress;
#endif
        }

        static void applyDefaultTypographyRecursive(SuperContainer& node, const Typography& defTypo) {
            if (node.type == 1 && !node.typography.has_value()) {
                node.typography = defTypo;
            }
            for (auto& child : node.children) {
                applyDefaultTypographyRecursive(child, defTypo);
            }
        }

        static double estimateSubtreeFlowExpansion(
                const SuperContainer& node,
                YGNodeRef yogaNode,
                double startY,
                double pageHeight,
                double headerReserve = 0.0,
                double footerReserve = 0.0
        ) {
            if (!yogaNode || pageHeight <= 0 || node.children.empty()) return 0.0;
            bool isRowLayout = node.layout.has_value() && (node.layout->direction == 2 || node.layout->direction == 3);
            double accumOffset = 0.0;
            double maxRowOffset = 0.0;
            double usablePageBottom = std::max(1.0, pageHeight - footerReserve);
            double maxUsableSpan = std::max(1.0, usablePageBottom - headerReserve);

            for (size_t i = 0; i < node.children.size(); ++i) {
                const auto& child = node.children[i];
                YGNodeRef childYoga = YGNodeGetChild(yogaNode, i);
                if (!childYoga) continue;
                if (child.layout.has_value() && child.layout->display == 1) continue;
                bool isAbs = child.position.has_value() && child.position->type == 1;
                if (isAbs) continue;

                double branchOffset = isRowLayout ? 0.0 : accumOffset;
                double cy = startY + YGNodeLayoutGetTop(childYoga) + branchOffset;
                double ch = YGNodeLayoutGetHeight(childYoga);

                int curP = static_cast<int>(std::floor(cy / pageHeight));
                double offInP = cy - (curP * pageHeight);
                double remInP = usablePageBottom - offInP;
                bool crosses = (offInP + std::max(0.1, ch - 0.1) > usablePageBottom);

                if (child.spanningRules.has_value()) {
                    const auto& sr = child.spanningRules.value();

                    if (sr.pageBreakBefore == 1 && offInP > headerReserve + 1.0) {
                        double ny = (curP + 1) * pageHeight + headerReserve;
                        branchOffset += (ny - cy);
                        cy = ny;
                    } else if (crosses && offInP > headerReserve + 1.0) {
                        if (sr.pageBreakInside == 1) {
                            double ny = (curP + 1) * pageHeight + headerReserve;
                            branchOffset += (ny - cy);
                            cy = ny;
                        } else if (sr.pageBreakInside == 2 || (sr.pageBreakInside == 0 && sr.safeThreshold != 100.0)) {
                            if (remInP < sr.safeThreshold) {
                                double ny = (curP + 1) * pageHeight + headerReserve;
                                branchOffset += (ny - cy);
                                cy = ny;
                            }
                        }
                    }
                } else if (footerReserve > 0.0 && crosses && child.children.empty() &&
                           offInP > headerReserve + 1.0 && ch <= maxUsableSpan) {
                    // Auto-protect leaf elements from colliding with repeating footer
                    double ny = (curP + 1) * pageHeight + headerReserve;
                    branchOffset += (ny - cy);
                    cy = ny;
                }

                branchOffset += estimateSubtreeFlowExpansion(child, childYoga, cy, pageHeight, headerReserve, footerReserve);

                if (child.spanningRules.has_value() && child.spanningRules->pageBreakAfter == 1) {
                    double botY = cy + ch;
                    int endP = static_cast<int>(std::floor(botY / pageHeight));
                    double nextTop = (endP + 1) * pageHeight + headerReserve;
                    if (nextTop > botY + 1.0) branchOffset += (nextTop - botY);
                }

                if (isRowLayout) {
                    maxRowOffset = std::max(maxRowOffset, branchOffset);
                } else {
                    accumOffset = branchOffset;
                }
            }
            return isRowLayout ? maxRowOffset : accumOffset;
        }

        static void paintTreeInternal(
                const SuperContainer& node,
                YGNodeRef yogaNode,
                IRenderTarget* target,
                double parentX,
                double parentY,
                double& flowOffsetY,
                uint32_t parentBgColor,
                double parentOpacity,
                double animProgress,
                double headerReserve = 0.0,
                double footerReserve = 0.0,
                double rootBottomMargin = 0.0,
                int currentPageNum = 0,
                int totalPagesCount = 0
        ) {
            if (!yogaNode || !target) return;
            if (node.layout.has_value() && node.layout->display == 1) return;

            double pageHeight = target->getPageHeight();

            // Multi-page repeating Header & Footer orchestrator with dynamic {{page}}/{{totalPages}} tokens
            if (node.id == "VIRTUAL_PAGE" && pageHeight > 0 && !node.children.empty()) {
                double rootX = parentX + YGNodeLayoutGetLeft(yogaNode);
                double rootTopMargin = YGNodeLayoutGetTop(yogaNode);

                const SuperContainer* headerNode = nullptr;
                YGNodeRef headerYoga = nullptr;
                const SuperContainer* bodyNode = nullptr;
                YGNodeRef bodyYoga = nullptr;
                const SuperContainer* footerNode = nullptr;
                YGNodeRef footerYoga = nullptr;

                for (size_t i = 0; i < node.children.size(); ++i) {
                    const auto& ch = node.children[i];
                    YGNodeRef chYoga = YGNodeGetChild(yogaNode, i);
                    if (ch.id == "__CANVAS_HEADER__") {
                        headerNode = &ch;
                        headerYoga = chYoga;
                    } else if (ch.id == "__CANVAS_FOOTER__") {
                        footerNode = &ch;
                        footerYoga = chYoga;
                    } else {
                        bodyNode = &ch;
                        bodyYoga = chYoga;
                    }
                }

                double hHeight = headerYoga ? YGNodeLayoutGetHeight(headerYoga) : 0.0;
                double fHeight = footerYoga ? YGNodeLayoutGetHeight(footerYoga) : 0.0;
                double effHeaderReserve = rootTopMargin + hHeight;
                double effFooterReserve = rootBottomMargin + fHeight;

                double bodyFlowOffset = 0.0;
                double maxBottomY = effHeaderReserve;

                if (bodyNode && bodyYoga) {
                    paintTreeInternal(
                            *bodyNode, bodyYoga, target,
                            rootX, rootTopMargin, bodyFlowOffset,
                            parentBgColor, parentOpacity, animProgress,
                            effHeaderReserve, effFooterReserve, rootBottomMargin,
                            0, 0
                    );
                    maxBottomY = rootTopMargin + YGNodeLayoutGetTop(bodyYoga) + YGNodeLayoutGetHeight(bodyYoga) + bodyFlowOffset;
                }

                int totalPages = std::max(1, static_cast<int>(std::floor(std::max(0.0, maxBottomY - 0.1) / pageHeight)) + 1);

                // Paint repeating Header & Footer across all generated pages (1..totalPages)
                for (int p = 0; p < totalPages; ++p) {
                    double pageBaseY = p * pageHeight;
                    int displayPageNum = p + 1;

                    if (headerNode && headerYoga && !headerNode->children.empty()) {
                        double dummyOffset = 0.0;
                        paintTreeInternal(
                                headerNode->children[0], YGNodeGetChild(headerYoga, 0), target,
                                rootX, pageBaseY + rootTopMargin, dummyOffset,
                                parentBgColor, parentOpacity, animProgress,
                                0.0, 0.0, rootBottomMargin,
                                displayPageNum, totalPages
                        );
                    }
                    if (footerNode && footerYoga && !footerNode->children.empty()) {
                        double dummyOffset = 0.0;
                        double footerTopY = pageBaseY + pageHeight - rootBottomMargin - fHeight;
                        paintTreeInternal(
                                footerNode->children[0], YGNodeGetChild(footerYoga, 0), target,
                                rootX, footerTopY, dummyOffset,
                                parentBgColor, parentOpacity, animProgress,
                                0.0, 0.0, rootBottomMargin,
                                displayPageNum, totalPages
                        );
                    }
                }
                return;
            }

            bool isAbsolute = node.position.has_value() && node.position->type == 1;
            double x = parentX + YGNodeLayoutGetLeft(yogaNode);
            double y = parentY + YGNodeLayoutGetTop(yogaNode) + (isAbsolute ? 0.0 : flowOffsetY);
            double w = YGNodeLayoutGetWidth(yogaNode);
            double h = YGNodeLayoutGetHeight(yogaNode);

            bool triggerBreakAfter = false;
            double usablePageBottom = std::max(1.0, pageHeight - footerReserve);
            double maxUsableSpan = std::max(1.0, usablePageBottom - headerReserve);

            if (pageHeight > 0 && !isAbsolute) {
                int curPage = static_cast<int>(std::floor(y / pageHeight));
                double offsetInPage = y - (curPage * pageHeight);
                double remainingInPage = usablePageBottom - offsetInPage;
                bool crossesPageBoundary = (offsetInPage + std::max(0.1, h - 0.1) > usablePageBottom);

                if (node.spanningRules.has_value()) {
                    const auto& sr = node.spanningRules.value();

                    if (sr.pageBreakBefore == 1 && offsetInPage > headerReserve + 1.0) {
                        double newY = (curPage + 1) * pageHeight + headerReserve;
                        flowOffsetY += (newY - y);
                        y = newY;
                    } else if (crossesPageBoundary && offsetInPage > headerReserve + 1.0) {
                        if (sr.pageBreakInside == 1) {
                            double newY = (curPage + 1) * pageHeight + headerReserve;
                            flowOffsetY += (newY - y);
                            y = newY;
                        } else if (sr.pageBreakInside == 2 || (sr.pageBreakInside == 0 && sr.safeThreshold != 100.0)) {
                            if (remainingInPage < sr.safeThreshold) {
                                double newY = (curPage + 1) * pageHeight + headerReserve;
                                flowOffsetY += (newY - y);
                                y = newY;
                            }
                        }
                    }

                    if (sr.pageBreakAfter == 1) {
                        triggerBreakAfter = true;
                    }
                } else if (footerReserve > 0.0 && crossesPageBoundary && node.children.empty() &&
                           offsetInPage > headerReserve + 1.0 && h <= maxUsableSpan) {
                    // Auto-protect leaf elements from overlapping the repeating footer zone
                    double newY = (curPage + 1) * pageHeight + headerReserve;
                    flowOffsetY += (newY - y);
                    y = newY;
                }
            }

            double precomputedChildExpansion = 0.0;
            if (node.type == 0 && pageHeight > 0 && !node.children.empty() && node.id != "VIRTUAL_PAGE") {
                precomputedChildExpansion = estimateSubtreeFlowExpansion(node, yogaNode, y, pageHeight, headerReserve, footerReserve);
            }
            double effectiveBoxH = h + precomputedChildExpansion;

            TweenedNodeState tweenState = LottieGifEngine::evaluateNodeTransition(node, animProgress);
            double myOpacity = parentOpacity * std::clamp(tweenState.opacity, 0.0, 1.0);

            bool hasTransform = tweenState.hasTransform && hasActiveTransform(tweenState.transform);
            if (hasTransform) {
                target->pushTransform(x, y, w, effectiveBoxH, tweenState.transform);
            }

            if (node.bookmarkTitle.has_value() && !node.bookmarkTitle->empty()) {
                target->addBookmark(y, node.bookmarkTitle.value());
            }

            processAndDrawShadow(node, yogaNode, x, y, w, effectiveBoxH, target, parentBgColor, animProgress);
            processAndDrawMirror(node, yogaNode, x, y, w, effectiveBoxH, target, parentBgColor, animProgress);

            uint32_t myBgColor = parentBgColor;
            if (node.decoration.has_value() && node.decoration->backgroundColor.has_value()) {
                myBgColor = node.decoration->backgroundColor.value();
            }

            bool hasClip = false;
            std::string clipPath = "";

            bool wantsClip = (node.decoration.has_value() &&
                              (node.decoration->isClip ||
                               node.decoration->shape == 1 ||
                               (node.decoration->borderRadius.has_value() && !node.children.empty()))) ||
                             (node.layout.has_value() && node.layout->overflow == 1);

            if (wantsClip) {
                hasClip = true;
                if (node.decoration.has_value() &&
                    (node.decoration->isClip || node.decoration->borderRadius.has_value() || node.decoration->shape == 1)) {
                    clipPath = ClipEngine::generateClipPath(w, effectiveBoxH, x, y, pageHeight, node.decoration.value());
                    if (node.decoration->clipRule == 1 && !clipPath.empty()) {
                        clipPath += "W* n\n";
                    }
                }
            }

            if (hasClip) target->pushClip(x, y, w, effectiveBoxH, clipPath, node.decoration);

            std::vector<ZNode> zNodes;
            zNodes.reserve(node.children.size());

            for (size_t i = 0; i < node.children.size(); ++i) {
                int z = 0;
                if (node.children[i].position.has_value()) z = node.children[i].position.value().zIndex;
                YGNodeRef childYogaNode = YGNodeGetChild(yogaNode, i);
                zNodes.push_back({&node.children[i], childYogaNode, z});
            }

            std::stable_sort(zNodes.begin(), zNodes.end(), [](const ZNode& a, const ZNode& b) {
                return a.zIndex < b.zIndex;
            });

            bool isRowLayout = node.layout.has_value() && (node.layout->direction == 2 || node.layout->direction == 3);
            double childFlowOffset = 0.0;

            size_t splitIdx = 0;
            while (splitIdx < zNodes.size() && zNodes[splitIdx].zIndex < 0) {
                double rowBranchOffset = isRowLayout ? 0.0 : childFlowOffset;
                paintTreeInternal(
                        *zNodes[splitIdx].container, zNodes[splitIdx].yogaNode, target,
                        x, y, rowBranchOffset, myBgColor, myOpacity, animProgress,
                        headerReserve, footerReserve, rootBottomMargin,
                        currentPageNum, totalPagesCount
                );
                if (!isRowLayout) childFlowOffset = rowBranchOffset;
                splitIdx++;
            }

            std::optional<BoxDecoration> effectiveDeco = node.decoration;
            if (effectiveDeco.has_value()) {
                effectiveDeco->opacity = myOpacity;
            } else if (myOpacity < 0.999) {
                BoxDecoration tempDeco;
                tempDeco.opacity = myOpacity;
                effectiveDeco = tempDeco;
            }

            switch (node.type) {
                case 0:
                    target->drawBox(x, y, w, effectiveBoxH, effectiveDeco);
                    if (node.formField.has_value()) {
                        target->drawFormField(x, y, w, effectiveBoxH, node.formField.value(), node.typography);
                    }
                    break;
                case 1:
                    if (node.content.has_value()) {
                        if (node.decoration.has_value()) target->drawBox(x, y, w, h, effectiveDeco);
                        std::optional<Typography> effectiveTypo = node.typography;
                        if (effectiveTypo.has_value() && myOpacity < 0.999) {
                            uint32_t c = effectiveTypo->color;
                            uint8_t a = static_cast<uint8_t>(std::round(((c >> 24) & 0xFF) * myOpacity));
                            effectiveTypo->color = (static_cast<uint32_t>(a) << 24) | (c & 0x00FFFFFF);
                        }
                        bool replacedPageToken = false;
                        std::string resolvedText = resolvePageTokens(
                                node.content.value(), currentPageNum, totalPagesCount, replacedPageToken
                        );
                        // Bypass pre-baked rasterMask if dynamic page token changed the text string
                        const std::optional<std::string>& effectiveMask =
                                replacedPageToken ? std::nullopt : node.rasterMask;
                        target->drawText(x, y, w, h, resolvedText, effectiveTypo, effectiveMask);
                    }
                    break;
                case 2:
                    if (node.content.has_value()) {
                        target->drawImage(x, y, w, h, node.content.value(), node.imageProps, effectiveDeco);
                    }
                    break;
                case 3:
                    if (node.content.has_value()) target->drawSvg(x, y, w, h, node.content.value(), node.svgProps);
                    break;
                case 4:
                    if (node.content.has_value()) {
                        if (node.decoration.has_value()) target->drawBox(x, y, w, h, effectiveDeco);
                        double lottieProg = (animProgress < 0.999) ? animProgress : 0.0;
                        target->drawLottie(x, y, w, h, node.content.value(), node.lottieProps, lottieProg, myBgColor);
                    }
                    break;
            }

            if (node.linkUrl.has_value() && !node.linkUrl->empty()) {
                target->addLink(x, y, w, effectiveBoxH, node.linkUrl.value());
            }

            double maxRowOffset = 0.0;
            while (splitIdx < zNodes.size()) {
                double rowBranchOffset = isRowLayout ? 0.0 : childFlowOffset;
                paintTreeInternal(
                        *zNodes[splitIdx].container, zNodes[splitIdx].yogaNode, target,
                        x, y, rowBranchOffset, myBgColor, myOpacity, animProgress,
                        headerReserve, footerReserve, rootBottomMargin,
                        currentPageNum, totalPagesCount
                );
                if (isRowLayout) {
                    maxRowOffset = std::max(maxRowOffset, rowBranchOffset);
                } else {
                    childFlowOffset = rowBranchOffset;
                }
                splitIdx++;
            }

            if (!isAbsolute) {
                flowOffsetY += (isRowLayout ? maxRowOffset : childFlowOffset);
            }

            if (triggerBreakAfter && pageHeight > 0 && !isAbsolute) {
                double bottomY = y + h + (isRowLayout ? maxRowOffset : childFlowOffset);
                int endP = static_cast<int>(std::floor(bottomY / pageHeight));
                double nextPTop = (endP + 1) * pageHeight + headerReserve;
                if (nextPTop > bottomY + 1.0) {
                    flowOffsetY += (nextPTop - bottomY);
                }
            }

            if (hasClip) target->popClip();
            if (hasTransform) target->popTransform();
        }

    public:
        static YGNodeRef solveLayout(CoreDocument& doc) {
            for (const auto& kv : doc.fonts) {
                FontEngine::getInstance().loadFont(kv.first, kv.second);
            }

            if (doc.defaultTypography.has_value()) {
                applyDefaultTypographyRecursive(doc.body, doc.defaultTypography.value());
                if (doc.header.has_value()) applyDefaultTypographyRecursive(doc.header.value(), doc.defaultTypography.value());
                if (doc.footer.has_value()) applyDefaultTypographyRecursive(doc.footer.value(), doc.defaultTypography.value());
            }

            if (doc.header.has_value() || doc.footer.has_value()) {
                SuperContainer pageNode;
                pageNode.id = "VIRTUAL_PAGE";
                pageNode.type = 0;

                FlexLayout pageLayout;
                pageLayout.direction = 0;
                pageLayout.justifyContent = 0;
                pageLayout.alignItems = 4;
                pageNode.layout = pageLayout;

                if (doc.header.has_value()) {
                    SuperContainer hWrap;
                    hWrap.id = "__CANVAS_HEADER__";
                    hWrap.type = 0;
                    FlexLayout hl;
                    hl.alignItems = 4;
                    hWrap.layout = hl;
                    hWrap.children.push_back(doc.header.value());
                    pageNode.children.push_back(std::move(hWrap));
                }

                SuperContainer originalBody = doc.body;
                if (!originalBody.layout.has_value()) originalBody.layout = FlexLayout();
                originalBody.layout->flexGrow = 1.0;
                originalBody.layout->flexShrink = 1.0;

                if (originalBody.constraints.has_value() && originalBody.constraints->heightPercent.has_value()) {
                    originalBody.constraints->heightPercent = std::nullopt;
                }

                pageNode.children.push_back(std::move(originalBody));

                if (doc.footer.has_value()) {
                    SuperContainer fWrap;
                    fWrap.id = "__CANVAS_FOOTER__";
                    fWrap.type = 0;
                    FlexLayout fl;
                    fl.alignItems = 4;
                    fWrap.layout = fl;
                    fWrap.children.push_back(doc.footer.value());
                    pageNode.children.push_back(std::move(fWrap));
                }

                doc.body = std::move(pageNode);
            }

            YGNodeRef rootYogaNode = LayoutEngine::buildYogaTree(doc.body, true);
            if (!rootYogaNode) return nullptr;

            if (doc.config.margin.has_value()) {
                const auto& m = doc.config.margin.value();
                double usableW = doc.config.w - m.left - m.right;
                double usableH = doc.config.h - m.top - m.bottom;
                YGNodeStyleSetWidth(rootYogaNode, usableW);
                YGNodeStyleSetMinHeight(rootYogaNode, usableH);
                YGNodeStyleSetMargin(rootYogaNode, YGEdgeTop, m.top);
                YGNodeStyleSetMargin(rootYogaNode, YGEdgeRight, m.right);
                YGNodeStyleSetMargin(rootYogaNode, YGEdgeBottom, m.bottom);
                YGNodeStyleSetMargin(rootYogaNode, YGEdgeLeft, m.left);
            } else {
                YGNodeStyleSetWidth(rootYogaNode, doc.config.w);
                YGNodeStyleSetMinHeight(rootYogaNode, doc.config.h);
            }

            YGDirection rootDir = (doc.config.dir == 2) ? YGDirectionRTL : YGDirectionLTR;
            YGNodeCalculateLayout(rootYogaNode, YGUndefined, YGUndefined, rootDir);
            return rootYogaNode;
        }

        static void paintTree(
                const SuperContainer& node,
                YGNodeRef yogaNode,
                IRenderTarget* target,
                double parentX = 0,
                double parentY = 0,
                uint32_t parentBgColor = 0xFFFFFFFF,
                double parentOpacity = 1.0,
                double animProgress = 1.0,
                double rootBottomMargin = 0.0
        ) {
            double rootFlowOffsetY = 0.0;
            paintTreeInternal(
                    node, yogaNode, target,
                    parentX, parentY, rootFlowOffsetY,
                    parentBgColor, parentOpacity, animProgress,
                    0.0, 0.0, rootBottomMargin,
                    0, 0
            );
        }
    };
} // namespace CoreCanvas