// FILE: src/param_box.h
// PURPOSE: Dart ke BoxConstraints, EdgeInsets, aur Position ko C++ struct me map karna.
// 🚀 FAANG FIX: std::optional ka use kiya gaya hai taaki Dart se aane wale null values C++ me crash (NaN) na karein.

#pragma once
#include <optional>

namespace CoreCanvas {

// ============================================================================
// 🚀 EDGE INSETS (Dart ke non-nullable strict doubles)
// ============================================================================
    struct EdgeInsets {
        double top = 0.0;
        double right = 0.0;
        double bottom = 0.0;
        double left = 0.0;
    };

// ============================================================================
// 📦 BOX CONSTRAINTS (Dart ke double? mapped to std::optional)
// ============================================================================
    struct BoxConstraints {
        // Fixed Dimensions
        std::optional<double> width;
        std::optional<double> height;
        std::optional<double> minWidth;
        std::optional<double> maxWidth;
        std::optional<double> minHeight;
        std::optional<double> maxHeight;
        std::optional<double> aspectRatio;

        // Percentage Dimensions
        std::optional<double> widthPercent;
        std::optional<double> heightPercent;
        std::optional<double> minWidthPercent;
        std::optional<double> maxWidthPercent;
        std::optional<double> minHeightPercent;
        std::optional<double> maxHeightPercent;
    };

// ============================================================================
// 📍 POSITION (Type & Z-Index strict int, baaki optional coordinates)
// ============================================================================
    struct Position {
        int type = 0;   // 0: relative, 1: absolute, 2: static
        int zIndex = 0;

        // Fixed Coordinates
        std::optional<double> top;
        std::optional<double> right;
        std::optional<double> bottom;
        std::optional<double> left;

        // Percentage Coordinates
        std::optional<double> topPercent;
        std::optional<double> rightPercent;
        std::optional<double> bottomPercent;
        std::optional<double> leftPercent;
    };

} // namespace CoreCanvas