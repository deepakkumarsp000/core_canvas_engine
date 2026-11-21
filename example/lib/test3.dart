// FILE: example/lib/test3.dart
import 'test_registry.dart';

class Test3Cases {
  static const String _cat = "3. 3D Layering & Absolute Space";

  static List<TestCase> getCases() {
    return [
      _case3_1(),
      _case3_2(),
      _case3_3(),
      _case3_4(),
      _case3_5(),
      _case3_6(),
      _case3_7(),
      _case3_8(),
      _case3_9(),
      _case3_10(),
      _case3_11(),
      _case3_12(),
      _case3_13(),
      _case3_14(),
      _case3_15(),
      _case3_16(),
      _case3_17(),
      _case3_18(),
      _case3_19(),
      _case3_20(),
      _case3_21(),
    ];
  }

  // Case 3.1: Relative Offset Push
  static TestCase _case3_1() => TestCase(
    "3.1 Relative Offset Push",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        direction: FlexDir.row,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(width: 100, height: 100, decoration: CanvasDecoration(backgroundColor: 0xFF9E9E9E)),
          CanvasBox(
            width: 100,
            height: 100,
            posType: PosType.relative,
            top: 40.0,
            left: 20.0,
            decoration: CanvasDecoration(backgroundColor: 0xFFE91E63),
            children: [CanvasText("Relative\nT:40 L:20", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
          ),
          CanvasBox(width: 100, height: 100, decoration: CanvasDecoration(backgroundColor: 0xFF9E9E9E)),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.2: Absolute Corners
  static TestCase _case3_2() => TestCase(
    "3.2 Absolute Corners",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 400,
            height: 400,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(width: 80, height: 80, posType: PosType.absolute, top: 0, left: 0, decoration: CanvasDecoration(backgroundColor: 0xFFF44336)),
              CanvasBox(width: 80, height: 80, posType: PosType.absolute, top: 0, right: 0, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50)),
              CanvasBox(width: 80, height: 80, posType: PosType.absolute, bottom: 0, left: 0, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3)),
              CanvasBox(width: 80, height: 80, posType: PosType.absolute, bottom: 0, right: 0, decoration: CanvasDecoration(backgroundColor: 0xFFFFC107)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.3: Absolute Percentage Offsets
  static TestCase _case3_3() => TestCase(
    "3.3 Absolute Pct Offsets",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 400,
            height: 400,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                topPct: 50.0,
                leftPct: 50.0,
                decoration: CanvasDecoration(backgroundColor: 0xFF673AB7),
                children: [CanvasText("T:50% L:50%", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.4: Z-Index Inversion (-1 behind parent)
  static TestCase _case3_4() => TestCase(
    "3.4 Z-Index Inversion (-1)",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            decoration: CanvasDecoration(backgroundColor: 0xFF00BCD4),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                top: -20,
                left: -20,
                zIndex: -1,
                decoration: CanvasDecoration(backgroundColor: 0xFFE91E63),
                children: [CanvasText("Z: -1", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.5: Z-Index Interleaving
  static TestCase _case3_5() => TestCase(
    "3.5 Z-Index Interleaving",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 300,
            height: 300,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(width: 150, height: 150, posType: PosType.absolute, top: 20, left: 20, zIndex: 10, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50)),
              CanvasBox(width: 150, height: 150, posType: PosType.absolute, top: 40, left: 40, zIndex: 5, decoration: CanvasDecoration(backgroundColor: 0xFFF44336)),
              CanvasBox(width: 150, height: 150, posType: PosType.absolute, top: 60, left: 60, zIndex: 20, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.6: Absolute Center Deadlock
  static TestCase _case3_6() => TestCase(
    "3.6 Absolute Center Deadlock",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.start,
        alignItems: FlexAlign.flexStart,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 400,
            height: 400,
            posType: PosType.relative,
            marginAuto: true,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                marginAuto: true,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5722),
                children: [CanvasText("Deadlock\nCenter", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.7: Static Fallback
  static TestCase _case3_7() => TestCase(
    "3.7 Static Fallback",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            posType: PosType.static,
            top: 500,
            left: 500,
            bottom: -9999,
            right: 8888,
            topPct: 200,
            leftPct: -50,
            decoration: CanvasDecoration(backgroundColor: 0xFF9C27B0),
            children: [
              CanvasText(
                "Static Fallback\nExact Center\nGarbage Ignored",
                color: 0xFFFFFFFF,
                align: TextAlign.center,
                weight: 700,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.8: Out-of-Bounds Absolute
  static TestCase _case3_8() => TestCase(
    "3.8 Out-of-Bounds Absolute",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                top: -50,
                left: -50,
                decoration: CanvasDecoration(backgroundColor: 0xFF009688),
                children: [CanvasText("Out of\nBounds", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.9: Nested Absolute Contexts
  static TestCase _case3_9() => TestCase(
    "3.9 Nested Absolute Contexts",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            widthPct: 50,
            heightPct: 50,
            posType: PosType.absolute,
            top: 0,
            left: 0,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                bottom: 0,
                right: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF9800),
                children: [CanvasText("Nested BR", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.10: Overflow Hidden clipping Absolute
  static TestCase _case3_10() => TestCase(
    "3.10 Overflow Hidden Clipping",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                right: -75,
                bottom: -75,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Clipped", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.11: overflow: 0, isClip: false
  static TestCase _case3_11() => TestCase(
    "3.11 Overflow 0, isClip False",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.visible,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, isClip: false),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                right: -75,
                bottom: -75,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("No Clip", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.12: overflow: 1, isClip: false
  static TestCase _case3_12() => TestCase(
    "3.12 Overflow 1, isClip False",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, isClip: false),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                right: -75,
                bottom: -75,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Layout\nClipped", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.13: overflow: 0, isClip: true
  static TestCase _case3_13() => TestCase(
    "3.13 Overflow 0, isClip True",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.visible,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, isClip: true),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                right: -75,
                bottom: -75,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Mask\nClipped", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.14: overflow: 1, isClip: true
  static TestCase _case3_14() => TestCase(
    "3.14 Overflow 1, isClip True",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, isClip: true),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                right: -75,
                bottom: -75,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Double\nClipped", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.15: BorderRadius with Overflow Hidden
  static TestCase _case3_15() => TestCase(
    "3.15 Border Radius + Overflow",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, borderRadius: EdgeInsets.all(220)),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                right: -20,
                top: -20,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252, borderRadius: EdgeInsets.all(90)),
                children: [CanvasText("Round\nClip 1", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.16: BorderRadius with isClip True
  static TestCase _case3_16() => TestCase(
    "3.16 Border Radius + isClip",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.visible,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF3F51B5,
              isClip: true,
              borderRadius: EdgeInsets.all(50),
              shadow: CanvasShadow(color: 0xFF000000, offsetX: 0.0, offsetY: 15.0, blurRadius: 25.0, spreadRadius: 0.0),
            ),
            children: [
              CanvasBox(
                width: 100,
                height: 100,
                posType: PosType.absolute,
                left: -20,
                bottom: -20,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Round\nClip 2", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.17: SVG Path Clipping (Triangle Mask)
  static TestCase _case3_17() => TestCase(
    "3.17 SVG Path Clipping",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5, isClip: true, clipSvgPath: "M 100 0 L 200 200 L 0 200 Z"),
            children: [
              CanvasBox(
                width: 200,
                height: 200,
                posType: PosType.absolute,
                top: 0,
                left: 0,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Triangle\nClipped", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.18: Nested Dynamic Clips (Radius + SVG)
  static TestCase _case3_18() => TestCase(
    "3.18 Nested Clips + Black & White Shadows",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 350,
            height: 350,
            overflow: Overflow.hidden,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              isClip: true,
              borderRadius: EdgeInsets.all(40.0),
              shadow: CanvasShadow(color: 0x99000000, offsetX: 0.0, offsetY: 15.0, blurRadius: 15.0, spreadRadius: 2.0),
              mirror: CanvasReflection(distance: 10.0, blurRadius: 8.0, opacity: 0.6),
            ),
            children: [
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                widthPct: 100,
                heightPct: 100,
                posType: PosType.absolute,
                top: 0,
                left: 0,
                fit: ImageFit.cover,
              ),
              CanvasBox(
                width: 200,
                height: 200,
                decoration: CanvasDecoration(
                  isClip: true,
                  clipSvgPath: "DYNAMIC_SVG_PLACEHOLDER",
                  shadow: CanvasShadow(color: 0xDDFFFFFF, offsetX: 0.0, offsetY: 5.0, blurRadius: 10.0, spreadRadius: 2.0),
                ),
                children: [
                  CanvasImage(
                    base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                    widthPct: 100,
                    heightPct: 100,
                    fit: ImageFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsSvgFile: true,
    needsImageFile: true,
  );

  // Case 3.19: The Ultimate 6-Level Nested Clipping Nightmare
  static TestCase _case3_19() => TestCase(
    "3.19 Ultimate 6-Level SVG Clip",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 400,
            height: 400,
            decoration: CanvasDecoration(backgroundColor: 0xFF1A237E, isClip: true, clipSvgPath: "DYNAMIC_SVG_PLACEHOLDER"),
            children: [
              CanvasBox(
                width: 300,
                height: 300,
                posType: PosType.absolute,
                top: -40,
                right: -40,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF009688,
                  isClip: true,
                  clipMath: "M 150 0 L 300 75 L 300 225 L 150 300 L 0 225 L 0 75 Z",
                ),
                children: [
                  CanvasBox(
                    width: 250,
                    height: 250,
                    posType: PosType.absolute,
                    bottom: -50,
                    left: -30,
                    overflow: Overflow.hidden,
                    decoration: CanvasDecoration(backgroundColor: 0xFFFFC107, borderRadius: EdgeInsets.all(40)),
                    children: [
                      CanvasBox(
                        width: 200,
                        height: 200,
                        posType: PosType.absolute,
                        bottom: -20,
                        right: -40,
                        decoration: CanvasDecoration(
                          backgroundColor: 0xFFFF5722,
                          isClip: true,
                          clipSvgPath: "M 100 0 L 200 200 L 0 200 Z",
                        ),
                        children: [
                          CanvasBox(
                            width: 150,
                            height: 150,
                            posType: PosType.absolute,
                            top: -30,
                            left: -30,
                            overflow: Overflow.hidden,
                            decoration: CanvasDecoration(backgroundColor: 0xFFE91E63),
                            children: [
                              CanvasBox(
                                width: 100,
                                height: 100,
                                posType: PosType.absolute,
                                top: 25,
                                right: -30,
                                overflow: Overflow.hidden,
                                decoration: CanvasDecoration(backgroundColor: 0xFF9C27B0, borderRadius: EdgeInsets.all(50)),
                                justifyContent: FlexJustify.center,
                                alignItems: FlexAlign.center,
                                children: [
                                  CanvasText("CORE\nL-6", color: 0xFFFFFFFF, align: TextAlign.center, weight: 700),
                                ],
                              ),
                            ],
                          ),
                        ],
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
    needsSvgFile: true,
  );

  // Case 3.20: The Z-Index Escaper
  static TestCase _case3_20() => TestCase(
    "3.20 Negative Z-Index vs Clip",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                posType: PosType.absolute,
                left: -50,
                top: -50,
                zIndex: -1,
                decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
                children: [CanvasText("Z-Index\nTrapped", color: 0xFFFFFFFF, align: TextAlign.center)],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 3.21: Text FX Tri-Test (Shadow, Mirror, Both)
  static TestCase _case3_21() => TestCase(
    "3.21 True Text Raster FX",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF121212),
        children: [
          CanvasText(
            "SHADOW ONLY",
            color: 0xFF00E5FF,
            fontSize: 48.0,
            weight: 800,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAA00E5FF, offsetX: 0.0, offsetY: 0.0, blurRadius: 20.0),
            ),
          ),
          CanvasText(
            "MIRROR ONLY",
            color: 0xFFFFEB3B,
            fontSize: 48.0,
            weight: 800,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              mirror: CanvasReflection(distance: 2.0, blurRadius: 4.0, opacity: 0.5),
            ),
          ),
          CanvasText(
            "BOTH FX ENABLED",
            color: 0xFFFF5252,
            fontSize: 48.0,
            weight: 800,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAAFF5252, offsetX: 0.0, offsetY: 0.0, blurRadius: 25.0),
              mirror: CanvasReflection(distance: 2.0, blurRadius: 6.0, opacity: 0.6),
            ),
          ),
        ],
      ),
    ),
    category: _cat,
  );
}