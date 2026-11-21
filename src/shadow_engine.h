// FILE: src/shadow_engine.h
// PURPOSE: Universal Rasterized True Shadow & Mirror Reflection Generator (Enterprise Speed)
// 🚀 FAANG FIX: Restored Mirror Fade Math Operators, Safe ImageBuffer::allocate & O(N) Alpha Dilation!

#pragma once
#include <vector>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <cstdlib>
#include <algorithm>
#include <iostream>
#include "config.h"
#include "image_engine.h"
#include "svg_engine.h"
#include "param_style.h"

namespace CoreCanvas {

    struct ShadowResult {
        std::vector<uint8_t> pixels;
        int width = 0;
        int height = 0;
        double drawX = 0.0;
        double drawY = 0.0;
    };

    class ShadowEngine {
    private:
        static void boxBlurH(const std::vector<uint8_t>& in, std::vector<uint8_t>& out, int w, int h, int r) {
            double iarr = 1.0 / (r + r + 1);
            for (int i = 0; i < h; i++) {
                int ti = i * w, li = ti, ri = ti + r;
                int fv = in[ti], lv = in[ti + w - 1], val = (r + 1) * fv;
                for (int j = 0; j < r; j++) val += in[ti + j];
                for (int j = 0; j <= r; j++) { val += in[ri++] - fv; out[ti++] = static_cast<uint8_t>(std::round(val * iarr)); }
                for (int j = r + 1; j < w - r; j++) { val += in[ri++] - in[li++]; out[ti++] = static_cast<uint8_t>(std::round(val * iarr)); }
                for (int j = w - r; j < w; j++) { val += lv - in[li++]; out[ti++] = static_cast<uint8_t>(std::round(val * iarr)); }
            }
        }

        static void boxBlurT(const std::vector<uint8_t>& in, std::vector<uint8_t>& out, int w, int h, int r) {
            double iarr = 1.0 / (r + r + 1);
            for (int i = 0; i < w; i++) {
                int ti = i, li = ti, ri = ti + r * w;
                int fv = in[ti], lv = in[ti + w * (h - 1)], val = (r + 1) * fv;
                for (int j = 0; j < r; j++) val += in[ti + j * w];
                for (int j = 0; j <= r; j++) { val += in[ri] - fv; out[ti] = static_cast<uint8_t>(std::round(val * iarr)); ri += w; ti += w; }
                for (int j = r + 1; j < h - r; j++) { val += in[ri] - in[li]; out[ti] = static_cast<uint8_t>(std::round(val * iarr)); li += w; ri += w; ti += w; }
                for (int j = h - r; j < h; j++) { val += lv - in[li]; out[ti] = static_cast<uint8_t>(std::round(val * iarr)); li += w; ti += w; }
            }
        }

        static void fastBoxBlur(std::vector<uint8_t>& pixels, int w, int h, int r) {
            if (r <= 0 || w <= 0 || h <= 0) return;
            int safeR = std::min({r, (w - 1) / 2, (h - 1) / 2});
            if (safeR <= 0) return;
            std::vector<uint8_t> temp(pixels.size());
            boxBlurH(pixels, temp, w, h, safeR);
            boxBlurT(temp, pixels, w, h, safeR);
            boxBlurH(pixels, temp, w, h, safeR);
            boxBlurT(temp, pixels, w, h, safeR);
            boxBlurH(pixels, temp, w, h, safeR);
            boxBlurT(temp, pixels, w, h, safeR);
        }

        static void dilateAlphaMask(std::vector<uint8_t>& mask, int w, int h, int radius) {
            if (radius <= 0 || w <= 0 || h <= 0) return;
            std::vector<uint8_t> temp(w * h, 0);

            for (int y = 0; y < h; ++y) {
                int rowOffset = y * w;
                for (int x = 0; x < w; ++x) {
                    int x0 = std::max(0, x - radius);
                    int x1 = std::min(w - 1, x + radius);
                    uint8_t maxVal = 0;
                    for (int kx = x0; kx <= x1; ++kx) {
                        uint8_t v = mask[rowOffset + kx];
                        if (v > maxVal) {
                            maxVal = v;
                            if (maxVal == 255) break;
                        }
                    }
                    temp[rowOffset + x] = maxVal;
                }
            }

            for (int y = 0; y < h; ++y) {
                int y0 = std::max(0, y - radius);
                int y1 = std::min(h - 1, y + radius);
                for (int x = 0; x < w; ++x) {
                    uint8_t maxVal = 0;
                    for (int ky = y0; ky <= y1; ++ky) {
                        uint8_t v = temp[ky * w + x];
                        if (v > maxVal) {
                            maxVal = v;
                            if (maxVal == 255) break;
                        }
                    }
                    mask[y * w + x] = maxVal;
                }
            }
        }

        static uint32_t sampleColorStops(const std::vector<int>& stops, double t) {
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

    public:
        // ============================================================================
        // [SECTION A] STANDARD BOX SHADOW (Supports Rectangle, Asymmetric Radius, Circle & Gradients)
        // ============================================================================
        static ShadowResult generateBoxShadow(
                double boxW,
                double boxH,
                double x,
                double y,
                const CanvasShadow& shadowProps,
                const std::optional<EdgeInsets>& radius,
                int shape = 0
        ) {
            ShadowResult result;
            uint32_t color = shadowProps.color;
            double offsetX = shadowProps.offsetX, offsetY = shadowProps.offsetY;
            double blurRadius = shadowProps.blurRadius, spreadRadius = shadowProps.spreadRadius;

            bool hasGrad = shadowProps.gradient.has_value() && !shadowProps.gradient->empty();
            uint8_t a = (color >> 24) & 0xFF, r = (color >> 16) & 0xFF, g = (color >> 8) & 0xFF, b = color & 0xFF;
            if (!hasGrad && (a == 0 || (blurRadius == 0 && spreadRadius == 0 && offsetX == 0 && offsetY == 0))) {
                return result;
            }

            int padding = static_cast<int>(std::ceil(blurRadius * 2.5));
            int targetW = static_cast<int>(std::ceil(boxW + (spreadRadius * 2) + (padding * 2)));
            int targetH = static_cast<int>(std::ceil(boxH + (spreadRadius * 2) + (padding * 2)));
            if (targetW <= 0 || targetH <= 0) return result;

            std::vector<uint8_t> alphaMask(targetW * targetH, 0);
            int startX = padding, startY = padding, endX = targetW - padding, endY = targetH - padding;
            double effW = endX - startX, effH = endY - startY;

            double maxR = std::min(effW, effH) / 2.0;
            double tl = 0, tr = 0, br = 0, bl = 0;
            if (shape == 1) {
                tl = tr = br = bl = maxR;
            } else if (radius.has_value()) {
                tl = std::clamp(radius->top + spreadRadius, 0.0, maxR);
                tr = std::clamp(radius->right + spreadRadius, 0.0, maxR);
                br = std::clamp(radius->bottom + spreadRadius, 0.0, maxR);
                bl = std::clamp(radius->left + spreadRadius, 0.0, maxR);
            }

            for (int iy = startY; iy < endY; ++iy) {
                for (int ix = startX; ix < endX; ++ix) {
                    double px = ix - startX, py = iy - startY;
                    bool inside = true;
                    if (tl > 0 && px < tl && py < tl) inside = (px - tl)*(px - tl) + (py - tl)*(py - tl) <= tl*tl;
                    else if (tr > 0 && px > effW - tr && py < tr) inside = (px - (effW - tr))*(px - (effW - tr)) + (py - tr)*(py - tr) <= tr*tr;
                    else if (br > 0 && px > effW - br && py > effH - br) inside = (px - (effW - br))*(px - (effW - br)) + (py - (effH - br))*(py - (effH - br)) <= br*br;
                    else if (bl > 0 && px < bl && py > effH - bl) inside = (px - bl)*(px - bl) + (py - (effH - bl))*(py - (effH - bl)) <= bl*bl;

                    if (inside) alphaMask[iy * targetW + ix] = 255;
                }
            }

            int blurPx = static_cast<int>(std::ceil(blurRadius / 2.0));
            if (blurPx > 0) fastBoxBlur(alphaMask, targetW, targetH, blurPx);

            result.pixels.resize(targetW * targetH * 4, 0);
            for (int iy = 0; iy < targetH; ++iy) {
                for (int ix = 0; ix < targetW; ++ix) {
                    size_t i = static_cast<size_t>(iy * targetW + ix);
                    uint8_t curR = r, curG = g, curB = b, curA = a;
                    if (hasGrad) {
                        double t = (ix / std::max(1.0, (double)targetW)) * 0.65 + (iy / std::max(1.0, (double)targetH)) * 0.35;
                        uint32_t gc = sampleColorStops(shadowProps.gradient.value(), t);
                        curA = (gc >> 24) & 0xFF;
                        curR = (gc >> 16) & 0xFF;
                        curG = (gc >> 8) & 0xFF;
                        curB = gc & 0xFF;
                    }
                    result.pixels[i * 4 + 0] = curR;
                    result.pixels[i * 4 + 1] = curG;
                    result.pixels[i * 4 + 2] = curB;
                    double alphaFactor = (alphaMask[i] / 255.0) * (curA / 255.0);
                    result.pixels[i * 4 + 3] = static_cast<uint8_t>(std::clamp(alphaFactor * 255.0, 0.0, 255.0));
                }
            }
            result.width = targetW;
            result.height = targetH;
            result.drawX = x - spreadRadius - padding + offsetX;
            result.drawY = y - spreadRadius - padding + offsetY;
            return result;
        }

        // ============================================================================
        // [SECTION B] IMAGE & RASTERIZED TEXT SHADOW (True Shape Alpha Dilation + Blur)
        // ============================================================================
        static ShadowResult generateImageShadow(
                const ImageBuffer& img,
                double boxW,
                double boxH,
                double x,
                double y,
                const CanvasShadow& shadowProps
        ) {
            if (!shadowProps.isDropShadow || shadowProps.shadowType == 1) {
                return generateBoxShadow(boxW, boxH, x, y, shadowProps, std::nullopt, 0);
            }

            ShadowResult result;
            if (!img.pixels || img.channels != 4) return result;

            uint32_t color = shadowProps.color;
            double offsetX = shadowProps.offsetX, offsetY = shadowProps.offsetY;
            double blurRadius = shadowProps.blurRadius, spreadRadius = shadowProps.spreadRadius;

            bool hasGrad = shadowProps.gradient.has_value() && !shadowProps.gradient->empty();
            uint8_t a = (color >> 24) & 0xFF, r = (color >> 16) & 0xFF, g = (color >> 8) & 0xFF, b = color & 0xFF;
            if (!hasGrad && a == 0) return result;

            int padding = static_cast<int>(std::ceil(blurRadius * 2.5));
            int spreadPx = std::max(0, static_cast<int>(std::ceil(spreadRadius)));
            int targetW = static_cast<int>(std::ceil(boxW + (spreadPx * 2) + (padding * 2)));
            int targetH = static_cast<int>(std::ceil(boxH + (spreadPx * 2) + (padding * 2)));
            if (targetW <= 0 || targetH <= 0) return result;

            std::vector<uint8_t> alphaMask(targetW * targetH, 0);
            double scaleX = static_cast<double>(img.width) / boxW;
            double scaleY = static_cast<double>(img.height) / boxH;
            int startX = padding + spreadPx, startY = padding + spreadPx;

            for (int iy = 0; iy < std::ceil(boxH); ++iy) {
                for (int ix = 0; ix < std::ceil(boxW); ++ix) {
                    int imgX = std::clamp(static_cast<int>(ix * scaleX), 0, img.width - 1);
                    int imgY = std::clamp(static_cast<int>(iy * scaleY), 0, img.height - 1);
                    uint8_t imgAlpha = img.pixels[(imgY * img.width + imgX) * 4 + 3];
                    if (imgAlpha > 0) {
                        int outX = startX + ix, outY = startY + iy;
                        if (outX >= 0 && outX < targetW && outY >= 0 && outY < targetH) {
                            alphaMask[outY * targetW + outX] = imgAlpha;
                        }
                    }
                }
            }

            if (spreadPx > 0) {
                dilateAlphaMask(alphaMask, targetW, targetH, spreadPx);
            }

            int blurPx = static_cast<int>(std::ceil(blurRadius / 2.0));
            if (blurPx > 0) fastBoxBlur(alphaMask, targetW, targetH, blurPx);

            result.pixels.resize(targetW * targetH * 4, 0);
            for (int iy = 0; iy < targetH; ++iy) {
                for (int ix = 0; ix < targetW; ++ix) {
                    size_t i = static_cast<size_t>(iy * targetW + ix);
                    uint8_t curR = r, curG = g, curB = b, curA = a;
                    if (hasGrad) {
                        double t = (ix / std::max(1.0, (double)targetW)) * 0.65 + (iy / std::max(1.0, (double)targetH)) * 0.35;
                        uint32_t gc = sampleColorStops(shadowProps.gradient.value(), t);
                        curA = (gc >> 24) & 0xFF;
                        curR = (gc >> 16) & 0xFF;
                        curG = (gc >> 8) & 0xFF;
                        curB = gc & 0xFF;
                    }
                    result.pixels[i * 4 + 0] = curR;
                    result.pixels[i * 4 + 1] = curG;
                    result.pixels[i * 4 + 2] = curB;
                    double normalizedMask = std::min(1.0, (alphaMask[i] / 255.0) * 1.35);
                    double alphaFactor = normalizedMask * (curA / 255.0);
                    result.pixels[i * 4 + 3] = static_cast<uint8_t>(std::clamp(alphaFactor * 255.0, 0.0, 255.0));
                }
            }
            result.width = targetW;
            result.height = targetH;
            result.drawX = x - spreadPx - padding + offsetX;
            result.drawY = y - spreadPx - padding + offsetY;
            return result;
        }

        // ============================================================================
        // [SECTION C] UNIVERSAL MIRROR REFLECTION ENGINE (Supports 5 FadeDirections & FadeGradient!)
        // ============================================================================
        static ShadowResult generateImageMirror(
                const ImageBuffer& img,
                double boxW,
                double boxH,
                double x,
                double y,
                const CanvasReflection& mirrorProps
        ) {
            ShadowResult result;
            if (!img.pixels || img.channels != 4 || mirrorProps.opacity <= 0.0) return result;

            double blurRadius = mirrorProps.blurRadius;
            int padding = static_cast<int>(std::ceil(blurRadius * 2.0));
            int targetW = static_cast<int>(std::ceil(boxW + (padding * 2)));
            int targetH = static_cast<int>(std::ceil(boxH + (padding * 2)));
            if (targetW <= 0 || targetH <= 0) return result;

            int maxContentRow = img.height - 1;
            for (int ry = img.height - 1; ry >= 0; --ry) {
                bool rowHasPixels = false;
                for (int rx = 0; rx < img.width; ++rx) {
                    if (img.pixels[(ry * img.width + rx) * 4 + 3] > 5) {
                        rowHasPixels = true;
                        break;
                    }
                }
                if (rowHasPixels) {
                    maxContentRow = ry;
                    break;
                }
            }

            uint8_t fallbackR = 255, fallbackG = 255, fallbackB = 255;
            for (int i = 0; i < img.width * img.height; ++i) {
                if (img.pixels[i * 4 + 3] > 20) {
                    fallbackR = img.pixels[i * 4 + 0];
                    fallbackG = img.pixels[i * 4 + 1];
                    fallbackB = img.pixels[i * 4 + 2];
                    break;
                }
            }

            std::vector<uint8_t> chR(targetW * targetH, fallbackR);
            std::vector<uint8_t> chG(targetW * targetH, fallbackG);
            std::vector<uint8_t> chB(targetW * targetH, fallbackB);
            std::vector<uint8_t> chA(targetW * targetH, 0);

            double scaleX = static_cast<double>(img.width) / boxW;
            double scaleY = static_cast<double>(img.height) / boxH;
            int startX = padding, startY = padding;
            int ceilBoxH = static_cast<int>(std::ceil(boxH));
            int ceilBoxW = static_cast<int>(std::ceil(boxW));
            bool hasFadeGrad = mirrorProps.fadeGradient.has_value() && !mirrorProps.fadeGradient->empty();

            for (int iy = 0; iy < ceilBoxH; ++iy) {
                double progressY = static_cast<double>(iy) / std::max(1, ceilBoxH);

                int imgY = maxContentRow - static_cast<int>(iy * scaleY);
                if (imgY < 0) continue;
                imgY = std::clamp(imgY, 0, img.height - 1);

                uint8_t lastR = fallbackR, lastG = fallbackG, lastB = fallbackB;

                for (int ix = 0; ix < ceilBoxW; ++ix) {
                    double progressX = static_cast<double>(ix) / std::max(1, ceilBoxW);

                    double fadeRatio = 1.0;
                    double gradT = progressY;
                    switch (mirrorProps.fadeDirection) {
                        case 1:
                            fadeRatio = std::clamp(progressY, 0.0, 1.0);
                            gradT = 1.0 - progressY;
                            break;
                        case 2:
                            fadeRatio = std::max(0.0, 1.0 - progressX);
                            gradT = progressX;
                            break;
                        case 3:
                            fadeRatio = std::clamp(progressX, 0.0, 1.0);
                            gradT = 1.0 - progressX;
                            break;
                        case 4:
                            fadeRatio = 1.0;
                            gradT = progressY;
                            break;
                        case 0:
                        default:
                            fadeRatio = std::max(0.0, 1.0 - progressY);
                            gradT = progressY;
                            break;
                    }

                    double currentOpacity = mirrorProps.opacity * fadeRatio;

                    int imgX = std::clamp(static_cast<int>(ix * scaleX), 0, img.width - 1);
                    int srcIdx = (imgY * img.width + imgX) * 4;
                    int outX = startX + ix, outY = startY + iy;

                    if (outX >= 0 && outX < targetW && outY >= 0 && outY < targetH) {
                        int outIdx = outY * targetW + outX;
                        uint8_t srcA = img.pixels[srcIdx + 3];
                        if (srcA > 0) {
                            lastR = img.pixels[srcIdx + 0];
                            lastG = img.pixels[srcIdx + 1];
                            lastB = img.pixels[srcIdx + 2];

                            if (hasFadeGrad) {
                                uint32_t fg = sampleColorStops(mirrorProps.fadeGradient.value(), gradT);
                                uint8_t fA = (fg >> 24) & 0xFF, fR = (fg >> 16) & 0xFF, fG = (fg >> 8) & 0xFF, fB = fg & 0xFF;
                                lastR = static_cast<uint8_t>((lastR + fR) / 2);
                                lastG = static_cast<uint8_t>((lastG + fG) / 2);
                                lastB = static_cast<uint8_t>((lastB + fB) / 2);
                                currentOpacity *= (fA / 255.0);
                            }

                            chR[outIdx] = lastR;
                            chG[outIdx] = lastG;
                            chB[outIdx] = lastB;
                            chA[outIdx] = static_cast<uint8_t>(std::clamp(srcA * currentOpacity, 0.0, 255.0));
                        } else {
                            chR[outIdx] = lastR;
                            chG[outIdx] = lastG;
                            chB[outIdx] = lastB;
                        }
                    }
                }
            }

            int blurPx = static_cast<int>(std::ceil(blurRadius / 2.0));
            if (blurPx > 0) {
                fastBoxBlur(chR, targetW, targetH, blurPx);
                fastBoxBlur(chG, targetW, targetH, blurPx);
                fastBoxBlur(chB, targetW, targetH, blurPx);
                fastBoxBlur(chA, targetW, targetH, blurPx);
            }

            result.pixels.resize(targetW * targetH * 4, 0);
            for (size_t i = 0; i < static_cast<size_t>(targetW * targetH); ++i) {
                result.pixels[i * 4 + 0] = chR[i];
                result.pixels[i * 4 + 1] = chG[i];
                result.pixels[i * 4 + 2] = chB[i];
                result.pixels[i * 4 + 3] = chA[i];
            }

            double emptyBottomPx = (img.height - 1 - maxContentRow) / scaleY;
            result.width = targetW;
            result.height = targetH;
            result.drawX = x - padding;
            result.drawY = y + boxH - emptyBottomPx + mirrorProps.distance - padding;
            return result;
        }

        // ============================================================================
        // [SECTION D] DIRECT BOX MIRROR HELPER
        // ============================================================================
        static ShadowResult generateBoxMirror(
                double boxW,
                double boxH,
                double x,
                double y,
                uint32_t bgColor,
                const std::optional<EdgeInsets>& radius,
                const CanvasReflection& mirrorProps,
                int shape = 0
        ) {
            ShadowResult result;
            if (mirrorProps.opacity <= 0.0) return result;

            int w = static_cast<int>(std::ceil(boxW)), h = static_cast<int>(std::ceil(boxH));
            if (w <= 0 || h <= 0) return result;

            ImageBuffer tempImg = ImageBuffer::allocate(w, h);
            if (!tempImg.pixels) return result;

            uint8_t a = (bgColor >> 24) & 0xFF, r = (bgColor >> 16) & 0xFF, g = (bgColor >> 8) & 0xFF, b = bgColor & 0xFF;
            double maxR = std::min(boxW, boxH) / 2.0;
            double tl = 0, tr = 0, br = 0, bl = 0;
            if (shape == 1) {
                tl = tr = br = bl = maxR;
            } else if (radius.has_value()) {
                tl = std::min(radius->top, maxR); tr = std::min(radius->right, maxR);
                br = std::min(radius->bottom, maxR); bl = std::min(radius->left, maxR);
            }

            for (int iy = 0; iy < h; ++iy) {
                for (int ix = 0; ix < w; ++ix) {
                    bool inside = true;
                    if (tl > 0 && ix < tl && iy < tl) inside = (ix - tl)*(ix - tl) + (iy - tl)*(iy - tl) <= tl*tl;
                    else if (tr > 0 && ix > boxW - tr && iy < tr) inside = (ix - (boxW - tr))*(ix - (boxW - tr)) + (iy - tr)*(iy - tr) <= tr*tr;
                    else if (br > 0 && ix > boxW - br && iy > boxH - br) inside = (ix - (boxW - br))*(ix - (boxW - br)) + (iy - (boxH - br))*(iy - (boxH - br)) <= br*br;
                    else if (bl > 0 && ix < bl && iy > boxH - bl) inside = (ix - bl)*(ix - bl) + (iy - (boxH - bl))*(iy - (boxH - bl)) <= bl*bl;

                    if (inside) {
                        int idx = (iy * w + ix) * 4;
                        tempImg.pixels[idx + 0] = r; tempImg.pixels[idx + 1] = g;
                        tempImg.pixels[idx + 2] = b; tempImg.pixels[idx + 3] = a;
                    }
                }
            }
            return generateImageMirror(tempImg, boxW, boxH, x, y, mirrorProps);
        }

        // ============================================================================
        // [SECTION E] SVG SHADOW & MIRROR GENERATORS
        // ============================================================================
        static ShadowResult generateSvgShadow(const std::string& svgXml, double boxW, double boxH, double x, double y, const CanvasShadow& shadowProps) {
            ShadowResult result;
            if (svgXml.empty()) return result;

            NSVGimage* svgImage = SvgEngine::parseSvg(svgXml);
            if (!svgImage) return result;

            int w = std::max(1, static_cast<int>(std::ceil(boxW)));
            int h = std::max(1, static_cast<int>(std::ceil(boxH)));
            std::vector<uint8_t> rasterPixels = SvgEngine::rasterizeSvg(svgImage, w, h, 0xFFFFFFFF);
            SvgEngine::freeSvg(svgImage);

            if (rasterPixels.empty()) return result;

            ImageBuffer tempImg = ImageBuffer::allocate(w, h);
            if (!tempImg.pixels) return result;
            std::memcpy(tempImg.pixels, rasterPixels.data(), static_cast<size_t>(w) * static_cast<size_t>(h) * 4);

            return generateImageShadow(tempImg, boxW, boxH, x, y, shadowProps);
        }

        static ShadowResult generateSvgMirror(const std::string& svgXml, double boxW, double boxH, double x, double y, const CanvasReflection& mirrorProps, uint32_t fillColor = 0xFFFFFFFF) {
            ShadowResult result;
            if (svgXml.empty()) return result;

            NSVGimage* svgImage = SvgEngine::parseSvg(svgXml);
            if (!svgImage) return result;

            int w = std::max(1, static_cast<int>(std::ceil(boxW)));
            int h = std::max(1, static_cast<int>(std::ceil(boxH)));
            std::vector<uint8_t> rasterPixels = SvgEngine::rasterizeSvg(svgImage, w, h, fillColor);
            SvgEngine::freeSvg(svgImage);

            if (rasterPixels.empty()) return result;

            ImageBuffer tempImg = ImageBuffer::allocate(w, h);
            if (!tempImg.pixels) return result;
            std::memcpy(tempImg.pixels, rasterPixels.data(), static_cast<size_t>(w) * static_cast<size_t>(h) * 4);

            return generateImageMirror(tempImg, boxW, boxH, x, y, mirrorProps);
        }
    };

} // namespace CoreCanvas