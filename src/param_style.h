// FILE: src/param_style.h
// PURPOSE: C++ Struct mappings for BoxDecoration, CanvasShadow, and CanvasReflection.
// 🚀 FAANG FIX: Synced shadowType, fadeDirection, and gradientAngle with Dart AST!

#pragma once
#include <optional>
#include <vector>
#include <string>
#include <cstdint>
#include "param_box.h"

namespace CoreCanvas {

// ============================================================================
// 🌟 UNIVERSAL FX MODELS (Shadow & Mirror)
// ============================================================================
    struct CanvasShadow {
        uint32_t color = 0xFF000000;
        std::optional<std::vector<int>> gradient;
        double offsetX = 0.0;
        double offsetY = 0.0;
        double blurRadius = 10.0;
        double spreadRadius = 0.0;
        bool isDropShadow = true; // True = True Alpha Blur, False = Box Math
        int shadowType = 0;       // 🔥 NEW: 0 = dropShadow, 1 = boxShadow
    };

    struct CanvasReflection {
        double distance = 0.0;
        double blurRadius = 0.0;
        double opacity = 0.5;
        int fadeDirection = 0;    // 🔥 NEW: 0 = bottom, 1 = top, 2 = right, 3 = left, 4 = none
        std::optional<std::vector<int>> fadeGradient;
    };

// ============================================================================
// 🎨 BOX DECORATION
// ============================================================================
    struct BoxDecoration {
        std::optional<uint32_t> backgroundColor;
        std::optional<uint32_t> borderColor;
        std::optional<std::vector<int>> gradient;
        double gradientAngle = 0.0; // 🔥 NEW: Angle in degrees (0 to 360) for Linear Gradients
        std::optional<std::string> backgroundImage;

        double opacity = 1.0;
        int blendMode = 0;

        std::optional<EdgeInsets> borderWidth;
        int borderStyle = 0;
        std::optional<std::vector<double>> borderDash;
        std::optional<EdgeInsets> borderRadius;

        int shape = 0;
        bool isClip = false;
        int clipRule = 0;
        std::optional<std::string> clipSvgPath;
        std::optional<std::string> clipMath;

        std::optional<CanvasShadow> shadow;
        std::optional<CanvasReflection> mirror;
    };

} // namespace CoreCanvas