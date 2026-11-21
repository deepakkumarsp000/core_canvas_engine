// FILE: src/param_layout.h
// PURPOSE: Dart ke FlexLayout model ko C++ struct me map karna taaki Yoga engine isko read kar sake.
// 🚀 FAANG FIX: Memory footprint ko chota rakhne ke liye sirf zaroori types aur default values use kiye hain.

#pragma once
#include <optional>

namespace CoreCanvas {

// ============================================================================
// 🧘 META YOGA FLEXBOX (Fast Integer & Double Mapping)
// ============================================================================
    struct FlexLayout {
        // Layout Enums (Mapped as fast integers directly matching Dart Enums)
        int display = 0;
        int direction = 0;
        int layoutDirection = 0;
        int justifyContent = 0;
        int alignItems = 0;
        int alignContent = 0;
        int alignSelf = 0;
        int wrap = 0;
        int overflow = 0;

        // Strict Doubles (Non-nullable in Dart)
        double gap = 0.0;
        double rowGap = 0.0;
        double columnGap = 0.0;
        double flexGrow = 0.0;
        double flexShrink = 1.0; // 🔥 Default 1.0 as per Dart model

        // Optional Dimensions (Dart ke double? -> std::optional in C++)
        std::optional<double> flexBasis;
        std::optional<double> flexBasisPercent;

        // Boolean flags
        bool isFlexBasisAuto = false;
    };

} // namespace CoreCanvas