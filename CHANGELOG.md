## 1.0.0

* Initial production release of Core Canvas Engine.
* Native C++20 rendering engine powered by Meta Yoga Flexbox, YYJSON, PDFGen, NanoSVG, STB, LibWebP, Tweeny, and RLottie.
* Unified 6-format export support: PDF, PNG, JPG, WebP, HTML5, and Animated GIF.
* Smart 4-Mode build configuration (`Zero-Config`, `Presets`, `Opt-In`, `Opt-Out`) for minimal binary size.
* Built-in macro widgets: `CanvasTable`, `CanvasBulletList`, `CanvasProgressBar`, `CanvasCard`, `CanvasBadge`, `CanvasIcon`, and `CanvasCustomPainter`.
* Multi-page repeating headers and footers with dynamic `{{page}}` and `{{totalPages}}` tokens.
* Structured `CanvasExportResult`, `CanvasCapabilities`, and `CanvasEngineException` diagnostics.