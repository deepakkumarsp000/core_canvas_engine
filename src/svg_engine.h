// FILE: src/svg_engine.h
// PURPOSE: Native SVG XML parser and NanoSVG rasterizer with authentic multi-color support.
// Supports optional color tinting/masking for Drop Shadows and Clip Masks.

#pragma once
#include <string>
#include <vector>
#include <optional>
#include <cstring>
#include <algorithm>
#include <cstdint>
#include "config.h"
#include "nanosvg.h"
#include "nanosvgrast.h"

#ifndef NDEBUG
#ifdef __ANDROID__
#include <android/log.h>
#define CANVAS_SVG_LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "CANVAS_ENGINE", __VA_ARGS__)
#else
#include <cstdio>
#define CANVAS_SVG_LOGE(...) do { fprintf(stderr, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stderr, "\n"); } while(0)
#endif
#else
#define CANVAS_SVG_LOGE(...) ((void)0)
#endif

namespace CoreCanvas {

    class SvgEngine {
    public:
        static NSVGimage* parseSvg(const std::string& svgXml) {
#if defined(CANVAS_ENABLE_SVG) || defined(CANVAS_ENABLE_PDF) || defined(CANVAS_ENABLE_SHADOWS)
            if (svgXml.empty()) return nullptr;
            char* xmlCopy = new char[svgXml.length() + 1];
            std::strcpy(xmlCopy, svgXml.c_str());
            NSVGimage* image = nsvgParse(xmlCopy, "px", 96.0f);
            delete[] xmlCopy;
            if (!image) {
                CANVAS_SVG_LOGE("NanoSVG failed to parse SVG XML payload.");
            }
            return image;
#else
            (void)svgXml;
            return nullptr;
#endif
        }

        // Rasterizes an NSVGimage into an RGBA buffer.
        // Pass std::nullopt for overrideColor to preserve original multi-color SVG fills,
        // or pass an AARRGGBB color to tint/generate shadow & clip masks.
        static std::vector<uint8_t> rasterizeSvg(
                NSVGimage* image,
                int width,
                int height,
                std::optional<uint32_t> overrideColor = std::nullopt
        ) {
            std::vector<uint8_t> pixels;
#if defined(CANVAS_ENABLE_SVG) || defined(CANVAS_ENABLE_SHADOWS) || defined(CANVAS_ENABLE_IMAGE_EXPORT)
            if (!image || width <= 0 || height <= 0) return pixels;

            pixels.resize(static_cast<size_t>(width) * static_cast<size_t>(height) * 4, 0);
            NSVGrasterizer* rast = nsvgCreateRasterizer();
            if (!rast) return pixels;

            bool hasOverride = overrideColor.has_value();
            uint32_t nanoColor = 0;
            float overrideOpacity = 1.0f;

            if (hasOverride) {
                // Convert Dart AARRGGBB to NanoSVG ABGR (little-endian)
                uint32_t col = overrideColor.value();
                uint8_t a = (col >> 24) & 0xFF;
                uint8_t r = (col >> 16) & 0xFF;
                uint8_t g = (col >> 8)  & 0xFF;
                uint8_t b = col & 0xFF;
                nanoColor = (static_cast<uint32_t>(a) << 24) |
                            (static_cast<uint32_t>(b) << 16) |
                            (static_cast<uint32_t>(g) << 8)  |
                            static_cast<uint32_t>(r);
                overrideOpacity = a / 255.0f;
            }

            float minX = 1e6f, minY = 1e6f, maxX = -1e6f, maxY = -1e6f;

            for (NSVGshape* shape = image->shapes; shape != NULL; shape = shape->next) {
                if (!(shape->flags & NSVG_FLAGS_VISIBLE)) continue;

                if (hasOverride) {
                    shape->fill.type = NSVG_PAINT_COLOR;
                    shape->fill.color = nanoColor;
                    shape->opacity = overrideOpacity;
                }

                if (shape->bounds[0] < minX) minX = shape->bounds[0];
                if (shape->bounds[1] < minY) minY = shape->bounds[1];
                if (shape->bounds[2] > maxX) maxX = shape->bounds[2];
                if (shape->bounds[3] > maxY) maxY = shape->bounds[3];
            }

            float actualW = maxX - minX;
            float actualH = maxY - minY;

            if (actualW <= 0 || actualH <= 0) {
                actualW = image->width > 0 ? image->width : static_cast<float>(width);
                actualH = image->height > 0 ? image->height : static_cast<float>(height);
                minX = 0.0f;
                minY = 0.0f;
            }

            float scaleX = static_cast<float>(width) / actualW;
            float scaleY = static_cast<float>(height) / actualH;
            float scale = std::min(scaleX, scaleY);

            float tx = (static_cast<float>(width) - (actualW * scale)) / 2.0f - (minX * scale);
            float ty = (static_cast<float>(height) - (actualH * scale)) / 2.0f - (minY * scale);

            nsvgRasterize(rast, image, tx, ty, scale, pixels.data(), width, height, width * 4);
            nsvgDeleteRasterizer(rast);
#else
            (void)image; (void)width; (void)height; (void)overrideColor;
#endif
            return pixels;
        }

        static void freeSvg(NSVGimage* image) {
            if (image) nsvgDelete(image);
        }
    };

} // namespace CoreCanvas