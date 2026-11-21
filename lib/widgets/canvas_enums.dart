// FILE: lib/widgets/canvas_enums.dart
// PURPOSE: Ultimate Exhaustive IDE Auto-complete Enums for Level-2 C++ Engine

// ============================================================================
// ⚙️ ENGINE & DOCUMENT CONFIG (Target Formats & PDF Preferences)
// ============================================================================
enum TargetFormat {
  pdf(0),
  png(1),
  html(2),
  jpg(3),
  webp(4),
  gif(5);

  const TargetFormat(this.value);
  final int value;
}

enum ColorSpace {
  rgb(0),
  grayscale(1),
  cmyk(2);

  const ColorSpace(this.value);
  final int value;
}

enum PdfPageMode {
  useNone(0),
  useOutlines(1),
  useThumbs(2),
  fullScreen(3),
  useOC(4),
  useAttachments(5);

  const PdfPageMode(this.value);
  final int value;
}

enum PdfPageLayout {
  singlePage(0),
  oneColumn(1),
  twoColumnLeft(2),
  twoColumnRight(3),
  twoPageLeft(4),
  twoPageRight(5);

  const PdfPageLayout(this.value);
  final int value;
}

// ============================================================================
// 📦 CORE ELEMENTS
// ============================================================================
enum CanvasElementType {
  container(0),
  text(1),
  image(2),
  svg(3),
  lottie(4);

  const CanvasElementType(this.value);
  final int value;
}

// ============================================================================
// 🧘 META YOGA (100% Layout Coverage)
// ============================================================================
enum FlexDisplay {
  flex(0),
  none(1);

  const FlexDisplay(this.value);
  final int value;
}

// 🔥 ROOT CAUSE FIX: 100% Synced with Facebook Yoga Native Enum
enum FlexDir {
  column(0),
  columnReverse(1),
  row(2),
  rowReverse(3);

  const FlexDir(this.value);
  final int value;
}

enum FlexJustify {
  start(0),
  center(1),
  end(2),
  spaceBetween(3),
  spaceAround(4),
  spaceEvenly(5);

  const FlexJustify(this.value);
  final int value;
}

enum FlexAlign {
  auto(0),
  flexStart(1),
  center(2),
  flexEnd(3),
  stretch(4),
  baseline(5),
  spaceBetween(6),
  spaceAround(7);

  const FlexAlign(this.value);
  final int value;
}

enum FlexWrap {
  noWrap(0),
  wrap(1),
  wrapReverse(2);

  const FlexWrap(this.value);
  final int value;
}

enum PosType {
  relative(0),
  absolute(1),
  static(2);

  const PosType(this.value);
  final int value;
}

enum LayoutDirection {
  inherit(0),
  ltr(1),
  rtl(2);

  const LayoutDirection(this.value);
  final int value;
}

enum Overflow {
  visible(0),
  hidden(1),
  scroll(2);

  const Overflow(this.value);
  final int value;
}

// ============================================================================
// 🎨 PDFGEN & STB STYLE DECORATIONS (100% Coverage)
// ============================================================================
enum BorderStyle {
  solid(0),
  dashed(1),
  dotted(2);

  const BorderStyle(this.value);
  final int value;
}

enum StrokeCap {
  butt(0),
  round(1),
  square(2);

  const StrokeCap(this.value);
  final int value;
}

enum StrokeJoin {
  miter(0),
  round(1),
  bevel(2);

  const StrokeJoin(this.value);
  final int value;
}

enum BoxShape {
  rectangle(0),
  circle(1);

  const BoxShape(this.value);
  final int value;
}

enum BlendMode {
  normal(0),
  multiply(1),
  screen(2),
  overlay(3),
  darken(4),
  lighten(5),
  colorDodge(6),
  colorBurn(7),
  hardLight(8),
  softLight(9),
  difference(10),
  exclusion(11);

  const BlendMode(this.value);
  final int value;
}

// ============================================================================
// 🅰 STB TRUETYPE (Typography Exhaustive)
// ============================================================================
enum FontStyle {
  normal(0),
  italic(1),
  oblique(2);

  const FontStyle(this.value);
  final int value;
}

enum TextAlign {
  left(0),
  center(1),
  right(2),
  justify(3);

  const TextAlign(this.value);
  final int value;
}

enum TextDecoration {
  none(0),
  underline(1),
  lineThrough(2),
  overline(3),
  invisible(4);

  const TextDecoration(this.value);
  final int value;
}

enum TextOverflow {
  clip(0),
  ellipsis(1);

  const TextOverflow(this.value);
  final int value;
}

// ============================================================================
// 🖼️ STB IMAGE & NANOSVG (Media & Vector)
// ============================================================================
enum ImageFit {
  none(0),
  fill(1),
  contain(2),
  cover(3),
  scaleDown(4);

  const ImageFit(this.value);
  final int value;
}

enum ImageAlignment {
  center(0),
  topLeft(1),
  topCenter(2),
  topRight(3),
  centerLeft(4),
  centerRight(5),
  bottomLeft(6),
  bottomCenter(7),
  bottomRight(8);

  const ImageAlignment(this.value);
  final int value;
}

enum ClipRule {
  nonZero(0),
  evenOdd(1);

  const ClipRule(this.value);
  final int value;
}

// ============================================================================
// 📝 ACROFORMS (Interactive PDF)
// ============================================================================
enum FormFieldType {
  text(0),
  checkbox(1),
  radio(2),
  button(3),
  dropdown(4);

  const FormFieldType(this.value);
  final int value;
}

// ============================================================================
// 🎬 TWEENY ENGINE (100% Math Curve Coverage)
// ============================================================================
enum TimingFunction {
  linear(0),
  // Sine (Smooth start/end)
  easeInSine(1),
  easeOutSine(2),
  easeInOutSine(3),
  // Quad (Faster acceleration)
  easeInQuad(4),
  easeOutQuad(5),
  easeInOutQuad(6),
  // Cubic
  easeInCubic(7),
  easeOutCubic(8),
  easeInOutCubic(9),
  // Quart
  easeInQuart(10),
  easeOutQuart(11),
  easeInOutQuart(12),
  // Quint
  easeInQuint(13),
  easeOutQuint(14),
  easeInOutQuint(15),
  // Expo (Extremely fast acceleration)
  easeInExpo(16),
  easeOutExpo(17),
  easeInOutExpo(18),
  // Circ
  easeInCirc(19),
  easeOutCirc(20),
  easeInOutCirc(21),
  // Back (Pulls back before shooting forward)
  easeInBack(22),
  easeOutBack(23),
  easeInOutBack(24),
  // Elastic (Rubber band effect)
  easeInElastic(25),
  easeOutElastic(26),
  easeInOutElastic(27),
  // Bounce (Bouncing ball effect)
  easeInBounce(28),
  easeOutBounce(29),
  easeInOutBounce(30);

  const TimingFunction(this.value);
  final int value;
}

// ============================================================================
// 🌟 UNIVERSAL FX ENUMS (Shadows & Reflections)
// ============================================================================

/// Determines how the shadow is calculated by the C++ Engine.
enum ShadowType {
  /// True alpha-based Gaussian blur (Matches the exact shape of transparent images/SVGs).
  dropShadow(0),

  /// Rectangular/Rounded math-based blur (Fastest, ignores internal transparency).
  boxShadow(1);

  const ShadowType(this.value);
  final int value;
}

/// Determines the direction in which a mirror reflection fades out.
enum FadeDirection {
  /// Reflection fades from top to bottom (Standard water reflection).
  bottom(0),

  /// Reflection fades from bottom to top.
  top(1),

  /// Reflection fades from left to right.
  right(2),

  /// Reflection fades from right to left.
  left(3),

  /// No fade gradient, reflection remains at constant opacity.
  none(4);

  const FadeDirection(this.value);
  final int value;
}
