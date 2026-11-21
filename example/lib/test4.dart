// FILE: example/lib/test4.dart
// PURPOSE: TEST 4 - The Aesthetics & Masking Engine (BoxDecoration Stress Suite)

import 'test_registry.dart';

class Test4Cases {
  static const String _cat = "4. Aesthetics & Masking (BoxDecoration)";

  static List<TestCase> getCases() {
    return [
      _case4_1(),
      _case4_2(),
      _case4_3(),
      _case4_4(),
      _case4_5(),
      _case4_6(),
      _case4_7(),
      _case4_8(),
      _case4_9(),
      _case4_10(),
    ];
  }

  // Case 4.1: Asymmetric Border Radius (TL=10, TR=50, BR=0, BL=100)
  static TestCase _case4_1() => TestCase(
    "4.1 Asymmetric Border Radius",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFECEFF1),
        children: [
          CanvasBox(
            width: 340,
            height: 240,
            overflow: Overflow.hidden,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E88E5,
              isClip: true,
              borderRadius: EdgeInsets.only(
                top: 10.0,
                right: 50.0,
                bottom: 0.0,
                left: 100.0,
              ),
              shadow: CanvasShadow(
                color: 0xAA0D47A1,
                offsetX: 0.0,
                offsetY: 16.0,
                blurRadius: 24.0,
                spreadRadius: 4.0,
              ),
            ),
            children: [
              CanvasBox(
                width: 140,
                height: 50,
                posType: PosType.absolute,
                top: 0,
                left: 0,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [
                  CanvasText("TL: 10", color: 0xFFFFFFFF, weight: 700),
                ],
              ),
              CanvasBox(
                width: 140,
                height: 50,
                posType: PosType.absolute,
                top: 0,
                right: 0,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFFFFB300),
                children: [
                  CanvasText("TR: 50", color: 0xFF000000, weight: 700),
                ],
              ),
              CanvasBox(
                width: 140,
                height: 50,
                posType: PosType.absolute,
                bottom: 0,
                right: 0,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF00E676),
                children: [
                  CanvasText("BR: 0 (Sharp)", color: 0xFF000000, weight: 700),
                ],
              ),
              CanvasBox(
                width: 160,
                height: 60,
                posType: PosType.absolute,
                bottom: 0,
                left: 0,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFFAB47BC),
                children: [
                  CanvasText("BL: 100", color: 0xFFFFFFFF, weight: 700),
                ],
              ),
              CanvasText(
                "ASYMMETRIC\nLEAF CARD",
                color: 0xFFFFFFFF,
                fontSize: 24.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.2: Dashed vs Dotted Borders
  static TestCase _case4_2() => TestCase(
    "4.2 Dashed vs Dotted Borders",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF5F5F5),
        children: [
          CanvasBox(
            width: 340,
            height: 160,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderColor: 0xFFE53935,
              borderWidth: EdgeInsets.all(4.0),
              borderStyle: BorderStyle.dashed,
              borderDash: const [10.0, 5.0],
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "DASHED BORDER\nborderDash: [10, 5] | width: 4px",
                color: 0xFFE53935,
                fontSize: 18.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 340,
            height: 160,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderColor: 0xFF3949AB,
              borderWidth: EdgeInsets.all(5.0),
              borderStyle: BorderStyle.dotted,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "DOTTED BORDER\nborderStyle: BorderStyle.dotted",
                color: 0xFF3949AB,
                fontSize: 18.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 340,
            height: 160,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF263238,
              borderColor: 0xFF00E676,
              borderWidth: EdgeInsets.all(4.0),
              borderStyle: BorderStyle.dashed,
              borderDash: const [20.0, 8.0, 4.0, 8.0],
            ),
            children: [
              CanvasText(
                "MORSE CODE DASH\nborderDash: [20, 8, 4, 8]",
                color: 0xFF00E676,
                fontSize: 18.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.3: Multi-layered Drop Shadows
  static TestCase _case4_3() => TestCase(
    "4.3 Multi-Layered Heavy Shadows",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
        children: [
          CanvasBox(
            width: 300,
            height: 180,
            decoration: CanvasDecoration(
              borderRadius: EdgeInsets.all(28.0),
              shadow: CanvasShadow(
                color: 0x88F50057,
                offsetX: -12.0,
                offsetY: 22.0,
                blurRadius: 45.0,
                spreadRadius: 8.0,
              ),
            ),
            children: [
              CanvasBox(
                widthPct: 100,
                heightPct: 100,
                decoration: CanvasDecoration(
                  borderRadius: EdgeInsets.all(28.0),
                  shadow: CanvasShadow(
                    color: 0x9900E5FF,
                    offsetX: 12.0,
                    offsetY: -10.0,
                    blurRadius: 35.0,
                    spreadRadius: 4.0,
                  ),
                ),
                children: [
                  CanvasBox(
                    widthPct: 100,
                    heightPct: 100,
                    justifyContent: FlexJustify.center,
                    alignItems: FlexAlign.center,
                    decoration: CanvasDecoration(
                      backgroundColor: 0xFF1E293B,
                      borderRadius: EdgeInsets.all(28.0),
                      shadow: CanvasShadow(
                        color: 0xCCFFFFFF,
                        offsetX: 0.0,
                        offsetY: 0.0,
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ),
                    children: [
                      CanvasText(
                        "3-LAYER STACKED\nNEON SHADOW RIG",
                        color: 0xFFFFFFFF,
                        fontSize: 22.0,
                        weight: 800,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          CanvasBox(
            width: 300,
            height: 180,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(24.0),
              shadow: CanvasShadow(
                color: 0xCC7C4DFF,
                offsetX: 0.0,
                offsetY: 20.0,
                blurRadius: 40.0,
                spreadRadius: 18.0,
              ),
            ),
            children: [
              CanvasText(
                "HEAVY SPREAD + BLUR\nBlur: 40 | Spread: 18",
                color: 0xFF1E293B,
                fontSize: 20.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.4: Shape Morphing (Circle Override)
  static TestCase _case4_4() => TestCase(
    "4.4 Shape Morphing (Circle Override)",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFE8EAF6),
        children: [
          CanvasBox(
            width: 260,
            height: 260,
            overflow: Overflow.hidden,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF3F51B5,
              shape: BoxShape.circle,
              isClip: true,
              borderRadius: EdgeInsets.only(
                top: 5.0,
                right: 140.0,
                bottom: 0.0,
                left: 300.0,
              ),
              shadow: CanvasShadow(
                color: 0x991A237E,
                offsetX: 0.0,
                offsetY: 14.0,
                blurRadius: 24.0,
                spreadRadius: 4.0,
              ),
              mirror: CanvasReflection(
                distance: 12.0,
                blurRadius: 6.0,
                opacity: 0.55,
              ),
            ),
            children: [
              CanvasBox(
                widthPct: 100,
                height: 45,
                posType: PosType.absolute,
                top: 0,
                left: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
              ),
              CanvasBox(
                widthPct: 100,
                height: 45,
                posType: PosType.absolute,
                bottom: 0,
                left: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFFFFCA28),
              ),
              CanvasText(
                "PERFECT CIRCLE\nRadius Ignored!",
                color: 0xFFFFFFFF,
                fontSize: 22.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.5: Alpha Opacity (0.3 on parent affecting children)
  static TestCase _case4_5() => TestCase(
    "4.5 Parent Alpha Opacity (0.3)",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF212121),
        children: [
          CanvasBox(
            width: 500,
            height: 120,
            posType: PosType.absolute,
            top: 360,
            left: 47,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF00E5FF,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "BACKGROUND BAR BEHIND CARDS",
                color: 0xFF000000,
                fontSize: 22.0,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            widthPct: 90,
            height: 420,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceEvenly,
            alignItems: FlexAlign.center,
            children: [
              CanvasBox(
                width: 220,
                height: 320,
                padding: EdgeInsets.all(16.0),
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFE91E63,
                  opacity: 1.0,
                  borderRadius: EdgeInsets.all(20.0),
                ),
                children: [
                  CanvasText(
                    "OPACITY: 1.0\n(Control)",
                    color: 0xFFFFFFFF,
                    fontSize: 20.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                  CanvasBox(
                    width: 160,
                    height: 100,
                    justifyContent: FlexJustify.center,
                    alignItems: FlexAlign.center,
                    decoration: CanvasDecoration(
                      backgroundColor: 0xFFFFEB3B,
                      borderRadius: EdgeInsets.all(12.0),
                    ),
                    children: [
                      CanvasText(
                        "Opaque Child",
                        color: 0xFF000000,
                        weight: 800,
                      ),
                    ],
                  ),
                ],
              ),
              CanvasBox(
                width: 220,
                height: 320,
                padding: EdgeInsets.all(16.0),
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFE91E63,
                  opacity: 0.3,
                  borderRadius: EdgeInsets.all(20.0),
                ),
                children: [
                  CanvasText(
                    "OPACITY: 0.3\n(Parent + Child)",
                    color: 0xFFFFFFFF,
                    fontSize: 20.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                  CanvasBox(
                    width: 160,
                    height: 100,
                    justifyContent: FlexJustify.center,
                    alignItems: FlexAlign.center,
                    decoration: CanvasDecoration(
                      backgroundColor: 0xFFFFEB3B,
                      borderRadius: EdgeInsets.all(12.0),
                    ),
                    children: [
                      CanvasText(
                        "Faded Child",
                        color: 0xFF000000,
                        weight: 800,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.6: Blend Modes (Multiply Venn)
  static TestCase _case4_6() => TestCase(
    "4.6 Blend Modes (Multiply Venn)",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFFFFFFF),
        children: [
          CanvasBox(
            width: 420,
            height: 420,
            children: [
              CanvasBox(
                width: 240,
                height: 240,
                posType: PosType.absolute,
                top: 20,
                left: 30,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF00E5FF,
                  borderRadius: EdgeInsets.all(120.0),
                  blendMode: BlendMode.multiply,
                ),
                children: [CanvasText("CYAN", color: 0xFF000000, weight: 800)],
              ),
              CanvasBox(
                width: 240,
                height: 240,
                posType: PosType.absolute,
                top: 20,
                right: 30,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFF007F,
                  borderRadius: EdgeInsets.all(120.0),
                  blendMode: BlendMode.multiply,
                ),
                children: [
                  CanvasText("MAGENTA", color: 0xFFFFFFFF, weight: 800),
                ],
              ),
              CanvasBox(
                width: 240,
                height: 240,
                posType: PosType.absolute,
                bottom: 20,
                left: 90,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFFEA00,
                  borderRadius: EdgeInsets.all(120.0),
                  blendMode: BlendMode.multiply,
                ),
                children: [
                  CanvasText("YELLOW", color: 0xFF000000, weight: 800),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.7: Linear Gradient Fill
  static TestCase _case4_7() => TestCase(
    "4.7 Linear Gradient Fill",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF121212),
        children: [
          CanvasBox(
            width: 380,
            height: 200,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF8E2DE2, 0xFF4A00E0, 0xFF00E5FF],
              borderRadius: EdgeInsets.all(24.0),
              shadow: CanvasShadow(
                color: 0xAA00E5FF,
                offsetX: 0.0,
                offsetY: 12.0,
                blurRadius: 25.0,
              ),
            ),
            children: [
              CanvasText(
                "CYBERPUNK GRADIENT\n[Purple -> Indigo -> Cyan]",
                color: 0xFFFFFFFF,
                fontSize: 22.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 380,
            height: 200,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFFFF416C, 0xFFFF4B2B, 0xFFFFCA28],
              borderRadius: EdgeInsets.all(24.0),
              mirror: CanvasReflection(
                distance: 8.0,
                blurRadius: 6.0,
                opacity: 0.5,
              ),
            ),
            children: [
              CanvasText(
                "SUNSET GRADIENT + MIRROR\n[Pink -> Orange -> Gold]",
                color: 0xFFFFFFFF,
                fontSize: 22.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.8: Decoration Background Image
  static TestCase _case4_8() => TestCase(
    "4.8 Decoration Background Image",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFECEFF1),
        children: [
          CanvasBox(
            width: 360,
            height: 360,
            padding: EdgeInsets.all(24.0),
            justifyContent: FlexJustify.end,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF263238,
              backgroundImage: "DYNAMIC_IMAGE_PLACEHOLDER",
              isClip: true,
              borderRadius: EdgeInsets.all(32.0),
              borderColor: 0xFFFFFFFF,
              borderWidth: EdgeInsets.all(4.0),
              shadow: CanvasShadow(
                color: 0x99000000,
                offsetX: 0.0,
                offsetY: 18.0,
                blurRadius: 28.0,
                spreadRadius: 2.0,
              ),
              mirror: CanvasReflection(
                distance: 10.0,
                blurRadius: 8.0,
                opacity: 0.55,
              ),
            ),
            children: [
              CanvasBox(
                widthPct: 100,
                height: 80,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xCC000000,
                  borderRadius: EdgeInsets.all(16.0),
                ),
                children: [
                  CanvasText(
                    "DECORATION BG IMAGE\nMapped via backgroundImage",
                    color: 0xFFFFFFFF,
                    fontSize: 18.0,
                    weight: 700,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // Case 4.9: Rule-Based Clipping (EvenOdd vs NonZero)
  static TestCase _case4_9() => TestCase(
    "4.9 ClipRule: EvenOdd vs NonZero",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF1A1A2E),
        children: [
          CanvasBox(
            width: 240,
            height: 240,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF00E5FF,
              isClip: true,
              clipRule: ClipRule.nonZero,
              clipSvgPath:
              "M 0 0 L 240 0 L 240 240 L 0 240 Z M 60 60 L 180 60 L 180 180 L 60 180 Z",
              shadow: CanvasShadow(color: 0xAA00E5FF, blurRadius: 20.0),
            ),
            children: [
              CanvasText(
                "ClipRule.nonZero\n(Center Filled)",
                color: 0xFF000000,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 240,
            height: 240,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            padding: EdgeInsets.all(14.0),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFF2E93,
              isClip: true,
              clipRule: ClipRule.evenOdd,
              clipSvgPath:
              "M 0 0 L 240 0 L 240 240 L 0 240 Z M 60 60 L 180 60 L 180 180 L 60 180 Z",
              shadow: CanvasShadow(color: 0xAAFF2E93, blurRadius: 20.0),
            ),
            children: [
              CanvasText(
                "ClipRule.evenOdd",
                color: 0xFFFFFFFF,
                fontSize: 16.0,
                weight: 800,
              ),
              CanvasText(
                "HOLLOW CENTER HOLE",
                color: 0xFFFFFFFF,
                fontSize: 14.0,
                weight: 800,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 4.10: Advanced SVG Shield Clip
  static TestCase _case4_10() => TestCase(
    "4.10 Advanced SVG Shield Clip",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 320,
            height: 360,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              isClip: true,
              clipSvgPath:
              "M 160 0 C 220 30 280 30 320 40 C 320 180 280 280 160 360 C 40 280 0 180 0 40 C 40 30 100 30 160 0 Z",
              shadow: CanvasShadow(
                color: 0xAA000000,
                offsetX: 0.0,
                offsetY: 16.0,
                blurRadius: 24.0,
                spreadRadius: 2.0,
              ),
              mirror: CanvasReflection(
                distance: 10.0,
                blurRadius: 7.0,
                opacity: 0.55,
              ),
            ),
            children: [
              CanvasBox(
                width: 160,
                height: 180,
                posType: PosType.absolute,
                top: 0,
                left: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFFE53935),
              ),
              CanvasBox(
                width: 160,
                height: 180,
                posType: PosType.absolute,
                bottom: 0,
                right: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFF1E88E5),
              ),
              CanvasBox(
                width: 180,
                height: 180,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFFCA28,
                  shape: BoxShape.circle,
                  shadow: CanvasShadow(
                    color: 0x99000000,
                    blurRadius: 15.0,
                    offsetY: 6.0,
                  ),
                ),
                children: [
                  CanvasText(
                    "SHIELD\nCLIP 4.10",
                    color: 0xFF1E293B,
                    fontSize: 22.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
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