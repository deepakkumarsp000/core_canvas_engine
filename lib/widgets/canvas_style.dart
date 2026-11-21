// FILE: lib/widgets/canvas_style.dart
// PURPOSE: Reusable Design System (CSS-like Classes) for Canvas Widgets
// EXHAUSTIVE: Handles Margin, Padding, Decoration, and Typography defaults.

import '../models/super_container.dart';
import 'canvas_enums.dart';

class CanvasStyle {
  // 📏 SPACING
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  // 🎨 DECORATION
  final int? backgroundColor;
  final int? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final BorderStyle? borderStyle;
  final List<double>? borderDash;
  final double? opacity;
  final BlendMode? blendMode;
  final BoxShape? shape;

  // 🔥 NAYA FX LAYER (Renamed to avoid method name conflicts)
  final CanvasShadow? shadowDef;
  final CanvasReflection? mirrorDef;

  // 🅰️ TYPOGRAPHY DEFAULTS (Cascade down to Text)
  final int? textColor;
  final double? fontSize;
  final int? fontWeight;
  final TextAlign? textAlign;

  const CanvasStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.borderStyle,
    this.borderDash,
    this.opacity,
    this.blendMode,
    this.shape,
    this.shadowDef,
    this.mirrorDef,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  /// 🔄 CASCADING MERGE (CSS Overwrite Logic)
  CanvasStyle copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    int? backgroundColor,
    int? borderColor,
    double? borderWidth,
    double? borderRadius,
    BorderStyle? borderStyle,
    List<double>? borderDash,
    double? opacity,
    BlendMode? blendMode,
    BoxShape? shape,
    CanvasShadow? shadowDef,
    CanvasReflection? mirrorDef,
    int? textColor,
    double? fontSize,
    int? fontWeight,
    TextAlign? textAlign,
  }) {
    return CanvasStyle(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      borderStyle: borderStyle ?? this.borderStyle,
      borderDash: borderDash ?? this.borderDash,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      shape: shape ?? this.shape,
      shadowDef: shadowDef ?? this.shadowDef,
      mirrorDef: mirrorDef ?? this.mirrorDef,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  /// -------------------------------------------------------------------------
  /// ✨ FLUENT SETTERS (jQuery-style Chaining for Style Definitions)
  /// -------------------------------------------------------------------------

  CanvasStyle bg(int color) => copyWith(backgroundColor: color);
  CanvasStyle p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasStyle px(double val) => copyWith(
    padding: EdgeInsets.symmetric(horizontal: val, vertical: padding?.top ?? 0),
  );
  CanvasStyle py(double val) => copyWith(
    padding: EdgeInsets.symmetric(
      vertical: val,
      horizontal: padding?.right ?? 0,
    ),
  );
  CanvasStyle m(double val) => copyWith(margin: EdgeInsets.all(val));

  CanvasStyle rounded(double radius) => copyWith(borderRadius: radius);
  CanvasStyle circle() => copyWith(shape: BoxShape.circle);

  CanvasStyle border({
    int color = 0xFF000000,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return copyWith(borderColor: color, borderWidth: width, borderStyle: style);
  }

  // 🔥 NAYE FX SHORTHANDS (Direct .shadow aur .mirror lagane ke liye)
  CanvasStyle shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double dx = 0.0,
    double dy = 0.0,
    bool isDropShadow = true,
  }) => copyWith(
    shadowDef: CanvasShadow(
      color: color,
      blurRadius: blur,
      offsetX: dx,
      offsetY: dy,
      isDropShadow: isDropShadow,
    ),
  );

  CanvasStyle mirror({
    double distance = 0.0,
    double blur = 0.0,
    double opacity = 0.5,
  }) => copyWith(
    mirrorDef: CanvasReflection(
      distance: distance,
      blurRadius: blur,
      opacity: opacity,
    ),
  );

  CanvasStyle alpha(double val) => copyWith(opacity: val);
  CanvasStyle blend(BlendMode mode) => copyWith(blendMode: mode);

  // Typography Shorthands
  CanvasStyle text({int? color, double? size, int? weight, TextAlign? align}) {
    return copyWith(
      textColor: color,
      fontSize: size,
      fontWeight: weight,
      textAlign: align,
    );
  }
}
