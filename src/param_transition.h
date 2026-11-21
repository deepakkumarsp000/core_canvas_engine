// FILE: src/param_transition.h
// PURPOSE: Dart ke TransitionProps ko C++ struct me map karna taaki Tweeny engine animations handle kar sake.
// 🚀 FAANG FIX: Added full keyframe starting states (fromOpacity, fromScale, fromX, fromY, fromRotate, loop, yoyo)!

#pragma once
#include <optional>

namespace CoreCanvas {

// ============================================================================
// 🎬 TRANSITION PROPS (Timing, 31 Tweeny Curves & Keyframe States)
// ============================================================================
    struct TransitionProps {
        int durationMs = 300;
        int delayMs = 0;
        int timingFunction = 1; // 0..30 (Maps 1:1 to Tweeny Easing Curves)

        std::optional<double> fromOpacity;
        std::optional<double> fromScale;
        std::optional<double> fromX;
        std::optional<double> fromY;
        std::optional<double> fromRotate;
        bool loop = false;
        bool yoyo = false;
    };

} // namespace CoreCanvas