// FILE: lib/test0.dart
// 🚀 FAANG FIX: Clean Single-Import via test_registry.dart + Added missing category on Case 0.2!

import 'test_registry.dart';

class Test0Cases {
  static const String _cat = "0. Config & Meta";

  static List<TestCase> getCases() {
    return [
      _case0_1(),
      _case0_2(),
      _case0_3(),
      _case0_4(),
      _case0_5(),
      _case0_6(),
      _case0_7(),
      _case0_8(),
      _case0_9(),
      _case0_10(),
      _case0_11(),
      _case0_12(),
      _case0_13(),
      _case0_14(),
    ];
  }

  // Case 0.12: Layer 1 - Parent Flex Centering
  static TestCase _case0_12() => TestCase(
    "0.12 Layer 1: Parent Flex Centering",
    CanvasDocument(
      format: const CanvasFormat(500.0, 700.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            direction: FlexDir.column,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50),
            children: [
              CanvasText(
                "Hello World",
                fontSize: 20,
                weight: 700,
                color: 0xFFFFFFFF,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.13: Layer 2 - Margin Auto Centering
  static TestCase _case0_13() => TestCase(
    "0.13 Layer 2: Margin Auto Centering",
    CanvasDocument(
      format: const CanvasFormat(500.0, 700.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.start,
        alignItems: FlexAlign.flexStart,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasBox(
            width: 200,
            height: 200,
            marginAuto: true,
            decoration: CanvasDecoration(backgroundColor: 0xFF2196F3),
            children: [
              CanvasText(
                "Hello World",
                fontSize: 20,
                weight: 700,
                color: 0xFFFFFFFF,
                marginAuto: true,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.14: Layer 3 - Internal Typography Centering
  static TestCase _case0_14() => TestCase(
    "0.14 Layer 3: Internal Typography Centering",
    CanvasDocument(
      format: const CanvasFormat(500.0, 700.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFEAEAEA),
        children: [
          CanvasText(
            "Hello World",
            width: 200,
            height: 200,
            fontSize: 20,
            weight: 700,
            color: 0xFFFFFFFF,
            align: TextAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFFF9800),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.1: Standard A4 Vertical (The Benchmark)
  static TestCase _case0_1() => TestCase(
    "0.1 Standard A4 Vertical",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.pdf,
      layoutDirection: LayoutDirection.ltr,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFE5E5E5),
        children: [
          CanvasText(
            "Standard A4 Document (Benchmark)",
            fontSize: 24,
            weight: 700,
            color: 0xFF000000,
            widthPct: 100,
            height: 30,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.11: Centered Container with Centered Text
  static TestCase _case0_11() => TestCase(
    "0.11 Centered Container & Text",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.pdf,
      layoutDirection: LayoutDirection.ltr,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFE5E5E5),
        children: [
          CanvasBox(
            width: 400,
            height: 200,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFF2196F3),
            children: [
              CanvasText(
                "I am perfectly centered!",
                widthPct: 100,
                heightPct: 100,
                fontSize: 28,
                weight: 700,
                color: 0xFFFFFFFF,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.2: Custom Dimensions & Margin (Instagram Square)
  static TestCase _case0_2() => TestCase(
    "0.2 Custom Dimensions (1080x1080)",
    CanvasDocument(
      format: const CanvasFormat(1080.0, 1080.0),
      canvasMargin: EdgeInsets.all(50.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF007AFF),
        children: [
          CanvasText(
            "1080x1080 Custom Format & 50px Margin",
            fontSize: 36,
            weight: 700,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 50,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.3: Landscape Orientation (A5 Horizontal)
  static TestCase _case0_3() => TestCase(
    "0.3 Landscape Orientation (A5)",
    CanvasDocument(
      format: const CanvasFormat(595.0, 420.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF4CAF50),
        children: [
          CanvasText(
            "Landscape Mode (W:595, H:420)",
            fontSize: 28,
            weight: 700,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 40,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.4: Full Metadata Injection (Acrobat Properties)
  static TestCase _case0_4() => TestCase(
    "0.4 Full Metadata Injection",
    CanvasDocument(
      title: "Confidential Report",
      author: "Core Canvas Admin",
      subject: "Engine Stress Testing",
      keywords: "PDF, C++, Layout, Fast",
      creator: "Flutter Frontend",
      producer: "Zero-Bloat C++ Layer",
      creationDate: "2026-10-05",
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 15.0,
        children: [
          CanvasText(
            "Metadata Injected Successfully!",
            fontSize: 24,
            weight: 700,
            color: 0xFF000000,
            widthPct: 100,
            height: 30,
            align: TextAlign.center,
          ),
          CanvasText(
            "Check Document Properties (Ctrl+D in Acrobat)",
            fontSize: 16,
            color: 0xFF555555,
            widthPct: 100,
            height: 20,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.5: Viewer Preferences Lockdown (Presentation Mode)
  static TestCase _case0_5() => TestCase(
    "0.5 Viewer Preferences (Kiosk)",
    CanvasDocument(
      hideToolbar: true,
      hideMenubar: true,
      fitWindow: true,
      pageMode: PdfPageMode.fullScreen,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF222222),
        children: [
          CanvasText(
            "Presentation Mode Enforced",
            fontSize: 28,
            color: 0xFF00FF00,
            widthPct: 100,
            height: 40,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.6: Header & Footer Injection (Single Page)
  static TestCase _case0_6() => TestCase(
    "0.6 Header & Footer Spanning",
    CanvasDocument(
      header: CanvasBox(
        widthPct: 100,
        height: 60,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5),
        children: [
          CanvasText(
            "COMPANY HEADER",
            fontSize: 20,
            weight: 700,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 25,
            align: TextAlign.center,
          ),
        ],
      ),
      footer: CanvasBox(
        widthPct: 100,
        height: 40,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF3F51B5),
        children: [
          CanvasText(
            "Page 1 - Confidential Footer",
            fontSize: 14,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 20,
            align: TextAlign.center,
          ),
        ],
      ),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF0F0F0),
        children: [
          CanvasText(
            "Main Body Content (Squeezed between H/F)",
            fontSize: 20,
            color: 0xFF000000,
            widthPct: 100,
            height: 30,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.7: Right-To-Left (RTL) Root Direction
  static TestCase _case0_7() => TestCase(
    "0.7 RTL Root Direction",
    CanvasDocument(
      layoutDirection: LayoutDirection.rtl,
      body: CanvasBox(
        direction: FlexDir.row,
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.start,
        children: [
          CanvasBox(
            width: 150,
            heightPct: 100,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFFF5252),
            children: [
              CanvasText(
                "Right Block (1)",
                color: 0xFFFFFFFF,
                widthPct: 100,
                height: 20,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            flexGrow: 1.0,
            heightPct: 100,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFF00BCD4),
            children: [
              CanvasText(
                "Left Block (2)",
                color: 0xFFFFFFFF,
                widthPct: 100,
                height: 20,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.8: Quality & Color Space Overrides (Print Prep)
  static TestCase _case0_8() => TestCase(
    "0.8 Print Prep (CMYK & 300 DPI)",
    CanvasDocument(
      colorSpace: ColorSpace.cmyk,
      exportQuality: 100,
      dpi: 300,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFE8F5E9),
        children: [
          CanvasText(
            "Print Quality Engine Settings Applied",
            fontSize: 24,
            color: 0xFF2E7D32,
            widthPct: 100,
            height: 35,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 0.9: Heavy Header, No Body (Edge Case)
  static TestCase _case0_9() => TestCase(
    "0.9 Heavy Header & Zero Body",
    CanvasDocument(
      header: CanvasBox(
        widthPct: 100,
        height: 600,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFFF9800),
        children: [
          CanvasText(
            "MASSIVE HEADER (600px)",
            fontSize: 36,
            weight: 700,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 50,
            align: TextAlign.center,
          ),
        ],
      ),
      body: CanvasBox(width: 0, height: 0),
    ),
    category: _cat,
  );

  // Case 0.10: Lossless Export Flag
  static TestCase _case0_10() => TestCase(
    "0.10 Lossless Export Flag",
    CanvasDocument(
      lossless: true,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF607D8B),
        children: [
          CanvasText(
            "Lossless Export = TRUE",
            fontSize: 26,
            weight: 700,
            color: 0xFFFFFFFF,
            widthPct: 100,
            height: 40,
            align: TextAlign.center,
          ),
        ],
      ),
    ),
    category: _cat,
  );
}