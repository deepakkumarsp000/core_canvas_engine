// FILE: lib/models/engine_config.dart
// ============================================================================
// PURPOSE: Enterprise Universal Canvas Configuration Model (Core Canvas Engine)
// DESCRIPTION: Global document settings, C++ Target Routing, Yoga Root settings.
// 🚀 FAANG FIX: 100% Enum Sync with C++ Yoga & Strict Key Presence!
// ============================================================================

import 'dart:convert';
import 'super_container.dart';

/// 📐 Represents the physical or virtual dimensions of the target canvas.
class CanvasFormat {
  final double width, height;
  const CanvasFormat(this.width, this.height);

  static const CanvasFormat a4 = CanvasFormat(595.0, 842.0);
  static const CanvasFormat a5 = CanvasFormat(420.0, 595.0);
  static const CanvasFormat letter = CanvasFormat(612.0, 792.0);
  static const CanvasFormat legal = CanvasFormat(612.0, 1008.0);

  static const CanvasFormat web1080 = CanvasFormat(1920.0, 1080.0);
  static const CanvasFormat instaSquare = CanvasFormat(1080.0, 1080.0);
}

/// 🚀 ULTRA-FAST NUMERIC: PDFGen Viewer Preferences
class ViewerPreferences {
  final bool hideToolbar;
  final bool hideMenubar;
  final bool fitWindow;

  // Integer Mapping for C++ Enum (Synced with PdfPageMode)
  // 0: useNone, 1: useOutlines (Bookmarks), 2: useThumbs, 3: fullScreen, 4: useOC, 5: useAttachments
  final int pageMode;

  // Integer Mapping for C++ Enum (Synced with PdfPageLayout)
  // 0: singlePage, 1: oneColumn, 2: twoColumnLeft, 3: twoColumnRight, 4: twoPageLeft, 5: twoPageRight
  final int pageLayout;

  ViewerPreferences({
    this.hideToolbar = false,
    this.hideMenubar = false,
    this.fitWindow = false,
    this.pageMode = 0, // Fast Int
    this.pageLayout = 0, // Fast Int
  });

  Map<String, dynamic> toJson() {
    // 🔥 FIX: Hamesha bhejo, C++ parser ko inki zarurat hai
    return {
      'hideToolbar': hideToolbar,
      'hideMenubar': hideMenubar,
      'fitWindow': fitWindow,
      'pageMode': pageMode,
      'pageLayout': pageLayout,
    };
  }
}

/// ⚙️ Global configuration for the rendering surface.
class CanvasConfig {
  final CanvasFormat format;
  final EdgeInsets? canvasMargin;

  // 🚀 C++ Backend Router
  // 0: PDF, 1: PNG, 2: HTML, 3: JPG, 4: WEBP, 5: GIF
  final int targetFormat;

  // 🔥 SYNCED WITH LayoutDirection Enum & C++ Yoga:
  // 0: Inherit (LTR default), 1: LTR, 2: RTL
  final int layoutDirection;

  final double scaleFactor;
  final int dpi;

  // 0: RGB, 1: Grayscale, 2: CMYK
  final int colorSpace;

  // 🔥 Image Exporter Properties (STB Image Write & LibWebP)
  // 1 to 100 (Compression scale for JPG/WebP)
  final int exportQuality;
  // True = No Compression (WebP only), False = Compressed
  final bool lossless;

  CanvasConfig({
    this.format = CanvasFormat.a4,
    this.canvasMargin,
    this.targetFormat = 0, // Default: PDF
    this.layoutDirection =
        0, // Default: Inherit/LTR (0: Inherit, 1: LTR, 2: RTL)
    this.scaleFactor = 1.0,
    this.dpi = 72,
    this.colorSpace = 0, // Default: RGB
    this.exportQuality = 100, // 🔥 High Quality Default
    this.lossless = false, // 🔥 Default False
  });

  factory CanvasConfig.custom({
    required double width,
    required double height,
    EdgeInsets? margin,
    int targetFormat = 0,
    int layoutDirection = 0,
    double scaleFactor = 1.0,
    int dpi = 72,
    int colorSpace = 0,
    int exportQuality = 100,
    bool lossless = false,
  }) {
    return CanvasConfig(
      format: CanvasFormat(width, height),
      canvasMargin: margin,
      targetFormat: targetFormat,
      layoutDirection: layoutDirection,
      scaleFactor: scaleFactor,
      dpi: dpi,
      colorSpace: colorSpace,
      exportQuality: exportQuality,
      lossless: lossless,
    );
  }

  Map<String, dynamic> toJson() {
    // 🔥 FIX: Zero-Waste checks completely removed!
    // Ab C++ ka parser kabhi fail nahi hoga.
    final Map<String, dynamic> data = {
      'w': format.width,
      'h': format.height,
      'format': targetFormat,
      'dir': layoutDirection,
      'scale': scaleFactor,
      'dpi': dpi,
      'colorSpace': colorSpace,
      'quality': exportQuality,
      'lossless': lossless,
    };

    if (canvasMargin != null) {
      data['margin'] = canvasMargin!.toJson();
    }

    return data;
  }
}

/// 📇 Metadata information mapped across all platforms.
class DocumentInfo {
  final String? title,
      author,
      subject,
      keywords,
      creator,
      producer,
      creationDate;
  final ViewerPreferences? viewerPrefs;

  DocumentInfo({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator = "Core Canvas Engine",
    this.producer = "Level-2 Zero-Bloat C++ Engine",
    this.creationDate,
    this.viewerPrefs,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (author != null) data['author'] = author;
    if (subject != null) data['subject'] = subject;
    if (keywords != null) data['keywords'] = keywords;
    if (creator != null) data['creator'] = creator;
    if (producer != null) data['producer'] = producer;
    if (creationDate != null) data['creationDate'] = creationDate;

    if (viewerPrefs != null) {
      final prefsJson = viewerPrefs!.toJson();
      if (prefsJson.isNotEmpty) data['viewerPrefs'] = prefsJson;
    }
    return data;
  }
}

/// 🌐 The Universal Data Payload sent to the C++ Engine.
class CoreDocument {
  final CanvasConfig config;
  final DocumentInfo? info;
  final SuperContainer? header, footer;
  final SuperContainer body;

  // 🔥 FIX: Absolute disk paths to TTF/OTF files for ultra-fast C++ loading
  final Map<String, String>? fonts;
  final Typography? defaultTypography;

  CoreDocument({
    required this.config,
    required this.body,
    this.info,
    this.header,
    this.footer,
    this.fonts,
    this.defaultTypography,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'config': config.toJson(),
      'body': body.toJson(),
    };
    if (info != null) data['info'] = info!.toJson();
    if (header != null) data['header'] = header!.toJson();
    if (footer != null) data['footer'] = footer!.toJson();
    if (fonts != null) data['fonts'] = fonts;
    if (defaultTypography != null) {
      data['defaultTypo'] = defaultTypography!.toJson();
    }

    return data;
  }

  String toEngineJson() => jsonEncode(toJson());
}
