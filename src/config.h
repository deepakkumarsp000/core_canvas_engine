// FILE: src/config.h
// PURPOSE: Global engine settings, Document metadata, aur main AST node (SuperContainer) ko define karna.
// 🚀 FAANG FIX: std::optional aur std::unordered_map ka use kiya gaya hai zero-bloat nesting aur fast font lookups ke liye.

#pragma once
#include <string>
#include <vector>
#include <optional>
#include <unordered_map>

// Apne saare layer 1 params ko include kar rahe hain
#include "param_box.h"
#include "param_layout.h"
#include "param_style.h"
#include "param_text.h"
#include "param_media.h"
#include "param_transform.h"
#include "param_transition.h"

namespace CoreCanvas {

// ============================================================================
// ⚙️ CANVAS CONFIGURATION (Output routing and quality)
// ============================================================================
    struct CanvasConfig {
        double w = 595.0; // A4 width default
        double h = 842.0; // A4 height default
        std::optional<EdgeInsets> margin;
        int targetFormat = 0;
        int dir = 0;
        double scale = 1.0;
        int dpi = 72;
        int colorSpace = 0;
        int quality = 100;
        bool lossless = false;
    };

// ============================================================================
// 📇 METADATA & VIEWER PREFS
// ============================================================================
    struct ViewerPreferences {
        bool hideToolbar = false;
        bool hideMenubar = false;
        bool fitWindow = false;
        int pageMode = 0;
        int pageLayout = 0;
    };

    struct DocumentInfo {
        std::optional<std::string> title;
        std::optional<std::string> author;
        std::optional<std::string> subject;
        std::optional<std::string> keywords;
        std::optional<std::string> creator;
        std::optional<std::string> producer;
        std::optional<std::string> creationDate;
        std::optional<ViewerPreferences> viewerPrefs;
    };

// ============================================================================
// 📄 PDF SPANNING & FORMS
// ============================================================================
    struct SpanningRules {
        int pageBreakBefore = 0;
        int pageBreakInside = 0;
        int pageBreakAfter = 0;
        double safeThreshold = 100.0;
        int orphans = 2;
        int widows = 2;
    };

    struct FormFieldData {
        int fieldType = 0;
        std::string name;
        std::string value;
    };

// ============================================================================
// 📦 SUPER CONTAINER (The Ultimate AST Node)
// ============================================================================
    struct SuperContainer {
        std::string id;
        int type = 0;

        std::optional<BoxConstraints> constraints;
        std::optional<EdgeInsets> margin;
        std::optional<EdgeInsets> padding;
        std::optional<EdgeInsets> marginPercent;
        std::optional<EdgeInsets> paddingPercent;
        std::optional<FlexLayout> layout;
        std::optional<Position> position;
        std::optional<SpanningRules> spanningRules;
        std::optional<BoxDecoration> decoration;
        std::optional<TransformMatrix> transform;
        std::optional<TransitionProps> transition;
        std::optional<Typography> typography;

        std::optional<std::string> bookmarkTitle;
        bool marginAuto = false;

        std::optional<ImageProps> imageProps;
        std::optional<SvgProps> svgProps;
        std::optional<LottieProps> lottieProps;

        std::optional<std::string> content;
        std::optional<std::string> linkUrl;
        std::optional<std::string> fallbackText;
        std::optional<std::string> semanticTag;
        std::optional<std::string> rasterMask;

        std::optional<FormFieldData> formField;

        // 🔥 FIX: Vector of itself (Tree Structure)
        std::vector<SuperContainer> children;
    };

// ============================================================================
// 🌐 CORE DOCUMENT (The payload received from Dart)
// ============================================================================
    struct CoreDocument {
        CanvasConfig config;
        std::optional<DocumentInfo> info;
        std::optional<SuperContainer> header;
        std::optional<SuperContainer> footer;
        SuperContainer body;

        // 🔥 FIX: O(1) fast lookup for fonts using std::unordered_map
        // Dart maps { "FontName": "/absolute/path/to/font.ttf" }
        std::unordered_map<std::string, std::string> fonts;
        std::optional<Typography> defaultTypography;
    };

} // namespace CoreCanvas