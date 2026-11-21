// FILE: src/core_canvas_engine.cpp
// PURPOSE: Native FFI Entrypoint, Capability Reporter & 6-Format Target Router
// Structured status codes, conditional header implementations & clean production logging.

#define NANOSVG_IMPLEMENTATION
#include "nanosvg.h"
#undef NANOSVG_IMPLEMENTATION

#if defined(CANVAS_ENABLE_SVG) || defined(CANVAS_ENABLE_SHADOWS) || defined(CANVAS_ENABLE_IMAGE_EXPORT)
#define NANOSVGRAST_IMPLEMENTATION
#include "nanosvgrast.h"
#undef NANOSVGRAST_IMPLEMENTATION
#endif

#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"
#undef STB_TRUETYPE_IMPLEMENTATION

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#undef STB_IMAGE_IMPLEMENTATION

#if defined(CANVAS_ENABLE_IMAGE_EXPORT) || defined(CANVAS_ENABLE_GIF)
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#undef STB_IMAGE_WRITE_IMPLEMENTATION
#endif

#include <string>
#include <optional>
#include <exception>
#include <cstdint>

#ifdef __ANDROID__
#include <android/log.h>
#ifndef NDEBUG
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "CANVAS_ENGINE", __VA_ARGS__)
#else
#define LOGD(...) ((void)0)
#endif
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "CANVAS_ENGINE", __VA_ARGS__)
#else
#include <cstdio>
#ifndef NDEBUG
#define LOGD(...) do { fprintf(stdout, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stdout, "\n"); } while(0)
#else
#define LOGD(...) ((void)0)
#endif
#define LOGE(...) do { fprintf(stderr, "[CoreCanvasEngine] " __VA_ARGS__); fprintf(stderr, "\n"); } while(0)
#endif

#include "canvas_interface.h"
#include "config.h"
#include "node_parser.h"
#include "render_engine.h"
#ifdef CANVAS_ENABLE_PDF
#include "pdf_canvas.h"
#endif
#if defined(CANVAS_ENABLE_IMAGE_EXPORT) || defined(CANVAS_ENABLE_GIF)
#include "image_canvas.h"
#endif
#ifdef CANVAS_ENABLE_HTML
#include "html_canvas.h"
#endif
#include "layout_engine.h"
#include "clip_engine.h"
#include "svg_engine.h"
#include "image_engine.h"
#include "lottie_gif_engine.h"

using namespace CoreCanvas;

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#ifdef CANVAS_ENABLE_LOTTIE
static void convertRgbaToBgraPremul(unsigned char* data, int w, int h) {
    if (!data || w <= 0 || h <= 0) return;
    int total = w * h;
    for (int i = 0; i < total; ++i) {
        unsigned char* p = data + (i * 4);
        unsigned char r = p[0];
        unsigned char g = p[1];
        unsigned char b = p[2];
        unsigned char a = p[3];
        if (a < 255) {
            r = static_cast<unsigned char>((r * a) / 255);
            g = static_cast<unsigned char>((g * a) / 255);
            b = static_cast<unsigned char>((b * a) / 255);
        }
        p[0] = b;
        p[1] = g;
        p[2] = r;
        p[3] = a;
    }
}
#endif

extern "C" {

#ifdef CANVAS_ENABLE_LOTTIE
// RLottie image loader bridge (compiled only when CANVAS_ENABLE_LOTTIE is enabled)
EXPORT unsigned char* lottie_image_load(char const* filename, int* x, int* y, int* comp, int req_comp) {
    unsigned char* px = stbi_load(filename, x, y, comp, req_comp);
    if (px && x && y) convertRgbaToBgraPremul(px, *x, *y);
    return px;
}

EXPORT unsigned char* lottie_image_load_from_data(const char* imageData, int len, int* x, int* y, int* comp, int req_comp) {
    unsigned char* px = stbi_load_from_memory(reinterpret_cast<const unsigned char*>(imageData), len, x, y, comp, req_comp);
    if (px && x && y) convertRgbaToBgraPremul(px, *x, *y);
    return px;
}

EXPORT void lottie_image_free(unsigned char* data) {
    stbi_image_free(data);
}

// ARM NEON Pixman fallback symbols for RLottie
EXPORT void pixman_composite_src_n_8888_asm_neon(int32_t w, int32_t h, uint32_t* dst, int32_t dst_stride, uint32_t src) {
    for (int32_t y = 0; y < h; ++y) {
        uint32_t* row = dst + y * dst_stride;
        for (int32_t x = 0; x < w; ++x) {
            row[x] = src;
        }
    }
}

EXPORT void pixman_composite_over_n_8888_asm_neon(int32_t w, int32_t h, uint32_t* dst, int32_t dst_stride, uint32_t src) {
    uint32_t sia = 255 - (src >> 24);
    for (int32_t y = 0; y < h; ++y) {
        uint32_t* row = dst + y * dst_stride;
        for (int32_t x = 0; x < w; ++x) {
            uint32_t d = row[x];
            uint32_t rb = (d & 0x00FF00FFU) * sia;
            uint32_t ag = ((d >> 8) & 0x00FF00FFU) * sia;
            rb = (rb + ((rb >> 8) & 0x00FF00FFU) + 0x00800080U) >> 8;
            ag = (ag + ((ag >> 8) & 0x00FF00FFU) + 0x00800080U);
            row[x] = src + ((rb & 0x00FF00FFU) | (ag & 0xFF00FF00U));
        }
    }
}
#endif // CANVAS_ENABLE_LOTTIE

// Returns compile-time feature capability bitmask for Dart pre-flight validation
EXPORT uint32_t get_engine_capabilities() {
    uint32_t caps = 0;
#ifdef CANVAS_ENABLE_PDF
    caps |= CANVAS_CAP_PDF;
#endif
#ifdef CANVAS_ENABLE_SVG
    caps |= CANVAS_CAP_SVG;
#endif
#ifdef CANVAS_ENABLE_SHADOWS
    caps |= CANVAS_CAP_SHADOWS;
#endif
#ifdef CANVAS_ENABLE_IMAGE_EXPORT
    caps |= CANVAS_CAP_IMAGE_EXPORT;
#endif
#ifdef CANVAS_ENABLE_WEBP
    caps |= CANVAS_CAP_WEBP;
#endif
#ifdef CANVAS_ENABLE_LOTTIE
    caps |= CANVAS_CAP_LOTTIE;
#endif
#ifdef CANVAS_ENABLE_GIF
    caps |= CANVAS_CAP_GIF;
#endif
#ifdef CANVAS_ENABLE_HTML
    caps |= CANVAS_CAP_HTML;
#endif
    return caps;
}

// Master Export Router (0=PDF, 1=PNG, 2=HTML, 3=JPG, 4=WEBP, 5=GIF)
// Returns CANVAS_OK (1) on success or a negative CANVAS_ERR_* status code.
EXPORT int generate_pdf(const char* json_payload, const char* output_path) {
    try {
        if (!json_payload || !output_path || json_payload[0] == '\0' || output_path[0] == '\0') {
            LOGE("E_INVALID_ARGUMENTS: Null or empty payload/output path.");
            return CANVAS_ERR_INVALID_ARGS;
        }

        std::optional<CoreDocument> docOpt = NodeParser::parse(json_payload);
        if (!docOpt.has_value()) {
            LOGE("E_JSON_PARSE_FAILED: Failed to parse AST payload.");
            return CANVAS_ERR_JSON_PARSE;
        }
        CoreDocument& doc = docOpt.value();

        // Fail-fast capability check before running Yoga layout
        int format = doc.config.targetFormat;
        if (format == 2) {
#ifndef CANVAS_ENABLE_HTML
            LOGE("E_MODULE_HTML_DISABLED: Native module 'html' is not compiled.");
            return CANVAS_ERR_MODULE_HTML;
#endif
        } else if (format == 5) {
#ifndef CANVAS_ENABLE_GIF
            LOGE("E_MODULE_GIF_DISABLED: Native module 'gif' is not compiled.");
            return CANVAS_ERR_MODULE_GIF;
#endif
        } else if (format == 4) {
#ifndef CANVAS_ENABLE_WEBP
            LOGE("E_MODULE_WEBP_DISABLED: Native module 'webp' is not compiled.");
            return CANVAS_ERR_MODULE_WEBP;
#endif
#ifndef CANVAS_ENABLE_IMAGE_EXPORT
            LOGE("E_MODULE_IMAGE_EXPORT_DISABLED: Native module 'image_export' is not compiled.");
            return CANVAS_ERR_MODULE_IMAGE_EXPORT;
#endif
        } else if (format == 1 || format == 3) {
#ifndef CANVAS_ENABLE_IMAGE_EXPORT
            LOGE("E_MODULE_IMAGE_EXPORT_DISABLED: Native module 'image_export' is not compiled.");
            return CANVAS_ERR_MODULE_IMAGE_EXPORT;
#endif
        } else {
#ifndef CANVAS_ENABLE_PDF
            LOGE("E_MODULE_PDF_DISABLED: Native module 'pdf' is not compiled.");
            return CANVAS_ERR_MODULE_PDF;
#endif
        }

        YGNodeRef rootYogaNode = RenderEngine::solveLayout(doc);
        if (!rootYogaNode) {
            LOGE("E_LAYOUT_FAILED: Meta Yoga layout resolution failed.");
            return CANVAS_ERR_LAYOUT;
        }

        bool success = false;
        double rootBottomMargin = doc.config.margin.has_value() ? doc.config.margin->bottom : 0.0;

        if (format == 2) {
#ifdef CANVAS_ENABLE_HTML
            HtmlCanvas htmlExporter(doc.config);
            RenderEngine::paintTree(doc.body, rootYogaNode, &htmlExporter, 0, 0, 0xFFFFFFFF, 1.0, 1.0, rootBottomMargin);
            success = htmlExporter.saveToFile(output_path);
#endif
        } else if (format == 5) {
#ifdef CANVAS_ENABLE_GIF
            ImageCanvas frameCanvas(doc.config);
            LottieGifEngine::GifAnimationWriter gifWriter;
            bool isAnimated = LottieGifEngine::hasAnimatedNodes(doc.body);
            int totalFrames = isAnimated ? 20 : 1;
            int fps = 20;

            if (gifWriter.begin(output_path, frameCanvas.getWidth(), frameCanvas.getHeight(), fps)) {
                for (int f = 0; f < totalFrames; ++f) {
                    double progress = (totalFrames > 1)
                                      ? (static_cast<double>(f) / static_cast<double>(totalFrames - 1))
                                      : 1.0;
                    frameCanvas.clear(0xFFFFFFFF);
                    RenderEngine::paintTree(doc.body, rootYogaNode, &frameCanvas, 0, 0, 0xFFFFFFFF, 1.0, progress, rootBottomMargin);
                    gifWriter.writeFrame(frameCanvas.getPixels());
                }
                success = gifWriter.end();
            }
#endif
        } else if (format == 1 || format == 3 || format == 4) {
#ifdef CANVAS_ENABLE_IMAGE_EXPORT
            ImageCanvas imgExporter(doc.config);
            RenderEngine::paintTree(doc.body, rootYogaNode, &imgExporter, 0, 0, 0xFFFFFFFF, 1.0, 1.0, rootBottomMargin);
            success = imgExporter.saveToTargetFormat(output_path);
#endif
        } else {
#ifdef CANVAS_ENABLE_PDF
            PdfCanvas pdfExporter(doc.config, doc.info);
            RenderEngine::paintTree(doc.body, rootYogaNode, &pdfExporter, 0, 0, 0xFFFFFFFF, 1.0, 1.0, rootBottomMargin);
            success = pdfExporter.saveToFile(output_path);
#endif
        }

        LayoutEngine::freeYogaTree(rootYogaNode);

        if (success) {
            LOGD("Export succeeded (format=%d, path=%s)", format, output_path);
            return CANVAS_OK;
        }

        LOGE("E_OUTPUT_WRITE_FAILED: Unable to write output artifact at %s", output_path);
        return CANVAS_ERR_OUTPUT_WRITE;

    } catch (const std::exception& e) {
        LOGE("E_INTERNAL_NATIVE_ERROR: %s", e.what());
        return CANVAS_ERR_INTERNAL;
    } catch (...) {
        LOGE("E_INTERNAL_NATIVE_ERROR: Unhandled unknown native exception.");
        return CANVAS_ERR_INTERNAL;
    }
}

EXPORT int ping_engine() {
    return 200;
}

EXPORT int register_memory_asset(const char* asset_id, const uint8_t* data, int length) {
    if (!asset_id || !data || length <= 0) return 0;
    bool ok = ImageEngine::registerMemoryAsset(std::string(asset_id), data, length);
    return ok ? 1 : 0;
}

EXPORT void clear_memory_assets() {
    ImageEngine::clearMemoryAssets();
}

} // extern "C"