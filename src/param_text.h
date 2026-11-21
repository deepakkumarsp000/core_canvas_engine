// FILE: src/param_text.h
// PURPOSE: C++ Struct mappings for Typography and inline RichText TextRuns.
// 🚀 FAANG FIX: Added per-span color, fontSize, weight, and style to TextRun!

#pragma once
#include <optional>
#include <string>
#include <vector>
#include <cstdint>

namespace CoreCanvas {

    struct TextRun {
        std::string text = "";
        double dx = 0.0;
        double dy = 0.0;
        std::optional<uint32_t> color;
        std::optional<double> fontSize;
        std::optional<int> weight;
        std::optional<int> style;
    };

    struct Typography {
        std::optional<std::string> fontFamily;
        double fontSize = 12.0;
        uint32_t color = 0xFF000000;
        int weight = 400;

        int style = 0;
        int align = 0;
        int decoration = 0;
        int textOverflow = 0;

        std::string fontVariant = "normal";
        std::string textRenderMode = "fill";

        double lineHeight = 1.2;
        double letterSpacing = 0.0;
        double wordSpacing = 0.0;
        double baselineOffset = 0.0;

        std::optional<int> maxLines;
        std::optional<std::vector<TextRun>> runs;
    };

} // namespace CoreCanvas