# Core Canvas Engine

A super-fast native **C++20** engine for Flutter that lets you build layouts once and export them to **PDF, PNG, JPG, WebP, HTML5, or Animated GIF**.

Powered by **Meta Yoga (Flexbox)**, **YYJSON**, **PDFGen**, **NanoSVG**, **STB**, **LibWebP**, **Tweeny**, and **RLottie**, all layout calculations and rendering run off the main UI thread via **Dart FFI** — so your Flutter app stays smooth at 60/120 FPS.

---

## Key Features

- **Design Once, Export Anywhere:** Export the same `CanvasDocument` to **PDF, PNG, JPG, WebP, HTML, or Animated GIF**.
- **Zero-Config by Default:** Install and use every feature right away — no setup needed.
- **Shrink Your App Size Anytime:** Strip unused C++ modules (like Lottie, WebP, or GIF) directly from `pubspec.yaml` to bring the native library down to **~160 KB**.
- **Built-In Pro Widgets:** Ready-made `CanvasTable`, `CanvasBulletList`, `CanvasProgressBar`, `CanvasCard`, `CanvasBadge`, `CanvasIcon`, and `CanvasCustomPainter`.
- **Multi-Page Smart PDFs:** Automatic repeating headers and footers with live `{{page}}` and `{{totalPages}}` numbers, plus page-break-safe tables.
- **Rich Visual Effects:** Drop shadows, water mirror reflections, linear gradients, 12 blend modes, SVG clipping, 2D transforms, and 31 animation easing curves.
- **Full Unicode, Hindi & Emoji Support:** Automatically renders Indian scripts (Hindi, Gujarati, Tamil, etc.), Emojis, RichText spans, and 5,000+ Material/Cupertino icons at 2x Retina sharpness.
- **Clear Error Diagnostics:** Built-in pre-flight checks return structured error codes with exact fix instructions.

---

## Installation

Add `core_canvas_engine` to your app's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  core_canvas_engine: ^1.0.0