// FILE: example/lib/test11.dart
// PURPOSE: TEST 11 - Visual FX, Multi-Color SVG Parity, 12 BlendModes, ClipRules, Nested 2D Transforms & Mirrors

import 'test_registry.dart';

class Test11Cases {
  static const String _cat =
      "11. Visual FX, Multi-Color SVG, 12 BlendModes & Transforms";

  static List<TestCase> getCases() {
    return [
      _case11_1(),
      _case11_2(),
      _case11_3(),
      _case11_4(),
      _case11_5(),
      _case11_6(),
      _case11_7(),
      _case11_8(),
      _case11_9(),
      _case11_10(),
    ];
  }

  // Vibrant 5-color vector emblem (No fill override -> tests authentic multi-color SVG preservation!)
  static const String _kMultiColorEmblemSvg = '''
<svg width="240" height="240" viewBox="0 0 240 240">
  <circle cx="120" cy="120" r="108" fill="#0F172A" stroke="#38BDF8" stroke-width="8"/>
  <path d="M 120 26 L 146 92 L 216 96 L 162 140 L 178 208 L 120 172 L 62 208 L 78 140 L 24 96 L 94 92 Z"
        fill="#FACC15" stroke="#B45309" stroke-width="4"/>
  <circle cx="120" cy="120" r="44" fill="#EF4444"/>
  <circle cx="120" cy="120" r="24" fill="#10B981"/>
  <circle cx="120" cy="120" r="10" fill="#FFFFFF"/>
</svg>
''';

  // Helper to build the 12 BlendMode comparison grid (reused for PDF & PNG parity!)
  static CanvasBox _build12BlendModesGrid(String titleBadge) {
    final List<BlendMode> modes = BlendMode.values;

    return CanvasBox(
      widthPct: 100,
      heightPct: 100,
      padding: EdgeInsets.all(20.0),
      direction: FlexDir.column,
      gap: 14.0,
      decoration: CanvasDecoration(
        gradient: const [0xFFF8FAFC, 0xFFE2E8F0],
        gradientAngle: 90.0,
      ),
      children: [
        CanvasBox(
          widthPct: 100,
          height: 46,
          justifyContent: FlexJustify.center,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(
            backgroundColor: 0xFF0F172A,
            borderRadius: EdgeInsets.all(10.0),
          ),
          children: [
            titleBadge.toCanvasText().size(14.5).bold(900).textColor(0xFF38BDF8),
          ],
        ),
        CanvasBox(
          widthPct: 100,
          direction: FlexDir.row,
          wrap: FlexWrap.wrap,
          justifyContent: FlexJustify.spaceBetween,
          rowGap: 14.0,
          colGap: 10.0,
          children: modes.map((BlendMode mode) {
            return CanvasBox(
              width: 170,
              height: 158,
              padding: EdgeInsets.all(10.0),
              direction: FlexDir.column,
              justifyContent: FlexJustify.spaceBetween,
              alignItems: FlexAlign.center,
              decoration: CanvasDecoration(
                backgroundColor: 0xFFFFFFFF,
                borderRadius: EdgeInsets.all(12.0),
                borderColor: 0xFFCBD5E1,
                borderWidth: EdgeInsets.all(1.0),
              ),
              children: [
                CanvasBox(
                  width: 146,
                  height: 112,
                  decoration: CanvasDecoration(
                    gradient: const [0xFF0284C7, 0xFF22C55E, 0xFFFACC15],
                    gradientAngle: 0.0,
                    borderRadius: EdgeInsets.all(8.0),
                  ),
                  children: [
                    // Solid magenta circle blended over the 3-color gradient
                    CanvasBox(
                      width: 78,
                      height: 78,
                      posType: PosType.absolute,
                      top: 17,
                      left: 16,
                      decoration: CanvasDecoration(
                        backgroundColor: 0xFFEC4899,
                        shape: BoxShape.circle,
                        blendMode: mode,
                      ),
                    ),
                    // Solid orange circle blended over both
                    CanvasBox(
                      width: 78,
                      height: 78,
                      posType: PosType.absolute,
                      top: 17,
                      right: 16,
                      decoration: CanvasDecoration(
                        backgroundColor: 0xFFF97316,
                        shape: BoxShape.circle,
                        blendMode: mode,
                      ),
                    ),
                  ],
                ),
                mode.name.toUpperCase()
                    .toCanvasText()
                    .size(10.5)
                    .bold(800)
                    .textColor(0xFF0F172A),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // Case 11.1: Multi-Color SVG Parity Test (PDF Vector)
  static TestCase _case11_1() => TestCase(
    "11.1 [PDF] Multi-Color SVG Vector Parity (No Tint Override)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(28.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF8FAFC),
        children: [
          "11.1 MULTI-COLOR SVG IN PDF VECTOR ENGINE"
              .toCanvasText()
              .size(17.0)
              .bold(900)
              .textColor(0xFF0F172A),
          "Navy circle + Cyan ring + Gold star + Red/Green/White core must render with exact original colors."
              .toCanvasText()
              .size(11.5)
              .textColor(0xFF475569)
              .center(),
          CanvasSvg(svgXml: _kMultiColorEmblemSvg, width: 260, height: 260),
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceEvenly,
            children: [
              CanvasCol(
                align: FlexAlign.center,
                gap: 8.0,
                children: [
                  CanvasSvg(svgXml: _kMultiColorEmblemSvg, width: 120, height: 120),
                  "Authentic Colors (fill: null)"
                      .toCanvasText()
                      .size(10.5)
                      .bold()
                      .textColor(0xFF0F172A),
                ],
              ),
              CanvasCol(
                align: FlexAlign.center,
                gap: 8.0,
                children: [
                  CanvasSvg(
                    svgXml: _kMultiColorEmblemSvg,
                    width: 120,
                    height: 120,
                    fill: 0xFF7C3AED,
                  ),
                  "Explicit Override (Purple)"
                      .toCanvasText()
                      .size(10.5)
                      .bold()
                      .textColor(0xFF7C3AED),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 11.2: Multi-Color SVG Parity Test (PNG Raster Fix Verification)
  static TestCase _case11_2() => TestCase(
    "11.2 [PNG] Multi-Color SVG Raster Parity (std::nullopt Fix)",
    CanvasDocument(
      format: const CanvasFormat(540.0, 540.0),
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF0F172A, 0xFF1E293B],
          gradientAngle: 135.0,
        ),
        children: [
          "11.2 MULTI-COLOR SVG IN PNG FRAMEBUFFER"
              .toCanvasText()
              .size(16.0)
              .bold(900)
              .textColor(0xFF38BDF8),
          CanvasSvg(svgXml: _kMultiColorEmblemSvg, width: 280, height: 280)
              .shadow(color: 0xAA38BDF8, blur: 20.0)
              .mirror(distance: 8.0, blur: 3.0, opacity: 0.45),
          CanvasBox(height: 50),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 11.3: All 12 BlendModes Grid (PDF Lazy Page-Buffer Replay Test)
  static TestCase _case11_3() => TestCase(
    "11.3 [PDF] All 12 BlendModes Grid (Lazy Page-Buffer Replay)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: _build12BlendModesGrid(
        "11.3 ALL 12 BLEND MODES — PDF LAZY BUFFER REPLAY",
      ),
    ),
    category: _cat,
  );

  // Case 11.4: All 12 BlendModes Grid (PNG Framebuffer Parity)
  static TestCase _case11_4() => TestCase(
    "11.4 [PNG] All 12 BlendModes Grid (Framebuffer Parity)",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.png,
      body: _build12BlendModesGrid(
        "11.4 ALL 12 BLEND MODES — PNG FRAMEBUFFER PARITY",
      ),
    ),
    category: _cat,
  );

  // Case 11.5: ClipRule.evenOdd vs ClipRule.nonZero Donut & Star Cutouts
  static TestCase _case11_5() {
    const String concentricDonutPath =
        "M 110 10 A 100 100 0 1 0 110 210 A 100 100 0 1 0 110 10 Z "
        "M 110 55 A 55 55 0 1 0 110 165 A 55 55 0 1 0 110 55 Z";

    const String pentagramStarPath =
        "M 110 10 L 175 205 L 15 85 L 205 85 L 45 205 Z";

    return TestCase(
      "11.5 [PNG] ClipRule.evenOdd vs nonZero (Donut & Star Cutouts)",
      CanvasDocument(
        format: const CanvasFormat(560.0, 620.0),
        targetFormat: TargetFormat.png,
        body: CanvasBox(
          widthPct: 100,
          heightPct: 100,
          padding: EdgeInsets.all(24.0),
          direction: FlexDir.column,
          justifyContent: FlexJustify.spaceBetween,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
          children: [
            "11.5 EVEN-ODD vs NON-ZERO CLIPPING (PNG)"
                .toCanvasText()
                .size(16.0)
                .bold(900)
                .textColor(0xFFFFFFFF),
            CanvasRow(
              widthPct: 100,
              justify: FlexJustify.spaceEvenly,
              children: [
                CanvasCol(
                  align: FlexAlign.center,
                  gap: 10.0,
                  children: [
                    CanvasBox(
                      width: 220,
                      height: 220,
                      decoration: CanvasDecoration(
                        gradient: const [0xFF06B6D4, 0xFF3B82F6],
                        isClip: true,
                        clipRule: ClipRule.evenOdd,
                        clipSvgPath: concentricDonutPath,
                      ),
                    ),
                    "EvenOdd Donut (Hollow)"
                        .toCanvasText()
                        .size(12.0)
                        .bold()
                        .textColor(0xFF38BDF8),
                  ],
                ),
                CanvasCol(
                  align: FlexAlign.center,
                  gap: 10.0,
                  children: [
                    CanvasBox(
                      width: 220,
                      height: 220,
                      decoration: CanvasDecoration(
                        gradient: const [0xFF06B6D4, 0xFF3B82F6],
                        isClip: true,
                        clipRule: ClipRule.nonZero,
                        clipSvgPath: concentricDonutPath,
                      ),
                    ),
                    "NonZero Donut (Solid)"
                        .toCanvasText()
                        .size(12.0)
                        .bold()
                        .textColor(0xFF94A3B8),
                  ],
                ),
              ],
            ),
            CanvasRow(
              widthPct: 100,
              justify: FlexJustify.spaceEvenly,
              children: [
                CanvasCol(
                  align: FlexAlign.center,
                  gap: 10.0,
                  children: [
                    CanvasBox(
                      width: 220,
                      height: 220,
                      decoration: CanvasDecoration(
                        gradient: const [0xFFF43F5E, 0xFFFACC15],
                        isClip: true,
                        clipRule: ClipRule.evenOdd,
                        clipSvgPath: pentagramStarPath,
                      ),
                    ),
                    "EvenOdd Star (Cut Center)"
                        .toCanvasText()
                        .size(12.0)
                        .bold()
                        .textColor(0xFFFDA4AF),
                  ],
                ),
                CanvasCol(
                  align: FlexAlign.center,
                  gap: 10.0,
                  children: [
                    CanvasBox(
                      width: 220,
                      height: 220,
                      decoration: CanvasDecoration(
                        gradient: const [0xFFF43F5E, 0xFFFACC15],
                        isClip: true,
                        clipRule: ClipRule.nonZero,
                        clipSvgPath: pentagramStarPath,
                      ),
                    ),
                    "NonZero Star (Filled)"
                        .toCanvasText()
                        .size(12.0)
                        .bold()
                        .textColor(0xFFFDE047),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 11.6: Nested 2D Affine Transforms (Rotate + Scale + Skew + Custom Pivot ox/oy)
  static TestCase _case11_6() => TestCase(
    "11.6 [PNG] Nested 2D Affine Transforms & Pivot Origins",
    CanvasDocument(
      format: const CanvasFormat(560.0, 560.0),
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
        children: [
          CanvasBox(
            posType: PosType.absolute,
            top: 20,
            left: 30,
            children: [
              "11.6 NESTED AFFINE MATRICES (ROTATE + SCALE + SKEW + PIVOT)"
                  .toCanvasText()
                  .size(13.5)
                  .bold(900)
                  .textColor(0xFF38BDF8),
            ],
          ),
          // Outer Parent rotated +14 deg around center
          CanvasBox(
            width: 340,
            height: 300,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF1E3A8A, 0xFF7C3AED],
              borderRadius: EdgeInsets.all(24.0),
              borderColor: 0xFF38BDF8,
              borderWidth: EdgeInsets.all(3.0),
            ),
            transform: TransformMatrix(
              rotateZ: 14.0,
              scaleX: 1.05,
              scaleY: 1.05,
              originX: 0.5,
              originY: 0.5,
            ),
            children: [
              // Nested Child counter-rotated -26 deg + skewed 10 deg around top-left pivot (0, 0)
              CanvasBox(
                width: 220,
                height: 140,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFACC15,
                  borderRadius: EdgeInsets.all(16.0),
                  borderColor: 0xFF0F172A,
                  borderWidth: EdgeInsets.all(3.0),
                ),
                transform: TransformMatrix(
                  rotateZ: -26.0,
                  skewX: 10.0,
                  originX: 0.0,
                  originY: 0.0,
                ),
                children: [
                  "NESTED MATRIX\nParent: +14 deg\nChild: -26 deg, SkewX: 10"
                      .toCanvasText()
                      .size(13.0)
                      .bold(900)
                      .textColor(0xFF0F172A)
                      .center(),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 11.7: 5-Direction Mirror Reflection Showcase (bottom, top, right, left, none + fadeGradient)
  static TestCase _case11_7() {
    CanvasBox buildMirrorTile(
        String label,
        FadeDirection dir, {
          List<int>? fadeGrad,
        }) {
      return CanvasBox(
        width: 155,
        height: 195,
        padding: EdgeInsets.all(12.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.start,
        alignItems: FlexAlign.center,
        gap: 10.0,
        decoration: CanvasDecoration(
          backgroundColor: 0xFF1E293B,
          borderRadius: EdgeInsets.all(12.0),
          borderColor: 0xFF334155,
          borderWidth: EdgeInsets.all(1.0),
        ),
        children: [
          label.toCanvasText().size(11.0).bold(800).textColor(0xFF38BDF8),
          CanvasBox(
            width: 110,
            height: 62,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFFEC4899, 0xFF8B5CF6],
              borderRadius: EdgeInsets.all(10.0),
              mirror: CanvasReflection(
                distance: 4.0,
                blurRadius: 2.0,
                opacity: 0.75,
                fadeDirection: dir.value,
                fadeGradient: fadeGrad,
              ),
            ),
            children: [
              "FX".toCanvasText().size(18.0).bold(900).textColor(0xFFFFFFFF),
            ],
          ),
        ],
      );
    }

    return TestCase(
      "11.7 [PNG] 5-Direction Mirror Fade + FadeGradient Showcase",
      CanvasDocument(
        format: const CanvasFormat(560.0, 520.0),
        targetFormat: TargetFormat.png,
        body: CanvasBox(
          widthPct: 100,
          heightPct: 100,
          padding: EdgeInsets.all(20.0),
          direction: FlexDir.column,
          gap: 16.0,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
          children: [
            "11.7 ALL 5 MIRROR FADE DIRECTIONS + GRADIENT TINT"
                .toCanvasText()
                .size(14.5)
                .bold(900)
                .textColor(0xFFFFFFFF),
            CanvasRow(
              widthPct: 100,
              justify: FlexJustify.spaceEvenly,
              children: [
                buildMirrorTile("Fade: BOTTOM", FadeDirection.bottom),
                buildMirrorTile("Fade: TOP", FadeDirection.top),
                buildMirrorTile("Fade: RIGHT", FadeDirection.right),
              ],
            ),
            CanvasRow(
              widthPct: 100,
              justify: FlexJustify.spaceEvenly,
              children: [
                buildMirrorTile("Fade: LEFT", FadeDirection.left),
                buildMirrorTile("Fade: NONE", FadeDirection.none),
                buildMirrorTile(
                  "Fade: GRADIENT",
                  FadeDirection.bottom,
                  fadeGrad: const [0xFF00E5FF, 0x0000E5FF],
                ),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 11.8: ShadowType.dropShadow vs ShadowType.boxShadow + Multi-Stop Gradient Glow
  static TestCase _case11_8() => TestCase(
    "11.8 [PNG] DropShadow vs BoxShadow + Multi-Stop Gradient Glow",
    CanvasDocument(
      format: const CanvasFormat(560.0, 480.0),
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
        children: [
          "11.8 DROP SHADOW vs BOX SHADOW + GRADIENT GLOW"
              .toCanvasText()
              .size(15.0)
              .bold(900)
              .textColor(0xFFFFFFFF),
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceEvenly,
            children: [
              CanvasCol(
                align: FlexAlign.center,
                gap: 14.0,
                children: [
                  CanvasSvg(
                    svgXml: _kMultiColorEmblemSvg,
                    width: 140,
                    height: 140,
                  ).shadow(
                    color: 0xFF00E5FF,
                    blur: 22.0,
                    spread: 4.0,
                    type: ShadowType.dropShadow,
                  ),
                  "ShadowType.dropShadow\n(True Alpha Contour)"
                      .toCanvasText()
                      .size(11.5)
                      .bold()
                      .textColor(0xFF38BDF8)
                      .center(),
                ],
              ),
              CanvasCol(
                align: FlexAlign.center,
                gap: 14.0,
                children: [
                  CanvasSvg(
                    svgXml: _kMultiColorEmblemSvg,
                    width: 140,
                    height: 140,
                  ).shadow(
                    color: 0xFFF43F5E,
                    blur: 22.0,
                    spread: 4.0,
                    type: ShadowType.boxShadow,
                  ),
                  "ShadowType.boxShadow\n(Fast Rectangular Box)"
                      .toCanvasText()
                      .size(11.5)
                      .bold()
                      .textColor(0xFFFDA4AF)
                      .center(),
                ],
              ),
            ],
          ),
          CanvasBox(
            width: 380,
            height: 80,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              borderRadius: EdgeInsets.all(16.0),
              shadow: CanvasShadow(
                gradient: const [0xFF00E5FF, 0xFFA855F7, 0xFFF43F5E],
                blurRadius: 24.0,
                spreadRadius: 6.0,
              ),
            ),
            children: [
              "3-STOP NEON GRADIENT SHADOW (CYAN -> PURPLE -> PINK)"
                  .toCanvasText()
                  .size(11.5)
                  .bold(800)
                  .textColor(0xFFFFFFFF),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 11.9: Asymmetric Borders, Custom borderDash & 9-Point ImageAlignment Grid
  static TestCase _case11_9() {
    final List<ImageAlignment> alignments = [
      ImageAlignment.topLeft,
      ImageAlignment.topCenter,
      ImageAlignment.topRight,
      ImageAlignment.centerLeft,
      ImageAlignment.center,
      ImageAlignment.centerRight,
      ImageAlignment.bottomLeft,
      ImageAlignment.bottomCenter,
      ImageAlignment.bottomRight,
    ];

    return TestCase(
      "11.9 [PDF] Asymmetric Borders, Custom Dash & 9-Point ImageAlign",
      CanvasDocument(
        format: CanvasFormat.a4,
        canvasMargin: EdgeInsets.all(24.0),
        body: CanvasCol(
          widthPct: 100,
          gap: 16.0,
          children: [
            "11.9 ASYMMETRIC BORDERS, CUSTOM DASH & 9-POINT IMAGE ALIGNMENT"
                .toCanvasText()
                .size(14.0)
                .bold(900)
                .textColor(0xFF0F172A),
            CanvasRow(
              widthPct: 100,
              gap: 14.0,
              children: [
                CanvasBox(
                  flexGrow: 1.0,
                  height: 70,
                  justifyContent: FlexJustify.center,
                  alignItems: FlexAlign.center,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFF8FAFC,
                    borderColor: 0xFF0F172A,
                    borderWidth: EdgeInsets.only(
                      top: 6.0,
                      right: 2.0,
                      bottom: 4.0,
                      left: 1.0,
                    ),
                  ),
                  children: [
                    "Asymmetric Border (T:6 R:2 B:4 L:1)"
                        .toCanvasText()
                        .size(10.5)
                        .bold()
                        .textColor(0xFF0F172A),
                  ],
                ),
                CanvasBox(
                  flexGrow: 1.0,
                  height: 70,
                  justifyContent: FlexJustify.center,
                  alignItems: FlexAlign.center,
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFFEFF6FF,
                    borderColor: 0xFF2563EB,
                    borderWidth: EdgeInsets.all(2.5),
                    borderStyle: BorderStyle.dashed,
                    borderDash: const [10.0, 4.0, 2.0, 4.0],
                  ),
                  children: [
                    "Custom Dash [10, 4, 2, 4]"
                        .toCanvasText()
                        .size(10.5)
                        .bold()
                        .textColor(0xFF1D4ED8),
                  ],
                ),
              ],
            ),
            CanvasBox(
              widthPct: 100,
              direction: FlexDir.row,
              wrap: FlexWrap.wrap,
              justifyContent: FlexJustify.spaceBetween,
              rowGap: 12.0,
              colGap: 10.0,
              children: alignments.map((ImageAlignment align) {
                return CanvasCol(
                  width: 168,
                  align: FlexAlign.center,
                  gap: 4.0,
                  children: [
                    CanvasBox(
                      width: 168,
                      height: 150,
                      decoration: CanvasDecoration(
                        backgroundColor: 0xFF1E293B,
                        borderColor: 0xFF94A3B8,
                        borderWidth: EdgeInsets.all(1.5),
                      ),
                      children: [
                        CanvasImage(
                          base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                          width: 165,
                          height: 147,
                          fit: ImageFit.contain,
                          imageAlignment: align,
                        ),
                      ],
                    ),
                    align.name
                        .toCanvasText()
                        .size(10.0)
                        .bold()
                        .textColor(0xFF334155),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      category: _cat,
      needsImageFile: true,
    );
  }

  // Case 11.10: Z-Index Negative/Positive Sandwich + Nested Opacity Cascade
  static TestCase _case11_10() => TestCase(
    "11.10 [PDF] Z-Index Sandwich (-5 / 0 / +99) + Opacity Cascade",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 24.0,
        align: FlexAlign.center,
        children: [
          "11.10 Z-INDEX STACKING & NESTED OPACITY MULTIPLICATION"
              .toCanvasText()
              .size(15.5)
              .bold(900)
              .textColor(0xFF0F172A),
          // Z-Index Sandwich
          CanvasBox(
            width: 360,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              // zIndex: -5 -> Painted BEHIND parent background
              CanvasBox(
                width: 260,
                height: 260,
                posType: PosType.absolute,
                top: -20,
                left: 50,
                zIndex: -5,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF06B6D4,
                  borderRadius: EdgeInsets.all(130.0),
                ),
              ),
              "PARENT SURFACE (zIndex: 0)\nCyan Circle behind has zIndex: -5"
                  .toCanvasText()
                  .size(13.0)
                  .bold()
                  .textColor(0xFFFFFFFF)
                  .center(),
              // zIndex: +99 -> Floating Ribbon on top
              CanvasBox(
                width: 150,
                height: 32,
                posType: PosType.absolute,
                top: -12,
                right: -12,
                zIndex: 99,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFEF4444,
                  borderRadius: EdgeInsets.all(16.0),
                ),
                children: [
                  "RIBBON (zIndex: +99)"
                      .toCanvasText()
                      .size(10.5)
                      .bold(900)
                      .textColor(0xFFFFFFFF),
                ],
              ),
            ],
          ),
          // Nested Opacity Cascade (0.65 * 0.65 = 0.4225)
          CanvasBox(
            width: 420,
            height: 180,
            padding: EdgeInsets.all(20.0),
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF2563EB,
              opacity: 0.65,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              "PARENT OPACITY: 0.65"
                  .toCanvasText()
                  .size(12.0)
                  .bold()
                  .textColor(0xFFFFFFFF),
              CanvasBox(
                width: 180,
                height: 120,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFDC2626,
                  opacity: 0.65,
                  borderRadius: EdgeInsets.all(12.0),
                ),
                children: [
                  "CHILD OPACITY: 0.65\nEffective = 0.42"
                      .toCanvasText()
                      .size(11.5)
                      .bold()
                      .textColor(0xFFFFFFFF)
                      .center(),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );
}