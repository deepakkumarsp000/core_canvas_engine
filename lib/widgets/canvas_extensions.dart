// FILE: lib/widgets/canvas_extensions.dart
// PURPOSE: Fluent Chaining & Exhaustive Property Updates (Zero Field-Shadowing Conflicts!)

import 'core_widgets.dart';

// ============================================================================
// STRING TO TEXT SHORTHAND
// ============================================================================
extension StringCanvasExt on String {
  /// Example: "Hello".toCanvasText().size(20).bold().textColor(0xFFFF0000).shadow(blur: 15)
  CanvasText toCanvasText() => CanvasText(this);
}

// ============================================================================
// INTERNAL HELPER: Recursive CSS Typography Cascade for Children
// ============================================================================
List<CanvasWidget> _cascadeTypography(
  List<CanvasWidget> children,
  CanvasStyle style,
) {
  final bool hasTypo =
      style.textColor != null ||
      style.fontSize != null ||
      style.fontWeight != null ||
      style.textAlign != null;
  if (!hasTypo || children.isEmpty) return children;

  return children.map((child) {
    if (child is CanvasText) {
      return child.copyWith(
        color: (child.color == 0xFF000000 && style.textColor != null)
            ? style.textColor
            : child.color,
        fontSize: (child.fontSize == 12.0 && style.fontSize != null)
            ? style.fontSize
            : child.fontSize,
        weight: (child.weight == 400 && style.fontWeight != null)
            ? style.fontWeight
            : child.weight,
        align: (child.align == TextAlign.left && style.textAlign != null)
            ? style.textAlign
            : child.align,
      );
    } else if (child is CanvasBox && child.children.isNotEmpty) {
      return child.copyWith(
        children: _cascadeTypography(child.children, style),
      );
    }
    return child;
  }).toList();
}

// ============================================================================
// CANVAS BOX EXTENSIONS
// ============================================================================
extension CanvasBoxExt on CanvasBox {
  CanvasBox copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? aspectRatio,
    double? widthPct,
    double? heightPct,
    double? minWidthPct,
    double? maxWidthPct,
    double? minHeightPct,
    double? maxHeightPct,
    EdgeInsets? padding,
    EdgeInsets? margin,
    EdgeInsets? paddingPct,
    EdgeInsets? marginPct,
    bool? marginAuto,
    FlexDisplay? display,
    FlexDir? direction,
    LayoutDirection? layoutDirection,
    FlexJustify? justifyContent,
    FlexAlign? alignItems,
    FlexAlign? alignContent,
    FlexAlign? alignSelf,
    FlexWrap? wrap,
    double? gap,
    double? rowGap,
    double? colGap,
    double? flexGrow,
    double? flexShrink,
    double? flexBasis,
    double? flexBasisPct,
    bool? isFlexBasisAuto,
    Overflow? overflow,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    SpanningRules? spanningRules,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
    List<CanvasWidget>? children,
  }) {
    return CanvasBox(
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      minWidthPct: minWidthPct ?? this.minWidthPct,
      maxWidthPct: maxWidthPct ?? this.maxWidthPct,
      minHeightPct: minHeightPct ?? this.minHeightPct,
      maxHeightPct: maxHeightPct ?? this.maxHeightPct,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      paddingPct: paddingPct ?? this.paddingPct,
      marginPct: marginPct ?? this.marginPct,
      marginAuto: marginAuto ?? this.marginAuto,
      display: display ?? this.display,
      direction: direction ?? this.direction,
      layoutDirection: layoutDirection ?? this.layoutDirection,
      justifyContent: justifyContent ?? this.justifyContent,
      alignItems: alignItems ?? this.alignItems,
      alignContent: alignContent ?? this.alignContent,
      alignSelf: alignSelf ?? this.alignSelf,
      wrap: wrap ?? this.wrap,
      gap: gap ?? this.gap,
      rowGap: rowGap ?? this.rowGap,
      colGap: colGap ?? this.colGap,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      flexBasis: flexBasis ?? this.flexBasis,
      flexBasisPct: flexBasisPct ?? this.flexBasisPct,
      isFlexBasisAuto: isFlexBasisAuto ?? this.isFlexBasisAuto,
      overflow: overflow ?? this.overflow,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      spanningRules: spanningRules ?? this.spanningRules,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
      children: children ?? this.children,
    );
  }

  /// Applies a reusable [CanvasStyle] and cascades typography defaults to nested [CanvasText] nodes.
  CanvasBox apply(CanvasStyle style) {
    return copyWith(
      padding: style.padding ?? padding,
      margin: style.margin ?? margin,
      children: _cascadeTypography(children, style),
      decoration: CanvasDecoration(
        backgroundColor: style.backgroundColor ?? decoration?.backgroundColor,
        borderColor: style.borderColor ?? decoration?.borderColor,
        borderWidth: style.borderWidth != null
            ? EdgeInsets.all(style.borderWidth!)
            : decoration?.borderWidth,
        borderRadius: style.borderRadius != null
            ? EdgeInsets.all(style.borderRadius!)
            : decoration?.borderRadius,
        borderStyle:
            style.borderStyle ?? decoration?.borderStyle ?? BorderStyle.solid,
        borderDash: style.borderDash ?? decoration?.borderDash,
        opacity: style.opacity ?? decoration?.opacity ?? 1.0,
        blendMode: style.blendMode ?? decoration?.blendMode ?? BlendMode.normal,
        shape: style.shape ?? decoration?.shape ?? BoxShape.rectangle,
        shadow: style.shadowDef ?? decoration?.shadow,
        mirror: style.mirrorDef ?? decoration?.mirror,
        gradient: decoration?.gradient,
        gradientAngle: decoration?.gradientAngle ?? 0.0,
        backgroundImage: decoration?.backgroundImage,
        isClip: decoration?.isClip ?? false,
        clipRule: decoration?.clipRule ?? ClipRule.nonZero,
        clipSvgPath: decoration?.clipSvgPath,
        clipMath: decoration?.clipMath,
      ),
    );
  }

  // Sizing
  CanvasBox w(double val) => copyWith(width: val);
  CanvasBox h(double val) => copyWith(height: val);
  CanvasBox size(double w, double h) => copyWith(width: w, height: h);
  CanvasBox wPct(double val) => copyWith(widthPct: val);
  CanvasBox hPct(double val) => copyWith(heightPct: val);

  // Spacing (Renamed from `gap` to `withGap` to prevent shadowing `CanvasBox.gap`)
  CanvasBox p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasBox m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasBox centerAuto() => copyWith(marginAuto: true);
  CanvasBox withGap(double val) => copyWith(gap: val);

  // Decoration & FX Shorthands
  CanvasBox bg(int color) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithBg(color),
  );
  CanvasBox gradient(List<int> colors, {double angle = 0.0}) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWith(
      gradient: colors,
      gradientAngle: angle,
    ),
  );
  CanvasBox border({
    int color = 0xFF000000,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    List<double>? dash,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWith(
      borderColor: color,
      borderWidth: EdgeInsets.all(width),
      borderStyle: style,
      borderDash: dash,
    ),
  );
  CanvasBox rounded(double rad) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithRadius(rad),
  );
  CanvasBox circle() => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShape(
      BoxShape.circle,
    ),
  );
  CanvasBox clipSvg(String svgPath, {ClipRule rule = ClipRule.nonZero}) =>
      copyWith(
        decoration: (decoration ?? CanvasDecoration()).copyWith(
          isClip: true,
          clipSvgPath: svgPath,
          clipRule: rule,
        ),
      );
  CanvasBox shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double spread = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    bool isDropShadow = true,
    ShadowType type = ShadowType.dropShadow,
    List<int>? gradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShadow(
      CanvasShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offsetX: dx,
        offsetY: dy,
        isDropShadow: isDropShadow,
        shadowType: type.value,
        gradient: gradient,
      ),
    ),
  );
  CanvasBox mirror({
    double distance = 0.0,
    double blur = 0.0,
    double opacity = 0.5,
    FadeDirection fadeDirection = FadeDirection.bottom,
    List<int>? fadeGradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithMirror(
      CanvasReflection(
        distance: distance,
        blurRadius: blur,
        opacity: opacity,
        fadeDirection: fadeDirection.value,
        fadeGradient: fadeGradient,
      ),
    ),
  );
  CanvasBox opacity(double val) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithOpacity(val),
  );
  CanvasBox blend(BlendMode mode) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithBlend(mode),
  );

  // Yoga Layout Shortcuts (Renamed `wrap` -> `flexWrap`, `children` -> `withChildren`)
  CanvasBox row() => copyWith(direction: FlexDir.row);
  CanvasBox col() => copyWith(direction: FlexDir.column);
  CanvasBox center() => copyWith(
    justifyContent: FlexJustify.center,
    alignItems: FlexAlign.center,
  );
  CanvasBox justify(FlexJustify j) => copyWith(justifyContent: j);
  CanvasBox align(FlexAlign a) => copyWith(alignItems: a);
  CanvasBox flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasBox flexWrap([FlexWrap w = FlexWrap.wrap]) => copyWith(wrap: w);
  CanvasBox clipHidden() => copyWith(overflow: Overflow.hidden);
  CanvasBox scroll() => copyWith(overflow: Overflow.scroll);

  // Position Shortcuts
  CanvasBox absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );

  // 2D Affine Transformers & Tweeny Keyframe Animations
  CanvasBox rotate(double degrees) => copyWith(
    transform: TransformMatrix(
      rotateZ: degrees,
      scaleX: transform?.scaleX ?? 1.0,
      scaleY: transform?.scaleY ?? 1.0,
      translateX: transform?.translateX ?? 0.0,
      translateY: transform?.translateY ?? 0.0,
      skewX: transform?.skewX ?? 0.0,
      skewY: transform?.skewY ?? 0.0,
    ),
  );
  CanvasBox scale(double s, [double? sy]) => copyWith(
    transform: TransformMatrix(
      scaleX: s,
      scaleY: sy ?? s,
      rotateZ: transform?.rotateZ ?? 0.0,
      translateX: transform?.translateX ?? 0.0,
      translateY: transform?.translateY ?? 0.0,
      skewX: transform?.skewX ?? 0.0,
      skewY: transform?.skewY ?? 0.0,
    ),
  );
  CanvasBox skew(double skx, [double sky = 0.0]) => copyWith(
    transform: TransformMatrix(
      skewX: skx,
      skewY: sky,
      scaleX: transform?.scaleX ?? 1.0,
      scaleY: transform?.scaleY ?? 1.0,
      rotateZ: transform?.rotateZ ?? 0.0,
      translateX: transform?.translateX ?? 0.0,
      translateY: transform?.translateY ?? 0.0,
    ),
  );
  CanvasBox translate(double tx, double ty) => copyWith(
    transform: TransformMatrix(
      translateX: tx,
      translateY: ty,
      scaleX: transform?.scaleX ?? 1.0,
      scaleY: transform?.scaleY ?? 1.0,
      rotateZ: transform?.rotateZ ?? 0.0,
      skewX: transform?.skewX ?? 0.0,
      skewY: transform?.skewY ?? 0.0,
    ),
  );
  CanvasBox animate(
    int durationMs, {
    int delayMs = 0,
    TimingFunction curve = TimingFunction.easeOutQuad,
    double? fromOpacity,
    double? fromScale,
    double? fromX,
    double? fromY,
    double? fromRotate,
    bool loop = false,
    bool yoyo = false,
  }) => copyWith(
    transition: TransitionProps(
      durationMs: durationMs,
      delayMs: delayMs,
      timingFunction: curve.value,
      fromOpacity: fromOpacity,
      fromScale: fromScale,
      fromX: fromX,
      fromY: fromY,
      fromRotate: fromRotate,
      loop: loop,
      yoyo: yoyo,
    ),
  );

  // PDF Spanning Rules & Meta
  CanvasBox pageBreakBefore() =>
      copyWith(spanningRules: SpanningRules(pageBreakBefore: 1));
  CanvasBox pageBreakAfter() =>
      copyWith(spanningRules: SpanningRules(pageBreakAfter: 1));
  CanvasBox avoidPageBreakInside() =>
      copyWith(spanningRules: SpanningRules(pageBreakInside: 1));
  CanvasBox meta({String? link, String? bookmark, String? semantic}) =>
      copyWith(linkUrl: link, bookmarkTitle: bookmark, semanticTag: semantic);
  CanvasBox withChildren(List<CanvasWidget> widgets) =>
      copyWith(children: widgets);
}

// ============================================================================
// ZERO-LOSS DECORATION CLONER
// ============================================================================
extension CanvasDecoHelper on CanvasDecoration {
  CanvasDecoration copyWith({
    int? backgroundColor,
    int? borderColor,
    List<int>? gradient,
    double? gradientAngle,
    String? backgroundImage,
    double? opacity,
    EdgeInsets? borderWidth,
    EdgeInsets? borderRadius,
    BorderStyle? borderStyle,
    List<double>? borderDash,
    BoxShape? shape,
    bool? isClip,
    ClipRule? clipRule,
    String? clipSvgPath,
    String? clipMath,
    BlendMode? blendMode,
    CanvasShadow? shadow,
    CanvasReflection? mirror,
  }) {
    return CanvasDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      gradient: gradient ?? this.gradient,
      gradientAngle: gradientAngle ?? this.gradientAngle,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      opacity: opacity ?? this.opacity,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      borderStyle: borderStyle ?? this.borderStyle,
      borderDash: borderDash ?? this.borderDash,
      shape: shape ?? this.shape,
      isClip: isClip ?? this.isClip,
      clipRule: clipRule ?? this.clipRule,
      clipSvgPath: clipSvgPath ?? this.clipSvgPath,
      clipMath: clipMath ?? this.clipMath,
      blendMode: blendMode ?? this.blendMode,
      shadow: shadow ?? this.shadow,
      mirror: mirror ?? this.mirror,
    );
  }

  CanvasDecoration copyWithBg(int c) => copyWith(backgroundColor: c);
  CanvasDecoration copyWithRadius(double r) =>
      copyWith(borderRadius: EdgeInsets.all(r));
  CanvasDecoration copyWithShape(BoxShape s) => copyWith(shape: s);
  CanvasDecoration copyWithOpacity(double o) => copyWith(opacity: o);
  CanvasDecoration copyWithBlend(BlendMode b) => copyWith(blendMode: b);
  CanvasDecoration copyWithShadow(CanvasShadow s) => copyWith(shadow: s);
  CanvasDecoration copyWithMirror(CanvasReflection m) => copyWith(mirror: m);
}

// ============================================================================
// CANVAS TEXT EXTENSIONS
// ============================================================================
extension CanvasTextExt on CanvasText {
  CanvasText copyWith({
    String? text,
    String? fontFamily,
    double? fontSize,
    int? color,
    int? weight,
    FontStyle? fontStyle,
    TextAlign? align,
    TextDecoration? textDecoration,
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? widthPct,
    double? heightPct,
    double? flexGrow,
    double? flexShrink,
    FlexDisplay? display,
    double? lineHeight,
    double? letterSpacing,
    double? wordSpacing,
    double? baselineOffset,
    int? maxLines,
    List<TextRun>? runs,
    TextOverflow? textOverflow,
    String? fontVariant,
    String? textRenderMode,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? marginPct,
    EdgeInsets? paddingPct,
    bool? marginAuto,
    FlexAlign? alignSelf,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
    String? rasterMask,
  }) {
    return CanvasText(
      text ?? this.text,
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      display: display ?? this.display,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      weight: weight ?? this.weight,
      fontStyle: fontStyle ?? this.fontStyle,
      align: align ?? this.align,
      textDecoration: textDecoration ?? this.textDecoration,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      baselineOffset: baselineOffset ?? this.baselineOffset,
      maxLines: maxLines ?? this.maxLines,
      runs: runs ?? this.runs,
      textOverflow: textOverflow ?? this.textOverflow,
      fontVariant: fontVariant ?? this.fontVariant,
      textRenderMode: textRenderMode ?? this.textRenderMode,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      marginPct: marginPct ?? this.marginPct,
      paddingPct: paddingPct ?? this.paddingPct,
      marginAuto: marginAuto ?? this.marginAuto,
      alignSelf: alignSelf ?? this.alignSelf,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
      rasterMask: rasterMask ?? this.rasterMask,
    );
  }

  /// Direct Style Application on CanvasText
  CanvasText apply(CanvasStyle style) {
    final bool hasBoxStyle =
        style.backgroundColor != null ||
        style.borderColor != null ||
        style.borderWidth != null ||
        style.borderRadius != null ||
        style.shadowDef != null ||
        style.mirrorDef != null ||
        style.opacity != null ||
        style.blendMode != null;

    return copyWith(
      padding: style.padding ?? padding,
      margin: style.margin ?? margin,
      color: style.textColor ?? color,
      fontSize: style.fontSize ?? fontSize,
      weight: style.fontWeight ?? weight,
      align: style.textAlign ?? align,
      decoration: hasBoxStyle || decoration != null
          ? CanvasDecoration(
              backgroundColor:
                  style.backgroundColor ?? decoration?.backgroundColor,
              borderColor: style.borderColor ?? decoration?.borderColor,
              borderWidth: style.borderWidth != null
                  ? EdgeInsets.all(style.borderWidth!)
                  : decoration?.borderWidth,
              borderRadius: style.borderRadius != null
                  ? EdgeInsets.all(style.borderRadius!)
                  : decoration?.borderRadius,
              borderStyle:
                  style.borderStyle ??
                  decoration?.borderStyle ??
                  BorderStyle.solid,
              borderDash: style.borderDash ?? decoration?.borderDash,
              opacity: style.opacity ?? decoration?.opacity ?? 1.0,
              blendMode:
                  style.blendMode ?? decoration?.blendMode ?? BlendMode.normal,
              shape: style.shape ?? decoration?.shape ?? BoxShape.rectangle,
              shadow: style.shadowDef ?? decoration?.shadow,
              mirror: style.mirrorDef ?? decoration?.mirror,
              gradient: decoration?.gradient,
              gradientAngle: decoration?.gradientAngle ?? 0.0,
              backgroundImage: decoration?.backgroundImage,
              isClip: decoration?.isClip ?? false,
              clipRule: decoration?.clipRule ?? ClipRule.nonZero,
              clipSvgPath: decoration?.clipSvgPath,
              clipMath: decoration?.clipMath,
            )
          : null,
    );
  }

  // Universal Shorthands
  CanvasText w(double val) => copyWith(width: val);
  CanvasText h(double val) => copyWith(height: val);
  CanvasText wPct(double val) => copyWith(widthPct: val);
  CanvasText hPct(double val) => copyWith(heightPct: val);
  CanvasText p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasText m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasText centerAuto() => copyWith(marginAuto: true);
  CanvasText flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasText absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );

  // Typography Shorthands (Uses `textColor` so it never shadows `CanvasText.color` field!)
  CanvasText font(String family) => copyWith(fontFamily: family);
  CanvasText textColor(int c) => copyWith(color: c);
  CanvasText size(double s) => copyWith(fontSize: s);
  CanvasText bold([int w = 700]) => copyWith(weight: w);
  CanvasText italic() => copyWith(fontStyle: FontStyle.italic);
  CanvasText underline() => copyWith(textDecoration: TextDecoration.underline);
  CanvasText strike() => copyWith(textDecoration: TextDecoration.lineThrough);
  CanvasText overline() => copyWith(textDecoration: TextDecoration.overline);
  CanvasText alignText(TextAlign tAlign) => copyWith(align: tAlign);
  CanvasText center() => copyWith(align: TextAlign.center);
  CanvasText ellipsis([int? max]) =>
      copyWith(textOverflow: TextOverflow.ellipsis, maxLines: max ?? maxLines);

  /// Fluent RichText Span Builder.
  CanvasText span(
    String spanText, {
    int? color,
    double? size,
    int? weight,
    FontStyle? style,
    double dx = 0.0,
    double dy = 0.0,
  }) {
    final List<TextRun> updatedRuns = List<TextRun>.from(runs ?? const []);
    updatedRuns.add(
      TextRun(spanText, dx, dy, color, size, weight, style?.value),
    );
    return copyWith(runs: updatedRuns);
  }

  // Transform & Tweeny Animation Shorthands on Text
  CanvasText rotate(double degrees) =>
      copyWith(transform: TransformMatrix(rotateZ: degrees));
  CanvasText scale(double s, [double? sy]) => copyWith(
    transform: TransformMatrix(scaleX: s, scaleY: sy ?? s),
  );
  CanvasText animate(
    int durationMs, {
    int delayMs = 0,
    TimingFunction curve = TimingFunction.easeOutQuad,
    double? fromOpacity,
    double? fromScale,
    double? fromX,
    double? fromY,
    double? fromRotate,
    bool loop = false,
    bool yoyo = false,
  }) => copyWith(
    transition: TransitionProps(
      durationMs: durationMs,
      delayMs: delayMs,
      timingFunction: curve.value,
      fromOpacity: fromOpacity,
      fromScale: fromScale,
      fromX: fromX,
      fromY: fromY,
      fromRotate: fromRotate,
      loop: loop,
      yoyo: yoyo,
    ),
  );

  // Direct Shadow & Mirror Chaining on Text
  CanvasText shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double spread = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    ShadowType type = ShadowType.dropShadow,
    List<int>? gradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShadow(
      CanvasShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offsetX: dx,
        offsetY: dy,
        shadowType: type.value,
        gradient: gradient,
      ),
    ),
  );

  CanvasText mirror({
    double distance = 2.0,
    double blur = 4.0,
    double opacity = 0.5,
    FadeDirection fadeDirection = FadeDirection.bottom,
    List<int>? fadeGradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithMirror(
      CanvasReflection(
        distance: distance,
        blurRadius: blur,
        opacity: opacity,
        fadeDirection: fadeDirection.value,
        fadeGradient: fadeGradient,
      ),
    ),
  );
}

// ============================================================================
// CANVAS IMAGE EXTENSIONS
// ============================================================================
extension CanvasImageExt on CanvasImage {
  CanvasImage copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? widthPct,
    double? heightPct,
    double? aspectRatio,
    double? flexGrow,
    double? flexShrink,
    FlexDisplay? display,
    ImageFit? fit,
    ImageAlignment? imageAlignment,
    int? dpi,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? marginPct,
    EdgeInsets? paddingPct,
    bool? marginAuto,
    FlexAlign? alignSelf,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
  }) {
    return CanvasImage(
      base64Data: base64Data,
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      display: display ?? this.display,
      fit: fit ?? this.fit,
      imageAlignment: imageAlignment ?? this.imageAlignment,
      dpi: dpi ?? this.dpi,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      marginPct: marginPct ?? this.marginPct,
      paddingPct: paddingPct ?? this.paddingPct,
      marginAuto: marginAuto ?? this.marginAuto,
      alignSelf: alignSelf ?? this.alignSelf,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
    );
  }

  CanvasImage w(double val) => copyWith(width: val);
  CanvasImage h(double val) => copyWith(height: val);
  CanvasImage wPct(double val) => copyWith(widthPct: val);
  CanvasImage hPct(double val) => copyWith(heightPct: val);
  CanvasImage p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasImage m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasImage centerAuto() => copyWith(marginAuto: true);
  CanvasImage flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasImage absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );
  CanvasImage objectFit(ImageFit f) => copyWith(fit: f);
  CanvasImage alignImage(ImageAlignment a) => copyWith(imageAlignment: a);
  CanvasImage rounded(double rad) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithRadius(rad),
  );
  CanvasImage circle() => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShape(
      BoxShape.circle,
    ),
  );
  CanvasImage rotate(double degrees) =>
      copyWith(transform: TransformMatrix(rotateZ: degrees));
  CanvasImage scale(double s, [double? sy]) => copyWith(
    transform: TransformMatrix(scaleX: s, scaleY: sy ?? s),
  );
  CanvasImage animate(
    int durationMs, {
    int delayMs = 0,
    TimingFunction curve = TimingFunction.easeOutQuad,
    double? fromOpacity,
    double? fromScale,
    double? fromX,
    double? fromY,
    double? fromRotate,
    bool loop = false,
    bool yoyo = false,
  }) => copyWith(
    transition: TransitionProps(
      durationMs: durationMs,
      delayMs: delayMs,
      timingFunction: curve.value,
      fromOpacity: fromOpacity,
      fromScale: fromScale,
      fromX: fromX,
      fromY: fromY,
      fromRotate: fromRotate,
      loop: loop,
      yoyo: yoyo,
    ),
  );
  CanvasImage shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double spread = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    ShadowType type = ShadowType.dropShadow,
    List<int>? gradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShadow(
      CanvasShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offsetX: dx,
        offsetY: dy,
        shadowType: type.value,
        gradient: gradient,
      ),
    ),
  );
  CanvasImage mirror({
    double distance = 0.0,
    double blur = 0.0,
    double opacity = 0.5,
    FadeDirection fadeDirection = FadeDirection.bottom,
    List<int>? fadeGradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithMirror(
      CanvasReflection(
        distance: distance,
        blurRadius: blur,
        opacity: opacity,
        fadeDirection: fadeDirection.value,
        fadeGradient: fadeGradient,
      ),
    ),
  );
}

// ============================================================================
// CANVAS SVG EXTENSIONS
// ============================================================================
extension CanvasSvgExt on CanvasSvg {
  CanvasSvg copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? widthPct,
    double? heightPct,
    double? aspectRatio,
    double? flexGrow,
    double? flexShrink,
    FlexDisplay? display,
    String? viewBox,
    int? fill,
    int? stroke,
    double? strokeWidth,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? marginPct,
    EdgeInsets? paddingPct,
    bool? marginAuto,
    FlexAlign? alignSelf,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
  }) {
    return CanvasSvg(
      svgXml: svgXml,
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      display: display ?? this.display,
      viewBox: viewBox ?? this.viewBox,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeJoin: strokeJoin ?? this.strokeJoin,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      marginPct: marginPct ?? this.marginPct,
      paddingPct: paddingPct ?? this.paddingPct,
      marginAuto: marginAuto ?? this.marginAuto,
      alignSelf: alignSelf ?? this.alignSelf,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
    );
  }

  CanvasSvg w(double val) => copyWith(width: val);
  CanvasSvg h(double val) => copyWith(height: val);
  CanvasSvg wPct(double val) => copyWith(widthPct: val);
  CanvasSvg hPct(double val) => copyWith(heightPct: val);
  CanvasSvg p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasSvg m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasSvg centerAuto() => copyWith(marginAuto: true);
  CanvasSvg flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasSvg absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );
  CanvasSvg fillColor(int c) => copyWith(fill: c);
  CanvasSvg strokeColor(int c, [double width = 2.0]) =>
      copyWith(stroke: c, strokeWidth: width);
  CanvasSvg rotate(double degrees) =>
      copyWith(transform: TransformMatrix(rotateZ: degrees));
  CanvasSvg scale(double s, [double? sy]) => copyWith(
    transform: TransformMatrix(scaleX: s, scaleY: sy ?? s),
  );
  CanvasSvg animate(
    int durationMs, {
    int delayMs = 0,
    TimingFunction curve = TimingFunction.easeOutQuad,
    double? fromOpacity,
    double? fromScale,
    double? fromX,
    double? fromY,
    double? fromRotate,
    bool loop = false,
    bool yoyo = false,
  }) => copyWith(
    transition: TransitionProps(
      durationMs: durationMs,
      delayMs: delayMs,
      timingFunction: curve.value,
      fromOpacity: fromOpacity,
      fromScale: fromScale,
      fromX: fromX,
      fromY: fromY,
      fromRotate: fromRotate,
      loop: loop,
      yoyo: yoyo,
    ),
  );
  CanvasSvg shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double spread = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    ShadowType type = ShadowType.dropShadow,
    List<int>? gradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShadow(
      CanvasShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offsetX: dx,
        offsetY: dy,
        shadowType: type.value,
        gradient: gradient,
      ),
    ),
  );
  CanvasSvg mirror({
    double distance = 0.0,
    double blur = 0.0,
    double opacity = 0.5,
    FadeDirection fadeDirection = FadeDirection.bottom,
    List<int>? fadeGradient,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithMirror(
      CanvasReflection(
        distance: distance,
        blurRadius: blur,
        opacity: opacity,
        fadeDirection: fadeDirection.value,
        fadeGradient: fadeGradient,
      ),
    ),
  );
}

// ============================================================================
// CANVAS LOTTIE EXTENSIONS
// ============================================================================
extension CanvasLottieExt on CanvasLottie {
  CanvasLottie copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? widthPct,
    double? heightPct,
    double? aspectRatio,
    double? flexGrow,
    double? flexShrink,
    FlexDisplay? display,
    double? speed,
    bool? autoplay,
    bool? loop,
    int? fps,
    int? initialFrame,
    int? endFrame,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? marginPct,
    EdgeInsets? paddingPct,
    bool? marginAuto,
    FlexAlign? alignSelf,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
  }) {
    return CanvasLottie(
      lottieJson: lottieJson,
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      display: display ?? this.display,
      autoplay: autoplay ?? this.autoplay,
      loop: loop ?? this.loop,
      speed: speed ?? this.speed,
      fps: fps ?? this.fps,
      initialFrame: initialFrame ?? this.initialFrame,
      endFrame: endFrame ?? this.endFrame,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      marginPct: marginPct ?? this.marginPct,
      paddingPct: paddingPct ?? this.paddingPct,
      marginAuto: marginAuto ?? this.marginAuto,
      alignSelf: alignSelf ?? this.alignSelf,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
    );
  }

  CanvasLottie w(double val) => copyWith(width: val);
  CanvasLottie h(double val) => copyWith(height: val);
  CanvasLottie wPct(double val) => copyWith(widthPct: val);
  CanvasLottie hPct(double val) => copyWith(heightPct: val);
  CanvasLottie p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasLottie m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasLottie centerAuto() => copyWith(marginAuto: true);
  CanvasLottie flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasLottie absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );
  CanvasLottie speedMultiplier(double s) => copyWith(speed: s);
  CanvasLottie frame(int start, [int? end]) =>
      copyWith(initialFrame: start, endFrame: end);
  CanvasLottie fpsCount(int f) => copyWith(fps: f);
  CanvasLottie rotate(double degrees) =>
      copyWith(transform: TransformMatrix(rotateZ: degrees));
  CanvasLottie scale(double s, [double? sy]) => copyWith(
    transform: TransformMatrix(scaleX: s, scaleY: sy ?? s),
  );
  CanvasLottie animate(
    int durationMs, {
    int delayMs = 0,
    TimingFunction curve = TimingFunction.easeOutQuad,
    double? fromOpacity,
    double? fromScale,
    double? fromX,
    double? fromY,
    double? fromRotate,
    bool loop = false,
    bool yoyo = false,
  }) => copyWith(
    transition: TransitionProps(
      durationMs: durationMs,
      delayMs: delayMs,
      timingFunction: curve.value,
      fromOpacity: fromOpacity,
      fromScale: fromScale,
      fromX: fromX,
      fromY: fromY,
      fromRotate: fromRotate,
      loop: loop,
      yoyo: yoyo,
    ),
  );
  CanvasLottie shadow({
    int color = 0xFF000000,
    double blur = 10.0,
    double spread = 0.0,
    double dx = 0.0,
    double dy = 0.0,
    ShadowType type = ShadowType.dropShadow,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithShadow(
      CanvasShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offsetX: dx,
        offsetY: dy,
        shadowType: type.value,
      ),
    ),
  );
  CanvasLottie mirror({
    double distance = 0.0,
    double blur = 0.0,
    double opacity = 0.5,
    FadeDirection fadeDirection = FadeDirection.bottom,
  }) => copyWith(
    decoration: (decoration ?? CanvasDecoration()).copyWithMirror(
      CanvasReflection(
        distance: distance,
        blurRadius: blur,
        opacity: opacity,
        fadeDirection: fadeDirection.value,
      ),
    ),
  );
}

// ============================================================================
// CANVAS FORM EXTENSIONS
// ============================================================================
extension CanvasFormExt on CanvasForm {
  CanvasForm copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? widthPct,
    double? heightPct,
    double? aspectRatio,
    double? flexGrow,
    double? flexShrink,
    FlexDisplay? display,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? marginPct,
    EdgeInsets? paddingPct,
    bool? marginAuto,
    FlexAlign? alignSelf,
    PosType? posType,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? topPct,
    double? rightPct,
    double? bottomPct,
    double? leftPct,
    int? zIndex,
    CanvasDecoration? decoration,
    TransformMatrix? transform,
    TransitionProps? transition,
    Typography? typography,
    String? linkUrl,
    String? bookmarkTitle,
    String? semanticTag,
    String? fallbackText,
  }) {
    return CanvasForm(
      name: name,
      fieldType: fieldType,
      value: value,
      id: id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      widthPct: widthPct ?? this.widthPct,
      heightPct: heightPct ?? this.heightPct,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      flexGrow: flexGrow ?? this.flexGrow,
      flexShrink: flexShrink ?? this.flexShrink,
      display: display ?? this.display,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      marginPct: marginPct ?? this.marginPct,
      paddingPct: paddingPct ?? this.paddingPct,
      marginAuto: marginAuto ?? this.marginAuto,
      alignSelf: alignSelf ?? this.alignSelf,
      posType: posType ?? this.posType,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      topPct: topPct ?? this.topPct,
      rightPct: rightPct ?? this.rightPct,
      bottomPct: bottomPct ?? this.bottomPct,
      leftPct: leftPct ?? this.leftPct,
      zIndex: zIndex ?? this.zIndex,
      decoration: decoration ?? this.decoration,
      transform: transform ?? this.transform,
      transition: transition ?? this.transition,
      typography: typography ?? this.typography,
      linkUrl: linkUrl ?? this.linkUrl,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      semanticTag: semanticTag ?? this.semanticTag,
      fallbackText: fallbackText ?? this.fallbackText,
    );
  }

  CanvasForm w(double val) => copyWith(width: val);
  CanvasForm h(double val) => copyWith(height: val);
  CanvasForm wPct(double val) => copyWith(widthPct: val);
  CanvasForm hPct(double val) => copyWith(heightPct: val);
  CanvasForm p(double val) => copyWith(padding: EdgeInsets.all(val));
  CanvasForm m(double val) => copyWith(margin: EdgeInsets.all(val));
  CanvasForm centerAuto() => copyWith(marginAuto: true);
  CanvasForm flex(double grow, [double shrink = 1.0]) =>
      copyWith(flexGrow: grow, flexShrink: shrink);
  CanvasForm absolute({double? t, double? r, double? b, double? l, int? z}) =>
      copyWith(
        posType: PosType.absolute,
        top: t,
        right: r,
        bottom: b,
        left: l,
        zIndex: z,
      );
}

// ============================================================================
// CANVAS DOCUMENT EXTENSIONS (Multi-Format & ColorSpace Fluent Switchers)
// ============================================================================
extension CanvasDocumentExt on CanvasDocument {
  CanvasDocument copyWith({
    CanvasWidget? body,
    CanvasWidget? header,
    CanvasWidget? footer,
    Map<String, String>? customFonts,
    Typography? defaultTypography,
    CanvasFormat? format,
    EdgeInsets? canvasMargin,
    TargetFormat? targetFormat,
    LayoutDirection? layoutDirection,
    double? scaleFactor,
    int? dpi,
    ColorSpace? colorSpace,
    int? exportQuality,
    bool? lossless,
    String? title,
    String? author,
    String? subject,
    String? keywords,
    String? creator,
    String? producer,
    String? creationDate,
    bool? hideToolbar,
    bool? hideMenubar,
    bool? fitWindow,
    PdfPageMode? pageMode,
    PdfPageLayout? pageLayout,
  }) {
    return CanvasDocument(
      body: body ?? this.body,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      customFonts: customFonts ?? this.customFonts,
      defaultTypography: defaultTypography ?? this.defaultTypography,
      format: format ?? this.format,
      canvasMargin: canvasMargin ?? this.canvasMargin,
      targetFormat: targetFormat ?? this.targetFormat,
      layoutDirection: layoutDirection ?? this.layoutDirection,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      dpi: dpi ?? this.dpi,
      colorSpace: colorSpace ?? this.colorSpace,
      exportQuality: exportQuality ?? this.exportQuality,
      lossless: lossless ?? this.lossless,
      title: title ?? this.title,
      author: author ?? this.author,
      subject: subject ?? this.subject,
      keywords: keywords ?? this.keywords,
      creator: creator ?? this.creator,
      producer: producer ?? this.producer,
      creationDate: creationDate ?? this.creationDate,
      hideToolbar: hideToolbar ?? this.hideToolbar,
      hideMenubar: hideMenubar ?? this.hideMenubar,
      fitWindow: fitWindow ?? this.fitWindow,
      pageMode: pageMode ?? this.pageMode,
      pageLayout: pageLayout ?? this.pageLayout,
    );
  }

  CanvasDocument quality(int q) => copyWith(exportQuality: q);
  CanvasDocument asPdf() => copyWith(targetFormat: TargetFormat.pdf);
  CanvasDocument asPng() => copyWith(targetFormat: TargetFormat.png);
  CanvasDocument asJpg({int quality = 95}) =>
      copyWith(targetFormat: TargetFormat.jpg, exportQuality: quality);
  CanvasDocument asWebp({int quality = 90, bool lossless = false}) => copyWith(
    targetFormat: TargetFormat.webp,
    exportQuality: quality,
    lossless: lossless,
  );
  CanvasDocument asHtml() => copyWith(targetFormat: TargetFormat.html);
  CanvasDocument asGif() => copyWith(targetFormat: TargetFormat.gif);
  CanvasDocument grayscale() => copyWith(colorSpace: ColorSpace.grayscale);
  CanvasDocument cmyk() => copyWith(colorSpace: ColorSpace.cmyk);
}
