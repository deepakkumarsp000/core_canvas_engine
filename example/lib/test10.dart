// FILE: example/lib/test10.dart
// PURPOSE: TEST 10 - 3-Tier Unicode, Indic Scripts, RichText Spans, Icons, CustomPainter & CanvasStyle Cascade

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart'
    show
    Icons,
    CustomPainter,
    Canvas,
    Size,
    Paint,
    PaintingStyle,
    RRect,
    Radius,
    Rect,
    Color;

import 'test_registry.dart';

class Test10Cases {
  static const String _cat =
      "10. Unicode, Indic Scripts, RichText, Icons & GPU Mask Pipeline";

  static List<TestCase> getCases() {
    return [
      _case10_1(),
      _case10_2(),
      _case10_3(),
      _case10_4(),
      _case10_5(),
      _case10_6(),
      _case10_7(),
      _case10_8(),
      _case10_9(),
      _case10_10(),
    ];
  }

  // Case 10.1: Multi-Script Indian Document (Hindi, Gujarati, Tamil & Rupee)
  static TestCase _case10_1() => TestCase(
    "10.1 [PDF] Multi-Script Indian Doc (Hindi, Gujarati, Tamil & ₹)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(16.0),
            decoration: CanvasDecoration(
              gradient: const [0xFFFF9933, 0xFFFFFFFF, 0xFF138808],
              gradientAngle: 0.0,
              borderRadius: EdgeInsets.all(10.0),
              borderColor: 0xFF0F172A,
              borderWidth: EdgeInsets.all(1.5),
            ),
            children: [
              CanvasText(
                "भारत का बहुभाषी दस्तावेज़ — Multi-Script Engine 🇮🇳",
                widthPct: 100,
                fontSize: 16.0,
                weight: 800,
                color: 0xFF0F172A,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFFF8FAFC,
            children: [
              CanvasCol(
                widthPct: 100,
                gap: 10.0,
                children: [
                  "हिंदी (Devanagari): नमस्ते! कोर कैनवास इंजन बिना किसी एक्स्ट्रा फॉन्ट बंडल के ₹49,999.00 जैसे भारतीय रुपये और हिंदी लिपि को 2x रेटिना क्वालिटी में रेंडर करता है।"
                      .toCanvasText()
                      .size(13.0)
                      .textColor(0xFF0F172A),
                  CanvasDivider(color: 0xFFE2E8F0),
                  "ગુજરાતી (Gujarati): નમસ્તે ગુજરાત! આ પ્લગઇન ફ્લટર અને C++20 ની મદદથી સુપર ફાસ્ટ PDF અને ઇમેજ બનાવે છે — કુલ રકમ ₹1,25,000."
                      .toCanvasText()
                      .size(13.0)
                      .textColor(0xFF1E3A8A),
                  CanvasDivider(color: 0xFFE2E8F0),
                  "தமிழ் (Tamil): வணக்கம்! இது மிக வேகமான C++20 மற்றும் Flutter FFI ஆவண இயந்திரம் — மொத்தம் ₹85,500."
                      .toCanvasText()
                      .size(13.0)
                      .textColor(0xFF065F46),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.2: Multi-Page Hindi Paragraph Slicing (Verifies segBot Bug Fix!)
  static TestCase _case10_2() {
    final String longHindiParagraph = List<String>.generate(
      28,
          (int i) =>
      "${i + 1}. यह मल्टी-पेज हिंदी टेक्स्ट स्लाइसिंग टेस्ट है (₹${(i + 1) * 1000}) — पेज कट होने पर टेक्स्ट को बिना स्ट्रेच हुए अगले पेज पर साफ़-सुथरा रेंडर होना चाहिए।",
    ).join("\n\n");

    return TestCase(
      "10.2 [PDF] Multi-Page Hindi Raster Slicing (segBot Fix Test)",
      CanvasDocument(
        format: CanvasFormat.a4,
        canvasMargin: EdgeInsets.all(28.0),
        body: CanvasCol(
          widthPct: 100,
          gap: 12.0,
          children: [
            "10.2 MULTI-PAGE UNICODE RASTER SLICING VERIFICATION"
                .toCanvasText()
                .size(15.0)
                .bold(900)
                .textColor(0xFF0F172A),
            CanvasText(
              longHindiParagraph,
              widthPct: 100,
              fontSize: 13.0,
              lineHeight: 1.45,
              color: 0xFF1E293B,
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 10.3: Fluent RichText .span() Mixed Styling
  static TestCase _case10_3() => TestCase(
    "10.3 [PDF] Fluent RichText .span() Mixed Colors, Sizes & Scripts",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(32.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 18.0,
        children: [
          "10.3 RICHTEXT INLINE SPANS SHOWCASE"
              .toCanvasText()
              .size(17.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFFFFFFFF,
            children: [
              "Core Canvas Engine supports "
                  .toCanvasText()
                  .size(14.0)
                  .textColor(0xFF1E293B)
                  .span("BOLD CYAN", color: 0xFF0284C7, weight: 900, size: 16.0)
                  .span(", ", color: 0xFF1E293B)
                  .span(
                "Italic Crimson",
                color: 0xFFDC2626,
                style: FontStyle.italic,
                weight: 700,
              )
                  .span(", Indian Rupees ", color: 0xFF1E293B)
                  .span("₹99,999/-", color: 0xFF059669, weight: 900, size: 17.0)
                  .span(", Hindi (", color: 0xFF1E293B)
                  .span("अद्भुत रेंडरिंग 🚀", color: 0xFF7C3AED, weight: 800)
                  .span(") all inside a single TextPainter mask!", color: 0xFF1E293B),
            ],
          ),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFF0F172A,
            children: [
              "STATUS: "
                  .toCanvasText()
                  .size(15.0)
                  .bold()
                  .textColor(0xFF94A3B8)
                  .span("PASSED ", color: 0xFF4ADE80, weight: 900, size: 18.0)
                  .span("• ", color: 0xFF64748B)
                  .span("ZERO CRASHES ", color: 0xFF38BDF8, weight: 800)
                  .span("• ", color: 0xFF64748B)
                  .span("100% SYNCED 🔥", color: 0xFFFACC15, weight: 900),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.4: Complex Emoji Stress Test (ZWJ Sequences, Skin Tones & Flags)
  static TestCase _case10_4() => TestCase(
    "10.4 [PDF] Emoji Stress Test (ZWJ Sequences, Flags & Badges)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "10.4 EMOJI & UNICODE GLYPH MATRIX 🚀🔥⚡"
              .toCanvasText()
              .size(17.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFF1E293B,
            children: [
              CanvasCol(
                widthPct: 100,
                gap: 12.0,
                children: [
                  "Flags: 🇮🇳 🇺🇸 🇯🇵 🇩🇪 🇬🇧 🇫🇷"
                      .toCanvasText()
                      .size(18.0)
                      .textColor(0xFFFFFFFF),
                  "ZWJ & Professions: 👨‍👩‍👧‍👦 👨‍💻 👩‍🔬 🧑‍🚀 🦸‍♂️"
                      .toCanvasText()
                      .size(18.0)
                      .textColor(0xFFFFFFFF),
                  "Symbols & Tech: ⚙️ 🧠 💎 🛡️ 📊 🎯 ✅ ❌ ⚠️"
                      .toCanvasText()
                      .size(18.0)
                      .textColor(0xFFFFFFFF),
                ],
              ),
            ],
          ),
          CanvasRow(
            widthPct: 100,
            gap: 10.0,
            wrap: FlexWrap.wrap,
            children: [
              CanvasBadge(label: "🚀 Fast FFI", backgroundColor: 0xFF0F172A, textColor: 0xFF38BDF8),
              CanvasBadge(label: "🔥 Zero Bloat", backgroundColor: 0xFF7F1D1D, textColor: 0xFFFECACA),
              CanvasBadge(label: "💎 2x Retina", backgroundColor: 0xFF3B0764, textColor: 0xFFE9D5FF),
              CanvasBadge(label: "🇮🇳 Made in India", backgroundColor: 0xFF064E3B, textColor: 0xFFA7F3D0),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.5: 5,000+ Icon Matrix (Material + Cupertino Icons with Shadows & Mirror)
  static TestCase _case10_5() => TestCase(
    "10.5 [PDF] Material & Cupertino Icon Matrix + Neon FX",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 20.0,
        children: [
          "10.5 ZERO-KB MATERIAL & CUPERTINO ICONS"
              .toCanvasText()
              .size(17.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(20.0),
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceAround,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF0F172A,
              borderRadius: EdgeInsets.all(14.0),
            ),
            children: [
              Icons.verified.toCanvasIcon(size: 46.0, color: 0xFF38BDF8).shadow(
                color: 0xCC00E5FF,
                blur: 14.0,
              ),
              Icons.rocket_launch
                  .toCanvasIcon(size: 46.0, color: 0xFFF43F5E)
                  .shadow(color: 0xCCF43F5E, blur: 14.0),
              Icons.bolt.toCanvasIcon(size: 46.0, color: 0xFFFACC15).shadow(
                color: 0xCCFACC15,
                blur: 14.0,
              ),
              CupertinoIcons.star_fill
                  .toCanvasIcon(size: 44.0, color: 0xFF4ADE80)
                  .shadow(color: 0xCC22C55E, blur: 14.0),
              CupertinoIcons.shield_lefthalf_fill
                  .toCanvasIcon(size: 44.0, color: 0xFFC084FC)
                  .shadow(color: 0xCCA855F7, blur: 14.0),
            ],
          ),
          CanvasRow(
            widthPct: 100,
            gap: 12.0,
            justify: FlexJustify.spaceBetween,
            children: [
              CanvasBadge(
                label: "Verified Pro",
                icon: Icons.check_circle,
                backgroundColor: 0xFFECFDF5,
                textColor: 0xFF059669,
                borderColor: 0xFF10B981,
              ),
              CanvasBadge(
                label: "Cloud Synced",
                icon: CupertinoIcons.cloud_upload_fill,
                backgroundColor: 0xFFEFF6FF,
                textColor: 0xFF2563EB,
                borderColor: 0xFF3B82F6,
              ),
              CanvasBadge(
                label: "High Security",
                icon: Icons.lock,
                backgroundColor: 0xFFFEF2F2,
                textColor: 0xFFDC2626,
                borderColor: 0xFFEF4444,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.6: Text Overflow Ellipsis + Padding & Thick Border Width Cascade
  static TestCase _case10_6() {
    const String longSentence =
        "Core Canvas Engine automatically subtracts horizontal padding and borderWidth from the available text box width so ellipsis truncation never overflows outside rounded borders.";

    return TestCase(
      "10.6 [PDF] Ellipsis (maxLines 1/2/3) + Border-Width Cascade Sync",
      CanvasDocument(
        format: CanvasFormat.a4,
        canvasMargin: EdgeInsets.all(28.0),
        body: CanvasCol(
          widthPct: 100,
          gap: 16.0,
          children: [
            "10.6 ELLIPSIS & PADDING/BORDER WIDTH SYNC"
                .toCanvasText()
                .size(16.0)
                .bold(900)
                .textColor(0xFF0F172A),
            CanvasBox(
              width: 340,
              padding: EdgeInsets.all(14.0),
              decoration: CanvasDecoration(
                backgroundColor: 0xFFF8FAFC,
                borderColor: 0xFF2563EB,
                borderWidth: EdgeInsets.all(6.0),
                borderRadius: EdgeInsets.all(10.0),
              ),
              children: [
                "maxLines: 1 (with 6px border + 14px padding)"
                    .toCanvasText()
                    .size(10.0)
                    .bold()
                    .textColor(0xFF2563EB),
                CanvasText(longSentence, fontSize: 12.0, color: 0xFF0F172A)
                    .ellipsis(1),
              ],
            ),
            CanvasBox(
              width: 340,
              padding: EdgeInsets.all(14.0),
              decoration: CanvasDecoration(
                backgroundColor: 0xFFF8FAFC,
                borderColor: 0xFF059669,
                borderWidth: EdgeInsets.all(6.0),
                borderRadius: EdgeInsets.all(10.0),
              ),
              children: [
                "maxLines: 2 (with 6px border + 14px padding)"
                    .toCanvasText()
                    .size(10.0)
                    .bold()
                    .textColor(0xFF059669),
                CanvasText(longSentence, fontSize: 12.0, color: 0xFF0F172A)
                    .ellipsis(2),
              ],
            ),
            CanvasBox(
              width: 340,
              padding: EdgeInsets.all(14.0),
              decoration: CanvasDecoration(
                backgroundColor: 0xFFF8FAFC,
                borderColor: 0xFF7C3AED,
                borderWidth: EdgeInsets.all(6.0),
                borderRadius: EdgeInsets.all(10.0),
              ),
              children: [
                "maxLines: 3 (with 6px border + 14px padding)"
                    .toCanvasText()
                    .size(10.0)
                    .bold()
                    .textColor(0xFF7C3AED),
                CanvasText(longSentence, fontSize: 12.0, color: 0xFF0F172A)
                    .ellipsis(3),
              ],
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 10.7: Scientific & Financial Typography (baselineOffset, Spacing & Decos)
  static TestCase _case10_7() => TestCase(
    "10.7 [PDF] Typography FX (baselineOffset, Spacing, Strike & Overline)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(32.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "10.7 SCIENTIFIC & FINANCIAL TYPOGRAPHY"
              .toCanvasText()
              .size(17.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasRow(
            align: FlexAlign.center,
            children: [
              CanvasText("E = mc", fontSize: 22.0, weight: 700, color: 0xFF0F172A),
              CanvasText(
                "2",
                fontSize: 13.0,
                weight: 700,
                color: 0xFFDC2626,
                baselineOffset: 8.0,
              ),
              CanvasText("    |    H", fontSize: 22.0, weight: 700, color: 0xFF0F172A),
              CanvasText(
                "2",
                fontSize: 13.0,
                weight: 700,
                color: 0xFF2563EB,
                baselineOffset: -5.0,
              ),
              CanvasText("O", fontSize: 22.0, weight: 700, color: 0xFF0F172A),
            ],
          ),
          CanvasDivider(color: 0xFFE2E8F0),
          CanvasText(
            "WIDE LETTER SPACING (4.0px)",
            fontSize: 14.0,
            weight: 700,
            letterSpacing: 4.0,
            color: 0xFF1E3A8A,
          ),
          CanvasText(
            "WIDE WORD SPACING ACROSS TERMS",
            fontSize: 14.0,
            weight: 600,
            wordSpacing: 10.0,
            color: 0xFF065F46,
          ),
          CanvasRow(
            gap: 20.0,
            children: [
              "Underlined Text".toCanvasText().size(14.0).underline().textColor(0xFF2563EB),
              "MRP 9,999".toCanvasText().size(14.0).strike().textColor(0xFFDC2626),
              "Overlined Heading".toCanvasText().size(14.0).overline().textColor(0xFF7C3AED),
            ],
          ),
          CanvasRow(
            gap: 20.0,
            children: [
              "Times-Roman Serif Italic"
                  .toCanvasText()
                  .font("Times-Roman")
                  .size(15.0)
                  .italic()
                  .textColor(0xFF0F172A),
              "Courier Bold Monospace"
                  .toCanvasText()
                  .font("Courier")
                  .size(14.0)
                  .bold()
                  .textColor(0xFF334155),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.8: Neon Gradient Text Shadow + Text Water Mirror (PNG Export)
  static TestCase _case10_8() => TestCase(
    "10.8 [PNG] Neon Gradient Text Shadow + Water Mirror Reflection",
    CanvasDocument(
      format: const CanvasFormat(600.0, 420.0),
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 28.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF020617, 0xFF0F172A, 0xFF1E1B4B],
          gradientAngle: 120.0,
        ),
        children: [
          "CORE CANVAS"
              .toCanvasText()
              .size(54.0)
              .bold(900)
              .textColor(0xFFFFFFFF)
              .shadow(
            gradient: const [0xFF00E5FF, 0xFFFF007F],
            blur: 18.0,
            spread: 2.0,
          )
              .mirror(distance: 6.0, blur: 3.0, opacity: 0.55),
          CanvasBox(height: 36),
          "2x Retina Text Mask • Gradient Alpha Blur • Live Reflection"
              .toCanvasText()
              .size(14.0)
              .bold()
              .textColor(0xFF94A3B8),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 10.9: Vector Analytics Bar Chart + Handwritten Signature Block
  static TestCase _case10_9() {
    const String signatureSvg = '''
<svg width="220" height="70" viewBox="0 0 220 70">
  <path d="M 10 52 C 28 12, 42 12, 48 48 C 56 32, 72 24, 80 46 C 95 28, 112 20, 126 44 C 142 30, 165 24, 184 40 C 195 48, 204 38, 212 34"
        fill="none" stroke="#1E3A8A" stroke-width="3.2" stroke-linecap="round"/>
  <path d="M 24 60 L 196 56" fill="none" stroke="#2563EB" stroke-width="1.5"/>
</svg>
''';

    CanvasBox buildBar(String month, double heightPx, int color) {
      return CanvasCol(
        align: FlexAlign.center,
        gap: 6.0,
        children: [
          CanvasBox(
            width: 38,
            height: heightPx,
            decoration: CanvasDecoration(
              backgroundColor: color,
              borderRadius: EdgeInsets.only(top: 6.0, right: 6.0),
            ),
          ),
          month.toCanvasText().size(10.0).bold().textColor(0xFF475569),
        ],
      );
    }

    return TestCase(
      "10.9 [PDF] Vector Analytics Bar Chart & Signature Card",
      CanvasDocument(
        format: CanvasFormat.a4,
        canvasMargin: EdgeInsets.all(28.0),
        body: CanvasCol(
          widthPct: 100,
          gap: 20.0,
          children: [
            "10.9 VECTOR ANALYTICS CHART & DIGITAL SIGNATURE"
                .toCanvasText()
                .size(16.0)
                .bold(900)
                .textColor(0xFF0F172A),
            CanvasCard(
              widthPct: 100,
              backgroundColor: 0xFFF8FAFC,
              children: [
                "MONTHLY PDF EXPORTS (IN THOUSANDS)"
                    .toCanvasText()
                    .size(11.0)
                    .bold(800)
                    .textColor(0xFF334155),
                CanvasBox(
                  widthPct: 100,
                  height: 210,
                  padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                  direction: FlexDir.row,
                  justifyContent: FlexJustify.spaceAround,
                  alignItems: FlexAlign.flexEnd,
                  decoration: CanvasDecoration(
                    borderColor: 0xFFCBD5E1,
                    borderWidth: EdgeInsets.only(bottom: 2.0, left: 2.0),
                  ),
                  children: [
                    buildBar("JUL", 75, 0xFF94A3B8),
                    buildBar("AUG", 110, 0xFF38BDF8),
                    buildBar("SEP", 145, 0xFF2563EB),
                    buildBar("OCT", 130, 0xFF7C3AED),
                    buildBar("NOV", 172, 0xFF10B981),
                  ],
                ),
              ],
            ),
            CanvasCard(
              widthPct: 100,
              backgroundColor: 0xFFFFFFFF,
              children: [
                CanvasRow(
                  widthPct: 100,
                  justify: FlexJustify.spaceBetween,
                  align: FlexAlign.center,
                  children: [
                    CanvasCol(
                      gap: 4.0,
                      children: [
                        "AUTHORIZED SIGNATORY"
                            .toCanvasText()
                            .size(10.0)
                            .bold(800)
                            .textColor(0xFF64748B),
                        "Aarav Sharma — Chief Architect"
                            .toCanvasText()
                            .size(12.0)
                            .bold()
                            .textColor(0xFF0F172A),
                      ],
                    ),
                    CanvasSvg(svgXml: signatureSvg, width: 180, height: 60),
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

  /// Async helper to test [CanvasCustomPainter] directly with `CoreCanvasEngine.exportDocument()`.
  static Future<CanvasDocument> buildAsyncCustomPainterDoc() async {
    final CanvasImage chartImg = await CanvasCustomPainter(
      painter: _MiniSparkBarPainter(),
      width: 320,
      height: 160,
    );
    return CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "CanvasCustomPainter 2x Retina Capture".toCanvasText().size(18.0).bold(),
          chartImg,
        ],
      ),
    );
  }

  // Case 10.10: Reusable CanvasStyle Cascading Design System
  static TestCase _case10_10() {
    final CanvasStyle darkCardStyle = const CanvasStyle()
        .bg(0xFF0F172A)
        .p(18.0)
        .rounded(14.0)
        .border(color: 0xFF38BDF8, width: 2.0)
        .shadow(color: 0x660284C7, blur: 14.0, dy: 6.0)
        .text(color: 0xFFE2E8F0, size: 13.0, weight: 600);

    final CanvasStyle successPillStyle = const CanvasStyle()
        .bg(0xFF064E3B)
        .px(16.0)
        .py(10.0)
        .rounded(20.0)
        .border(color: 0xFF10B981, width: 1.5)
        .text(color: 0xFFA7F3D0, size: 12.0, weight: 800, align: TextAlign.center);

    return TestCase(
      "10.10 [PDF] Reusable CanvasStyle CSS-Like Typography Cascade",
      CanvasDocument(
        format: CanvasFormat.a4,
        canvasMargin: EdgeInsets.all(28.0),
        body: CanvasCol(
          widthPct: 100,
          gap: 18.0,
          children: [
            "10.10 CANVASSTYLE DESIGN SYSTEM CASCADE"
                .toCanvasText()
                .size(16.0)
                .bold(900)
                .textColor(0xFF0F172A),
            CanvasBox(
              widthPct: 100,
              direction: FlexDir.column,
              gap: 8.0,
              children: [
                CanvasText("Inherited Text #1 (Auto Light Gray, 13px, Weight 600)"),
                CanvasBox(
                  direction: FlexDir.column,
                  gap: 4.0,
                  children: [
                    CanvasText("Deeply Nested Child #2 (Recursively Cascaded)"),
                    CanvasText(
                      "Explicit Override Child #3 (Amber 15px Bold)",
                      color: 0xFFFACC15,
                      fontSize: 15.0,
                      weight: 900,
                    ),
                  ],
                ),
              ],
            ).apply(darkCardStyle),
            CanvasBox(
              width: 260,
              children: [CanvasText("Cascaded Emerald Pill Badge")],
            ).apply(successPillStyle),
          ],
        ),
      ),
      category: _cat,
    );
  }
}

class _MiniSparkBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      bg,
    );

    final List<double> values = [0.35, 0.55, 0.78, 0.62, 0.92, 0.85];
    final Paint barPaint =
    Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;

    final double barW = 28.0;
    final double gap = 18.0;
    for (int i = 0; i < values.length; i++) {
      final double h = values[i] * (size.height - 40);
      final double x = 24.0 + i * (barW + gap);
      final double y = size.height - 20 - h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barW, h),
          const Radius.circular(6),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}