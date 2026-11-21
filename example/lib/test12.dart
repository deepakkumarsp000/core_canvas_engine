// FILE: example/lib/test12.dart
// PURPOSE: TEST 12 - Advanced Animations, RLottie Segments & 6-Format Export Matrix

import 'package:flutter/material.dart' show Icons;

import 'test_registry.dart';

class Test12Cases {
  static const String _cat =
      "12. Advanced Animations, RLottie Segments & 6-Format Matrix";

  static List<TestCase> getCases() {
    return [
      _case12_1(),
      _case12_2(),
      _case12_3(),
      _case12_4(),
      _case12_5(),
      _case12_6(),
      _case12_7(),
      _case12_8(),
      _case12_9(),
      _case12_10(),
    ];
  }

  // Embedded 60-frame spinning geometric star RLottie JSON
  static const String _kOrbitLottieJson = '''
{
  "v": "5.5.7",
  "fr": 30,
  "ip": 0,
  "op": 60,
  "w": 200,
  "h": 200,
  "nm": "OrbitStar",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "Star",
      "sr": 1,
      "ks": {
        "o": {"a": 0, "k": 100},
        "r": {
          "a": 1,
          "k": [
            {"t": 0, "s": [0], "e": [360], "i": {"x": [0.5], "y": [0.5]}, "o": {"x": [0.5], "y": [0.5]}},
            {"t": 60, "s": [360]}
          ]
        },
        "p": {"a": 0, "k": [100, 100, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {
          "a": 1,
          "k": [
            {"t": 0, "s": [65, 65, 100], "e": [110, 110, 100], "i": {"x": [0.4, 0.4, 0.4], "y": [1, 1, 1]}, "o": {"x": [0.6, 0.6, 0.6], "y": [0, 0, 0]}},
            {"t": 30, "s": [110, 110, 100], "e": [65, 65, 100], "i": {"x": [0.4, 0.4, 0.4], "y": [1, 1, 1]}, "o": {"x": [0.6, 0.6, 0.6], "y": [0, 0, 0]}},
            {"t": 60, "s": [65, 65, 100]}
          ]
        }
      },
      "shapes": [
        {
          "ty": "gr",
          "it": [
            {
              "ty": "sr",
              "sy": 1,
              "d": 1,
              "pt": {"a": 0, "k": 6},
              "p": {"a": 0, "k": [0, 0]},
              "r": {"a": 0, "k": 0},
              "ir": {"a": 0, "k": 42},
              "is": {"a": 0, "k": 0},
              "or": {"a": 0, "k": 82},
              "os": {"a": 0, "k": 0}
            },
            {
              "ty": "st",
              "c": {"a": 0, "k": [0.13, 0.83, 0.93, 1]},
              "o": {"a": 0, "k": 100},
              "w": {"a": 0, "k": 7}
            },
            {
              "ty": "fl",
              "c": {"a": 0, "k": [0.96, 0.62, 0.04, 1]},
              "o": {"a": 0, "k": 80}
            },
            {
              "ty": "tr",
              "p": {"a": 0, "k": [0, 0]},
              "a": {"a": 0, "k": [0, 0]},
              "s": {"a": 0, "k": [100, 100]},
              "r": {"a": 0, "k": 0},
              "o": {"a": 0, "k": 100}
            }
          ]
        }
      ]
    }
  ]
}
''';

  static const String _kRocketSvg = '''
<svg width="140" height="140" viewBox="0 0 140 140">
  <circle cx="70" cy="70" r="62" fill="#1E293B" stroke="#38BDF8" stroke-width="5"/>
  <path d="M 70 22 L 96 96 L 70 80 L 44 96 Z" fill="#F43F5E" stroke="#FFFFFF" stroke-width="3"/>
</svg>
''';

  // Case 12.1: Staggered Choreography (delayMs Waterfall)
  static TestCase _case12_1() {
    final List<int> barColors = [
      0xFF06B6D4,
      0xFF3B82F6,
      0xFF8B5CF6,
      0xFFEC4899,
      0xFFF59E0B,
    ];

    return TestCase(
      "12.1 [GIF] Staggered delayMs Waterfall Choreography",
      CanvasDocument(
        format: const CanvasFormat(480.0, 460.0),
        targetFormat: TargetFormat.gif,
        body: CanvasBox(
          widthPct: 100,
          heightPct: 100,
          padding: EdgeInsets.all(24.0),
          direction: FlexDir.column,
          justifyContent: FlexJustify.spaceBetween,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
          children: [
            "12.1 STAGGERED delayMs WATERFALL (0..600 ms)"
                .toCanvasText()
                .size(14.5)
                .bold(900)
                .textColor(0xFFFFFFFF),
            ...List<CanvasWidget>.generate(5, (int i) {
              final int delay = i * 150;
              return CanvasBox(
                width: 400,
                height: 58,
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                direction: FlexDir.row,
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: barColors[i],
                  borderRadius: EdgeInsets.all(12.0),
                ),
                children: [
                  "Step #${i + 1} Card"
                      .toCanvasText()
                      .size(14.0)
                      .bold(900)
                      .textColor(0xFF0F172A),
                  "delayMs: $delay ms"
                      .toCanvasText()
                      .size(12.0)
                      .bold()
                      .textColor(0xFF0F172A),
                ],
              ).animate(
                450,
                delayMs: delay,
                curve: TimingFunction.easeOutBack,
                fromX: -180.0,
                fromOpacity: 0.0,
              );
            }),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 12.2: RLottie Speed (2.0x) & Segment (frame 15..45, loop: false)
  static TestCase _case12_2() => TestCase(
    "12.2 [GIF] RLottie Speed 2.0x vs Segment (Frame 15..45)",
    CanvasDocument(
      format: const CanvasFormat(520.0, 340.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(20.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF0F172A),
        children: [
          "12.2 RLOTTIE SPEED & FRAME SEGMENT CONTROL"
              .toCanvasText()
              .size(14.5)
              .bold(900)
              .textColor(0xFF38BDF8),
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceEvenly,
            children: [
              CanvasCol(
                align: FlexAlign.center,
                gap: 8.0,
                children: [
                  CanvasLottie(
                    lottieJson: _kOrbitLottieJson,
                    width: 180,
                    height: 180,
                    speed: 2.0,
                    loop: true,
                    initialFrame: 0,
                    endFrame: 59,
                  ),
                  "speed: 2.0x | loop: true"
                      .toCanvasText()
                      .size(12.0)
                      .bold()
                      .textColor(0xFF4ADE80),
                ],
              ),
              CanvasCol(
                align: FlexAlign.center,
                gap: 8.0,
                children: [
                  CanvasLottie(
                    lottieJson: _kOrbitLottieJson,
                    width: 180,
                    height: 180,
                    speed: 1.0,
                    loop: false,
                    initialFrame: 15,
                    endFrame: 45,
                  ),
                  "frames: 15..45 | loop: false"
                      .toCanvasText()
                      .size(12.0)
                      .bold()
                      .textColor(0xFFFACC15),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.3: Animated SVG + Animated Text + Live Drop Shadow per Frame
  static TestCase _case12_3() => TestCase(
    "12.3 [GIF] Animated SVG + Animated Text + Live Neon Shadow",
    CanvasDocument(
      format: const CanvasFormat(480.0, 420.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 24.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF020617, 0xFF1E1B4B],
          gradientAngle: 135.0,
        ),
        children: [
          CanvasSvg(svgXml: _kRocketSvg, width: 150, height: 150)
              .shadow(color: 0xCC00E5FF, blur: 18.0)
              .animate(
            900,
            curve: TimingFunction.easeOutBack,
            fromRotate: -180.0,
            fromScale: 0.3,
          ),
          "LAUNCHING CORE CANVAS"
              .toCanvasText()
              .size(22.0)
              .bold(900)
              .textColor(0xFFFFFFFF)
              .shadow(color: 0xCCF43F5E, blur: 14.0)
              .animate(
            900,
            curve: TimingFunction.easeOutCubic,
            fromY: 80.0,
            fromOpacity: 0.1,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.4: Yoyo Elastic Heartbeat Card (Overshoot Curve Safety Test)
  static TestCase _case12_4() => TestCase(
    "12.4 [GIF] Yoyo Elastic Heartbeat (Overshoot Clamping Check)",
    CanvasDocument(
      format: const CanvasFormat(440.0, 440.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
        children: [
          CanvasBox(
            width: 240,
            height: 240,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFFF43F5E, 0xFFEC4899],
              shape: BoxShape.circle,
              shadow: CanvasShadow(
                color: 0xAAF43F5E,
                blurRadius: 24.0,
                spreadRadius: 4.0,
              ),
            ),
            children: [
              "ELASTIC\nYOYO"
                  .toCanvasText()
                  .size(28.0)
                  .bold(900)
                  .textColor(0xFFFFFFFF)
                  .center(),
            ],
          ).animate(
            1000,
            curve: TimingFunction.easeInOutElastic,
            fromScale: 0.55,
            yoyo: true,
            loop: true,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.5: WebP Lossless Compression Showcase
  static TestCase _case12_5() => TestCase(
    "12.5 [WEBP] Lossless WebP Sharp Vector & Typography Card",
    CanvasDocument(
      format: const CanvasFormat(540.0, 400.0),
      targetFormat: TargetFormat.webp,
      lossless: true,
      exportQuality: 100,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF064E3B, 0xFF0F172A],
          gradientAngle: 45.0,
        ),
        children: [
          CanvasBadge(
            label: "WEBP LOSSLESS: TRUE",
            icon: Icons.high_quality,
            backgroundColor: 0xFF10B981,
            textColor: 0xFF022C22,
          ),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFF1E293B,
            children: [
              CanvasCol(
                widthPct: 100,
                gap: 10.0,
                children: [
                  "Pixel-Exact Lossless LibWebP Encoding"
                      .toCanvasText()
                      .size(16.0)
                      .bold(900)
                      .textColor(0xFF34D399),
                  CanvasProgressBar(
                    label: "Visual Fidelity",
                    value: 1.0,
                    showPercentage: true,
                    fillColor: 0xFF10B981,
                    labelColor: 0xFFFFFFFF,
                  ),
                  CanvasProgressBar(
                    label: "Alpha Channel Support",
                    value: 1.0,
                    showPercentage: true,
                    fillColor: 0xFF38BDF8,
                    labelColor: 0xFFFFFFFF,
                  ),
                ],
              ),
            ],
          ),
          "Zero JPEG ringing artifacts on thin text & UI borders."
              .toCanvasText()
              .size(12.0)
              .textColor(0xFFA7F3D0),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.6: JPEG Low Quality (35) + ColorSpace.grayscale Vintage Poster
  static TestCase _case12_6() => TestCase(
    "12.6 [JPG] Grayscale Vintage Poster (quality: 35 + .grayscale())",
    CanvasDocument(
      format: const CanvasFormat(520.0, 620.0),
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(28.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFFDC2626, 0xFF2563EB, 0xFFFACC15],
          gradientAngle: 135.0,
        ),
        children: [
          "NOIR EDITION"
              .toCanvasText()
              .size(34.0)
              .bold(900)
              .textColor(0xFFFFFFFF),
          CanvasSvg(svgXml: _kRocketSvg, width: 180, height: 180),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFF0F172A,
            children: [
              "Even though this layout uses red, blue, and yellow gradients, fluent .asJpg(quality: 35).grayscale() converts every pixel to BT.601 Grayscale in C++."
                  .toCanvasText()
                  .size(12.5)
                  .textColor(0xFFFFFFFF)
                  .center(),
            ],
          ),
        ],
      ),
    ).asJpg(quality: 35).grayscale(),
    category: _cat,
  );

  // Case 12.7: Full-Feature HTML5/CSS3 Landing Page
  static TestCase _case12_7() => TestCase(
    "12.7 [HTML] Full-Feature HTML5/CSS3 Landing Page Export",
    CanvasDocument(
      format: const CanvasFormat(800.0, 620.0),
      targetFormat: TargetFormat.html,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(36.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF0F172A, 0xFF1E1B4B, 0xFF0284C7],
          gradientAngle: 120.0,
        ),
        children: [
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceBetween,
            align: FlexAlign.center,
            children: [
              "CORE CANVAS ENGINE"
                  .toCanvasText()
                  .size(20.0)
                  .bold(900)
                  .textColor(0xFF38BDF8),
              CanvasButton(
                text: "Docs on pub.dev",
                linkUrl: "https://pub.dev",
                buttonColor: 0xFF10B981,
                fontSize: 13.0,
              ),
            ],
          ),
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceBetween,
            align: FlexAlign.center,
            gap: 24.0,
            children: [
              CanvasCol(
                gap: 12.0,
                children: [
                  "Write Once. Export to 6 Formats."
                      .toCanvasText()
                      .size(28.0)
                      .bold(900)
                      .textColor(0xFFFFFFFF),
                  "CSS3 gradients, transforms, blend modes, shadows, inline SVGs, and interactive <a> links exported directly from C++20."
                      .toCanvasText()
                      .size(14.0)
                      .textColor(0xFFCBD5E1),
                ],
              ).flex(1.0),
              CanvasBox(
                width: 200,
                height: 200,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF1E293B,
                  borderRadius: EdgeInsets.all(20.0),
                  shadow: CanvasShadow(
                    color: 0x99000000,
                    blurRadius: 24.0,
                    offsetY: 12.0,
                  ),
                ),
                children: [
                  CanvasSvg(svgXml: _kRocketSvg, width: 130, height: 130),
                ],
              ).rotate(-6.0),
            ],
          ),
          CanvasDivider(color: 0xFF334155),
          "Exported as standalone HTML5/CSS3 DOM — Open in Chrome or Safari!"
              .toCanvasText()
              .size(12.0)
              .textColor(0xFF94A3B8),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.8: Multi-Format Fluent Switcher Immutability Check
  static TestCase _case12_8() {
    final CanvasDocument basePdfDoc = CanvasDocument(
      format: const CanvasFormat(520.0, 380.0),
      targetFormat: TargetFormat.pdf,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 14.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF1E3A8A, 0xFF0284C7],
          gradientAngle: 45.0,
        ),
        children: [
          "12.8 IMMUTABLE FLUENT FORMAT SWITCHER"
              .toCanvasText()
              .size(16.0)
              .bold(900)
              .textColor(0xFFFFFFFF),
          "Cloned from PDF -> PNG via .asPng() without mutating original doc."
              .toCanvasText()
              .size(12.5)
              .textColor(0xFFE0F2FE)
              .center(),
        ],
      ),
    );

    final CanvasDocument clonedPng = basePdfDoc.asPng();
    final CanvasDocument clonedWebp = basePdfDoc.asWebp(quality: 85);
    final CanvasDocument clonedHtml = basePdfDoc.asHtml();

    final bool immutabilityOk =
        basePdfDoc.targetFormat == TargetFormat.pdf &&
            clonedPng.targetFormat == TargetFormat.png &&
            clonedWebp.targetFormat == TargetFormat.webp &&
            clonedHtml.targetFormat == TargetFormat.html;

    return TestCase(
      "12.8 [PNG] Fluent Switcher Immutability (PDF -> PNG/WEBP/HTML)",
      clonedPng.copyWith(
        body: CanvasBox(
          widthPct: 100,
          heightPct: 100,
          padding: EdgeInsets.all(24.0),
          justifyContent: FlexJustify.center,
          alignItems: FlexAlign.center,
          gap: 14.0,
          decoration: CanvasDecoration(
            gradient: const [0xFF0F172A, 0xFF1E3A8A],
            gradientAngle: 45.0,
          ),
          children: [
            "12.8 IMMUTABILITY CHECK: ${immutabilityOk ? 'PASSED' : 'FAILED'}"
                .toCanvasText()
                .size(18.0)
                .bold(900)
                .textColor(immutabilityOk ? 0xFF4ADE80 : 0xFFF87171),
            "base=${basePdfDoc.targetFormat.name} | png=${clonedPng.targetFormat.name} | webp=${clonedWebp.targetFormat.name} | html=${clonedHtml.targetFormat.name}"
                .toCanvasText()
                .size(12.0)
                .bold()
                .textColor(0xFF38BDF8),
          ],
        ),
      ),
      category: _cat,
    );
  }

  // Case 12.9: High-Resolution 1080x1080 Social Media Banner (Insta Square)
  static TestCase _case12_9() => TestCase(
    "12.9 [PNG] 1080x1080 High-Res Social Banner (Sub-Pixel AA)",
    CanvasDocument(
      format: CanvasFormat.instaSquare,
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(64.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF020617, 0xFF1E1B4B, 0xFF4C1D95],
          gradientAngle: 135.0,
        ),
        children: [
          CanvasRow(
            widthPct: 100,
            justify: FlexJustify.spaceBetween,
            align: FlexAlign.center,
            children: [
              CanvasBadge(
                label: "v1.0.0 RELEASE",
                icon: Icons.rocket_launch,
                fontSize: 22.0,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 26.0),
                borderRadius: 30.0,
                backgroundColor: 0xFF00E5FF,
                textColor: 0xFF0F172A,
              ),
              "1080 x 1080 px"
                  .toCanvasText()
                  .size(22.0)
                  .bold()
                  .textColor(0xFF94A3B8),
            ],
          ),
          CanvasBox(
            width: 440,
            height: 440,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF06B6D4, 0xFF3B82F6, 0xFFEC4899],
              shape: BoxShape.circle,
              borderColor: 0xFFFFFFFF,
              borderWidth: EdgeInsets.all(10.0),
              shadow: CanvasShadow(
                color: 0xAA00E5FF,
                blurRadius: 40.0,
                spreadRadius: 8.0,
              ),
            ),
            children: [
              "CORE\nCANVAS"
                  .toCanvasText()
                  .size(72.0)
                  .bold(900)
                  .textColor(0xFFFFFFFF)
                  .center(),
            ],
          ),
          "Native C++20 Flexbox Engine for Flutter"
              .toCanvasText()
              .size(34.0)
              .bold(800)
              .textColor(0xFFE2E8F0)
              .center(),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 12.10: Static Single-Frame GIF Fast-Path Fallback (No Animated Nodes)
  static TestCase _case12_10() => TestCase(
    "12.10 [GIF] Static 1-Frame GIF Fast-Path (hasAnimatedNodes == false)",
    CanvasDocument(
      format: const CanvasFormat(480.0, 320.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 12.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF1E293B, 0xFF0F172A],
          borderColor: 0xFF38BDF8,
          borderWidth: EdgeInsets.all(3.0),
        ),
        children: [
          "12.10 SINGLE-FRAME STATIC GIF"
              .toCanvasText()
              .size(18.0)
              .bold(900)
              .textColor(0xFF38BDF8),
          "Zero .animate() or CanvasLottie nodes -> C++ encodes 1 frame instead of 20!"
              .toCanvasText()
              .size(12.5)
              .textColor(0xFFE2E8F0)
              .center(),
        ],
      ),
    ),
    category: _cat,
  );
}