// FILE: src/canvas_interface.h
// PURPOSE: Pure C FFI ABI declarations for Core Canvas Engine (Dart FFI / ffigen).
// Defines structured status codes and compile-time native capability bitmasks.

#pragma once
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define EXPORT_API __declspec(dllexport)
#else
#define EXPORT_API __attribute__((visibility("default"))) __attribute__((used))
#endif

// ============================================================================
// STATUS CODES (1:1 synced with Dart CanvasErrorCode)
// ============================================================================
#define CANVAS_OK                          1
#define CANVAS_ERR_INVALID_ARGS           -1
#define CANVAS_ERR_JSON_PARSE             -2
#define CANVAS_ERR_LAYOUT                 -3
#define CANVAS_ERR_OUTPUT_WRITE           -4

#define CANVAS_ERR_MODULE_PDF             -10
#define CANVAS_ERR_MODULE_IMAGE_EXPORT    -11
#define CANVAS_ERR_MODULE_WEBP            -12
#define CANVAS_ERR_MODULE_GIF             -13
#define CANVAS_ERR_MODULE_HTML            -14
#define CANVAS_ERR_MODULE_LOTTIE          -15
#define CANVAS_ERR_MODULE_SVG             -16
#define CANVAS_ERR_MODULE_SHADOWS         -17

#define CANVAS_ERR_INTERNAL               -99

// ============================================================================
// CAPABILITY BITMASK (1:1 synced with Dart CanvasCapabilities)
// ============================================================================
#define CANVAS_CAP_PDF                    (1u << 0)
#define CANVAS_CAP_SVG                    (1u << 1)
#define CANVAS_CAP_SHADOWS                (1u << 2)
#define CANVAS_CAP_IMAGE_EXPORT           (1u << 3)
#define CANVAS_CAP_WEBP                   (1u << 4)
#define CANVAS_CAP_LOTTIE                 (1u << 5)
#define CANVAS_CAP_GIF                    (1u << 6)
#define CANVAS_CAP_HTML                   (1u << 7)

// Master export entrypoint. Returns CANVAS_OK (1) on success or a negative CANVAS_ERR_* code.
EXPORT_API int generate_pdf(const char* json_payload, const char* output_path);

// Health check. Returns 200 when the shared library is loaded and responsive.
EXPORT_API int ping_engine();

// Returns a bitmask of CANVAS_CAP_* flags compiled into this binary.
EXPORT_API uint32_t get_engine_capabilities();

// Zero-Copy Binary Arena: copies raw image bytes into native RAM under an asset ID.
EXPORT_API int register_memory_asset(const char* asset_id, const uint8_t* data, int length);

// Releases all binary assets currently stored in the native Memory Arena.
EXPORT_API void clear_memory_assets();

#ifdef __cplusplus
}
#endif