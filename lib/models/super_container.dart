// FILE: lib/models/super_container.dart
// ============================================================================
// PURPOSE: Enterprise Universal AST Model (Level 2)
// 🚀 ULTRA-FAST: 100% Int/Double mapped. Zero String properties for Layout/Styles!
// 🔥 UPGRADED: Full Tweeny Keyframe Props, RLottie Frame Control & RichText Runs!
// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint and kDebugMode

/// 🚀 EDGE INSETS & BOX CONSTRAINTS
class EdgeInsets {
  final double top, right, bottom, left;
  const EdgeInsets(this.top, this.right, this.bottom, this.left);

  factory EdgeInsets.all(double value) =>
      EdgeInsets(value, value, value, value);
  factory EdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  }) => EdgeInsets(vertical, horizontal, vertical, horizontal);
  factory EdgeInsets.only({
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double left = 0.0,
  }) => EdgeInsets(top, right, bottom, left);

  List<double> toJson() => [top, right, bottom, left];
}

class BoxConstraints {
  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPercent,
      heightPercent,
      minWidthPercent,
      maxWidthPercent,
      minHeightPercent,
      maxHeightPercent;

  BoxConstraints({
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPercent,
    this.heightPercent,
    this.minWidthPercent,
    this.maxWidthPercent,
    this.minHeightPercent,
    this.maxHeightPercent,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (width != null) data['w'] = width;
    if (height != null) data['h'] = height;
    if (minWidth != null) data['minW'] = minWidth;
    if (maxWidth != null) data['maxW'] = maxWidth;
    if (minHeight != null) data['minH'] = minHeight;
    if (maxHeight != null) data['maxH'] = maxHeight;
    if (aspectRatio != null) data['ratio'] = aspectRatio;

    if (widthPercent != null) data['wPct'] = widthPercent;
    if (heightPercent != null) data['hPct'] = heightPercent;
    if (minWidthPercent != null) data['minWPct'] = minWidthPercent;
    if (maxWidthPercent != null) data['maxWPct'] = maxWidthPercent;
    if (minHeightPercent != null) data['minHPct'] = minHeightPercent;
    if (maxHeightPercent != null) data['maxHPct'] = maxHeightPercent;
    return data;
  }
}

/// 📦 META YOGA FLEXBOX
class FlexLayout {
  final int display;
  final int direction;
  final int layoutDirection;
  final int justifyContent, alignItems, alignContent, alignSelf;
  final int wrap;
  final int overflow;

  final double gap, rowGap, columnGap, flexGrow, flexShrink;
  final double? flexBasis, flexBasisPercent;
  final bool isFlexBasisAuto;

  FlexLayout({
    this.display = 0,
    this.direction = 0,
    this.layoutDirection = 0,
    this.justifyContent = 0,
    this.alignItems = 0,
    this.alignContent = 0,
    this.alignSelf = 0,
    this.wrap = 0,
    this.overflow = 0,
    this.gap = 0.0,
    this.rowGap = 0.0,
    this.columnGap = 0.0,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.flexBasis,
    this.flexBasisPercent,
    this.isFlexBasisAuto = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'display': display,
      'dir': direction,
      'layoutDir': layoutDirection,
      'justify': justifyContent,
      'align': alignItems,
      'alignContent': alignContent,
      'alignSelf': alignSelf,
      'wrap': wrap,
      'overflow': overflow,
      'gap': gap,
      'rowGap': rowGap,
      'colGap': columnGap,
      'flexGrow': flexGrow,
      'flexShrink': flexShrink,
    };

    if (flexBasis != null) data['flexBasis'] = flexBasis;
    if (flexBasisPercent != null) data['flexBasisPct'] = flexBasisPercent;
    if (isFlexBasisAuto) data['flexBasisAuto'] = true;
    return data;
  }
}

class Position {
  final int type;
  final double? top, right, bottom, left;
  final double? topPercent, rightPercent, bottomPercent, leftPercent;
  final int zIndex;

  Position({
    this.type = 0,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPercent,
    this.rightPercent,
    this.bottomPercent,
    this.leftPercent,
    this.zIndex = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (type != 0) data['type'] = type;
    if (zIndex != 0) data['zIndex'] = zIndex;

    if (top != null) data['top'] = top;
    if (right != null) data['right'] = right;
    if (bottom != null) data['bottom'] = bottom;
    if (left != null) data['left'] = left;

    if (topPercent != null) data['topPct'] = topPercent;
    if (rightPercent != null) data['rightPct'] = rightPercent;
    if (bottomPercent != null) data['bottomPct'] = bottomPercent;
    if (leftPercent != null) data['leftPct'] = leftPercent;
    return data;
  }
}

/// 🔄 TRANSFORM MATRIX
class TransformMatrix {
  final double scaleX,
      scaleY,
      rotateZ,
      translateX,
      translateY,
      skewX,
      skewY,
      originX,
      originY;
  TransformMatrix({
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.skewX = 0.0,
    this.skewY = 0.0,
    this.originX = 0.5,
    this.originY = 0.5,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (scaleX != 1.0) data['sx'] = scaleX;
    if (scaleY != 1.0) data['sy'] = scaleY;
    if (rotateZ != 0.0) data['rz'] = rotateZ;
    if (translateX != 0.0) data['tx'] = translateX;
    if (translateY != 0.0) data['ty'] = translateY;
    if (skewX != 0.0) data['skx'] = skewX;
    if (skewY != 0.0) data['sky'] = skewY;
    if (originX != 0.5) data['ox'] = originX;
    if (originY != 0.5) data['oy'] = originY;
    return data;
  }
}

/// 📄 SPANNING RULES
class SpanningRules {
  final int pageBreakBefore, pageBreakInside, pageBreakAfter;
  final double safeThreshold;
  final int orphans, widows;

  SpanningRules({
    this.pageBreakBefore = 0,
    this.pageBreakInside = 0,
    this.pageBreakAfter = 0,
    this.safeThreshold = 100.0,
    this.orphans = 2,
    this.widows = 2,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (pageBreakBefore != 0) data['breakBefore'] = pageBreakBefore;
    if (pageBreakInside != 0) data['breakInside'] = pageBreakInside;
    if (pageBreakAfter != 0) data['breakAfter'] = pageBreakAfter;
    if (safeThreshold != 100.0) data['safeThreshold'] = safeThreshold;
    if (orphans != 2) data['orphans'] = orphans;
    if (widows != 2) data['widows'] = widows;
    return data;
  }
}

/// 📝 ACROFORM DATA
class FormFieldData {
  final int fieldType;
  final String name;
  final String value;
  FormFieldData({required this.fieldType, required this.name, this.value = ''});
  Map<String, dynamic> toJson() => {
    'fieldType': fieldType,
    'name': name,
    'value': value,
  };
}

/// 🅰️ INLINE RICH-TEXT RUN (Supports per-span color, size, weight & offset!)
class TextRun {
  final String text;
  final double dx, dy;
  final int? color;
  final double? fontSize;
  final int? weight;
  final int? style;

  TextRun(
    this.text, [
    this.dx = 0.0,
    this.dy = 0.0,
    this.color,
    this.fontSize,
    this.weight,
    this.style,
  ]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'text': text, 'dx': dx, 'dy': dy};
    if (color != null) data['color'] = color;
    if (fontSize != null) data['size'] = fontSize;
    if (weight != null) data['weight'] = weight;
    if (style != null) data['style'] = style;
    return data;
  }
}

/// 🅰️ TYPOGRAPHY
class Typography {
  final String? fontFamily;
  final double fontSize;
  final int color, weight;

  final int style;
  final int align;
  final int decoration;
  final int textOverflow;
  final String fontVariant, textRenderMode;

  final double lineHeight, letterSpacing, wordSpacing, baselineOffset;
  final int? maxLines;
  final List<TextRun>? runs;

  Typography({
    this.fontFamily = 'Helvetica',
    this.fontSize = 12.0,
    this.color = 0xFF000000,
    this.weight = 400,
    this.style = 0,
    this.align = 0,
    this.decoration = 0,
    this.textOverflow = 0,
    this.fontVariant = 'normal',
    this.textRenderMode = 'fill',
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.baselineOffset = 0.0,
    this.maxLines,
    this.runs,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'size': fontSize,
      'color': color,
      'weight': weight,
    };

    if (fontFamily != null) data['font'] = fontFamily;

    if (style != 0) data['style'] = style;
    if (align != 0) data['align'] = align;
    if (decoration != 0) data['decoration'] = decoration;
    if (textOverflow != 0) data['overflow'] = textOverflow;
    if (fontVariant != 'normal') data['fontVariant'] = fontVariant;
    if (textRenderMode != 'fill') data['textMode'] = textRenderMode;

    if (lineHeight != 1.2) data['lineHeight'] = lineHeight;
    if (letterSpacing != 0.0) data['spacing'] = letterSpacing;
    if (wordSpacing != 0.0) data['wordSpacing'] = wordSpacing;
    if (baselineOffset != 0.0) data['baselineOffset'] = baselineOffset;
    if (maxLines != null) data['maxLines'] = maxLines;

    try {
      if (runs != null && runs!.isNotEmpty) {
        data['runs'] = runs!.map((r) => r.toJson()).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("🔴 [DART_DEEP_ERR] Failed to map TextRuns: $e");
      }
    }

    return data;
  }
}

/// 🎬 TWEENY TRANSITION & ANIMATION PROPS (Supports all 31 Easing Curves + Keyframe States!)
class TransitionProps {
  final int durationMs, delayMs;
  final int timingFunction; // 0..30 (Maps 1:1 to Tweeny Easing Curves)

  // 🔥 Keyframe Starting States for C++ Tweeny & GIF / HTML5 Animation!
  final double? fromOpacity;
  final double? fromScale;
  final double? fromX;
  final double? fromY;
  final double? fromRotate;
  final bool loop;
  final bool yoyo;

  TransitionProps({
    this.durationMs = 300,
    this.delayMs = 0,
    this.timingFunction = 1,
    this.fromOpacity,
    this.fromScale,
    this.fromX,
    this.fromY,
    this.fromRotate,
    this.loop = false,
    this.yoyo = false,
  });

  Map<String, dynamic> toJson() {
    // Always include duration, delay & timing so C++ knows this node has an active transition!
    final Map<String, dynamic> data = {
      'duration': durationMs,
      'delay': delayMs,
      'timing': timingFunction,
    };
    if (fromOpacity != null) data['fromOpacity'] = fromOpacity;
    if (fromScale != null) data['fromScale'] = fromScale;
    if (fromX != null) data['fromX'] = fromX;
    if (fromY != null) data['fromY'] = fromY;
    if (fromRotate != null) data['fromRotate'] = fromRotate;
    if (loop) data['loop'] = true;
    if (yoyo) data['yoyo'] = true;
    return data;
  }
}

/// 📸 IMAGE PROPS
class ImageProps {
  final int fit;
  final int alignment;
  final int? dpi;

  ImageProps({this.fit = 0, this.alignment = 0, this.dpi});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fit != 0) data['fit'] = fit;
    if (alignment != 0) data['align'] = alignment;
    if (dpi != null) data['dpi'] = dpi;
    return data;
  }
}

/// 🎨 SVG PROPS
class SvgProps {
  final String? viewBox;
  final int? fill, stroke;
  final double strokeWidth;
  final int strokeCap, strokeJoin;

  SvgProps({
    this.viewBox,
    this.fill,
    this.stroke,
    this.strokeWidth = 0.0,
    this.strokeCap = 0,
    this.strokeJoin = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (viewBox != null) data['viewBox'] = viewBox;
    if (fill != null) data['fill'] = fill;
    if (stroke != null) data['stroke'] = stroke;
    if (strokeWidth != 0.0) data['strokeW'] = strokeWidth;
    if (strokeCap != 0) data['strokeCap'] = strokeCap;
    if (strokeJoin != 0) data['strokeJoin'] = strokeJoin;
    return data;
  }
}

/// 🎥 RLOTTIE PROPS (100% Synced for C++ RLottie Frame & GIF Animation)
class LottieProps {
  final bool autoplay, loop;
  final double speed;
  final int? fps, initialFrame, endFrame;

  LottieProps({
    this.autoplay = true,
    this.loop = true,
    this.speed = 1.0,
    this.fps,
    this.initialFrame = 0,
    this.endFrame,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'autoplay': autoplay,
      'loop': loop,
      'speed': speed,
      'frame': initialFrame ?? 0,
    };
    if (fps != null) data['fps'] = fps;
    if (endFrame != null) data['endFrame'] = endFrame;
    return data;
  }
}

// ============================================================================
// 🌟 UNIVERSAL FX MODELS (Shadow & Mirror)
// ============================================================================
class CanvasShadow {
  final int color;
  final List<int>? gradient;
  final double offsetX, offsetY;
  final double blurRadius, spreadRadius;
  final bool isDropShadow; // True = True Alpha Blur, False = Box Math
  final int shadowType; // 0: dropShadow, 1: boxShadow

  CanvasShadow({
    this.color = 0xFF000000,
    this.gradient,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.blurRadius = 10.0,
    this.spreadRadius = 0.0,
    this.isDropShadow = true,
    this.shadowType = 0,
  });

  Map<String, dynamic> toJson() {
    final bool effectiveDrop = shadowType == 0 ? isDropShadow : false;
    final Map<String, dynamic> data = {
      'color': color,
      'dx': offsetX,
      'dy': offsetY,
      'blur': blurRadius,
      'spread': spreadRadius,
      'isDrop': effectiveDrop,
      'type': shadowType,
    };
    if (gradient != null && gradient!.isNotEmpty) data['gradient'] = gradient;
    return data;
  }
}

class CanvasReflection {
  final double distance;
  final double blurRadius;
  final double opacity;
  final int fadeDirection; // 0: bottom, 1: top, 2: right, 3: left, 4: none
  final List<int>? fadeGradient;

  CanvasReflection({
    this.distance = 0.0,
    this.blurRadius = 0.0,
    this.opacity = 0.5,
    this.fadeDirection = 0,
    this.fadeGradient,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'distance': distance,
      'blur': blurRadius,
      'opacity': opacity,
    };
    if (fadeDirection != 0) data['fadeDir'] = fadeDirection;
    if (fadeGradient != null && fadeGradient!.isNotEmpty) {
      data['fadeGradient'] = fadeGradient;
    }
    return data;
  }
}

/// 📄 PDFGEN BOX DECORATION
class BoxDecoration {
  final int? backgroundColor, borderColor;
  final List<int>? gradient;
  final double gradientAngle; // Angle in degrees for Linear Gradient
  final String? backgroundImage;

  final double opacity;
  final EdgeInsets? borderWidth;
  final int borderStyle;
  final List<double>? borderDash;
  final EdgeInsets? borderRadius;

  final int shape;
  final bool isClip;
  final int clipRule;
  final String? clipSvgPath, clipMath;

  final CanvasShadow? shadow;
  final CanvasReflection? mirror;

  final int blendMode;

  BoxDecoration({
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.gradientAngle = 0.0,
    this.backgroundImage,
    this.opacity = 1.0,
    this.borderWidth,
    this.borderStyle = 0,
    this.borderDash,
    this.borderRadius,
    this.shape = 0,
    this.isClip = false,
    this.clipRule = 0,
    this.clipSvgPath,
    this.clipMath,
    this.shadow,
    this.mirror,
    this.blendMode = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (backgroundColor != null) data['bg'] = backgroundColor;
    if (backgroundImage != null) data['bgImg'] = backgroundImage;
    if (opacity != 1.0) data['opacity'] = opacity;
    if (borderColor != null) data['borderColor'] = borderColor;
    if (borderWidth != null) data['borderWidth'] = borderWidth!.toJson();
    if (borderStyle != 0) data['borderStyle'] = borderStyle;
    if (borderDash != null) data['borderDash'] = borderDash;
    if (borderRadius != null) data['radius'] = borderRadius!.toJson();

    if (shape != 0) data['shape'] = shape;
    if (isClip) data['clip'] = isClip;
    if (clipRule != 0) data['clipRule'] = clipRule;
    if (clipSvgPath != null) data['clipSvgPath'] = clipSvgPath;
    if (clipMath != null) data['clipMath'] = clipMath;

    if (shadow != null) data['shadow'] = shadow!.toJson();
    if (mirror != null) data['mirror'] = mirror!.toJson();

    if (gradient != null && gradient!.isNotEmpty) {
      data['gradient'] = gradient;
      if (gradientAngle != 0.0) data['gradientAngle'] = gradientAngle;
    }
    if (blendMode != 0) data['blendMode'] = blendMode;

    return data;
  }
}

// ============================================================================
// 📦 CORE SUPER CONTAINER
// ============================================================================
class SuperContainer {
  final String id;
  final int type;

  final BoxConstraints? constraints;
  final EdgeInsets? margin, padding, marginPercent, paddingPercent;
  final FlexLayout? layout;
  final Position? position;
  final SpanningRules? spanningRules;
  final BoxDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final Typography? typography;
  final String? bookmarkTitle;
  final bool marginAuto;

  final ImageProps? imageProps;
  final SvgProps? svgProps;
  final LottieProps? lottieProps;

  final String? content, linkUrl, fallbackText, semanticTag, rasterMask;
  final FormFieldData? formField;
  final List<SuperContainer>? children;

  SuperContainer({
    required this.id,
    required this.type,
    this.constraints,
    this.margin,
    this.padding,
    this.marginPercent,
    this.paddingPercent,
    this.layout,
    this.position,
    this.spanningRules,
    this.decoration,
    this.transform,
    this.transition,
    this.typography,
    this.bookmarkTitle,
    this.marginAuto = false,
    this.imageProps,
    this.svgProps,
    this.lottieProps,
    this.content,
    this.linkUrl,
    this.fallbackText,
    this.semanticTag,
    this.rasterMask,
    this.formField,
    this.children,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'id': id, 'type': type};

    try {
      if (constraints != null) data['constraints'] = constraints!.toJson();
      if (margin != null) data['margin'] = margin!.toJson();
      if (padding != null) data['padding'] = padding!.toJson();
      if (marginPercent != null) data['marginPct'] = marginPercent!.toJson();
      if (paddingPercent != null) data['paddingPct'] = paddingPercent!.toJson();
      if (layout != null) data['layout'] = layout!.toJson();
      if (position != null) data['position'] = position!.toJson();
      if (spanningRules != null) {
        data['spanningRules'] = spanningRules!.toJson();
      }
      if (decoration != null) data['decoration'] = decoration!.toJson();
      if (transform != null) data['transform'] = transform!.toJson();
      if (transition != null) data['transition'] = transition!.toJson();
      if (typography != null) data['typography'] = typography!.toJson();

      if (bookmarkTitle != null) data['bookmark'] = bookmarkTitle;
      if (marginAuto) data['marginAuto'] = true;

      if (imageProps != null) data['imgProps'] = imageProps!.toJson();
      if (svgProps != null) data['svgProps'] = svgProps!.toJson();
      if (lottieProps != null) data['lottieProps'] = lottieProps!.toJson();

      if (content != null) data['content'] = content;
      if (linkUrl != null) data['linkUrl'] = linkUrl;
      if (fallbackText != null) data['fallbackText'] = fallbackText;
      if (semanticTag != null) data['semanticTag'] = semanticTag;
      if (rasterMask != null) data['rasterMask'] = rasterMask;
      if (formField != null) data['formField'] = formField!.toJson();

      if (children != null) {
        data['children'] = children!.map((c) => c.toJson()).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          "🔴 [DART_DEEP_ERR] Failed generating JSON for SuperContainer ID: $id -> $e",
        );
      }
    }

    return data;
  }

  String toEngineJson() {
    try {
      return jsonEncode(toJson());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          "🔴 [DART_DEEP_ERR] Failed stringifying JSON payload for engine -> $e",
        );
      }
      return "{}";
    }
  }
}
