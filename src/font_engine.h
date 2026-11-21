// FILE: src/font_engine.h
// PURPOSE: Cross-Platform Zero-Bloat Font Metrics & True Shape Text-to-RGBA Rasterizer
// 🚀 FAANG FIX: Safe ImageBuffer::allocate Sync, BaselineOffset Support & Full Yoga Measure Callback Sync!

#pragma once
#include <string>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <iostream>
#include <sstream>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <algorithm>
#include <yoga/Yoga.h>
#include "config.h"
#include "stb_truetype.h"
#include "image_engine.h"

namespace CoreCanvas {

    class FontEngine {
    private:
        std::unordered_map<std::string, std::vector<unsigned char>> fontBuffers;
        std::unordered_map<std::string, stbtt_fontinfo> fontInfos;
        bool systemFontsChecked = false;

        int getStandardCharWidth(char c) {
            static const int helveticaWidths[256] = {
                    278,278,278,278,278,278,278,278,278,278,278,278,278,278,278,278,
                    278,278,278,278,278,278,278,278,278,278,278,278,278,278,278,278,
                    278,278,355,556,556,889,667,191,333,333,389,584,278,333,278,278,
                    556,556,556,556,556,556,556,556,556,556,278,278,584,584,584,556,
                    1015,667,667,722,722,667,611,778,722,278,500,667,556,833,722,778,
                    667,778,722,667,611,722,667,944,667,667,611,278,278,278,469,556,
                    333,556,556,500,556,556,278,556,556,222,222,500,222,833,556,556,
                    556,556,333,500,278,556,500,722,500,500,500,334,260,334,584,278
            };
            unsigned char uc = static_cast<unsigned char>(c);
            return (uc < 128) ? helveticaWidths[uc] : 556;
        }

        // 🚀 ZERO-KB CROSS-PLATFORM SYSTEM FONT DISCOVERY
        void ensureSystemFontsLoaded() {
            if (systemFontsChecked) return;
            systemFontsChecked = true;

            const std::vector<std::string> regularPaths = {
                    "/system/fonts/Roboto-Regular.ttf",
                    "/system/fonts/NotoSans-Regular.ttf",
                    "/system/fonts/DroidSans.ttf",
                    "C:/Windows/Fonts/arial.ttf",
                    "C:/Windows/Fonts/segoeui.ttf",
                    "/System/Library/Fonts/Supplemental/Arial.ttf",
                    "/System/Library/Fonts/Helvetica.ttc",
                    "/System/Library/Fonts/Core/Helvetica.ttc",
                    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
                    "/usr/share/fonts/TTF/DejaVuSans.ttf"
            };

            const std::vector<std::string> boldPaths = {
                    "/system/fonts/Roboto-Bold.ttf",
                    "/system/fonts/DroidSans-Bold.ttf",
                    "C:/Windows/Fonts/arialbd.ttf",
                    "C:/Windows/Fonts/segoeuib.ttf",
                    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
                    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
            };

            for (const auto& path : regularPaths) {
                if (loadFont("__sys_regular__", path)) break;
            }
            for (const auto& path : boldPaths) {
                if (loadFont("__sys_bold__", path)) break;
            }
        }

        std::string resolveBestFont(const std::string& requestedFont, int weight) {
            if (fontInfos.find(requestedFont) != fontInfos.end()) {
                return requestedFont;
            }
            ensureSystemFontsLoaded();
            if (weight >= 600 && fontInfos.find("__sys_bold__") != fontInfos.end()) {
                return "__sys_bold__";
            }
            if (fontInfos.find("__sys_regular__") != fontInfos.end()) {
                return "__sys_regular__";
            }
            if (!fontInfos.empty()) {
                return fontInfos.begin()->first;
            }
            return "";
        }

        FontEngine() = default;

    public:
        FontEngine(const FontEngine&) = delete;
        FontEngine& operator=(const FontEngine&) = delete;

        static FontEngine& getInstance() {
            static FontEngine instance;
            return instance;
        }

        bool hasFont(const std::string& fontName) {
            if (fontInfos.find(fontName) != fontInfos.end()) return true;
            ensureSystemFontsLoaded();
            return !fontInfos.empty();
        }

        bool loadFont(const std::string& fontName, const std::string& fontPath) {
            if (fontInfos.find(fontName) != fontInfos.end()) return true;
            std::ifstream file(fontPath, std::ios::binary | std::ios::ate);
            if (!file.is_open()) return false;
            std::streamsize size = file.tellg();
            if (size <= 0) return false;
            file.seekg(0, std::ios::beg);
            std::vector<unsigned char> buffer(size);
            if (file.read(reinterpret_cast<char*>(buffer.data()), size)) {
                int offset = stbtt_GetFontOffsetForIndex(buffer.data(), 0);
                if (offset < 0) offset = 0;
                stbtt_fontinfo info;
                if (!stbtt_InitFont(&info, buffer.data(), offset)) return false;
                fontBuffers[fontName] = std::move(buffer);
                stbtt_InitFont(&info, fontBuffers[fontName].data(), offset);
                fontInfos[fontName] = info;
                return true;
            }
            return false;
        }

        YGSize measureText(
                const std::string& text,
                const std::string& fontName,
                double fontSize,
                double maxWidth,
                double letterSpacing = 0.0,
                double wordSpacing = 0.0,
                double lineHeightMult = 1.15
        ) {
            if (text.empty()) return {0.0f, 0.0f};
            float effLineMult = (lineHeightMult > 0.1) ? static_cast<float>(lineHeightMult) : 1.15f;

            // Measure using standard Helvetica metrics when custom TTF is not in C++ map
            if (fontInfos.find(fontName) == fontInfos.end()) {
                float maxLineW = 0.0f;
                float currentLineW = 0.0f;
                int lines = 1;

                for (char c : text) {
                    if (c == '\n') {
                        if (currentLineW > maxLineW) maxLineW = currentLineW;
                        currentLineW = 0.0f;
                        lines++;
                        continue;
                    }
                    float cw = (getStandardCharWidth(c) * static_cast<float>(fontSize)) / 1000.0f;
                    cw += static_cast<float>(letterSpacing);
                    if (c == ' ') cw += static_cast<float>(wordSpacing);

                    if (maxWidth > 0 && (currentLineW + cw) > maxWidth && currentLineW > 0) {
                        if (currentLineW > maxLineW) maxLineW = currentLineW;
                        currentLineW = cw;
                        lines++;
                    } else {
                        currentLineW += cw;
                    }
                }
                if (currentLineW > maxLineW) maxLineW = currentLineW;
                float approxHeight = lines * (static_cast<float>(fontSize) * effLineMult);
                return {maxLineW, approxHeight};
            }

            stbtt_fontinfo& info = fontInfos[fontName];
            float scale = stbtt_ScaleForMappingEmToPixels(&info, static_cast<float>(fontSize));
            int ascent, descent, lineGap;
            stbtt_GetFontVMetrics(&info, &ascent, &descent, &lineGap);
            float lineHeight = static_cast<float>(fontSize) * effLineMult;
            float currentX = 0.0f;
            float currentY = lineHeight;
            float maxLineWidth = 0.0f;

            for (size_t i = 0; i < text.length(); ++i) {
                if (text[i] == '\n') {
                    if (currentX > maxLineWidth) maxLineWidth = currentX;
                    currentX = 0.0f;
                    currentY += lineHeight;
                    continue;
                }
                int advance, lsb;
                stbtt_GetCodepointHMetrics(&info, text[i], &advance, &lsb);
                float charWidth = (advance * scale) + static_cast<float>(letterSpacing);
                if (text[i] == ' ') charWidth += static_cast<float>(wordSpacing);

                if (maxWidth > 0 && (currentX + charWidth) > maxWidth && currentX > 0) {
                    if (currentX > maxLineWidth) maxLineWidth = currentX;
                    currentX = 0.0f;
                    currentY += lineHeight;
                }
                currentX += charWidth;
                if (currentX > maxLineWidth) maxLineWidth = currentX;
            }
            return {maxLineWidth, currentY};
        }

        // ============================================================================
        // 🔥 TRUE SHAPE TEXT-TO-IMAGE RASTERIZER (With Color, Weight, Spacing & Alignment Sync)
        // ============================================================================
        ImageBuffer renderTextToImage(
                const std::string& text,
                const std::string& fontName,
                double fontSize,
                int boxW,
                int boxH,
                uint32_t textColor = 0xFFFFFFFF,
                int weight = 400,
                int align = 0,
                double letterSpacing = 0.0,
                double wordSpacing = 0.0,
                double baselineOffset = 0.0
        ) {
            if (boxW <= 0 || boxH <= 0 || text.empty()) return ImageBuffer();

            ImageBuffer img = ImageBuffer::allocate(boxW, boxH);
            if (!img.pixels) return img;

            uint8_t rCol = (textColor >> 16) & 0xFF;
            uint8_t gCol = (textColor >> 8) & 0xFF;
            uint8_t bCol = textColor & 0xFF;

            std::string activeFontKey = resolveBestFont(fontName, weight);
            if (activeFontKey.empty()) return img;

            stbtt_fontinfo& info = fontInfos[activeFontKey];
            float baseScale = stbtt_ScaleForMappingEmToPixels(&info, static_cast<float>(fontSize));

            std::vector<std::string> lines;
            std::stringstream ss(text);
            std::string lineStr;
            while (std::getline(ss, lineStr, '\n')) {
                lines.push_back(lineStr);
            }
            if (lines.empty()) lines.push_back(text);

            float lineHeight = static_cast<float>(boxH) / static_cast<float>(lines.size());
            bool synthesizeBold = (weight >= 600 && activeFontKey != "__sys_bold__");

            for (size_t lineIdx = 0; lineIdx < lines.size(); ++lineIdx) {
                const std::string& line = lines[lineIdx];
                if (line.empty()) continue;

                float targetLineW = 0.0f;
                float stbLineW = 0.0f;
                for (size_t i = 0; i < line.length(); ++i) {
                    float extraSpace = static_cast<float>(letterSpacing) + (line[i] == ' ' ? static_cast<float>(wordSpacing) : 0.0f);
                    targetLineW += (getStandardCharWidth(line[i]) * static_cast<float>(fontSize)) / 1000.0f + extraSpace;
                    int adv, lsb;
                    stbtt_GetCodepointHMetrics(&info, line[i], &adv, &lsb);
                    stbLineW += (adv * baseScale) + extraSpace;
                }

                float scaleX = baseScale;
                if (stbLineW > 0.0f && targetLineW > 0.0f) {
                    float ratio = std::clamp(targetLineW / stbLineW, 0.85f, 1.18f);
                    scaleX = baseScale * ratio;
                }
                float actualLineW = (stbLineW > 0.0f) ? (stbLineW * (scaleX / baseScale)) : targetLineW;

                float currentX = 0.0f;
                if (align == 1) {
                    currentX = std::max(0.0f, (static_cast<float>(boxW) - actualLineW) / 2.0f);
                } else if (align == 2) {
                    currentX = std::max(0.0f, static_cast<float>(boxW) - actualLineW);
                }

                float lineTop = lineIdx * lineHeight;
                float baselineY = lineTop + (lineHeight / 2.0f) + static_cast<float>(fontSize) * 0.28f - static_cast<float>(baselineOffset);

                for (size_t i = 0; i < line.length(); ++i) {
                    int advance, lsb, x0, y0, x1, y1;
                    stbtt_GetCodepointHMetrics(&info, line[i], &advance, &lsb);
                    stbtt_GetCodepointBitmapBox(&info, line[i], scaleX, baseScale, &x0, &y0, &x1, &y1);

                    int charW = x1 - x0;
                    int charH = y1 - y0;

                    if (charW > 0 && charH > 0) {
                        std::vector<uint8_t> charBitmap(charW * charH, 0);
                        stbtt_MakeCodepointBitmap(&info, charBitmap.data(), charW, charH, charW, scaleX, baseScale, line[i]);

                        int startX = static_cast<int>(std::round(currentX)) + x0;
                        int startY = static_cast<int>(std::round(baselineY)) + y0;

                        int boldPasses = synthesizeBold ? 2 : 1;
                        for (int bPass = 0; bPass < boldPasses; ++bPass) {
                            for (int y = 0; y < charH; ++y) {
                                for (int x = 0; x < charW; ++x) {
                                    int pxX = startX + x + bPass;
                                    int pxY = startY + y;
                                    if (pxX >= 0 && pxX < boxW && pxY >= 0 && pxY < boxH) {
                                        uint8_t alpha = charBitmap[y * charW + x];
                                        if (alpha > 0) {
                                            int idx = (pxY * boxW + pxX) * 4;
                                            img.pixels[idx + 0] = rCol;
                                            img.pixels[idx + 1] = gCol;
                                            img.pixels[idx + 2] = bCol;
                                            img.pixels[idx + 3] = std::max(alpha, img.pixels[idx + 3]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    float extraSpace = static_cast<float>(letterSpacing) + (line[i] == ' ' ? static_cast<float>(wordSpacing) : 0.0f);
                    currentX += (advance * scaleX) + extraSpace;
                }
            }
            return img;
        }

        static YGSize yogaMeasureCallback(const YGNode* node, float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode) {
            (void)height;
            (void)heightMode;
            void* context = YGNodeGetContext(node);
            if (!context) return {0, 0};
            const SuperContainer* container = static_cast<const SuperContainer*>(context);
            if (container->type != 1 || !container->content.has_value()) return {0, 0};

            std::string text = container->content.value();
            double fontSize = 12.0;
            double letterSpacing = 0.0;
            double wordSpacing = 0.0;
            double lineHeight = 1.15;
            std::string fontName = "Helvetica";

            if (container->typography.has_value()) {
                const auto& t = container->typography.value();
                fontSize = t.fontSize;
                letterSpacing = t.letterSpacing;
                wordSpacing = t.wordSpacing;
                lineHeight = t.lineHeight;
                if (t.fontFamily.has_value()) {
                    fontName = t.fontFamily.value();
                }
            }

            double maxWidth = -1.0;
            if (widthMode == YGMeasureModeExactly || widthMode == YGMeasureModeAtMost) {
                maxWidth = width;
            }
            return FontEngine::getInstance().measureText(text, fontName, fontSize, maxWidth, letterSpacing, wordSpacing, lineHeight);
        }
    };

} // namespace CoreCanvas