// FILE: lib/widgets/core_widgets.dart
// PURPOSE: Declarative Canvas DSL + Barrel Exports for Core Canvas Engine.
// Maps 100% of widget properties to SuperContainer with zero data loss.

import '../models/super_container.dart';
import '../models/engine_config.dart';
import 'canvas_enums.dart';

// Re-export full public API so importing either `core_canvas_engine.dart`
// or `core_widgets.dart` provides single-import access.
export '../ffi/canvas_bindings.g.dart';
export '../ffi/engine_bridge.dart';
export '../models/canvas_result.dart';
export '../models/engine_config.dart';
export '../models/super_container.dart';
export 'canvas_enums.dart';
export 'canvas_style.dart';
export 'canvas_extensions.dart';
export 'macro_widgets.dart';

/// Base contract implemented by all declarative Core Canvas widgets.
abstract class CanvasWidget {
  SuperContainer build();
}

// ============================================================================
// REUSABLE DSL DECORATION MODIFIER
// ============================================================================
class CanvasDecoration {
  final int? backgroundColor, borderColor;
  final List<int>? gradient;
  final double gradientAngle;
  final String? backgroundImage;
  final double opacity;
  final EdgeInsets? borderWidth, borderRadius;
  final BorderStyle borderStyle;
  final List<double>? borderDash;
  final BoxShape shape;
  final bool isClip;
  final ClipRule clipRule;
  final String? clipSvgPath, clipMath;
  final BlendMode blendMode;
  final CanvasShadow? shadow;
  final CanvasReflection? mirror;

  CanvasDecoration({
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.gradientAngle = 0.0,
    this.backgroundImage,
    this.opacity = 1.0,
    this.borderWidth,
    this.borderRadius,
    this.borderStyle = BorderStyle.solid,
    this.borderDash,
    this.shape = BoxShape.rectangle,
    this.isClip = false,
    this.clipRule = ClipRule.nonZero,
    this.clipSvgPath,
    this.clipMath,
    this.blendMode = BlendMode.normal,
    this.shadow,
    this.mirror,
  });

  BoxDecoration toModel() => BoxDecoration(
    backgroundColor: backgroundColor,
    borderColor: borderColor,
    gradient: gradient,
    gradientAngle: gradientAngle,
    backgroundImage: backgroundImage,
    opacity: opacity,
    borderWidth: borderWidth,
    borderRadius: borderRadius,
    borderStyle: borderStyle.value,
    borderDash: borderDash,
    shape: shape.value,
    isClip: isClip,
    clipRule: clipRule.value,
    clipSvgPath: clipSvgPath,
    clipMath: clipMath,
    blendMode: blendMode.value,
    shadow: shadow,
    mirror: mirror,
  );
}

// ============================================================================
// DOCUMENT ROOT
// ============================================================================
class CanvasDocument {
  final CanvasFormat format;
  final EdgeInsets? canvasMargin;
  final TargetFormat targetFormat;
  final LayoutDirection layoutDirection;
  final double scaleFactor;
  final int dpi;
  final ColorSpace colorSpace;
  final int exportQuality;
  final bool lossless;

  final String? title,
      author,
      subject,
      keywords,
      creator,
      producer,
      creationDate;

  final bool hideToolbar, hideMenubar, fitWindow;
  final PdfPageMode pageMode;
  final PdfPageLayout pageLayout;

  final CanvasWidget body;
  final CanvasWidget? header, footer;
  final Map<String, String>? customFonts;
  final Typography? defaultTypography;

  CanvasDocument({
    required this.body,
    this.header,
    this.footer,
    this.customFonts,
    this.defaultTypography,
    this.format = CanvasFormat.a4,
    this.canvasMargin,
    this.targetFormat = TargetFormat.pdf,
    this.layoutDirection = LayoutDirection.inherit,
    this.scaleFactor = 1.0,
    this.dpi = 72,
    this.colorSpace = ColorSpace.rgb,
    this.exportQuality = 100,
    this.lossless = false,
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator = 'Core Canvas Engine',
    this.producer = 'Core Canvas Native C++ Engine',
    this.creationDate,
    this.hideToolbar = false,
    this.hideMenubar = false,
    this.fitWindow = false,
    this.pageMode = PdfPageMode.useNone,
    this.pageLayout = PdfPageLayout.singlePage,
  });

  CoreDocument buildDocument() {
    return CoreDocument(
      config: CanvasConfig(
        format: format,
        canvasMargin: canvasMargin,
        targetFormat: targetFormat.value,
        layoutDirection: layoutDirection.value,
        scaleFactor: scaleFactor,
        dpi: dpi,
        colorSpace: colorSpace.value,
        exportQuality: exportQuality,
        lossless: lossless,
      ),
      info: DocumentInfo(
        title: title,
        author: author,
        subject: subject,
        keywords: keywords,
        creator: creator,
        producer: producer,
        creationDate: creationDate,
        viewerPrefs: ViewerPreferences(
          hideToolbar: hideToolbar,
          hideMenubar: hideMenubar,
          fitWindow: fitWindow,
          pageMode: pageMode.value,
          pageLayout: pageLayout.value,
        ),
      ),
      header: header?.build(),
      footer: footer?.build(),
      body: body.build(),
      fonts: customFonts,
      defaultTypography: defaultTypography,
    );
  }

  /// Direct AST Map representation for zero-double-decode mask injection.
  Map<String, dynamic> toJsonMap() => buildDocument().toJson();

  /// Encoded JSON payload string compatible with the native C++ engine.
  String toJsonPayload() => buildDocument().toEngineJson();
}

// ============================================================================
// CANVAS BOX (Type 0)
// ============================================================================
class CanvasBox extends CanvasWidget {
  final String id;

  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPct,
      heightPct,
      minWidthPct,
      maxWidthPct,
      minHeightPct,
      maxHeightPct;

  final EdgeInsets? padding, margin, paddingPct, marginPct;
  final bool marginAuto;
  final FlexDisplay display;
  final FlexDir direction;
  final LayoutDirection layoutDirection;
  final FlexJustify justifyContent;
  final FlexAlign alignItems, alignContent, alignSelf;
  final FlexWrap wrap;
  final double gap, rowGap, colGap, flexGrow, flexShrink;
  final double? flexBasis, flexBasisPct;
  final bool isFlexBasisAuto;
  final Overflow overflow;

  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;

  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final SpanningRules? spanningRules;

  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText;
  final List<CanvasWidget> children;

  CanvasBox({
    this.id = 'box',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPct,
    this.heightPct,
    this.minWidthPct,
    this.maxWidthPct,
    this.minHeightPct,
    this.maxHeightPct,
    this.padding,
    this.margin,
    this.paddingPct,
    this.marginPct,
    this.marginAuto = false,
    this.display = FlexDisplay.flex,
    this.direction = FlexDir.column,
    this.layoutDirection = LayoutDirection.inherit,
    this.justifyContent = FlexJustify.start,
    this.alignItems = FlexAlign.auto,
    this.alignContent = FlexAlign.auto,
    this.alignSelf = FlexAlign.auto,
    this.wrap = FlexWrap.noWrap,
    this.gap = 0.0,
    this.rowGap = 0.0,
    this.colGap = 0.0,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.flexBasis,
    this.flexBasisPct,
    this.isFlexBasisAuto = false,
    this.overflow = Overflow.visible,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.spanningRules,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
    this.children = const [],
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.container.value,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        widthPercent: widthPct,
        heightPercent: heightPct,
        minWidthPercent: minWidthPct,
        maxWidthPercent: maxWidthPct,
        minHeightPercent: minHeightPct,
        maxHeightPercent: maxHeightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      layout: FlexLayout(
        display: display.value,
        direction: direction.value,
        layoutDirection: layoutDirection.value,
        justifyContent: justifyContent.value,
        alignItems: alignItems.value,
        alignContent: alignContent.value,
        alignSelf: alignSelf.value,
        wrap: wrap.value,
        gap: gap,
        rowGap: rowGap,
        columnGap: colGap,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
        flexBasis: flexBasis,
        flexBasisPercent: flexBasisPct,
        isFlexBasisAuto: isFlexBasisAuto,
        overflow: overflow.value,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      spanningRules: spanningRules,
      children: children.map((c) => c.build()).toList(),
    );
  }
}

// ============================================================================
// CANVAS TEXT (Type 1)
// ============================================================================
class CanvasText extends CanvasWidget {
  final String id, text;

  final double? width, height, minWidth, maxWidth, minHeight, maxHeight;
  final double? widthPct, heightPct;
  final double flexGrow, flexShrink;
  final FlexDisplay display;

  final String? fontFamily;
  final double fontSize;
  final int color, weight;
  final FontStyle fontStyle;
  final TextAlign align;
  final TextDecoration textDecoration;
  final double lineHeight, letterSpacing, wordSpacing, baselineOffset;
  final int? maxLines;
  final List<TextRun>? runs;
  final TextOverflow textOverflow;
  final String fontVariant, textRenderMode;

  final EdgeInsets? margin, padding, marginPct, paddingPct;
  final bool marginAuto;
  final FlexAlign alignSelf;
  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;
  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText, rasterMask;

  CanvasText(
    this.text, {
    this.id = 'text_node',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.widthPct,
    this.heightPct,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.display = FlexDisplay.flex,
    this.fontFamily,
    this.fontSize = 12.0,
    this.color = 0xFF000000,
    this.weight = 400,
    this.fontStyle = FontStyle.normal,
    this.align = TextAlign.left,
    this.textDecoration = TextDecoration.none,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
    this.baselineOffset = 0.0,
    this.maxLines,
    this.runs,
    this.textOverflow = TextOverflow.clip,
    this.fontVariant = 'normal',
    this.textRenderMode = 'fill',
    this.margin,
    this.padding,
    this.marginPct,
    this.paddingPct,
    this.marginAuto = false,
    this.alignSelf = FlexAlign.auto,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
    this.rasterMask,
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.text.value,
      content: text,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        widthPercent: widthPct,
        heightPercent: heightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      rasterMask: rasterMask,
      layout: FlexLayout(
        display: display.value,
        alignSelf: alignSelf.value,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      typography: Typography(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        weight: weight,
        style: fontStyle.value,
        align: align.value,
        decoration: textDecoration.value,
        textOverflow: textOverflow.value,
        fontVariant: fontVariant,
        textRenderMode: textRenderMode,
        lineHeight: lineHeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        baselineOffset: baselineOffset,
        maxLines: maxLines,
        runs: runs,
      ),
    );
  }
}

// ============================================================================
// CANVAS IMAGE (Type 2)
// ============================================================================
class CanvasImage extends CanvasWidget {
  final String id, base64Data;
  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPct, heightPct;
  final double flexGrow, flexShrink;
  final FlexDisplay display;
  final ImageFit fit;
  final ImageAlignment imageAlignment;
  final int? dpi;

  final EdgeInsets? margin, padding, marginPct, paddingPct;
  final bool marginAuto;
  final FlexAlign alignSelf;
  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;
  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText;

  CanvasImage({
    required this.base64Data,
    this.id = 'image_node',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPct,
    this.heightPct,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.display = FlexDisplay.flex,
    this.fit = ImageFit.cover,
    this.imageAlignment = ImageAlignment.center,
    this.dpi,
    this.margin,
    this.padding,
    this.marginPct,
    this.paddingPct,
    this.marginAuto = false,
    this.alignSelf = FlexAlign.auto,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.image.value,
      content: base64Data,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        widthPercent: widthPct,
        heightPercent: heightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      layout: FlexLayout(
        display: display.value,
        alignSelf: alignSelf.value,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      imageProps: ImageProps(
        fit: fit.value,
        alignment: imageAlignment.value,
        dpi: dpi,
      ),
    );
  }
}

// ============================================================================
// CANVAS SVG (Type 3)
// ============================================================================
class CanvasSvg extends CanvasWidget {
  final String id, svgXml;
  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPct, heightPct;
  final double flexGrow, flexShrink;
  final FlexDisplay display;
  final String? viewBox;
  final int? fill, stroke;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;

  final EdgeInsets? margin, padding, marginPct, paddingPct;
  final bool marginAuto;
  final FlexAlign alignSelf;
  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;
  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText;

  CanvasSvg({
    required this.svgXml,
    this.id = 'svg_node',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPct,
    this.heightPct,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.display = FlexDisplay.flex,
    this.viewBox,
    this.fill,
    this.stroke,
    this.strokeWidth = 0.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.margin,
    this.padding,
    this.marginPct,
    this.paddingPct,
    this.marginAuto = false,
    this.alignSelf = FlexAlign.auto,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.svg.value,
      content: svgXml,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        widthPercent: widthPct,
        heightPercent: heightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      layout: FlexLayout(
        display: display.value,
        alignSelf: alignSelf.value,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      svgProps: SvgProps(
        viewBox: viewBox,
        fill: fill,
        stroke: stroke,
        strokeWidth: strokeWidth,
        strokeCap: strokeCap.value,
        strokeJoin: strokeJoin.value,
      ),
    );
  }
}

// ============================================================================
// CANVAS LOTTIE (Type 4)
// ============================================================================
class CanvasLottie extends CanvasWidget {
  final String id, lottieJson;
  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPct, heightPct;
  final double flexGrow, flexShrink;
  final FlexDisplay display;
  final bool autoplay, loop;
  final double speed;
  final int? fps, initialFrame, endFrame;

  final EdgeInsets? margin, padding, marginPct, paddingPct;
  final bool marginAuto;
  final FlexAlign alignSelf;
  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;
  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText;

  CanvasLottie({
    required this.lottieJson,
    this.id = 'lottie_node',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPct,
    this.heightPct,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.display = FlexDisplay.flex,
    this.autoplay = true,
    this.loop = true,
    this.speed = 1.0,
    this.fps,
    this.initialFrame = 0,
    this.endFrame,
    this.margin,
    this.padding,
    this.marginPct,
    this.paddingPct,
    this.marginAuto = false,
    this.alignSelf = FlexAlign.auto,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.lottie.value,
      content: lottieJson,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        widthPercent: widthPct,
        heightPercent: heightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      layout: FlexLayout(
        display: display.value,
        alignSelf: alignSelf.value,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      lottieProps: LottieProps(
        autoplay: autoplay,
        loop: loop,
        speed: speed,
        fps: fps,
        initialFrame: initialFrame,
        endFrame: endFrame,
      ),
    );
  }
}

// ============================================================================
// CANVAS FORM FIELD (AcroForms)
// ============================================================================
class CanvasForm extends CanvasWidget {
  final String id, name, value;
  final FormFieldType fieldType;

  final double? width,
      height,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
      aspectRatio;
  final double? widthPct, heightPct;
  final double flexGrow, flexShrink;
  final FlexDisplay display;
  final EdgeInsets? margin, padding, marginPct, paddingPct;
  final bool marginAuto;
  final FlexAlign alignSelf;
  final PosType posType;
  final double? top, right, bottom, left, topPct, rightPct, bottomPct, leftPct;
  final int zIndex;
  final CanvasDecoration? decoration;
  final TransformMatrix? transform;
  final TransitionProps? transition;
  final Typography? typography;
  final String? linkUrl, bookmarkTitle, semanticTag, fallbackText;

  CanvasForm({
    required this.name,
    required this.fieldType,
    this.value = '',
    this.id = 'form_node',
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.aspectRatio,
    this.widthPct,
    this.heightPct,
    this.flexGrow = 0.0,
    this.flexShrink = 1.0,
    this.display = FlexDisplay.flex,
    this.margin,
    this.padding,
    this.marginPct,
    this.paddingPct,
    this.marginAuto = false,
    this.alignSelf = FlexAlign.auto,
    this.posType = PosType.relative,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.topPct,
    this.rightPct,
    this.bottomPct,
    this.leftPct,
    this.zIndex = 0,
    this.decoration,
    this.transform,
    this.transition,
    this.typography,
    this.linkUrl,
    this.bookmarkTitle,
    this.semanticTag,
    this.fallbackText,
  });

  @override
  SuperContainer build() {
    return SuperContainer(
      id: id,
      type: CanvasElementType.container.value,
      constraints: BoxConstraints(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        widthPercent: widthPct,
        heightPercent: heightPct,
      ),
      margin: margin,
      padding: padding,
      marginPercent: marginPct,
      paddingPercent: paddingPct,
      marginAuto: marginAuto,
      linkUrl: linkUrl,
      bookmarkTitle: bookmarkTitle,
      semanticTag: semanticTag,
      fallbackText: fallbackText,
      layout: FlexLayout(
        display: display.value,
        alignSelf: alignSelf.value,
        flexGrow: flexGrow,
        flexShrink: flexShrink,
      ),
      position: Position(
        type: posType.value,
        zIndex: zIndex,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        topPercent: topPct,
        rightPercent: rightPct,
        bottomPercent: bottomPct,
        leftPercent: leftPct,
      ),
      decoration: decoration?.toModel(),
      transform: transform,
      transition: transition,
      typography: typography,
      formField: FormFieldData(
        fieldType: fieldType.value,
        name: name,
        value: value,
      ),
    );
  }
}
