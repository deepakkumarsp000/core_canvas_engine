// FILE: src/image_canvas.h
// PURPOSE: High-Speed RGBA Framebuffer Exporter for PNG, JPG (stb_image_write), WebP (libwebp) & Animated GIF!
// 🚀 FAANG FIX: Multi-Color SVG Preservation, Zero-Copy Shadow Blitting, Sub-Pixel AA Clipping & WebP Opt-In Guard!

#pragma once
#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <optional>
#include "render_engine.h"
#include "image_engine.h"
#include "font_engine.h"
#include "svg_engine.h"
#include "clip_engine.h"
#include "stb_image_write.h"

#if defined(CANVAS_ENABLE_WEBP) && __has_include("webp/encode.h")
#include "webp/encode.h"
#define HAS_WEBP_ENCODE 1
#else
#define HAS_WEBP_ENCODE 0
#endif

namespace CoreCanvas {

    class ImageCanvas : public IRenderTarget {
    private:
        std::vector<unsigned char> frameBuffer;
        int width, height;
        int channels = 4;
        CanvasConfig canvasConfig;

        struct Affine2D {
            double m00 = 1.0, m01 = 0.0, m02 = 0.0;
            double m10 = 0.0, m11 = 1.0, m12 = 0.0;

            void applyForward(double ux, double uy, double& sx, double& sy) const {
                sx = m00 * ux + m01 * uy + m02;
                sy = m10 * ux + m11 * uy + m12;
            }

            bool applyInverse(double sx, double sy, double& ux, double& uy) const {
                double det = m00 * m11 - m01 * m10;
                if (std::abs(det) < 1e-8) return false;
                double invDet = 1.0 / det;
                double dx = sx - m02;
                double dy = sy - m12;
                ux = ( m11 * dx - m01 * dy) * invDet;
                uy = (-m10 * dx + m00 * dy) * invDet;
                return true;
            }

            static Affine2D multiply(const Affine2D& A, const Affine2D& B) {
                Affine2D R;
                R.m00 = A.m00 * B.m00 + A.m01 * B.m10;
                R.m01 = A.m00 * B.m01 + A.m01 * B.m11;
                R.m02 = A.m00 * B.m02 + A.m01 * B.m12 + A.m02;
                R.m10 = A.m10 * B.m00 + A.m11 * B.m10;
                R.m11 = A.m10 * B.m01 + A.m11 * B.m11;
                R.m12 = A.m10 * B.m02 + A.m11 * B.m12 + A.m12;
                return R;
            }
        };

        std::vector<Affine2D> transformStack;

        struct ClipLayer {
            int x0 = 0, y0 = 0, x1 = 0, y1 = 0;
            double localX = 0.0, localY = 0.0, localW = 0.0, localH = 0.0;
            Affine2D transform;
            std::optional<BoxDecoration> deco;
            std::vector<uint8_t> svgMask;
            int maskW = 0, maskH = 0;
        };
        std::vector<ClipLayer> clipStack;

        Affine2D currentTransform() const {
            if (transformStack.empty()) return Affine2D{};
            return transformStack.back();
        }

        void computeTransformedBounds(double x, double y, double w, double h, int& outX0, int& outY0, int& outX1, int& outY1) const {
            Affine2D M = currentTransform();
            double cx[4] = {x, x + w, x, x + w};
            double cy[4] = {y, y, y + h, y + h};
            double minX = 1e9, minY = 1e9, maxX = -1e9, maxY = -1e9;
            for (int i = 0; i < 4; ++i) {
                double sx, sy;
                M.applyForward(cx[i], cy[i], sx, sy);
                minX = std::min(minX, sx);
                minY = std::min(minY, sy);
                maxX = std::max(maxX, sx);
                maxY = std::max(maxY, sy);
            }
            outX0 = std::max(0, static_cast<int>(std::floor(minX)));
            outY0 = std::max(0, static_cast<int>(std::floor(minY)));
            outX1 = std::min(width, static_cast<int>(std::ceil(maxX)));
            outY1 = std::min(height, static_cast<int>(std::ceil(maxY)));
        }

        // ✨ SUB-PIXEL ANTI-ALIASED COVERAGE [0.0 .. 1.0]: Eliminates staircase jagged edges on Circles & Rounded Corners!
        static double computeShapeCoverage(double px, double py, double w, double h, const BoxDecoration& d) {
            if (px < 0.0 || px >= w || py < 0.0 || py >= h) return 0.0;
            double maxR = std::min(w, h) / 2.0;

            if (d.shape == 1) {
                double cx = w / 2.0, cy = h / 2.0;
                double dist = std::sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
                return std::clamp(maxR + 0.5 - dist, 0.0, 1.0);
            }

            if (d.borderRadius.has_value()) {
                double tl = std::min(d.borderRadius->top, maxR);
                double tr = std::min(d.borderRadius->right, maxR);
                double br = std::min(d.borderRadius->bottom, maxR);
                double bl = std::min(d.borderRadius->left, maxR);

                if (tl > 0.0 && px < tl && py < tl) {
                    double dist = std::sqrt((px - tl) * (px - tl) + (py - tl) * (py - tl));
                    return std::clamp(tl + 0.5 - dist, 0.0, 1.0);
                }
                if (tr > 0.0 && px > w - tr && py < tr) {
                    double dist = std::sqrt((px - (w - tr)) * (px - (w - tr)) + (py - tr) * (py - tr));
                    return std::clamp(tr + 0.5 - dist, 0.0, 1.0);
                }
                if (br > 0.0 && px > w - br && py > h - br) {
                    double dist = std::sqrt((px - (w - br)) * (px - (w - br)) + (py - (h - br)) * (py - (h - br)));
                    return std::clamp(br + 0.5 - dist, 0.0, 1.0);
                }
                if (bl > 0.0 && px < bl && py > h - bl) {
                    double dist = std::sqrt((px - bl) * (px - bl) + (py - (h - bl)) * (py - (h - bl)));
                    return std::clamp(bl + 0.5 - dist, 0.0, 1.0);
                }
            }
            return 1.0;
        }

        static bool isInsideRoundedShape(double px, double py, double w, double h, const BoxDecoration& d) {
            return computeShapeCoverage(px, py, w, h, d) > 0.0;
        }

        bool isInsideActiveClip(int sx, int sy) const {
            if (clipStack.empty()) return true;
            for (const auto& c : clipStack) {
                if (sx < c.x0 || sx >= c.x1 || sy < c.y0 || sy >= c.y1) return false;

                double ux, uy;
                if (!c.transform.applyInverse(sx + 0.5, sy + 0.5, ux, uy)) return false;
                double lx = ux - c.localX;
                double ly = uy - c.localY;
                if (lx < 0.0 || lx >= c.localW || ly < 0.0 || ly >= c.localH) return false;

                if (!c.svgMask.empty() && c.maskW > 0 && c.maskH > 0) {
                    int mx = std::clamp(static_cast<int>((lx / c.localW) * c.maskW), 0, c.maskW - 1);
                    int my = std::clamp(static_cast<int>((ly / c.localH) * c.maskH), 0, c.maskH - 1);
                    if (c.svgMask[(my * c.maskW + mx) * 4 + 3] < 10) return false;
                } else if (c.deco.has_value()) {
                    if (computeShapeCoverage(lx, ly, c.localW, c.localH, c.deco.value()) <= 0.0) return false;
                }
            }
            return true;
        }

        static uint8_t blendChannelMode(int mode, uint8_t s, uint8_t d) {
            if (mode == 0) return s;
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

        void blendPixelScreen(int sx, int sy, uint8_t r, uint8_t g, uint8_t b, uint8_t a, int blendMode = 0) {
            if (sx < 0 || sx >= width || sy < 0 || sy >= height || a == 0) return;
            if (!isInsideActiveClip(sx, sy)) return;

            int idx = (sy * width + sx) * channels;
            uint8_t dR = frameBuffer[idx + 0], dG = frameBuffer[idx + 1], dB = frameBuffer[idx + 2], dA = frameBuffer[idx + 3];

            if (blendMode != 0) {
                r = blendChannelMode(blendMode, r, dR);
                g = blendChannelMode(blendMode, g, dG);
                b = blendChannelMode(blendMode, b, dB);
            }

            double alpha = a / 255.0;
            double inv = 1.0 - alpha;

            frameBuffer[idx + 0] = static_cast<uint8_t>(r * alpha + dR * inv);
            frameBuffer[idx + 1] = static_cast<uint8_t>(g * alpha + dG * inv);
            frameBuffer[idx + 2] = static_cast<uint8_t>(b * alpha + dB * inv);
            frameBuffer[idx + 3] = static_cast<uint8_t>(std::min(255.0, a + dA * inv));
        }

        // ⚡ ZERO-COPY RAW PIXEL BLITTER (Used by both ImageBuffer and std::vector<uint8_t> Shadows!)
        void blitRawPixels(
                double drawX,
                double drawY,
                double drawW,
                double drawH,
                const unsigned char* rawPixels,
                int imgWidth,
                int imgHeight,
                double opacity = 1.0,
                const std::optional<BoxDecoration>& maskDeco = std::nullopt,
                double clipBoxX = 0.0,
                double clipBoxY = 0.0,
                double clipBoxW = 0.0,
                double clipBoxH = 0.0
        ) {
            if (!rawPixels || imgWidth <= 0 || imgHeight <= 0 || drawW <= 0 || drawH <= 0) return;

            double effBoxX = (clipBoxW > 0.0) ? clipBoxX : drawX;
            double effBoxY = (clipBoxH > 0.0) ? clipBoxY : drawY;
            double effBoxW = (clipBoxW > 0.0) ? clipBoxW : drawW;
            double effBoxH = (clipBoxH > 0.0) ? clipBoxH : drawH;

            Affine2D M = currentTransform();
            int sx0, sy0, sx1, sy1;
            computeTransformedBounds(effBoxX, effBoxY, effBoxW, effBoxH, sx0, sy0, sx1, sy1);

            double effOp = std::clamp(opacity, 0.0, 1.0);
            int blendMode = maskDeco.has_value() ? maskDeco->blendMode : 0;

            for (int sy = sy0; sy < sy1; ++sy) {
                for (int sx = sx0; sx < sx1; ++sx) {
                    double ux, uy;
                    if (!M.applyInverse(sx + 0.5, sy + 0.5, ux, uy)) continue;

                    double boxLocalX = ux - effBoxX;
                    double boxLocalY = uy - effBoxY;
                    if (boxLocalX < 0.0 || boxLocalX >= effBoxW || boxLocalY < 0.0 || boxLocalY >= effBoxH) continue;

                    double shapeCov = 1.0;
                    if (maskDeco.has_value()) {
                        shapeCov = computeShapeCoverage(boxLocalX, boxLocalY, effBoxW, effBoxH, maskDeco.value());
                        if (shapeCov <= 0.0) continue;
                    }

                    double imgLocalX = ux - drawX;
                    double imgLocalY = uy - drawY;
                    if (imgLocalX < 0.0 || imgLocalX >= drawW || imgLocalY < 0.0 || imgLocalY >= drawH) continue;

                    int imgX = std::clamp(static_cast<int>((imgLocalX / drawW) * imgWidth), 0, imgWidth - 1);
                    int imgY = std::clamp(static_cast<int>((imgLocalY / drawH) * imgHeight), 0, imgHeight - 1);
                    int sIdx = (imgY * imgWidth + imgX) * 4;

                    uint8_t a = static_cast<uint8_t>(std::round(rawPixels[sIdx + 3] * effOp * shapeCov));
                    if (a > 0) {
                        blendPixelScreen(sx, sy, rawPixels[sIdx + 0], rawPixels[sIdx + 1], rawPixels[sIdx + 2], a, blendMode);
                    }
                }
            }
        }

        void blitImageBuffer(
                double drawX,
                double drawY,
                double drawW,
                double drawH,
                const ImageBuffer& img,
                double opacity = 1.0,
                const std::optional<BoxDecoration>& maskDeco = std::nullopt,
                double clipBoxX = 0.0,
                double clipBoxY = 0.0,
                double clipBoxW = 0.0,
                double clipBoxH = 0.0
        ) {
            blitRawPixels(
                    drawX, drawY, drawW, drawH,
                    img.pixels, img.width, img.height,
                    opacity, maskDeco, clipBoxX, clipBoxY, clipBoxW, clipBoxH
            );
        }

        static uint32_t sampleGrad(const std::vector<int>& stops, double t) {
            if (stops.empty()) return 0xFF000000;
            if (stops.size() == 1) return static_cast<uint32_t>(stops[0]);
            t = std::clamp(t, 0.0, 1.0);
            double scaled = t * (stops.size() - 1);
            size_t idx = static_cast<size_t>(std::floor(scaled));
            if (idx >= stops.size() - 1) return static_cast<uint32_t>(stops.back());
            double frac = scaled - idx;
            uint32_t c1 = static_cast<uint32_t>(stops[idx]);
            uint32_t c2 = static_cast<uint32_t>(stops[idx + 1]);
            uint8_t a = static_cast<uint8_t>(((c1 >> 24) & 0xFF) + (((int)((c2 >> 24) & 0xFF) - (int)((c1 >> 24) & 0xFF)) * frac));
            uint8_t r = static_cast<uint8_t>(((c1 >> 16) & 0xFF) + (((int)((c2 >> 16) & 0xFF) - (int)((c1 >> 16) & 0xFF)) * frac));
            uint8_t g = static_cast<uint8_t>(((c1 >> 8) & 0xFF) + (((int)((c2 >> 8) & 0xFF) - (int)((c1 >> 8) & 0xFF)) * frac));
            uint8_t b = static_cast<uint8_t>((c1 & 0xFF) + (((int)(c2 & 0xFF) - (int)(c1 & 0xFF)) * frac));
            return (static_cast<uint32_t>(a) << 24) | (static_cast<uint32_t>(r) << 16) | (static_cast<uint32_t>(g) << 8) | b;
        }

    public:
        ImageCanvas(const CanvasConfig& config) : canvasConfig(config) {
            width = std::max(1, static_cast<int>(config.w));
            height = std::max(1, static_cast<int>(config.h));
            frameBuffer.resize(width * height * channels, 255);
        }

        void clear(uint32_t argb = 0xFFFFFFFF) {
            uint8_t a = (argb >> 24) & 0xFF, r = (argb >> 16) & 0xFF, g = (argb >> 8) & 0xFF, b = argb & 0xFF;
            for (int i = 0; i < width * height; ++i) {
                frameBuffer[i * 4 + 0] = r;
                frameBuffer[i * 4 + 1] = g;
                frameBuffer[i * 4 + 2] = b;
                frameBuffer[i * 4 + 3] = a;
            }
            clipStack.clear();
            transformStack.clear();
        }

        const unsigned char* getPixels() const { return frameBuffer.data(); }
        int getWidth() const { return width; }
        int getHeight() const { return height; }

        bool saveToPng(const std::string& path) {
            ImageEngine::applyColorSpace(frameBuffer.data(), width, height, canvasConfig.colorSpace);
            return stbi_write_png(path.c_str(), width, height, channels, frameBuffer.data(), width * channels) != 0;
        }

        bool saveToJpg(const std::string& path, int quality = 95) {
            ImageEngine::applyColorSpace(frameBuffer.data(), width, height, canvasConfig.colorSpace);
            int safeQ = std::clamp(quality, 1, 100);
            return stbi_write_jpg(path.c_str(), width, height, channels, frameBuffer.data(), safeQ) != 0;
        }

        bool saveToWebp(const std::string& path, int quality = 90, bool lossless = false) {
            ImageEngine::applyColorSpace(frameBuffer.data(), width, height, canvasConfig.colorSpace);
#if HAS_WEBP_ENCODE
            uint8_t* output = nullptr;
            size_t size = 0;
            if (lossless) {
                size = WebPEncodeLosslessRGBA(frameBuffer.data(), width, height, width * 4, &output);
            } else {
                float q = static_cast<float>(std::clamp(quality, 1, 100));
                size = WebPEncodeRGBA(frameBuffer.data(), width, height, width * 4, q, &output);
            }
            if (size == 0 || !output) return false;
            std::ofstream file(path, std::ios::binary);
            bool ok = false;
            if (file.is_open()) {
                file.write(reinterpret_cast<const char*>(output), size);
                ok = file.good();
            }
            WebPFree(output);
            return ok;
#else
            (void)quality;
            (void)lossless;
            return saveToPng(path);
#endif
        }

        bool saveToTargetFormat(const std::string& path) {
            if (canvasConfig.targetFormat == 3) {
                return saveToJpg(path, canvasConfig.quality);
            } else if (canvasConfig.targetFormat == 4) {
                return saveToWebp(path, canvasConfig.quality, canvasConfig.lossless);
            }
            return saveToPng(path);
        }

        double getPageHeight() override { return static_cast<double>(height); }

        void pushTransform(double x, double y, double w, double h, const TransformMatrix& tm) override {
            double pivotX = x + w * tm.originX;
            double pivotY = y + h * tm.originY;

            double rad = tm.rotateZ * (3.14159265358979323846 / 180.0);
            double cosA = std::cos(rad);
            double sinA = std::sin(rad);
            double tanSkX = std::tan(tm.skewX * (3.14159265358979323846 / 180.0));
            double tanSkY = std::tan(tm.skewY * (3.14159265358979323846 / 180.0));

            double a = tm.scaleX * cosA;
            double b = tm.scaleX * sinA + tanSkY;
            double c = -tm.scaleY * sinA + tanSkX;
            double d = tm.scaleY * cosA;

            Affine2D local;
            local.m00 = a;
            local.m01 = c;
            local.m02 = pivotX + tm.translateX - (a * pivotX + c * pivotY);
            local.m10 = b;
            local.m11 = d;
            local.m12 = pivotY + tm.translateY - (b * pivotX + d * pivotY);

            if (transformStack.empty()) {
                transformStack.push_back(local);
            } else {
                transformStack.push_back(Affine2D::multiply(transformStack.back(), local));
            }
        }

        void popTransform() override {
            if (!transformStack.empty()) {
                transformStack.pop_back();
            }
        }

        void drawBox(double x, double y, double w, double h, const std::optional<BoxDecoration>& deco) override {
            if (!deco.has_value() || w <= 0 || h <= 0) return;
            const auto& d = deco.value();

            bool hasFill = d.backgroundColor.has_value();
            bool hasGrad = d.gradient.has_value() && !d.gradient->empty();
            bool hasBgImg = d.backgroundImage.has_value() && !d.backgroundImage->empty();
            bool hasBorder = d.borderColor.has_value() && d.borderWidth.has_value() && d.borderWidth->top > 0;

            if (!hasFill && !hasGrad && !hasBgImg && !hasBorder) return;

            Affine2D M = currentTransform();
            int sx0, sy0, sx1, sy1;
            computeTransformedBounds(x, y, w, h, sx0, sy0, sx1, sy1);

            double effOp = std::clamp(d.opacity, 0.0, 1.0);

            ImageBuffer bgImg;
            if (hasBgImg) bgImg = ImageEngine::decodeImage(d.backgroundImage.value());

            double rad = d.gradientAngle * (3.14159265358979323846 / 180.0);
            double gdx = std::cos(rad), gdy = std::sin(rad);
            double maxProj = std::max(0.5, (std::abs(gdx) + std::abs(gdy)) * 0.5);

            double bw = hasBorder ? d.borderWidth->top : 0.0;
            uint32_t bc = hasBorder ? d.borderColor.value() : 0;

            for (int sy = sy0; sy < sy1; ++sy) {
                for (int sx = sx0; sx < sx1; ++sx) {
                    double ux, uy;
                    if (!M.applyInverse(sx + 0.5, sy + 0.5, ux, uy)) continue;
                    double lx = ux - x;
                    double ly = uy - y;
                    if (lx < 0.0 || lx >= w || ly < 0.0 || ly >= h) continue;

                    double outerCov = computeShapeCoverage(lx, ly, w, h, d);
                    if (outerCov <= 0.0) continue;

                    bool isBorderPx = false;
                    if (hasBorder && bw > 0) {
                        double innerCov = computeShapeCoverage(lx - bw, ly - bw, std::max(1.0, w - bw * 2), std::max(1.0, h - bw * 2), d);
                        if (innerCov < 0.5) {
                            isBorderPx = true;
                        }
                    }

                    uint8_t sR = 0, sG = 0, sB = 0, sA = 0;
                    if (isBorderPx) {
                        sA = (bc >> 24) & 0xFF;
                        sR = (bc >> 16) & 0xFF;
                        sG = (bc >> 8) & 0xFF;
                        sB = bc & 0xFF;
                    } else {
                        if (hasGrad) {
                            double nx = lx / std::max(1.0, w), ny = ly / std::max(1.0, h);
                            double t = (std::abs(d.gradientAngle) < 1e-4)
                                       ? (nx * 0.65 + ny * 0.35)
                                       : (((nx - 0.5) * gdx + (ny - 0.5) * gdy) / (2.0 * maxProj) + 0.5);
                            uint32_t gc = sampleGrad(d.gradient.value(), t);
                            sA = (gc >> 24) & 0xFF; sR = (gc >> 16) & 0xFF; sG = (gc >> 8) & 0xFF; sB = gc & 0xFF;
                        } else if (hasFill) {
                            uint32_t fc = d.backgroundColor.value();
                            sA = (fc >> 24) & 0xFF; sR = (fc >> 16) & 0xFF; sG = (fc >> 8) & 0xFF; sB = fc & 0xFF;
                        }

                        if (bgImg.pixels && bgImg.width > 0 && bgImg.height > 0) {
                            int imgX = std::clamp(static_cast<int>((lx / std::max(1.0, w)) * bgImg.width), 0, bgImg.width - 1);
                            int imgY = std::clamp(static_cast<int>((ly / std::max(1.0, h)) * bgImg.height), 0, bgImg.height - 1);
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
                    }

                    sA = static_cast<uint8_t>(std::round(sA * effOp * outerCov));
                    if (sA > 0) {
                        blendPixelScreen(sx, sy, sR, sG, sB, sA, d.blendMode);
                    }
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
            double op = 1.0;
            if (typo.has_value()) {
                op = ((typo->color >> 24) & 0xFF) / 255.0;
            }
            if (rasterMask.has_value() && !rasterMask->empty()) {
                ImageBuffer img = ImageEngine::decodeImage(rasterMask.value());
                blitImageBuffer(x, y, w, h, img, op);
                return;
            }
            std::string fontName = "Helvetica";
            double fontSize = 12.0, letterSpacing = 0.0, wordSpacing = 0.0;
            uint32_t color = 0xFF000000;
            int weight = 400, align = 0;
            if (typo.has_value()) {
                fontSize = typo->fontSize;
                color = typo->color;
                weight = typo->weight;
                align = typo->align;
                letterSpacing = typo->letterSpacing;
                wordSpacing = typo->wordSpacing;
                if (typo->fontFamily.has_value()) fontName = typo->fontFamily.value();
            }
            ImageBuffer img = FontEngine::getInstance().renderTextToImage(
                    text, fontName, fontSize,
                    std::max(1, static_cast<int>(std::ceil(w))),
                    std::max(1, static_cast<int>(std::ceil(h))),
                    color, weight, align, letterSpacing, wordSpacing
            );
            blitImageBuffer(x, y, w, h, img, op);
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
            ImageBuffer img = ImageEngine::decodeImage(base64);
            if (!img.pixels || img.width <= 0 || img.height <= 0) return;

            double op = deco.has_value() ? deco->opacity : 1.0;
            ImageProps activeProps = props.value_or(ImageProps{3, 0, std::nullopt});
            ImageDrawRect fitRect = ImageEngine::calculateFit(w, h, img.width, img.height, activeProps);

            blitImageBuffer(x + fitRect.x, y + fitRect.y, fitRect.w, fitRect.h, img, op, deco, x, y, w, h);

            if (deco.has_value() && deco->borderColor.has_value() && deco->borderWidth.has_value() && deco->borderWidth->top > 0) {
                BoxDecoration borderOnly = deco.value();
                borderOnly.backgroundColor = std::nullopt;
                borderOnly.gradient = std::nullopt;
                borderOnly.backgroundImage = std::nullopt;
                drawBox(x, y, w, h, borderOnly);
            }
        }

        void drawSvg(double x, double y, double w, double h, const std::string& svgXml, const std::optional<SvgProps>& props) override {
            if (svgXml.empty() || w <= 0 || h <= 0) return;
            NSVGimage* svgImg = SvgEngine::parseSvg(svgXml);
            if (!svgImg) return;
            int rw = std::max(1, static_cast<int>(std::ceil(w)));
            int rh = std::max(1, static_cast<int>(std::ceil(h)));

            // 🔥 FIX: Pass std::nullopt when no custom fill is set so multi-color SVGs keep their authentic colors!
            std::optional<uint32_t> fillOverride = std::nullopt;
            if (props.has_value() && props->fill.has_value()) {
                fillOverride = static_cast<uint32_t>(props->fill.value());
            }

            std::vector<uint8_t> px = SvgEngine::rasterizeSvg(svgImg, rw, rh, fillOverride);
            SvgEngine::freeSvg(svgImg);
            if (!px.empty()) {
                drawRasterShadow(x, y, rw, rh, px, 0xFFFFFFFF);
            }
        }

        void drawRasterShadow(double x, double y, double w, double h, const std::vector<uint8_t>& pixels, uint32_t parentBgColor) override {
            (void)parentBgColor;
            int pw = static_cast<int>(w), ph = static_cast<int>(h);
            if (pw <= 0 || ph <= 0 || pixels.size() < static_cast<size_t>(pw * ph * 4)) return;

            // ⚡ ZERO-COPY BLIT: Directly blits from std::vector<uint8_t> without malloc/memcpy!
            blitRawPixels(x, y, w, h, pixels.data(), pw, ph, 1.0);
        }

        void pushClip(double x, double y, double w, double h, const std::string& clipSvgPath) override {
            pushClip(x, y, w, h, clipSvgPath, std::nullopt);
        }

        void pushClip(
                double x,
                double y,
                double w,
                double h,
                const std::string& clipSvgPath,
                const std::optional<BoxDecoration>& deco
        ) override {
            (void)clipSvgPath;
            ClipLayer layer;
            computeTransformedBounds(x, y, w, h, layer.x0, layer.y0, layer.x1, layer.y1);
            if (!clipStack.empty()) {
                layer.x0 = std::max(layer.x0, clipStack.back().x0);
                layer.y0 = std::max(layer.y0, clipStack.back().y0);
                layer.x1 = std::min(layer.x1, clipStack.back().x1);
                layer.y1 = std::min(layer.y1, clipStack.back().y1);
            }
            layer.localX = x;
            layer.localY = y;
            layer.localW = std::max(1.0, w);
            layer.localH = std::max(1.0, h);
            layer.transform = currentTransform();
            layer.deco = deco;

            if (deco.has_value() && deco->isClip && (deco->clipSvgPath.has_value() || deco->clipMath.has_value())) {
                std::string svgXml = ClipEngine::generateClipSvgXml(w, h, deco.value());
                if (deco->clipRule == 1 && svgXml.find("fill-rule") == std::string::npos) {
                    size_t pos = svgXml.find("<path ");
                    if (pos != std::string::npos) svgXml.insert(pos + 6, "fill-rule=\"evenodd\" ");
                }
                NSVGimage* svgImg = SvgEngine::parseSvg(svgXml);
                if (svgImg) {
                    layer.maskW = std::max(1, static_cast<int>(std::ceil(w)));
                    layer.maskH = std::max(1, static_cast<int>(std::ceil(h)));
                    layer.svgMask = SvgEngine::rasterizeSvg(svgImg, layer.maskW, layer.maskH, 0xFFFFFFFF);
                    SvgEngine::freeSvg(svgImg);
                }
            }

            clipStack.push_back(std::move(layer));
        }

        void popClip() override {
            if (!clipStack.empty()) clipStack.pop_back();
        }
    };

} // namespace CoreCanvas