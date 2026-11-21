// FILE: example/lib/test6.dart
// PURPOSE: TEST 6 - The Multi-Page Pagination, Blind-Cut, Smart-Cut & Custom-Threshold Suite

import 'test_registry.dart';

class Test6Cases {
  static const String _cat =
      "6. Multi-Page & Spanning Rules (Blind / Smart / Custom Cut)";

  static List<TestCase> getCases() {
    return [
      _case6_1(),
      _case6_2(),
      _case6_3(),
      _case6_4(),
      _case6_5(),
      _case6_6(),
      _case6_7(),
      _case6_8(),
      _case6_9(),
      _case6_10(),
      _case6_11(),
      _case6_12(),
      _case6_13(),
    ];
  }

  // Case 6.1: Default Blind Cut (Half-Box & Half-Text)
  static TestCase _case6_1() => TestCase(
    "6.1 Default Blind Cut (Half-Box & Half-Text)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF8FAFC),
        children: [
          CanvasBox(
            width: 520,
            height: 700,
            padding: EdgeInsets.all(24.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFE2E8F0,
              borderColor: 0xFF64748B,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "CASE 6.1: DEFAULT BLIND CUT\n(Top Spacer: 700px | A4 Page Height: 842px)",
                color: 0xFF0F172A,
                fontSize: 20.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Niche sirf 142px jagah bachi hai.\nAgla 280px container bina kisi rule ke hai, isliye wo aur uske beech ka 32pt text AADHA PAGE 1 par aur AADHA PAGE 2 par BLIND CUT hoga!",
                color: 0xFF334155,
                fontSize: 15.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 280,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            padding: EdgeInsets.all(16.0),
            decoration: CanvasDecoration(
              gradient: const [0xFF7C3AED, 0xFFEC4899],
              gradientAngle: 45.0,
              borderColor: 0xFF0F172A,
              borderWidth: EdgeInsets.all(4.0),
            ),
            children: [
              CanvasText(
                "TOP HALF OF CONTAINER (VISIBLE ON PAGE 1)",
                color: 0xFFFFFFFF,
                fontSize: 16.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "✂️ BLIND CUT TEXT ✂️",
                color: 0xFFFFEA00,
                fontSize: 34.0,
                weight: 900,
                align: TextAlign.center,
              ),
              CanvasText(
                "BOTTOM HALF OF CONTAINER (VISIBLE ON PAGE 2)",
                color: 0xFFFFFFFF,
                fontSize: 16.0,
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

  // Case 6.2: Smart Cut (Shift to Next Page + Cascade)
  static TestCase _case6_2() => TestCase(
    "6.2 Smart Cut (Shift to Next Page + Cascade)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        gap: 16.0,
        decoration: CanvasDecoration(backgroundColor: 0xFFF1F5F9),
        children: [
          CanvasBox(
            width: 520,
            height: 700,
            padding: EdgeInsets.all(24.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFDBEAFE,
              borderColor: 0xFF2563EB,
              borderWidth: EdgeInsets.all(2.0),
              borderRadius: EdgeInsets.all(12.0),
            ),
            children: [
              CanvasText(
                "CASE 6.2: SMART CUT (avoidPageBreakInside)",
                color: 0xFF1E3A8A,
                fontSize: 20.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Niche Page 1 par sirf 126px jagah bachi hai.\nAgla Green Card 240px ka hai aur uspe Smart Cut (.avoidPageBreakInside()) laga hai.\nIsliye wo yahan NAHI katega, seedha Page 2 ke TOP par jayega!",
                color: 0xFF1E40AF,
                fontSize: 15.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 240,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(pageBreakInside: 1),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF065F46,
              borderRadius: EdgeInsets.all(18.0),
              borderColor: 0xFF10B981,
              borderWidth: EdgeInsets.all(3.0),
            ),
            children: [
              CanvasText(
                "✅ SMART CUT CARD (100% INTACT ON PAGE 2!)\nRefused to be cut on Page 1 because 240px > 126px!\nShifted cleanly to the top of Page 2.",
                color: 0xFFFFFFFF,
                fontSize: 17.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 90,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFEF08A,
              borderColor: 0xFFCA8A04,
              borderWidth: EdgeInsets.all(2.0),
              borderRadius: EdgeInsets.all(12.0),
            ),
            children: [
              CanvasText(
                "🔗 SIBLING CASCADE VERIFIED:\nMain Smart-Cut Card ke niche wala sibling hu—bina overlap kiye Page 2 par uske niche aaya!",
                color: 0xFF713F12,
                fontSize: 14.0,
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

  // Case 6.3: Custom Cut (safeThreshold: Cut vs Shift)
  static TestCase _case6_3() => TestCase(
    "6.3 Custom Cut (safeThreshold: Cut vs Shift)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF8FAFC),
        children: [
          CanvasBox(
            width: 520,
            height: 690,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFEDD5,
              borderColor: 0xFFF97316,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "CASE 6.3 (PART A): CUSTOM CUT ALLOWED\nRemaining Space = 152px | safeThreshold = 90px",
                color: 0xFF9A3412,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Kyunki bachi hui jagah (152px) >= safeThreshold (90px) hai,\nisliye agla 260px Orange Box shift NAHI hoga balki yahin se CUT hoga!",
                color: 0xFF9A3412,
                fontSize: 15.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 260,
            padding: EdgeInsets.all(18.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(
              pageBreakInside: 2,
              safeThreshold: 90.0,
            ),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFEA580C,
              borderColor: 0xFF431407,
              borderWidth: EdgeInsets.all(3.0),
            ),
            children: [
              CanvasText(
                "✂️ CUSTOM CUT PART A (PAGE 1 TOP SLICE - 152px >= 90px)",
                color: 0xFFFFFFFF,
                fontSize: 15.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "✂️ CUSTOM CUT PART A (PAGE 2 BOTTOM SLICE - 108px)",
                color: 0xFFFFEA00,
                fontSize: 15.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 620,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFE0E7FF,
              borderColor: 0xFF4F46E5,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "CASE 6.3 (PART B): CUSTOM CUT SHIFTED\nRemaining Space on Page 2 = 114px | safeThreshold = 200px",
                color: 0xFF312E81,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Ab Page 2 ke niche sirf 114px bacha hai, jo safeThreshold (200px) se KAM hai!\nIsliye agla Indigo Box katega NAHI, seedha Page 3 par SHIFT ho jayega!",
                color: 0xFF312E81,
                fontSize: 15.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 220,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(
              pageBreakInside: 2,
              safeThreshold: 200.0,
            ),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF3730A3,
              borderRadius: EdgeInsets.all(16.0),
              borderColor: 0xFF818CF8,
              borderWidth: EdgeInsets.all(3.0),
            ),
            children: [
              CanvasText(
                "🚀 CUSTOM CUT PART B (SHIFTED TO PAGE 3!)\nBecause remaining 114px < safeThreshold 200px,\nthis 220px box jumped intact to Page 3!",
                color: 0xFFFFFFFF,
                fontSize: 17.0,
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

  // Case 6.4: Automatic 65-Line Multi-Page Paragraph
  static TestCase _case6_4() {
    final String longEssay = List.generate(
      65,
          (i) =>
      "Line ${(i + 1).toString().padLeft(2, '0')}: Core Canvas Engine automatically wraps and paginates long vector paragraphs across multiple A4 pages.",
    ).join("\n");

    return TestCase(
      "6.4 Auto Multi-Page Paragraph (65 Lines)",
      CanvasDocument(
        format: CanvasFormat.a4,
        body: CanvasBox(
          widthPct: 100,
          padding: EdgeInsets.all(28.0),
          direction: FlexDir.column,
          gap: 14.0,
          decoration: CanvasDecoration(backgroundColor: 0xFFFFFFFF),
          children: [
            CanvasBox(
              widthPct: 100,
              height: 60,
              justifyContent: FlexJustify.center,
              alignItems: FlexAlign.center,
              decoration: CanvasDecoration(
                backgroundColor: 0xFF0F172A,
                borderRadius: EdgeInsets.all(10.0),
              ),
              children: [
                CanvasText(
                  "6.4: 65-LINE CONTINUOUS PARAGRAPH AUTO-PAGINATION",
                  color: 0xFF38BDF8,
                  fontSize: 16.0,
                  weight: 800,
                ),
              ],
            ),
            CanvasText(
              longEssay,
              width: 535,
              height: 1320,
              fontSize: 13.0,
              lineHeight: 1.4,
              color: 0xFF1E293B,
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 6.5: Explicit Page Break Before & After
  static TestCase _case6_5() => TestCase(
    "6.5 Explicit pageBreakBefore & After",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        gap: 20.0,
        children: [
          CanvasBox(
            width: 520,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "CHAPTER 1 (ON PAGE 1)\nOnly 220px tall, but Chapter 2 has pageBreakBefore = 1!",
                color: 0xFFFFFFFF,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(pageBreakBefore: 1, pageBreakAfter: 1),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF7C2D12,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "CHAPTER 2 (FORCED ONTO PAGE 2)\nHas BOTH pageBreakBefore: 1 AND pageBreakAfter: 1!",
                color: 0xFFFFEDD5,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF065F46,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "CHAPTER 3 (FORCED ONTO PAGE 3)\nPushed to Page 3 by Chapter 2's pageBreakAfter!",
                color: 0xFFA7F3D0,
                fontSize: 18.0,
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

  // Case 6.6: Giant 1,900px Mega-Container
  static TestCase _case6_6() => TestCase(
    "6.6 Giant 1900px 3-Page Mega-Container",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 540,
            height: 1900,
            padding: EdgeInsets.all(24.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF0F172A, 0xFF1D4ED8, 0xFF9333EA, 0xFF10B981],
              gradientAngle: 90.0,
              borderColor: 0xFF0F172A,
              borderWidth: EdgeInsets.all(4.0),
            ),
            children: [
              CanvasText(
                "PAGE 1 TOP: GIANT 1,900px MEGA-CONTAINER\n(Larger than 2 full A4 pages!)",
                color: 0xFFFFFFFF,
                fontSize: 20.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "PAGE 2 MIDDLE: SEAMLESS GRADIENT SLICE (~950px Y)",
                color: 0xFFFFEA00,
                fontSize: 20.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "PAGE 3 BOTTOM: END OF 1,900px MEGA-CONTAINER!",
                color: 0xFFFFFFFF,
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

  // Case 6.7: Side-by-Side Row: Blind Cut vs Smart Cut
  static TestCase _case6_7() => TestCase(
    "6.7 Side-by-Side Row: Blind Cut vs Smart Cut",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        gap: 16.0,
        children: [
          CanvasBox(
            width: 540,
            height: 690,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFE2E8F0),
            children: [
              CanvasText(
                "6.7: PARALLEL ROW PAGINATION\nLeft Column = Default Blind Cut | Right Column = Smart Cut",
                color: 0xFF0F172A,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 540,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceBetween,
            children: [
              CanvasBox(
                width: 260,
                height: 240,
                padding: EdgeInsets.all(14.0),
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFBE123C,
                  borderColor: 0xFF4C0519,
                  borderWidth: EdgeInsets.all(3.0),
                ),
                children: [
                  CanvasText(
                    "LEFT: BLIND CUT\n(Page 1 Top Half)",
                    color: 0xFFFFFFFF,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                  CanvasText(
                    "✂️ CUT LINE ✂️",
                    color: 0xFFFFEA00,
                    fontSize: 20.0,
                    weight: 900,
                  ),
                  CanvasText(
                    "LEFT: BLIND CUT\n(Page 2 Bottom Half)",
                    color: 0xFFFFFFFF,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasBox(
                width: 260,
                height: 240,
                padding: EdgeInsets.all(14.0),
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                spanningRules: SpanningRules(pageBreakInside: 1),
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF15803D,
                  borderRadius: EdgeInsets.all(16.0),
                ),
                children: [
                  CanvasText(
                    "RIGHT: SMART CUT\nShifted 100% intact to Page 2!",
                    color: 0xFFFFFFFF,
                    fontSize: 16.0,
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

  // Case 6.8: 15-Item Invoice Table Grid with Smart-Cut Rows
  static TestCase _case6_8() {
    final List<CanvasWidget> tableRows = List.generate(15, (i) {
      final bool isEven = i % 2 == 0;
      return CanvasBox(
        width: 530,
        height: 68,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        direction: FlexDir.row,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        spanningRules: SpanningRules(pageBreakInside: 1),
        decoration: CanvasDecoration(
          backgroundColor: isEven ? 0xFFF8FAFC : 0xFFE2E8F0,
          borderColor: 0xFF94A3B8,
          borderWidth: EdgeInsets.all(1.0),
        ),
        children: [
          CanvasText(
            "ITEM #${i + 1} - Enterprise License",
            color: 0xFF0F172A,
            fontSize: 15.0,
            weight: 700,
          ),
          CanvasText(
            "Qty: ${(i + 1) * 2}  |  \$${(i + 1) * 150}.00",
            color: 0xFF0369A1,
            fontSize: 15.0,
            weight: 800,
          ),
        ],
      );
    });

    return TestCase(
      "6.8 15-Row Smart-Cut Invoice Table",
      CanvasDocument(
        format: CanvasFormat.a4,
        body: CanvasBox(
          widthPct: 100,
          padding: EdgeInsets.all(24.0),
          direction: FlexDir.column,
          alignItems: FlexAlign.center,
          gap: 8.0,
          children: [
            CanvasBox(
              width: 530,
              height: 64,
              justifyContent: FlexJustify.center,
              alignItems: FlexAlign.center,
              decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
              children: [
                CanvasText(
                  "6.8: 15-ROW INVOICE (SMART-CUT ROWS NEVER SPLIT IN HALF!)",
                  color: 0xFFFFFFFF,
                  fontSize: 15.0,
                  weight: 800,
                ),
              ],
            ),
            ...tableRows,
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 6.9: Domino Chain Reaction
  static TestCase _case6_9() {
    final List<int> palette = [
      0xFF1D4ED8,
      0xFF7C3AED,
      0xFFBE185D,
      0xFFB45309,
      0xFF047857,
    ];
    final List<CanvasWidget> cards = List.generate(5, (i) {
      return CanvasBox(
        width: 520,
        height: 360,
        padding: EdgeInsets.all(22.0),
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        spanningRules: SpanningRules(pageBreakInside: 1),
        decoration: CanvasDecoration(
          backgroundColor: palette[i],
          borderRadius: EdgeInsets.all(20.0),
        ),
        children: [
          CanvasText(
            "DOMINO SMART-CUT CARD #${i + 1} (360px Height)\n2 cards fit per A4 page (720px); the 3rd card automatically jumps to the next page!",
            color: 0xFFFFFFFF,
            fontSize: 17.0,
            weight: 800,
            align: TextAlign.center,
          ),
        ],
      );
    });

    return TestCase(
      "6.9 Domino Chain (5 Smart-Cut Cards -> 3 Pages)",
      CanvasDocument(
        format: CanvasFormat.a4,
        body: CanvasBox(
          widthPct: 100,
          padding: EdgeInsets.all(24.0),
          direction: FlexDir.column,
          alignItems: FlexAlign.center,
          gap: 20.0,
          children: cards,
        ),
      ),
      category: _cat,
    );
  }

  // Case 6.10: Grand Combined Stress Test
  static TestCase _case6_10() => TestCase(
    "6.10 Combined All-Cut Modes + PDF Bookmarks",
    CanvasDocument(
      format: CanvasFormat.a4,
      pageMode: PdfPageMode.useOutlines,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        children: [
          CanvasBox(
            width: 520,
            height: 710,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            bookmarkTitle: "1. Page 1 - Blind Cut Section",
            decoration: CanvasDecoration(backgroundColor: 0xFFE2E8F0),
            children: [
              CanvasText(
                "SECTION 1: 710px Spacer before Blind Cut",
                fontSize: 18.0,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 240,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            padding: EdgeInsets.all(14.0),
            decoration: CanvasDecoration(backgroundColor: 0xFFDC2626),
            children: [
              CanvasText(
                "1. BLIND CUT (PAGE 1 TOP)",
                color: 0xFFFFFFFF,
                weight: 800,
              ),
              CanvasText(
                "✂️ SLICED ACROSS PAGE 1 & 2 ✂️",
                color: 0xFFFFEA00,
                fontSize: 24.0,
                weight: 900,
              ),
              CanvasText(
                "1. BLIND CUT (PAGE 2 BOTTOM)",
                color: 0xFFFFFFFF,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 620,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFDBEAFE),
            children: [
              CanvasText(
                "SECTION 2: 620px Spacer before Smart Cut",
                fontSize: 18.0,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            bookmarkTitle: "2. Page 3 - Smart Cut Section",
            spanningRules: SpanningRules(pageBreakInside: 1),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF059669,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "2. SMART CUT (JUMPED INTACT TO PAGE 3!)",
                color: 0xFFFFFFFF,
                fontSize: 18.0,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 520,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFFEF3C7),
            children: [
              CanvasText(
                "SECTION 3: 520px Spacer before Custom Threshold Cut",
                fontSize: 16.0,
                weight: 800,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 220,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            bookmarkTitle: "3. Page 4 - Custom Threshold Section",
            spanningRules: SpanningRules(
              pageBreakInside: 2,
              safeThreshold: 160.0,
            ),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF4F46E5,
              borderRadius: EdgeInsets.all(16.0),
            ),
            children: [
              CanvasText(
                "3. CUSTOM THRESHOLD CUT (SHIFTED TO PAGE 4!)\nRemaining ~102px < safeThreshold 160px",
                color: 0xFFFFFFFF,
                fontSize: 17.0,
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

  // Case 6.11: Smart Cut Parent Containing Blind Cut Child
  static TestCase _case6_11() => TestCase(
    "6.11 Smart Parent + Blind Child (Fit vs Oversized)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        gap: 16.0,
        decoration: CanvasDecoration(backgroundColor: 0xFFF1F5F9),
        children: [
          CanvasBox(
            width: 520,
            height: 680,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFE2E8F0,
              borderColor: 0xFF475569,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "CASE 6.11: SMART-CUT PARENT + BLIND-CUT CHILD",
                color: 0xFF0F172A,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Niche 146px jagah bachi hai.\nAgla Outer Container 320px ka SMART CUT (Concrete) hai, aur uske andar wala box BLIND CUT (Fluid) hai.\nKyunki Parent Concrete hai, wo pura uth kar Page 2 par jayega aur andar wala Blind Child katne se bach jayega!",
                color: 0xFF1E293B,
                fontSize: 14.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 320,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(pageBreakInside: 1),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF065F46,
              borderRadius: EdgeInsets.all(16.0),
              borderColor: 0xFF10B981,
              borderWidth: EdgeInsets.all(3.0),
            ),
            children: [
              CanvasText(
                "🧱 OUTER PARENT: SMART CUT (Shifted to Page 2 Top!)",
                color: 0xFFA7F3D0,
                fontSize: 16.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasBox(
                width: 460,
                height: 180,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  gradient: const [0xFFF59E0B, 0xFFEF4444],
                  borderRadius: EdgeInsets.all(12.0),
                ),
                children: [
                  CanvasText(
                    "🌊 INNER CHILD: BLIND CUT (FLUID)\nProtected from slicing because Concrete Parent jumped to Page 2!",
                    color: 0xFFFFFFFF,
                    fontSize: 15.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 1000,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            spanningRules: SpanningRules(pageBreakInside: 1),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF312E81,
              borderColor: 0xFF818CF8,
              borderWidth: EdgeInsets.all(4.0),
            ),
            children: [
              CanvasText(
                "🧱 PART 2: OVERSIZED SMART PARENT (1000px > 842px A4)\nJumped cleanly to Page 3 Top first, now forced to slice into Page 4!",
                color: 0xFFC7D2FE,
                fontSize: 16.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasBox(
                width: 460,
                height: 260,
                padding: EdgeInsets.all(14.0),
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  gradient: const [0xFFEC4899, 0xFF8B5CF6],
                  borderColor: 0xFFFFFFFF,
                  borderWidth: EdgeInsets.all(2.0),
                ),
                children: [
                  CanvasText(
                    "INNER BLIND CHILD (PAGE 3 SLICE)",
                    color: 0xFFFFFFFF,
                    weight: 800,
                  ),
                  CanvasText(
                    "✂️ SLICED AT PAGE 3 -> 4 ✂️",
                    color: 0xFFFFEA00,
                    fontSize: 24.0,
                    weight: 900,
                  ),
                  CanvasText(
                    "INNER BLIND CHILD (PAGE 4 SLICE)",
                    color: 0xFFFFFFFF,
                    weight: 800,
                  ),
                ],
              ),
              CanvasText(
                "BOTTOM OF 1000px OVERSIZED SMART PARENT (ON PAGE 4)",
                color: 0xFFFFFFFF,
                fontSize: 15.0,
                weight: 800,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 6.12: Fluid Parent Containing Concrete Smart Child
  static TestCase _case6_12() => TestCase(
    "6.12 Fluid Parent + Smart Child (Auto-Stretch)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF8FAFC),
        children: [
          CanvasBox(
            width: 520,
            height: 560,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFE0F2FE,
              borderColor: 0xFF0284C7,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "CASE 6.12: FLUID PARENT (BLIND CUT) + SMART CHILD",
                color: 0xFF0369A1,
                fontSize: 18.0,
                weight: 800,
                align: TextAlign.center,
              ),
              CanvasText(
                "👇 Niche Page 1 par 282px jagah bachi hai.\nOuter Purple Container FLUID (Blind Cut) hai—uska Child #1 Page 1 par rahega,\nlekin Child #2 (Smart Cut) border par aane ki wajah se Page 2 par jump karega aur Outer Parent apni height auto-stretch karega!",
                color: 0xFF0C4A6E,
                fontSize: 14.0,
                weight: 700,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 480,
            padding: EdgeInsets.all(20.0),
            direction: FlexDir.column,
            alignItems: FlexAlign.center,
            gap: 18.0,
            decoration: CanvasDecoration(
              gradient: const [0xFF4C1D95, 0xFF7C3AED],
              gradientAngle: 90.0,
              borderColor: 0xFF0F172A,
              borderWidth: EdgeInsets.all(4.0),
            ),
            children: [
              CanvasBox(
                width: 470,
                height: 140,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF1E293B,
                  borderRadius: EdgeInsets.all(12.0),
                ),
                children: [
                  CanvasText(
                    "CHILD #1 (ON PAGE 1 INSIDE FLUID PARENT)\nHeight: 140px — Fits before 842px boundary!",
                    color: 0xFF38BDF8,
                    fontSize: 15.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasBox(
                width: 470,
                height: 180,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                spanningRules: SpanningRules(pageBreakInside: 1),
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF059669,
                  borderRadius: EdgeInsets.all(14.0),
                  borderColor: 0xFFA7F3D0,
                  borderWidth: EdgeInsets.all(2.5),
                ),
                children: [
                  CanvasText(
                    "🧱 CHILD #2: SMART CUT (JUMPED TO PAGE 2 TOP!)\nOuter Fluid Parent automatically stretched its purple background to wrap me!",
                    color: 0xFFFFFFFF,
                    fontSize: 15.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasBox(
                width: 470,
                height: 90,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFEF08A,
                  borderRadius: EdgeInsets.all(10.0),
                ),
                children: [
                  CanvasText(
                    "CHILD #3: CASCADED BELOW CHILD #2 STILL INSIDE FLUID PARENT!",
                    color: 0xFF713F12,
                    fontSize: 13.0,
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

  // Case 6.13: 3-Level Russian Doll Nesting
  static TestCase _case6_13() => TestCase(
    "6.13 3-Level Russian Doll (Custom -> Smart -> Blind)",
    CanvasDocument(
      format: CanvasFormat.a4,
      body: CanvasBox(
        widthPct: 100,
        direction: FlexDir.column,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF1F5F9),
        children: [
          CanvasBox(
            width: 520,
            height: 580,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(backgroundColor: 0xFFE2E8F0),
            children: [
              CanvasText(
                "CASE 6.13: 3-LEVEL RUSSIAN DOLL NESTING\nLevel 1: Custom Cut (safeThreshold: 120px) -> Slices!\nLevel 2: Smart Cut Middle Card -> Jumps to Page 2!\nLevel 3: Blind Cut Inner Box -> Protected inside Level 2!",
                color: 0xFF0F172A,
                fontSize: 16.0,
                weight: 800,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 460,
            padding: EdgeInsets.all(18.0),
            direction: FlexDir.column,
            alignItems: FlexAlign.center,
            gap: 16.0,
            spanningRules: SpanningRules(
              pageBreakInside: 2,
              safeThreshold: 120.0,
            ),
            decoration: CanvasDecoration(
              backgroundColor: 0xFF0F172A,
              borderColor: 0xFF38BDF8,
              borderWidth: EdgeInsets.all(4.0),
            ),
            children: [
              CanvasBox(
                width: 470,
                height: 150,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF1E293B,
                  borderRadius: EdgeInsets.all(10.0),
                ),
                children: [
                  CanvasText(
                    "LEVEL 1 (CUSTOM CUT OUTER): SLICED ON PAGE 1\nBecause 262px remaining >= 120px safeThreshold!",
                    color: 0xFF38BDF8,
                    fontSize: 15.0,
                    weight: 800,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasBox(
                width: 470,
                height: 240,
                padding: EdgeInsets.all(16.0),
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                spanningRules: SpanningRules(pageBreakInside: 1),
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF065F46,
                  borderRadius: EdgeInsets.all(16.0),
                  borderColor: 0xFF34D399,
                  borderWidth: EdgeInsets.all(2.5),
                ),
                children: [
                  CanvasText(
                    "LEVEL 2 (SMART CUT MIDDLE): JUMPED TO PAGE 2!",
                    color: 0xFFA7F3D0,
                    fontSize: 15.0,
                    weight: 800,
                  ),
                  CanvasBox(
                    width: 420,
                    height: 140,
                    justifyContent: FlexJustify.center,
                    alignItems: FlexAlign.center,
                    decoration: CanvasDecoration(
                      gradient: const [0xFFF59E0B, 0xFFEC4899],
                      borderRadius: EdgeInsets.all(12.0),
                    ),
                    children: [
                      CanvasText(
                        "LEVEL 3 (BLIND CUT INNERMOST BOX)\nSafely carried to Page 2 by Level 2 Smart-Cut Card!",
                        color: 0xFFFFFFFF,
                        fontSize: 14.0,
                        weight: 800,
                        align: TextAlign.center,
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
}