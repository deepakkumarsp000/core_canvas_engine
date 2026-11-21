// FILE: lib/widgets/macro_widgets.dart
// PURPOSE: High-Level Macro-Component Design System (Layer 3)
// Includes: CanvasIcon, CanvasCustomPainter, CanvasRow, CanvasCol, CanvasCard,
// CanvasBadge, CanvasDivider, CanvasButton, CanvasLabeledCheckbox,
// CanvasTable, CanvasBulletList & CanvasProgressBar.
// ignore_for_file: non_constant_identifier_names

import 'dart:ui' as ui;
import 'package:flutter/widgets.dart' show IconData, CustomPainter;

import 'core_widgets.dart';

// ============================================================================
// CANVAS ICON (Zero-KB Support for Material & Cupertino IconData)
// ============================================================================
CanvasText CanvasIcon(
  IconData icon, {
  double size = 24.0,
  int color = 0xFF000000,
  CanvasShadow? shadow,
  CanvasReflection? mirror,
  CanvasDecoration? decoration,
  EdgeInsets? padding,
  EdgeInsets? margin,
  PosType posType = PosType.relative,
  double? top,
  double? right,
  double? bottom,
  double? left,
  int zIndex = 0,
  String? id,
}) {
  final String resolvedFamily =
      (icon.fontPackage != null && icon.fontPackage!.isNotEmpty)
      ? 'packages/${icon.fontPackage}/${icon.fontFamily ?? 'MaterialIcons'}'
      : (icon.fontFamily ?? 'MaterialIcons');

  final CanvasDecoration? effectiveDeco =
      decoration ??
      ((shadow != null || mirror != null)
          ? CanvasDecoration(shadow: shadow, mirror: mirror)
          : null);

  return CanvasText(
    String.fromCharCode(icon.codePoint),
    id: id ?? 'icon_${icon.codePoint}',
    width: size * 1.15,
    height: size * 1.15,
    fontFamily: resolvedFamily,
    fontSize: size,
    color: color,
    align: TextAlign.center,
    lineHeight: 1.0,
    padding: padding,
    margin: margin,
    posType: posType,
    top: top,
    right: right,
    bottom: bottom,
    left: left,
    zIndex: zIndex,
    decoration: effectiveDeco,
  );
}

extension IconDataCanvasExt on IconData {
  CanvasText toCanvasIcon({
    double size = 24.0,
    int color = 0xFF000000,
    CanvasShadow? shadow,
    CanvasReflection? mirror,
  }) => CanvasIcon(
    this,
    size: size,
    color: color,
    shadow: shadow,
    mirror: mirror,
  );
}

// ============================================================================
// CANVAS CUSTOM PAINTER (Universal Escape Hatch for QR Codes, Charts & Graphs)
// ============================================================================
Future<CanvasImage> CanvasCustomPainter({
  required CustomPainter painter,
  required double width,
  required double height,
  double retinaScale = 2.0,
  ImageFit fit = ImageFit.contain,
  CanvasDecoration? decoration,
  CanvasShadow? shadow,
  CanvasReflection? mirror,
  String? id,
}) async {
  final int pixelW = (width * retinaScale).ceil();
  final int pixelH = (height * retinaScale).ceil();

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.scale(retinaScale, retinaScale);
  painter.paint(canvas, ui.Size(width, height));

  final ui.Picture picture = recorder.endRecording();
  ui.Image? img;
  String encodedData = '';
  final String assetKey =
      id ?? 'custom_painter_${DateTime.now().microsecondsSinceEpoch}';

  try {
    img = await picture.toImage(pixelW, pixelH);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final bytes = byteData.buffer.asUint8List();
      encodedData = CoreCanvasEngine.registerMemoryAsset(assetKey, bytes);
    }
  } finally {
    img?.dispose();
    picture.dispose();
  }

  final CanvasDecoration? effectiveDeco =
      decoration ??
      ((shadow != null || mirror != null)
          ? CanvasDecoration(shadow: shadow, mirror: mirror)
          : null);

  return CanvasImage(
    id: assetKey,
    base64Data: encodedData,
    width: width,
    height: height,
    fit: fit,
    decoration: effectiveDeco,
  );
}

// ============================================================================
// CANVAS ROW (Shorthand for Flexbox Row)
// ============================================================================
CanvasBox CanvasRow({
  required List<CanvasWidget> children,
  double? width,
  double? height,
  double? widthPct,
  double? heightPct,
  FlexJustify justify = FlexJustify.start,
  FlexAlign align = FlexAlign.auto,
  double gap = 0.0,
  FlexWrap wrap = FlexWrap.noWrap,
  EdgeInsets? padding,
  EdgeInsets? margin,
  CanvasStyle? style,
  String? id,
}) {
  final CanvasBox box = CanvasBox(
    id: id ?? 'row_macro',
    width: width,
    height: height,
    widthPct: widthPct,
    heightPct: heightPct,
    direction: FlexDir.row,
    justifyContent: justify,
    alignItems: align,
    gap: gap,
    wrap: wrap,
    padding: padding,
    margin: margin,
    children: children,
  );
  return style != null ? box.apply(style) : box;
}

// ============================================================================
// CANVAS COL (Shorthand for Flexbox Column)
// ============================================================================
CanvasBox CanvasCol({
  required List<CanvasWidget> children,
  double? width,
  double? height,
  double? widthPct,
  double? heightPct,
  FlexJustify justify = FlexJustify.start,
  FlexAlign align = FlexAlign.auto,
  double gap = 0.0,
  EdgeInsets? padding,
  EdgeInsets? margin,
  CanvasStyle? style,
  String? id,
}) {
  final CanvasBox box = CanvasBox(
    id: id ?? 'col_macro',
    width: width,
    height: height,
    widthPct: widthPct,
    heightPct: heightPct,
    direction: FlexDir.column,
    justifyContent: justify,
    alignItems: align,
    gap: gap,
    padding: padding,
    margin: margin,
    children: children,
  );
  return style != null ? box.apply(style) : box;
}

// ============================================================================
// CANVAS CARD (Pre-styled Surface)
// ============================================================================
CanvasBox CanvasCard({
  required List<CanvasWidget> children,
  double? width,
  double? height,
  double? widthPct,
  double? heightPct,
  EdgeInsets padding = const EdgeInsets(16.0, 16.0, 16.0, 16.0),
  double borderRadius = 12.0,
  int backgroundColor = 0xFFFFFFFF,
  CanvasShadow? shadow,
  CanvasReflection? mirror,
  CanvasStyle? extraStyle,
  String? id,
}) {
  final CanvasBox box = CanvasBox(
    id: id ?? 'card_macro',
    width: width,
    height: height,
    widthPct: widthPct,
    heightPct: heightPct,
    padding: padding,
    decoration: CanvasDecoration(
      backgroundColor: backgroundColor,
      borderRadius: EdgeInsets.all(borderRadius),
      shadow:
          shadow ??
          CanvasShadow(
            color: 0x33000000,
            blurRadius: 10.0,
            offsetY: 4.0,
            isDropShadow: true,
          ),
      mirror: mirror,
    ),
    children: children,
  );
  return extraStyle != null ? box.apply(extraStyle) : box;
}

// ============================================================================
// CANVAS BADGE (Pill-Shaped Status Tag with Optional Icon)
// ============================================================================
CanvasBox CanvasBadge({
  required String label,
  IconData? icon,
  int backgroundColor = 0xFF1E293B,
  int textColor = 0xFF38BDF8,
  int? borderColor,
  double fontSize = 13.0,
  double borderRadius = 20.0,
  EdgeInsets padding = const EdgeInsets(6.0, 14.0, 6.0, 14.0),
  CanvasShadow? shadow,
  String? id,
}) {
  return CanvasBox(
    id: id ?? 'badge_macro',
    direction: FlexDir.row,
    justifyContent: FlexJustify.center,
    alignItems: FlexAlign.center,
    gap: 6.0,
    padding: padding,
    decoration: CanvasDecoration(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderColor != null ? EdgeInsets.all(1.5) : null,
      borderRadius: EdgeInsets.all(borderRadius),
      shadow: shadow,
    ),
    children: [
      if (icon != null)
        CanvasIcon(icon, size: fontSize + 3.0, color: textColor),
      CanvasText(
        label,
        fontSize: fontSize,
        weight: 700,
        color: textColor,
        align: TextAlign.center,
      ),
    ],
  );
}

// ============================================================================
// CANVAS DIVIDER (Horizontal or Vertical Line Separator)
// ============================================================================
CanvasBox CanvasDivider({
  double thickness = 1.0,
  int color = 0xFFE2E8F0,
  double? length,
  double lengthPct = 100.0,
  bool isVertical = false,
  EdgeInsets? margin,
  String? id,
}) {
  return CanvasBox(
    id: id ?? 'divider_macro',
    width: isVertical ? thickness : length,
    widthPct: isVertical ? null : (length == null ? lengthPct : null),
    height: isVertical ? length : thickness,
    heightPct: isVertical ? (length == null ? lengthPct : null) : null,
    margin: margin,
    decoration: CanvasDecoration(backgroundColor: color),
  );
}

// ============================================================================
// CANVAS BUTTON (Interactive Form Button / Hyperlink)
// ============================================================================
CanvasBox CanvasButton({
  required String text,
  String? linkUrl,
  String? formActionName,
  int buttonColor = 0xFF007AFF,
  int textColor = 0xFFFFFFFF,
  double fontSize = 16.0,
  double borderRadius = 8.0,
  EdgeInsets padding = const EdgeInsets(12.0, 24.0, 12.0, 24.0),
  CanvasStyle? extraStyle,
  String? id,
}) {
  final CanvasBox box = CanvasBox(
    id: id ?? 'button_macro',
    padding: padding,
    justifyContent: FlexJustify.center,
    alignItems: FlexAlign.center,
    linkUrl: linkUrl,
    decoration: CanvasDecoration(
      backgroundColor: buttonColor,
      borderRadius: EdgeInsets.all(borderRadius),
    ),
    transition: TransitionProps(
      durationMs: 200,
      timingFunction: TimingFunction.easeOutQuad.value,
    ),
    children: [
      if (formActionName != null)
        CanvasForm(
          name: formActionName,
          fieldType: FormFieldType.button,
          posType: PosType.absolute,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          zIndex: 10,
        ),
      CanvasText(
        text,
        color: textColor,
        fontSize: fontSize,
        weight: 600,
        align: TextAlign.center,
      ),
    ],
  );
  return extraStyle != null ? box.apply(extraStyle) : box;
}

// ============================================================================
// CANVAS LABELED CHECKBOX (AcroForm Checkbox + Text Row)
// ============================================================================
CanvasBox CanvasLabeledCheckbox({
  required String labelText,
  required String fieldName,
  bool initialValue = false,
  int activeColor = 0xFF007AFF,
  double gap = 8.0,
  String? id,
}) {
  return CanvasRow(
    id: id ?? 'labeled_checkbox',
    align: FlexAlign.center,
    gap: gap,
    children: [
      CanvasForm(
        id: '${fieldName}_checkbox',
        name: fieldName,
        fieldType: FormFieldType.checkbox,
        value: initialValue ? 'true' : 'false',
        width: 24,
        height: 24,
        decoration: CanvasDecoration(
          backgroundColor: initialValue ? activeColor : 0xFFFFFFFF,
          borderColor: 0xFFCCCCCC,
          borderWidth: EdgeInsets.all(2.0),
          borderRadius: EdgeInsets.all(4.0),
        ),
      ),
      CanvasText(labelText, fontSize: 14.0, color: 0xFF333333),
    ],
  );
}

// ============================================================================
// CANVAS TABLE (Production Invoice, Report & Resume Data Table)
// Supports proportional column widths, zebra striping & page-break-safe rows.
// ============================================================================
CanvasBox CanvasTable({
  required List<String> headers,
  required List<List<String>> rows,
  List<double>? columnFlex,
  List<TextAlign>? columnAlignments,
  double? width,
  double widthPct = 100.0,
  int headerBgColor = 0xFF1E293B,
  int headerTextColor = 0xFFFFFFFF,
  int rowBgColor = 0xFFFFFFFF,
  int alternateRowBgColor = 0xFFF8FAFC,
  int textColor = 0xFF1E293B,
  int borderColor = 0xFFE2E8F0,
  double borderWidth = 1.0,
  double borderRadius = 6.0,
  double headerFontSize = 11.0,
  double cellFontSize = 10.5,
  EdgeInsets cellPadding = const EdgeInsets(8.0, 10.0, 8.0, 10.0),
  bool striped = true,
  bool avoidRowSplit = true,
  EdgeInsets? margin,
  String? id,
}) {
  final int colCount = headers.length;
  final List<CanvasWidget> tableRows = <CanvasWidget>[];

  double flexForCol(int i) =>
      (columnFlex != null && i < columnFlex.length) ? columnFlex[i] : 1.0;

  TextAlign alignForCol(int i) =>
      (columnAlignments != null && i < columnAlignments.length)
      ? columnAlignments[i]
      : TextAlign.left;

  // Header Row
  if (headers.isNotEmpty) {
    tableRows.add(
      CanvasBox(
        id: '${id ?? 'table'}_header',
        widthPct: 100.0,
        direction: FlexDir.row,
        alignItems: FlexAlign.stretch,
        spanningRules: avoidRowSplit ? SpanningRules(pageBreakInside: 1) : null,
        decoration: CanvasDecoration(
          backgroundColor: headerBgColor,
          borderColor: borderColor,
          borderWidth: EdgeInsets.only(bottom: borderWidth),
        ),
        children: List<CanvasWidget>.generate(colCount, (int i) {
          return CanvasBox(
            flexGrow: flexForCol(i),
            flexShrink: 1.0,
            padding: cellPadding,
            justifyContent: FlexJustify.center,
            children: [
              CanvasText(
                headers[i],
                widthPct: 100.0,
                fontSize: headerFontSize,
                weight: 700,
                color: headerTextColor,
                align: alignForCol(i),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Body Rows
  for (int r = 0; r < rows.length; r++) {
    final List<String> rowCells = rows[r];
    final bool isLast = r == rows.length - 1;
    final int bg = (striped && r.isOdd) ? alternateRowBgColor : rowBgColor;

    tableRows.add(
      CanvasBox(
        id: '${id ?? 'table'}_row_$r',
        widthPct: 100.0,
        direction: FlexDir.row,
        alignItems: FlexAlign.stretch,
        spanningRules: avoidRowSplit ? SpanningRules(pageBreakInside: 1) : null,
        decoration: CanvasDecoration(
          backgroundColor: bg,
          borderColor: isLast ? null : borderColor,
          borderWidth: isLast ? null : EdgeInsets.only(bottom: borderWidth),
        ),
        children: List<CanvasWidget>.generate(colCount, (int i) {
          final String cellVal = i < rowCells.length ? rowCells[i] : '';
          return CanvasBox(
            flexGrow: flexForCol(i),
            flexShrink: 1.0,
            padding: cellPadding,
            justifyContent: FlexJustify.center,
            children: [
              CanvasText(
                cellVal,
                widthPct: 100.0,
                fontSize: cellFontSize,
                color: textColor,
                align: alignForCol(i),
              ),
            ],
          );
        }),
      ),
    );
  }

  return CanvasBox(
    id: id ?? 'table_macro',
    width: width,
    widthPct: width == null ? widthPct : null,
    direction: FlexDir.column,
    overflow: Overflow.hidden,
    margin: margin,
    decoration: CanvasDecoration(
      borderColor: borderColor,
      borderWidth: EdgeInsets.all(borderWidth),
      borderRadius: borderRadius > 0 ? EdgeInsets.all(borderRadius) : null,
    ),
    children: tableRows,
  );
}

// ============================================================================
// CANVAS BULLET LIST (Hanging-Indent Bullet Points for Resumes & Reports)
// ============================================================================
CanvasBox CanvasBulletList({
  required List<String> items,
  String bullet = '-',
  int bulletColor = 0xFF334155,
  int textColor = 0xFF1E293B,
  double fontSize = 11.0,
  double lineHeight = 1.35,
  double itemSpacing = 5.0,
  double bulletGap = 8.0,
  double? width,
  double widthPct = 100.0,
  EdgeInsets? margin,
  String? id,
}) {
  return CanvasBox(
    id: id ?? 'bullet_list_macro',
    width: width,
    widthPct: width == null ? widthPct : null,
    direction: FlexDir.column,
    gap: itemSpacing,
    margin: margin,
    children: List<CanvasWidget>.generate(items.length, (int i) {
      return CanvasBox(
        id: '${id ?? 'bullet'}_item_$i',
        widthPct: 100.0,
        direction: FlexDir.row,
        alignItems: FlexAlign.flexStart,
        gap: bulletGap,
        spanningRules: SpanningRules(pageBreakInside: 1),
        children: [
          CanvasText(
            bullet,
            fontSize: fontSize,
            weight: 700,
            color: bulletColor,
            lineHeight: lineHeight,
          ),
          CanvasText(
            items[i],
            flexGrow: 1.0,
            flexShrink: 1.0,
            fontSize: fontSize,
            color: textColor,
            lineHeight: lineHeight,
          ),
        ],
      );
    }),
  );
}

// ============================================================================
// CANVAS PROGRESS BAR (Skill Bars & KPI Indicators for Resumes & Dashboards)
// ============================================================================
CanvasBox CanvasProgressBar({
  required double value,
  String? label,
  bool showPercentage = false,
  double? width,
  double widthPct = 100.0,
  double barHeight = 8.0,
  int trackColor = 0xFFE2E8F0,
  int fillColor = 0xFF2563EB,
  List<int>? fillGradient,
  int labelColor = 0xFF1E293B,
  double labelFontSize = 11.0,
  double borderRadius = 4.0,
  EdgeInsets? margin,
  String? id,
}) {
  final double clamped = value.clamp(0.0, 1.0).toDouble();
  final double fillPct = clamped * 100.0;
  final int pctInt = (fillPct).round();

  final CanvasBox track = CanvasBox(
    id: '${id ?? 'progress'}_track',
    widthPct: 100.0,
    height: barHeight,
    overflow: Overflow.hidden,
    decoration: CanvasDecoration(
      backgroundColor: trackColor,
      borderRadius: EdgeInsets.all(borderRadius),
    ),
    children: [
      if (fillPct > 0.0)
        CanvasBox(
          id: '${id ?? 'progress'}_fill',
          widthPct: fillPct,
          heightPct: 100.0,
          decoration: CanvasDecoration(
            backgroundColor: fillGradient == null ? fillColor : null,
            gradient: fillGradient,
            borderRadius: EdgeInsets.all(borderRadius),
          ),
        ),
    ],
  );

  if (label == null && !showPercentage) {
    return CanvasBox(
      id: id ?? 'progress_macro',
      width: width,
      widthPct: width == null ? widthPct : null,
      margin: margin,
      children: [track],
    );
  }

  return CanvasBox(
    id: id ?? 'progress_macro',
    width: width,
    widthPct: width == null ? widthPct : null,
    direction: FlexDir.column,
    gap: 4.0,
    margin: margin,
    children: [
      CanvasBox(
        widthPct: 100.0,
        direction: FlexDir.row,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        children: [
          if (label != null)
            CanvasText(
              label,
              fontSize: labelFontSize,
              weight: 600,
              color: labelColor,
            ),
          if (showPercentage)
            CanvasText(
              '$pctInt%',
              fontSize: labelFontSize - 0.5,
              weight: 600,
              color: labelColor,
            ),
        ],
      ),
      track,
    ],
  );
}
