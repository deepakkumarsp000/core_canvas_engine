// FILE: src/image_engine.h
// PURPOSE: Image format decoding (PNG, JPG, WebP, GIF), Zero-Copy Memory Arena, and 9-Point Object-Fit Math.
// 🚀 FAANG FIX: Conditional WebP Guard (0 KB when disabled), CMYK ColorSpace Support & Safe Allocator Cleanup!

#pragma once
#include <string>
#include <vector>
#include <unordered_map>
#include <mutex>
#include <iostream>
#include <algorithm>
#include <cstring>
#include <cstdlib>
#include <cstdint>
#include "config.h"
#include "stb_image.h"

#if defined(CANVAS_ENABLE_WEBP) && __has_include("webp/decode.h")
#include "webp/decode.h"
#define HAS_WEBP_DECODE 1
#else
#define HAS_WEBP_DECODE 0
#endif

namespace CoreCanvas {

    struct ImageBuffer {
        unsigned char* pixels = nullptr;
        int width = 0;
        int height = 0;
        int channels = 0;
        bool isWebP = false;

        ImageBuffer() = default;

        // Disable Copy (Prevents accidental double-free)
        ImageBuffer(const ImageBuffer&) = delete;
        ImageBuffer& operator=(const ImageBuffer&) = delete;

        // Enable Move Semantics (Zero-copy safe transfer)
        ImageBuffer(ImageBuffer&& other) noexcept
                : pixels(other.pixels), width(other.width), height(other.height),
        channels(other.channels), isWebP(other.isWebP) {
            other.pixels = nullptr;
        }

        ImageBuffer& operator=(ImageBuffer&& other) noexcept {
            if (this != &other) {
                cleanup();
                pixels = other.pixels;
                width = other.width;
                height = other.height;
                channels = other.channels;
                isWebP = other.isWebP;
                other.pixels = nullptr;
            }
            return *this;
        }

        // Safe zero-initialized RGBA allocation helper
        static ImageBuffer allocate(int w, int h) {
            ImageBuffer buf;
            if (w <= 0 || h <= 0) return buf;
            buf.width = w;
            buf.height = h;
            buf.channels = 4;
            buf.isWebP = false;
            buf.pixels = static_cast<unsigned char*>(std::calloc(static_cast<size_t>(w) * static_cast<size_t>(h), 4));
            return buf;
        }

        void cleanup() {
            if (pixels) {
#if HAS_WEBP_DECODE
                if (isWebP) {
                    WebPFree(pixels);
                } else {
                    stbi_image_free(pixels);
                }
#else
                stbi_image_free(pixels);
#endif
                pixels = nullptr;
            }
        }

        ~ImageBuffer() {
            cleanup();
        }
    };

    struct ImageDrawRect {
        double x, y, w, h;
    };

    class ImageEngine {
    private:
        // ⚡ ZERO-COPY RAM ARENA (Shared across all Dart Isolates!)
        static inline std::unordered_map<std::string, std::vector<unsigned char>> memoryArena;
        static inline std::mutex arenaMutex;

        // ⚡ SPEED BOOSTER: Compile-time constexpr Base64 Lookup Table (Zero heap allocation!)
        static constexpr int8_t kBase64Lut[256] = {
            -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,
                    52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,
                    -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
                    15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,
                    -1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
                    41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
                    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        };

        static bool isWebPFile(const unsigned char* data, size_t size) {
            if (!data || size < 12) return false;
            return data[0] == 'R' && data[1] == 'I' && data[2] == 'F' && data[3] == 'F' &&
                   data[8] == 'W' && data[9] == 'E' && data[10] == 'B' && data[11] == 'P';
        }

        static ImageBuffer decodeFromRawMemory(const unsigned char* data, size_t size) {
            ImageBuffer img;
            if (!data || size == 0) return img;

            if (isWebPFile(data, size)) {
#if HAS_WEBP_DECODE
                img.pixels = WebPDecodeRGBA(data, size, &img.width, &img.height);
                img.channels = 4;
                img.isWebP = true;
#endif
            } else {
                img.pixels = stbi_load_from_memory(data, static_cast<int>(size), &img.width, &img.height, &img.channels, 4);
                img.channels = 4;
                img.isWebP = false;
            }
            return img;
        }

    public:
        // ⚡ Register raw binary bytes directly from Dart FFI into C++ RAM
        static bool registerMemoryAsset(const std::string& id, const uint8_t* data, int length) {
            if (id.empty() || !data || length <= 0) return false;
            std::lock_guard<std::mutex> lock(arenaMutex);
            memoryArena[id] = std::vector<unsigned char>(data, data + length);
            return true;
        }

        // 🧹 Clear all cached binary assets from C++ RAM
        static void clearMemoryAssets() {
            std::lock_guard<std::mutex> lock(arenaMutex);
            memoryArena.clear();
        }

        static std::vector<unsigned char> decodeBase64(const std::string& in) {
            // Fast-path: Check if string is a 'mem://' URI from the Zero-Copy Arena!
            if (in.rfind("mem://", 0) == 0) {
                std::string assetId = in.substr(6);
                std::lock_guard<std::mutex> lock(arenaMutex);
                auto it = memoryArena.find(assetId);
                if (it != memoryArena.end()) {
                    return it->second;
                }
                return {};
            }

            std::vector<unsigned char> out;
            out.reserve((in.size() * 3) / 4);

            int val = 0, valb = -8;
            for (unsigned char c : in) {
                if (c == '=' || c == '\n' || c == '\r' || c == ' ') continue;
                int8_t d = kBase64Lut[c];
                if (d == -1) break;
                val = (val << 6) + d;
                valb += 6;
                if (valb >= 0) {
                    out.push_back(static_cast<unsigned char>((val >> valb) & 0xFF));
                    valb -= 8;
                }
            }
            return out;
        }

        // Encode raw bytes to Base64 (Used by HtmlCanvas when embedding 'mem://' assets)
        static std::string encodeBase64(const unsigned char* data, size_t len) {
            static constexpr char kEncTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            if (!data || len == 0) return "";
            std::string out;
            out.reserve(((len + 2) / 3) * 4);
            for (size_t i = 0; i < len; i += 3) {
                uint32_t n = static_cast<uint32_t>(data[i]) << 16;
                if (i + 1 < len) n |= static_cast<uint32_t>(data[i + 1]) << 8;
                if (i + 2 < len) n |= static_cast<uint32_t>(data[i + 2]);
                out.push_back(kEncTable[(n >> 18) & 63]);
                out.push_back(kEncTable[(n >> 12) & 63]);
                out.push_back((i + 1 < len) ? kEncTable[(n >> 6) & 63] : '=');
                out.push_back((i + 2 < len) ? kEncTable[n & 63] : '=');
            }
            return out;
        }

        // 🖼️ Decode Image from either 'mem://<id>' Arena OR Base64 String
        static ImageBuffer decodeImage(const std::string& sourceData) {
            if (sourceData.empty()) return ImageBuffer();

            // ⚡ ZERO-COPY ARENA FAST-PATH (No Base64 decoding needed!)
            if (sourceData.rfind("mem://", 0) == 0) {
                std::string assetId = sourceData.substr(6);
                std::lock_guard<std::mutex> lock(arenaMutex);
                auto it = memoryArena.find(assetId);
                if (it != memoryArena.end() && !it->second.empty()) {
                    return decodeFromRawMemory(it->second.data(), it->second.size());
                }
                return ImageBuffer();
            }

            std::vector<unsigned char> rawBytes = decodeBase64(sourceData);
            if (rawBytes.empty()) return ImageBuffer();
            return decodeFromRawMemory(rawBytes.data(), rawBytes.size());
        }

        // 🎨 Convert RGBA buffer in-place for ColorSpace == 1 (Grayscale) or ColorSpace == 2 (CMYK Print Gamut)
        static void applyColorSpace(unsigned char* pixels, int width, int height, int colorSpace) {
            if (!pixels || width <= 0 || height <= 0 || colorSpace == 0) return;
            int total = width * height;

            if (colorSpace == 1) { // Grayscale (ITU-R BT.601 luminance)
                for (int i = 0; i < total; ++i) {
                    int idx = i * 4;
                    uint8_t gray = static_cast<uint8_t>(
                            0.299 * pixels[idx + 0] + 0.587 * pixels[idx + 1] + 0.114 * pixels[idx + 2]
                    );
                    pixels[idx + 0] = gray;
                    pixels[idx + 1] = gray;
                    pixels[idx + 2] = gray;
                }
            } else if (colorSpace == 2) { // CMYK Print Gamut Conversion (RGB -> CMYK -> Press-clamped RGB)
                for (int i = 0; i < total; ++i) {
                    int idx = i * 4;
                    double r = pixels[idx + 0] / 255.0;
                    double g = pixels[idx + 1] / 255.0;
                    double b = pixels[idx + 2] / 255.0;

                    double k = 1.0 - std::max({r, g, b});
                    if (k < 0.999) {
                        double c = (1.0 - r - k) / (1.0 - k);
                        double m = (1.0 - g - k) / (1.0 - k);
                        double y = (1.0 - b - k) / (1.0 - k);

                        // Clamp neon/out-of-gamut RGB peaks to realistic SWOP CMYK ink limits
                        c = std::clamp(c * 0.94, 0.0, 1.0);
                        m = std::clamp(m * 0.93, 0.0, 1.0);
                        y = std::clamp(y * 0.95, 0.0, 1.0);
                        k = std::clamp(k * 0.98 + 0.02, 0.0, 1.0);

                        pixels[idx + 0] = static_cast<uint8_t>(std::round((1.0 - c) * (1.0 - k) * 255.0));
                        pixels[idx + 1] = static_cast<uint8_t>(std::round((1.0 - m) * (1.0 - k) * 255.0));
                        pixels[idx + 2] = static_cast<uint8_t>(std::round((1.0 - y) * (1.0 - k) * 255.0));
                    } else {
                        pixels[idx + 0] = 15;
                        pixels[idx + 1] = 15;
                        pixels[idx + 2] = 15;
                    }
                }
            }
        }

        // 📐 Complete Object-Fit (none, fill, contain, cover, scaleDown) & 9-Point Alignment Math
        static ImageDrawRect calculateFit(double boxW, double boxH, double imgW, double imgH, const ImageProps& props) {
            ImageDrawRect rect = {0.0, 0.0, boxW, boxH};
            if (imgW <= 0 || imgH <= 0 || boxW <= 0 || boxH <= 0) return rect;

            double ratioImg = imgW / imgH;
            double ratioBox = boxW / boxH;
            int fit = props.fit;

            // fit == 4 (scaleDown): behave like 'contain' if image is larger than box, else 'none'
            if (fit == 4) {
                fit = (imgW > boxW || imgH > boxH) ? 2 : 0;
            }

            if (fit == 1) { // fill
                rect.w = boxW;
                rect.h = boxH;
            } else if (fit == 2) { // contain
                if (ratioImg > ratioBox) {
                    rect.w = boxW;
                    rect.h = boxW / ratioImg;
                } else {
                    rect.h = boxH;
                    rect.w = boxH * ratioImg;
                }
            } else if (fit == 3) { // cover
                if (ratioImg > ratioBox) {
                    rect.h = boxH;
                    rect.w = boxH * ratioImg;
                } else {
                    rect.w = boxW;
                    rect.h = boxW / ratioImg;
                }
            } else { // 0: none (original size)
                rect.w = imgW;
                rect.h = imgH;
            }

            // 9-Point Alignment Routing (Matches Dart ImageAlignment Enum 0..8)
            switch (props.alignment) {
                case 1: rect.x = 0.0; rect.y = 0.0; break;
                case 2: rect.x = (boxW - rect.w) / 2.0; rect.y = 0.0; break;
                case 3: rect.x = boxW - rect.w; rect.y = 0.0; break;
                case 4: rect.x = 0.0; rect.y = (boxH - rect.h) / 2.0; break;
                case 5: rect.x = boxW - rect.w; rect.y = (boxH - rect.h) / 2.0; break;
                case 6: rect.x = 0.0; rect.y = boxH - rect.h; break;
                case 7: rect.x = (boxW - rect.w) / 2.0; rect.y = boxH - rect.h; break;
                case 8: rect.x = boxW - rect.w; rect.y = boxH - rect.h; break;
                case 0:
                default:
                    rect.x = (boxW - rect.w) / 2.0;
                    rect.y = (boxH - rect.h) / 2.0;
                    break;
            }
            return rect;
        }
    };

} // namespace CoreCanvas