// FILE: example/lib/test5.dart
// PURPOSE: TEST 5 - 3-Tier Smart Typography, Polyglot Unicode (Hindi/Kumaoni/Emojis),
//          Custom Asset Fonts & Zero-KB CanvasIcon Suite

import 'package:flutter/material.dart' show Icons;

import 'test_registry.dart';

class Test5Cases {
  static const String _cat = "5. Polyglot Unicode, Fonts & Icons";

  static List<TestCase> getCases() {
    return [
      _case5_1(),
      _case5_2(),
      _case5_3(),
      _case5_4(),
      _case5_5(),
      _case5_6(),
      _case5_7(),
      _case5_8(),
      _case5_9(),
      _case5_10(),
    ];
  }

  // Case 5.1: Complex Devanagari (Hindi, Kumaoni & Sanskrit Conjuncts)
  static TestCase _case5_1() => TestCase(
    "5.1 Devanagari Hindi & Kumaoni FX",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        padding: EdgeInsets.all(24.0),
        decoration: CanvasDecoration(backgroundColor: 0xFF0D1117),
        children: [
          CanvasText(
            "पैलाग! कस छौ तुम सब?",
            fontFamily: "Hind",
            fontSize: 40.0,
            weight: 700,
            color: 0xFF00E5FF,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(
                color: 0xCC00E5FF,
                offsetX: 0.0,
                offsetY: 0.0,
                blurRadius: 22.0,
              ),
              mirror: CanvasReflection(
                distance: 4.0,
                blurRadius: 4.0,
                opacity: 0.55,
              ),
            ),
          ),
          CanvasBox(
            width: 500,
            padding: EdgeInsets.all(20.0),
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF161B22,
              borderRadius: EdgeInsets.all(20.0),
              borderColor: 0xFF30363D,
              borderWidth: EdgeInsets.all(2.0),
              shadow: CanvasShadow(
                color: 0x99000000,
                blurRadius: 20.0,
                offsetY: 10.0,
              ),
            ),
            children: [
              CanvasText(
                "संयुक्ताक्षर परीक्षण:\nक्षत्रिय • त्रिशूल • विज्ञान • श्रमिक\nउज्ज्वल • राष्ट्रीय • किंकर्तव्यविमूढ़",
                fontFamily: "Hind",
                fontSize: 24.0,
                weight: 700,
                color: 0xFFFFCA28,
                align: TextAlign.center,
                lineHeight: 1.4,
                decoration: CanvasDecoration(
                  shadow: CanvasShadow(color: 0x88FF6F00, blurRadius: 12.0),
                ),
              ),
            ],
          ),
          CanvasText(
            "Core Canvas: १००% देसी रफ्तार!",
            fontFamily: "Poppins",
            fontSize: 34.0,
            weight: 800,
            color: 0xFFFF5252,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAAFF1744, blurRadius: 20.0),
              mirror: CanvasReflection(
                distance: 3.0,
                blurRadius: 5.0,
                opacity: 0.5,
              ),
            ),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.2: Full-Color Emoji Clusters
  static TestCase _case5_2() => TestCase(
    "5.2 Color Emoji Clusters + Mirror",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
        children: [
          CanvasText(
            "🔥 🚀 💎 ⚡ 🏆 🎯",
            fontSize: 46.0,
            weight: 800,
            color: 0xFFFFFFFF,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(
                color: 0xCCFF9100,
                offsetX: 0.0,
                offsetY: 0.0,
                blurRadius: 25.0,
                spreadRadius: 2.0,
              ),
              mirror: CanvasReflection(
                distance: 6.0,
                blurRadius: 4.0,
                opacity: 0.65,
              ),
            ),
          ),
          CanvasBox(
            width: 480,
            padding: EdgeInsets.all(24.0),
            direction: FlexDir.column,
            gap: 14.0,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF1E293B, 0xFF0F172A],
              borderRadius: EdgeInsets.all(24.0),
              borderColor: 0xFF38BDF8,
              borderWidth: EdgeInsets.all(2.0),
              shadow: CanvasShadow(
                color: 0x6600E5FF,
                blurRadius: 24.0,
                offsetY: 8.0,
              ),
            ),
            children: [
              CanvasText(
                "🇮🇳 नमस्ते भारत • ZERO BLOAT 🎉",
                fontSize: 26.0,
                weight: 800,
                color: 0xFF38BDF8,
                align: TextAlign.center,
              ),
              CanvasText(
                "👨‍💻 + ☕ + 🧠 = 💯 परिणाम!",
                fontSize: 28.0,
                weight: 700,
                color: 0xFFFACC15,
                align: TextAlign.center,
              ),
              CanvasText(
                "🌟 ✨ 🎨 🎭 🎪 🎢 🎡",
                fontSize: 32.0,
                color: 0xFFFFFFFF,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasText(
            "⚡ ULTRA FAST ENGINE 2.0 🔥",
            fontFamily: "Montserrat",
            fontSize: 32.0,
            weight: 800,
            color: 0xFF00E676,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAA00E676, blurRadius: 18.0),
              mirror: CanvasReflection(
                distance: 4.0,
                blurRadius: 4.0,
                opacity: 0.55,
              ),
            ),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.3: Custom Asset Font Showcase + Copyable Layer
  static TestCase _case5_3() => TestCase(
    "5.3 Custom Asset Fonts + Copyable 3-Tr",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        padding: EdgeInsets.all(24.0),
        decoration: CanvasDecoration(backgroundColor: 0xFFF8FAFC),
        children: [
          CanvasBox(
            width: 520,
            padding: EdgeInsets.all(20.0),
            direction: FlexDir.column,
            gap: 16.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(20.0),
              shadow: CanvasShadow(
                color: 0x22000000,
                blurRadius: 20.0,
                offsetY: 10.0,
              ),
            ),
            children: [
              CanvasText(
                "1. OSWALD BOLD — CONDENSED IMPACT DISPLAY",
                fontFamily: "Oswald-Bold",
                fontSize: 24.0,
                weight: 700,
                color: 0xFF0F172A,
              ),
              CanvasText(
                "2. Arvo Bold — Geometric Slab-Serif Typography",
                fontFamily: "Arvo-Bold",
                fontSize: 20.0,
                weight: 700,
                color: 0xFF1D4ED8,
              ),
              CanvasText(
                "3. Inconsolata — const int* ptr = &engine_v2;",
                fontFamily: "Inconsolata-Bold",
                fontSize: 19.0,
                weight: 700,
                color: 0xFF047857,
              ),
              CanvasText(
                "4. CrimsonText — Editorial Book & Magazine Luxury",
                fontFamily: "CrimsonText-Bold",
                fontSize: 22.0,
                weight: 700,
                color: 0xFF9D174D,
              ),
              CanvasText(
                "5. Poppins Bold — Modern Geometric UI Standard",
                fontFamily: "Poppins-Bold",
                fontSize: 20.0,
                weight: 700,
                color: 0xFF6D28D9,
              ),
              CanvasText(
                "6. ZillaSlab Bold — Mozilla Editorial Headline",
                fontFamily: "ZillaSlab-Bold",
                fontSize: 21.0,
                weight: 700,
                color: 0xFFB45309,
              ),
            ],
          ),
          CanvasBox(
            width: 520,
            height: 180,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF0F172A,
              borderRadius: EdgeInsets.all(20.0),
              shadow: CanvasShadow(
                color: 0x660F172A,
                blurRadius: 20.0,
                offsetY: 10.0,
              ),
            ),
            children: [
              CanvasText(
                "SELECT & COPY ME!",
                fontFamily: "Raleway-Bold",
                fontSize: 38.0,
                weight: 800,
                color: 0xFF38BDF8,
                align: TextAlign.center,
                decoration: CanvasDecoration(
                  shadow: CanvasShadow(color: 0xAA38BDF8, blurRadius: 18.0),
                  mirror: CanvasReflection(
                    distance: 4.0,
                    blurRadius: 4.0,
                    opacity: 0.55,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.4: Zero-KB CanvasIcon & IconData.toCanvasIcon() FX Matrix
  static TestCase _case5_4() => TestCase(
    "5.4 Zero-KB CanvasIcon FX Matrix",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0B0F19),
        children: [
          CanvasText(
            "ZERO-KB NATIVE ICON ENGINE",
            fontFamily: "Montserrat-Bold",
            fontSize: 28.0,
            weight: 800,
            color: 0xFFFFFFFF,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAA00E5FF, blurRadius: 16.0),
            ),
          ),
          CanvasRow(
            width: 500,
            justify: FlexJustify.spaceEvenly,
            align: FlexAlign.center,
            children: [
              CanvasIcon(
                Icons.rocket_launch,
                size: 64.0,
                color: 0xFF00E5FF,
                shadow: CanvasShadow(
                  color: 0xCC00E5FF,
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                ),
                mirror: CanvasReflection(
                  distance: 6.0,
                  blurRadius: 4.0,
                  opacity: 0.6,
                ),
              ),
              CanvasIcon(
                Icons.local_fire_department,
                size: 64.0,
                color: 0xFFFF5252,
                shadow: CanvasShadow(
                  color: 0xCCFF1744,
                  blurRadius: 22.0,
                  spreadRadius: 2.0,
                ),
                mirror: CanvasReflection(
                  distance: 6.0,
                  blurRadius: 4.0,
                  opacity: 0.6,
                ),
              ),
              CanvasIcon(
                Icons.verified,
                size: 64.0,
                color: 0xFF00E676,
                shadow: CanvasShadow(
                  color: 0xCC00E676,
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                ),
                mirror: CanvasReflection(
                  distance: 6.0,
                  blurRadius: 4.0,
                  opacity: 0.6,
                ),
              ),
              CanvasIcon(
                Icons.bolt,
                size: 64.0,
                color: 0xFFFFEA00,
                shadow: CanvasShadow(
                  color: 0xCCFFD600,
                  blurRadius: 22.0,
                  spreadRadius: 2.0,
                ),
                mirror: CanvasReflection(
                  distance: 6.0,
                  blurRadius: 4.0,
                  opacity: 0.6,
                ),
              ),
            ],
          ),
          CanvasBox(
            width: 480,
            height: 130,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceEvenly,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF1E293B, 0xFF0F172A],
              borderRadius: EdgeInsets.all(30.0),
              borderColor: 0xFF475569,
              borderWidth: EdgeInsets.all(2.0),
              shadow: CanvasShadow(
                color: 0xAA000000,
                blurRadius: 25.0,
                offsetY: 14.0,
              ),
              mirror: CanvasReflection(
                distance: 10.0,
                blurRadius: 6.0,
                opacity: 0.45,
              ),
            ),
            children: [
              Icons.home_rounded
                  .toCanvasIcon(size: 44.0, color: 0xFF38BDF8)
                  .shadow(color: 0xAA38BDF8, blur: 12.0),
              Icons.favorite_rounded
                  .toCanvasIcon(size: 44.0, color: 0xFFF43F5E)
                  .shadow(color: 0xAAF43F5E, blur: 12.0),
              Icons.shield_rounded
                  .toCanvasIcon(size: 44.0, color: 0xFFA855F7)
                  .shadow(color: 0xAAA855F7, blur: 12.0),
              Icons.workspace_premium
                  .toCanvasIcon(size: 44.0, color: 0xFFFACC15)
                  .shadow(color: 0xAAFACC15, blur: 12.0),
              Icons.settings_suggest
                  .toCanvasIcon(size: 44.0, color: 0xFF4ADE80)
                  .shadow(color: 0xAA4ADE80, blur: 12.0),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.5: Global 8-Script Polyglot Stress Test
  static TestCase _case5_5() => TestCase(
    "5.5 Global 8-Script Polyglot Card",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
        children: [
          CanvasBox(
            width: 520,
            padding: EdgeInsets.all(28.0),
            direction: FlexDir.column,
            gap: 14.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              borderRadius: EdgeInsets.all(24.0),
              borderColor: 0xFF38BDF8,
              borderWidth: EdgeInsets.all(2.0),
              shadow: CanvasShadow(
                color: 0x99000000,
                blurRadius: 30.0,
                offsetY: 15.0,
              ),
            ),
            children: [
              CanvasText(
                "🌍 UNIVERSAL POLYGLOT ENGINE",
                fontSize: 26.0,
                weight: 800,
                color: 0xFF38BDF8,
                align: TextAlign.center,
              ),
              CanvasText(
                "1. हिंदी: सत्यमेव जयते • वसुधैव कुटुम्बकम्",
                fontSize: 20.0,
                weight: 700,
                color: 0xFFFFFFFF,
              ),
              CanvasText(
                "2. ગુજરાતી: જય ગરવી ગુજરાત • કેમ છો રાજકોટ?",
                fontSize: 20.0,
                weight: 700,
                color: 0xFFFACC15,
              ),
              CanvasText(
                "3. தமிழ்: யாதும் ஊரே யாவரும் கேளிர்",
                fontSize: 20.0,
                weight: 700,
                color: 0xFF4ADE80,
              ),
              CanvasText(
                "4. 日本語: 高速キャンバスエンジン • 東京 2026",
                fontSize: 20.0,
                weight: 700,
                color: 0xFFF472B6,
              ),
              CanvasText(
                "5. Русский: Высокоскоростной движок PDF",
                fontSize: 20.0,
                weight: 700,
                color: 0xFFA78BFA,
              ),
              CanvasText(
                "6. العربية: محرك الرسم العالمي الفائق السرعة",
                fontSize: 20.0,
                weight: 700,
                color: 0xFFFB923C,
              ),
              CanvasText(
                "7. Math & FX: ∑ ∫ √π ∞ ≠ ≈ ≤ ≥ • ₹ € £ ¥ ₿",
                fontSize: 20.0,
                weight: 800,
                color: 0xFF2DD4BF,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.6: Parent Width Cascade & Multi-Line Paragraph Wrapping
  static TestCase _case5_6() => TestCase(
    "5.6 Parent Width Paragraph Wrap",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFE2E8F0),
        children: [
          CanvasBox(
            width: 340,
            padding: EdgeInsets.all(24.0),
            direction: FlexDir.column,
            gap: 12.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              borderRadius: EdgeInsets.all(20.0),
              shadow: CanvasShadow(
                color: 0x66000000,
                blurRadius: 20.0,
                offsetY: 10.0,
              ),
            ),
            children: [
              CanvasText(
                "📦 NARROW CARD (340px)",
                fontSize: 20.0,
                weight: 800,
                color: 0xFF38BDF8,
              ),
              CanvasText(
                "यह एक लंबा बहु-पंक्ति (Multi-line) पैराग्राफ है जिस पर खुद की कोई चौड़ाई (width) नहीं दी गई है। इंजन को अपने पेरेंट कार्ड की चौड़ाई और पैडिंग घटाकर इसे अपने आप सही जगह से मोड़ना (Wrap करना) चाहिए! 🚀✨",
                fontFamily: "Hind",
                fontSize: 17.0,
                weight: 600,
                color: 0xFFFFFFFF,
                lineHeight: 1.35,
                decoration: CanvasDecoration(
                  shadow: CanvasShadow(
                    color: 0xAA000000,
                    blurRadius: 6.0,
                    offsetY: 2.0,
                  ),
                ),
              ),
            ],
          ),
          CanvasBox(
            width: 480,
            padding: EdgeInsets.all(24.0),
            direction: FlexDir.column,
            gap: 12.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(20.0),
              borderColor: 0xFFCBD5E1,
              borderWidth: EdgeInsets.all(2.0),
              shadow: CanvasShadow(
                color: 0x33000000,
                blurRadius: 16.0,
                offsetY: 8.0,
              ),
            ),
            children: [
              CanvasText(
                "📐 WIDE CARD (480px) — AUTO CASCADE",
                fontSize: 18.0,
                weight: 800,
                color: 0xFF0F172A,
              ),
              CanvasText(
                "When a parent CanvasBox defines a width of 480px and padding of 24px, the pre-flight 2x Retina TextPainter automatically receives 432px as its layout maxWidth—matching Meta Yoga 1:1!",
                fontFamily: "Inter-Regular",
                fontSize: 16.0,
                weight: 600,
                color: 0xFF334155,
                lineHeight: 1.4,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.7: CSS Typography Cascade via .apply(CanvasStyle)
  static TestCase _case5_7() => TestCase(
    "5.7 CSS Typography Style Cascade",
    CanvasDocument(
      body: () {
        final cyberCardStyle = const CanvasStyle()
            .bg(0xFF18181B)
            .p(28.0)
            .rounded(24.0)
            .border(color: 0xFFA855F7, width: 3.0)
            .shadow(color: 0xAA9333EA, blur: 28.0, dy: 12.0)
            .text(
          color: 0xFFF43F5E,
          size: 26.0,
          weight: 800,
          align: TextAlign.center,
        );

        return CanvasBox(
          widthPct: 100,
          heightPct: 100,
          justifyContent: FlexJustify.center,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(backgroundColor: 0xFF09090B),
          children: [
            CanvasCol(
              width: 460,
              gap: 18.0,
              align: FlexAlign.center,
              style: cyberCardStyle,
              children: [
                CanvasText("CASCADED HEADLINE 1"),
                CanvasBox(
                  padding: EdgeInsets.all(14.0),
                  decoration: CanvasDecoration(
                    backgroundColor: 0xFF27272A,
                    borderRadius: EdgeInsets.all(14.0),
                  ),
                  children: [CanvasText("कैस्केड हुआ हिंदी टेक्स्ट 🔥")],
                ),
                CanvasText(
                  "Explicit Override (Stays Cyan)",
                  color: 0xFF00E5FF,
                  fontSize: 18.0,
                ),
              ],
            ),
          ],
        );
      }(),
    ),
    category: _cat,
  );

  // Case 5.8: FinTech Multilingual Receipt
  static TestCase _case5_8() => TestCase(
    "5.8 FinTech Multilingual Receipt",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFFF1F5F9),
        children: [
          CanvasBox(
            width: 440,
            padding: EdgeInsets.all(28.0),
            direction: FlexDir.column,
            gap: 18.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(24.0),
              shadow: CanvasShadow(
                color: 0x26000000,
                blurRadius: 25.0,
                offsetY: 14.0,
              ),
            ),
            children: [
              CanvasRow(
                justify: FlexJustify.spaceBetween,
                align: FlexAlign.center,
                children: [
                  CanvasCol(
                    gap: 4.0,
                    children: [
                      CanvasText(
                        "भुगतान सफल (PAYMENT SUCCESS)",
                        fontFamily: "Hind",
                        fontSize: 18.0,
                        weight: 700,
                        color: 0xFF16A34A,
                      ),
                      CanvasText(
                        "TXN-ID: #CCE-2026-99481-IN",
                        fontSize: 13.0,
                        weight: 600,
                        color: 0xFF64748B,
                      ),
                    ],
                  ),
                  CanvasIcon(
                    Icons.verified_rounded,
                    size: 44.0,
                    color: 0xFF16A34A,
                    shadow: CanvasShadow(color: 0x6616A34A, blurRadius: 12.0),
                  ),
                ],
              ),
              CanvasBox(
                widthPct: 100,
                padding: EdgeInsets.all(20.0),
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  gradient: const [0xFF0F172A, 0xFF1E293B],
                  borderRadius: EdgeInsets.all(16.0),
                ),
                children: [
                  CanvasText(
                    "₹ 1,49,999.00",
                    fontFamily: "Montserrat-Bold",
                    fontSize: 36.0,
                    weight: 800,
                    color: 0xFF38BDF8,
                    align: TextAlign.center,
                    decoration: CanvasDecoration(
                      shadow: CanvasShadow(color: 0x8838BDF8, blurRadius: 14.0),
                    ),
                  ),
                  CanvasText(
                    "एक लाख उनचास हज़ार नौ सौ निन्यानबे रुपये मात्र",
                    fontFamily: "Hind",
                    fontSize: 15.0,
                    weight: 600,
                    color: 0xFF94A3B8,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasRow(
                justify: FlexJustify.spaceBetween,
                children: [
                  CanvasText(
                    "ग्राहक (Customer):",
                    fontFamily: "Hind",
                    fontSize: 15.0,
                    color: 0xFF475569,
                  ),
                  CanvasText(
                    "दीपक कुमार (Deepak Kumar)",
                    fontFamily: "Hind",
                    fontSize: 15.0,
                    weight: 700,
                    color: 0xFF0F172A,
                  ),
                ],
              ),
              CanvasRow(
                justify: FlexJustify.spaceBetween,
                children: [
                  CanvasText(
                    "Payment Method:",
                    fontSize: 14.0,
                    color: 0xFF475569,
                  ),
                  CanvasText(
                    "⚡ UPI Instant (HDFC •••• 4821)",
                    fontSize: 14.0,
                    weight: 700,
                    color: 0xFF0F172A,
                  ),
                ],
              ),
              CanvasRow(
                justify: FlexJustify.spaceBetween,
                children: [
                  CanvasText(
                    "Engine License:",
                    fontSize: 14.0,
                    color: 0xFF475569,
                  ),
                  CanvasText(
                    "Enterprise Level-2 (Zero-Bloat)",
                    fontSize: 14.0,
                    weight: 700,
                    color: 0xFF2563EB,
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

  // Case 5.9: Letter/Word Spacing & Alignments
  static TestCase _case5_9() => TestCase(
    "5.9 Letter/Word Spacing & Alignments",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        padding: EdgeInsets.all(28.0),
        decoration: CanvasDecoration(backgroundColor: 0xFF111827),
        children: [
          CanvasText(
            "C I N E M A T I C   S P A C I N G",
            fontFamily: "Montserrat-Bold",
            fontSize: 22.0,
            weight: 800,
            letterSpacing: 4.0,
            color: 0xFFFBBF24,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAAF59E0B, blurRadius: 16.0),
            ),
          ),
          CanvasBox(
            width: 480,
            padding: EdgeInsets.all(20.0),
            direction: FlexDir.column,
            gap: 16.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1F2937,
              borderRadius: EdgeInsets.all(16.0),
              borderColor: 0xFF374151,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "⬅️ बायां संरेखण (TextAlign.left)",
                fontFamily: "Hind",
                widthPct: 100,
                fontSize: 20.0,
                weight: 700,
                color: 0xFF34D399,
                align: TextAlign.left,
              ),
              CanvasText(
                "🎯 मध्य संरेखण (TextAlign.center)",
                fontFamily: "Hind",
                widthPct: 100,
                fontSize: 20.0,
                weight: 700,
                color: 0xFF60A5FA,
                align: TextAlign.center,
              ),
              CanvasText(
                "दायां संरेखण (TextAlign.right) ➡️",
                fontFamily: "Hind",
                widthPct: 100,
                fontSize: 20.0,
                weight: 700,
                color: 0xFFF472B6,
                align: TextAlign.right,
              ),
            ],
          ),
          CanvasText(
            "WIDE   WORD   SPACING   FX",
            fontFamily: "Oswald-Bold",
            fontSize: 34.0,
            weight: 700,
            wordSpacing: 10.0,
            color: 0xFFA78BFA,
            align: TextAlign.center,
            decoration: CanvasDecoration(
              shadow: CanvasShadow(color: 0xAA8B5CF6, blurRadius: 18.0),
              mirror: CanvasReflection(
                distance: 4.0,
                blurRadius: 4.0,
                opacity: 0.55,
              ),
            ),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 5.10: God-Tier Polyglot Poster + Mirror
  static TestCase _case5_10() => TestCase(
    "5.10 God-Tier Polyglot Poster + Mirror",
    CanvasDocument(
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF07090E),
        children: [
          CanvasBox(
            width: 440,
            height: 320,
            padding: EdgeInsets.all(24.0),
            direction: FlexDir.column,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            overflow: Overflow.hidden,
            decoration: CanvasDecoration(
              isClip: true,
              gradient: const [0xFF311042, 0xFF1A103C, 0xFF0B2545],
              borderRadius: EdgeInsets.all(32.0),
              borderColor: 0xFF00E5FF,
              borderWidth: EdgeInsets.all(3.0),
              borderStyle: BorderStyle.dashed,
              borderDash: const [14.0, 6.0],
              shadow: CanvasShadow(
                color: 0xAA00E5FF,
                offsetX: 0.0,
                offsetY: 12.0,
                blurRadius: 30.0,
                spreadRadius: 4.0,
              ),
              mirror: CanvasReflection(
                distance: 12.0,
                blurRadius: 6.0,
                opacity: 0.6,
              ),
            ),
            children: [
              CanvasRow(
                widthPct: 100,
                justify: FlexJustify.spaceBetween,
                align: FlexAlign.center,
                children: [
                  CanvasIcon(
                    Icons.auto_awesome,
                    size: 40.0,
                    color: 0xFFFFEA00,
                    shadow: CanvasShadow(color: 0xCCFFEA00, blurRadius: 14.0),
                  ),
                  CanvasText(
                    "🔥 LEVEL-2 GOD ENGINE 🚀",
                    fontFamily: "Montserrat-Bold",
                    fontSize: 16.0,
                    weight: 800,
                    color: 0xFF00E5FF,
                  ),
                  CanvasIcon(
                    Icons.verified_user_rounded,
                    size: 40.0,
                    color: 0xFF00E676,
                    shadow: CanvasShadow(color: 0xCC00E676, blurRadius: 14.0),
                  ),
                ],
              ),
              CanvasCol(
                gap: 6.0,
                align: FlexAlign.center,
                children: [
                  CanvasText(
                    "अजेय भारत • 2026",
                    fontFamily: "Hind",
                    fontSize: 42.0,
                    weight: 800,
                    color: 0xFFFFFFFF,
                    align: TextAlign.center,
                    decoration: CanvasDecoration(
                      shadow: CanvasShadow(color: 0xCCF50057, blurRadius: 20.0),
                    ),
                  ),
                  CanvasText(
                    "100% VECTOR + RASTER HYBRID",
                    fontFamily: "Oswald-Bold",
                    fontSize: 22.0,
                    weight: 700,
                    letterSpacing: 2.0,
                    color: 0xFFFFCA28,
                    align: TextAlign.center,
                  ),
                ],
              ),
              CanvasBox(
                widthPct: 100,
                height: 52,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xCCF50057,
                  borderRadius: EdgeInsets.all(14.0),
                ),
                children: [
                  CanvasText(
                    "🪞 REFLECTING HINDI + EMOJIS + ICONS ✨",
                    fontSize: 16.0,
                    weight: 800,
                    color: 0xFFFFFFFF,
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