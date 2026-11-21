// FILE: example/lib/test2.dart
import 'test_registry.dart';

class Test2Cases {
  static const String _cat = "2. The Flexbox Chaos";

  static List<TestCase> getCases() {
    return [
      _case2_1(),
      _case2_2(),
      _case2_3(),
      _case2_4(),
      _case2_5(),
      _case2_6(),
      _case2_7(),
      _case2_8(),
      _case2_9(),
      _case2_10(),
      _case2_11(),
    ];
  }

  // Helper method to generate small colored blocks for Flex wrap tests
  static List<CanvasBox> _generateBlocks(int count, int baseColor) {
    return List.generate(count, (i) {
      return CanvasBox(
        width: 50,
        height: 50,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: baseColor + (i * 0x000505)),
        children: [CanvasText("${i + 1}", color: 0xFFFFFFFF, weight: 700)],
      );
    });
  }

  // Case 2.1: Flex Wrap & Global Gap
  static TestCase _case2_1() => TestCase(
    "2.1 Flex Wrap & Gap",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20),
        direction: FlexDir.row,
        wrap: FlexWrap.wrap,
        gap: 15.0,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: _generateBlocks(25, 0xFFE91E63),
      ),
    ),
    category: _cat,
  );

  // Case 2.2: Column Reverse Alignment
  static TestCase _case2_2() => TestCase(
    "2.2 Column Reverse",
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
            height: 400,
            direction: FlexDir.columnReverse,
            justifyContent: FlexJustify.start,
            gap: 10.0,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(widthPct: 100, height: 80, decoration: CanvasDecoration(backgroundColor: 0xFFF44336)),
              CanvasBox(widthPct: 100, height: 80, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50)),
              CanvasBox(widthPct: 100, height: 80, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.3: Justify Space Evenly vs Space Around
  static TestCase _case2_3() => TestCase(
    "2.3 Space Evenly vs Around",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20),
        direction: FlexDir.column,
        gap: 40,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            widthPct: 100,
            height: 100,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceEvenly,
            decoration: CanvasDecoration(backgroundColor: 0xFFCFD8DC),
            children: _generateBlocks(4, 0xFF673AB7),
          ),
          CanvasBox(
            widthPct: 100,
            height: 100,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceAround,
            decoration: CanvasDecoration(backgroundColor: 0xFFCFD8DC),
            children: _generateBlocks(4, 0xFFFF9800),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.4: Align Baseline
  static TestCase _case2_4() => TestCase(
    "2.4 Align Baseline",
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
            height: 200,
            direction: FlexDir.row,
            alignItems: FlexAlign.baseline,
            justifyContent: FlexJustify.center,
            gap: 15.0,
            decoration: CanvasDecoration(backgroundColor: 0xFFBBDEFB),
            children: [
              CanvasText("Small", fontSize: 12, decoration: CanvasDecoration(backgroundColor: 0xFFFFC107)),
              CanvasText("MASSIVE", fontSize: 48, weight: 700, decoration: CanvasDecoration(backgroundColor: 0xFFFFC107)),
              CanvasText("Medium", fontSize: 24, decoration: CanvasDecoration(backgroundColor: 0xFFFFC107)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.5: Axis-Specific Gaps
  static TestCase _case2_5() => TestCase(
    "2.5 Row & Col Specific Gaps",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(40),
        direction: FlexDir.row,
        wrap: FlexWrap.wrap,
        rowGap: 50.0,
        colGap: 5.0,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: _generateBlocks(16, 0xFF009688),
      ),
    ),
    category: _cat,
  );

  // Case 2.6: Fractional Flex Growth
  static TestCase _case2_6() => TestCase(
    "2.6 Fractional Flex Growth",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20),
        direction: FlexDir.row,
        gap: 10,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFFF44336)),
          CanvasBox(flexGrow: 2.5, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50)),
          CanvasBox(flexGrow: 0.5, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3)),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.7: Aggressive Flex Shrink
  static TestCase _case2_7() => TestCase(
    "2.7 Aggressive Flex Shrink",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20),
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 400,
            height: 100,
            direction: FlexDir.row,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(width: 300, heightPct: 100, flexShrink: 0.0, decoration: CanvasDecoration(backgroundColor: 0xFF000000)),
              CanvasBox(width: 300, heightPct: 100, flexShrink: 2.0, decoration: CanvasDecoration(backgroundColor: 0xFFFFEB3B)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.8: Flex Basis (Fixed vs Pct)
  static TestCase _case2_8() => TestCase(
    "2.8 Flex Basis",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20),
        direction: FlexDir.column,
        gap: 20,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            widthPct: 100,
            height: 200,
            direction: FlexDir.row,
            decoration: CanvasDecoration(backgroundColor: 0xFFCFD8DC),
            children: [
              CanvasBox(flexBasis: 150.0, flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF9C27B0)),
              CanvasBox(flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF00BCD4)),
            ],
          ),
          CanvasBox(
            widthPct: 100,
            height: 200,
            direction: FlexDir.row,
            decoration: CanvasDecoration(backgroundColor: 0xFFCFD8DC),
            children: [
              CanvasBox(flexBasisPct: 40.0, flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF795548)),
              CanvasBox(flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF8BC34A)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.9: Align Self Override
  static TestCase _case2_9() => TestCase(
    "2.9 Align Self Override",
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
            direction: FlexDir.row,
            alignItems: FlexAlign.flexStart,
            gap: 10.0,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(width: 80, height: 80, decoration: CanvasDecoration(backgroundColor: 0xFF607D8B)),
              CanvasBox(width: 80, height: 80, alignSelf: FlexAlign.center, decoration: CanvasDecoration(backgroundColor: 0xFFE91E63)),
              CanvasBox(width: 80, height: 80, alignSelf: FlexAlign.flexEnd, decoration: CanvasDecoration(backgroundColor: 0xFF009688)),
              CanvasBox(width: 80, alignSelf: FlexAlign.stretch, decoration: CanvasDecoration(backgroundColor: 0xFFFF5722)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.10: Display None Toggle
  static TestCase _case2_10() => TestCase(
    "2.10 Display None",
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
            height: 100,
            direction: FlexDir.row,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50)),
              CanvasBox(width: 100, heightPct: 100, display: FlexDisplay.none, decoration: CanvasDecoration(backgroundColor: 0xFFF44336)),
              CanvasBox(flexGrow: 1.0, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3)),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 2.11: Layout Direction Override (Node-level RTL)
  static TestCase _case2_11() => TestCase(
    "2.11 Node RTL Override",
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
            height: 100,
            direction: FlexDir.row,
            layoutDirection: LayoutDirection.rtl,
            decoration: CanvasDecoration(backgroundColor: 0xFFBDBDBD),
            children: [
              CanvasBox(width: 100, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFFFF5252), children: [CanvasText("1", align: TextAlign.center)]),
              CanvasBox(width: 100, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50), children: [CanvasText("2", align: TextAlign.center)]),
              CanvasBox(width: 100, heightPct: 100, decoration: CanvasDecoration(backgroundColor: 0xFF2196F3), children: [CanvasText("3", align: TextAlign.center)]),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );
}