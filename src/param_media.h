// FILE: src/param_media.h
// PURPOSE: Dart ke ImageProps, SvgProps, aur LottieProps ko C++ structs me map karna.
// 🚀 FAANG FIX: Added endFrame to LottieProps for full RLottie segment control!

#pragma once
#include <optional>
#include <string>

namespace CoreCanvas {

// ============================================================================
// 📸 IMAGE PROPS (For STB Image & LibWebP)
// ============================================================================
    struct ImageProps {
        int fit = 0;         // Enum value (0: none, 1: fill, 2: contain, 3: cover, 4: scaleDown)
        int alignment = 0;   // Enum value (0..8: 9-point alignment)
        std::optional<int> dpi;
    };

// ============================================================================
// 🎨 SVG PROPS (For NanoSVG)
// ============================================================================
    struct SvgProps {
        std::optional<std::string> viewBox;
        std::optional<int> fill;
        std::optional<int> stroke;
        double strokeWidth = 0.0;
        int strokeCap = 0;   // 0: butt, 1: round, 2: square
        int strokeJoin = 0;  // 0: miter, 1: round, 2: bevel
    };

// ============================================================================
// 🎥 LOTTIE PROPS (For RLottie)
// ============================================================================
    struct LottieProps {
        bool autoplay = true;
        bool loop = true;
        double speed = 1.0;
        std::optional<int> fps;
        int initialFrame = 0;
        std::optional<int> endFrame; // 🔥 NEW: End frame for segment playback
    };

} // namespace CoreCanvas