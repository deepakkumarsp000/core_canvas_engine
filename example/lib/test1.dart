// FILE: lib/test1.dart
// 🚀 FAANG FIX: Clean Single-Import via test_registry.dart!

import 'test_registry.dart';

class Test1Cases {
  static const String _cat = "1. Dimensions & Constraints";

  static List<TestCase> getCases() {
    return [
      _case1_1(),
      _case1_2(),
      _case1_3(),
      _case1_4(),
      _case1_5(),
      _case1_6(),
      _case1_7(),
      _case1_8(),
      _case1_9(),
      _case1_10(),
    ];
  }

  // Case 1.1: Standard Fixed Width & Height (w, h)
  static TestCase _case1_1() => TestCase(
    "1.1 Standard Fixed (w, h)",
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
            height: 150,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
            children: [
              CanvasText("200 x 150 Fixed", color: 0xFFFFFFFF, weight: 700),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 1.2: Pure Percentage Scaling (wPct, hPct inside a fixed parent)
  static TestCase _case1_2() => TestCase(
    "1.2 Pure Percentage Scaling",
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
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                widthPct: 50,
                heightPct: 50,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50),
                children: [
                  CanvasText("50% (200x200)", color: 0xFFFFFFFF, weight: 700),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 1.3: Min/Max Clash (minW > maxW - check engine failsafe)
  static TestCase _case1_3() => TestCase(
    "1.3 Min-Max Clash Failsafe",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            minWidth: 300,
            maxWidth: 100,
            height: 100,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFFF9800),
            children: [
              CanvasText(
                "MinW:300 > MaxW:100\n(Engine should output 300)",
                color: 0xFFFFFFFF,
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

  // Case 1.4: Aspect Ratio Lock (w fixed, aspectRatio driven h)
  static TestCase _case1_4() => TestCase(
    "1.4 Aspect Ratio Lock (w fixed)",
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
            aspectRatio: 2.0,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFF9C27B0),
            children: [
              CanvasText(
                "W:200, Ratio:2.0\n(Should be 200x100)",
                color: 0xFFFFFFFF,
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

  // Case 1.5: Dynamic Aspect Ratio (hPct driven, aspectRatio driven w)
  static TestCase _case1_5() => TestCase(
    "1.5 Dynamic Aspect Ratio (hPct)",
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
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                heightPct: 50,
                aspectRatio: 0.5,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5),
                children: [
                  CanvasText(
                    "hPct:50, Ratio:0.5\n(100x200)",
                    color: 0xFFFFFFFF,
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
  );

  // Case 1.6: Percentage Min/Max Limits (minWPct, maxHPct)
  static TestCase _case1_6() => TestCase(
    "1.6 Percentage Min-Max Limits",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 500,
            height: 500,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                widthPct: 10,
                minWidthPct: 50,
                heightPct: 100,
                maxHeightPct: 40,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF00BCD4),
                children: [
                  CanvasText(
                    "minWPct overrides wPct\nmaxHPct limits hPct",
                    color: 0xFFFFFFFF,
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
  );

  // Case 1.7: Auto Margin Centering (marginAuto: true with strict width)
  static TestCase _case1_7() => TestCase(
    "1.7 Auto Margin Centering",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.row,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 150,
            height: 150,
            marginAuto: true,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFE91E63),
            children: [
              CanvasText("marginAuto: true", color: 0xFFFFFFFF, weight: 700),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 1.8: Padding Percentages (paddingPct based on parent width)
  static TestCase _case1_8() => TestCase(
    "1.8 Padding Percentages",
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
            paddingPct: EdgeInsets.all(10.0),
            decoration: CanvasDecoration(backgroundColor: 0xFF333333),
            children: [
              CanvasBox(
                widthPct: 100,
                heightPct: 100,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF8BC34A),
                children: [
                  CanvasText(
                    "10% Parent Padding",
                    color: 0xFF000000,
                    weight: 700,
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

  // Case 1.9: Margin Percentages (marginPct pushing element off-center)
  static TestCase _case1_9() => TestCase(
    "1.9 Margin Percentages",
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
            alignItems: FlexAlign.flexStart,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(
                width: 150,
                height: 150,
                marginPct: EdgeInsets.only(left: 20.0, top: 10.0),
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(backgroundColor: 0xFF673AB7),
                children: [
                  CanvasText(
                    "20% Left, 10% Top\nMargin",
                    color: 0xFFFFFFFF,
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
  );

  // Case 1.10: Extreme Nested Padding Shrink (Padding > Width causing internal collapse)
  static TestCase _case1_10() => TestCase(
    "1.10 Extreme Padding Collapse",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(60.0),
            decoration: CanvasDecoration(backgroundColor: 0xFFF44336),
            children: [
              CanvasBox(
                widthPct: 100,
                heightPct: 100,
                decoration: CanvasDecoration(backgroundColor: 0xFF000000),
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );
}