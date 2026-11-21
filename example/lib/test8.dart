// FILE: lib/test8.dart
// PURPOSE: TEST 8 - Image Animations, Tweeny 31-Curve Transitions, RLottie & Multi-Format Suite (GIF, PNG, JPG, WEBP, HTML, PDF)
// 🚀 FAANG FIX: Clean Single-Import via test_registry.dart!

import 'test_registry.dart';

class Test8Cases {
  static const String _cat =
      "8. Image Animations, Tweeny Curves & Multi-Format (GIF/PNG/JPG/WEBP/HTML)";

  static List<TestCase> getCases() {
    return [
      _case8_1(),
      _case8_2(),
      _case8_3(),
      _case8_4(),
      _case8_5(),
      _case8_6(),
      _case8_7(),
      _case8_8(),
      _case8_9(),
      _case8_10(),
    ];
  }

  // Embedded 60-Frame Pulsing & Rotating Neon Ring RLottie JSON (Zero external file needed!)
  static const String _kSampleLottieJson = '''
{
  "v": "5.5.7",
  "fr": 30,
  "ip": 0,
  "op": 60,
  "w": 200,
  "h": 200,
  "nm": "NeonPulseRing",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 4,
      "nm": "RingLayer",
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
            {"t": 0, "s": [75, 75, 100], "e": [110, 110, 100], "i": {"x": [0.4, 0.4, 0.4], "y": [1, 1, 1]}, "o": {"x": [0.6, 0.6, 0.6], "y": [0, 0, 0]}},
            {"t": 30, "s": [110, 110, 100], "e": [75, 75, 100], "i": {"x": [0.4, 0.4, 0.4], "y": [1, 1, 1]}, "o": {"x": [0.6, 0.6, 0.6], "y": [0, 0, 0]}},
            {"t": 60, "s": [75, 75, 100]}
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
              "pt": {"a": 0, "k": 8},
              "p": {"a": 0, "k": [0, 0]},
              "r": {"a": 0, "k": 0},
              "ir": {"a": 0, "k": 55},
              "is": {"a": 0, "k": 0},
              "or": {"a": 0, "k": 82},
              "os": {"a": 0, "k": 0}
            },
            {
              "ty": "st",
              "c": {"a": 0, "k": [0.0, 0.9, 1.0, 1]},
              "o": {"a": 0, "k": 100},
              "w": {"a": 0, "k": 8}
            },
            {
              "ty": "fl",
              "c": {"a": 0, "k": [0.48, 0.18, 0.89, 1]},
              "o": {"a": 0, "k": 45}
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

  // ============================================================================
  // 🧪 Case 8.1: [FORMAT: GIF] Hero Image Bounce-In & Sliding Neon Badges
  // ============================================================================
  static TestCase _case8_1() => TestCase(
    "8.1 [GIF] Hero Image Bounce-In (easeOutBounce)",
    CanvasDocument(
      format: const CanvasFormat(480.0, 480.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        gap: 18.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF0F172A, 0xFF1E1B4B, 0xFF311042],
          gradientAngle: 135.0,
        ),
        children: [
          CanvasBox(
            width: 360,
            height: 44,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF00E5FF,
              borderRadius: EdgeInsets.all(22.0),
            ),
            children: [
              CanvasText(
                "🎬 8.1 ANIMATED GIF: IMAGE BOUNCE-IN",
                color: 0xFF0F172A,
                fontSize: 15.0,
                weight: 900,
              ),
            ],
          ).animate(
            1000,
            curve: TimingFunction.easeOutBack,
            fromX: -180.0,
            fromOpacity: 0.2,
          ),
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 240,
            height: 240,
            fit: ImageFit.cover,
            decoration: CanvasDecoration(
              borderRadius: EdgeInsets.all(28.0),
              borderColor: 0xFFFFFFFF,
              borderWidth: EdgeInsets.all(4.0),
              shadow: CanvasShadow(
                color: 0xAA00E5FF,
                offsetY: 14.0,
                blurRadius: 24.0,
                spreadRadius: 2.0,
              ),
            ),
          ).animate(
            1000,
            curve: TimingFunction.easeOutBounce,
            fromY: -200.0,
            fromScale: 0.35,
            fromOpacity: 0.2,
          ),
          CanvasBox(
            width: 380,
            height: 42,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFEC4899,
              borderRadius: EdgeInsets.all(14.0),
            ),
            children: [
              CanvasText(
                "Tweeny Curve: easeOutBounce | Format: GIF (20 FPS)",
                color: 0xFFFFFFFF,
                fontSize: 13.0,
                weight: 800,
              ),
            ],
          ).animate(
            1000,
            curve: TimingFunction.easeOutCubic,
            fromX: 180.0,
            fromOpacity: 0.2,
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.2: [FORMAT: GIF] Yoyo Floating Polaroid Images + Live Water Mirror
  // ============================================================================
  static TestCase _case8_2() => TestCase(
    "8.2 [GIF] Yoyo Polaroid Images + Live Mirror",
    CanvasDocument(
      format: const CanvasFormat(520.0, 480.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        direction: FlexDir.column,
        justifyContent: FlexJustify.start,
        alignItems: FlexAlign.center,
        padding: EdgeInsets.only(top: 28.0),
        gap: 24.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF090D16, 0xFF1E293B],
          gradientAngle: 90.0,
        ),
        children: [
          CanvasText(
            "8.2: YOYO FLOATING IMAGES + LIVE WATER REFLECTION",
            color: 0xFF38BDF8,
            fontSize: 16.0,
            weight: 900,
          ),
          CanvasBox(
            width: 460,
            height: 260,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceEvenly,
            alignItems: FlexAlign.center,
            children: [
              CanvasBox(
                width: 185,
                height: 215,
                padding: EdgeInsets.all(10.0),
                direction: FlexDir.column,
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFFFFFF,
                  borderRadius: EdgeInsets.all(14.0),
                  shadow: CanvasShadow(
                    color: 0x99000000,
                    offsetY: 10.0,
                    blurRadius: 16.0,
                  ),
                  mirror: CanvasReflection(
                    distance: 8.0,
                    blurRadius: 3.0,
                    opacity: 0.55,
                  ),
                ),
                children: [
                  CanvasImage(
                    base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                    width: 165,
                    height: 155,
                    fit: ImageFit.cover,
                    decoration: CanvasDecoration(
                      borderRadius: EdgeInsets.all(8.0),
                      isClip: true,
                    ),
                  ),
                  CanvasText(
                    "YOYO ROTATE #1",
                    color: 0xFF0F172A,
                    fontSize: 12.0,
                    weight: 800,
                  ),
                ],
              ).rotate(8.0).animate(
                1000,
                curve: TimingFunction.easeInOutSine,
                fromRotate: -22.0,
                fromScale: 0.78,
                yoyo: true,
                loop: true,
              ),
              CanvasBox(
                width: 185,
                height: 215,
                padding: EdgeInsets.all(10.0),
                direction: FlexDir.column,
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFFEF08A,
                  borderRadius: EdgeInsets.all(14.0),
                  shadow: CanvasShadow(
                    color: 0x99F59E0B,
                    offsetY: 10.0,
                    blurRadius: 16.0,
                  ),
                  mirror: CanvasReflection(
                    distance: 8.0,
                    blurRadius: 3.0,
                    opacity: 0.55,
                  ),
                ),
                children: [
                  CanvasImage(
                    base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                    width: 165,
                    height: 155,
                    fit: ImageFit.cover,
                    decoration: CanvasDecoration(
                      borderRadius: EdgeInsets.all(8.0),
                      isClip: true,
                    ),
                  ),
                  CanvasText(
                    "YOYO ROTATE #2",
                    color: 0xFF713F12,
                    fontSize: 12.0,
                    weight: 800,
                  ),
                ],
              ).rotate(-8.0).animate(
                1000,
                curve: TimingFunction.easeInOutSine,
                fromRotate: 22.0,
                fromScale: 0.78,
                yoyo: true,
                loop: true,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.3: [FORMAT: GIF] RLottie Vector Ring + Spinning Circular Image Avatar
  // ============================================================================
  static TestCase _case8_3() => TestCase(
    "8.3 [GIF] RLottie Vector Ring + Spinning Image",
    CanvasDocument(
      format: const CanvasFormat(480.0, 480.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
        children: [
          CanvasLottie(
            lottieJson: _kSampleLottieJson,
            width: 360,
            height: 360,
            initialFrame: 0,
            endFrame: 59,
            posType: PosType.absolute,
            top: 60,
            left: 60,
          ),
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 170,
            height: 170,
            fit: ImageFit.cover,
            decoration: CanvasDecoration(
              shape: BoxShape.circle,
              isClip: true,
              borderColor: 0xFF00E5FF,
              borderWidth: EdgeInsets.all(4.0),
              shadow: CanvasShadow(
                color: 0xCC7C3AED,
                blurRadius: 28.0,
                spreadRadius: 4.0,
              ),
            ),
          ).animate(
            1000,
            curve: TimingFunction.easeOutBack,
            fromScale: 0.25,
            fromRotate: -180.0,
            fromOpacity: 0.2,
          ),
          CanvasBox(
            width: 380,
            height: 38,
            posType: PosType.absolute,
            bottom: 22,
            left: 50,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xCC1E293B,
              borderRadius: EdgeInsets.all(19.0),
              borderColor: 0xFF38BDF8,
              borderWidth: EdgeInsets.all(1.5),
            ),
            children: [
              CanvasText(
                "RLottie Vector Frames + Tweeny easeOutBack Image",
                color: 0xFFFFFFFF,
                fontSize: 13.0,
                weight: 800,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.4: [FORMAT: PNG] High-DPI RGBA Image Gallery (Object-Fit & Masks)
  // ============================================================================
  static TestCase _case8_4() => TestCase(
    "8.4 [PNG] Image Fit & Mask Showcase (RGBA PNG)",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.png,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF0F172A, 0xFF1E293B],
          gradientAngle: 90.0,
        ),
        children: [
          CanvasBox(
            widthPct: 100,
            height: 58,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF0284C7,
              borderRadius: EdgeInsets.all(14.0),
            ),
            children: [
              CanvasText(
                "🖼️ 8.4 NATIVE PNG EXPORT: IMAGE FIT, CLIP & SHADOW SUITE",
                color: 0xFFFFFFFF,
                fontSize: 16.0,
                weight: 900,
              ),
            ],
          ),
          CanvasBox(
            widthPct: 100,
            direction: FlexDir.row,
            justifyContent: FlexJustify.spaceEvenly,
            alignItems: FlexAlign.center,
            children: [
              CanvasBox(
                width: 240,
                height: 310,
                padding: EdgeInsets.all(16.0),
                direction: FlexDir.column,
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF0F172A,
                  borderRadius: EdgeInsets.all(20.0),
                  borderColor: 0xFF38BDF8,
                  borderWidth: EdgeInsets.all(2.0),
                  shadow: CanvasShadow(
                    color: 0x8800E5FF,
                    blurRadius: 20.0,
                    offsetY: 8.0,
                  ),
                ),
                children: [
                  CanvasImage(
                    base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                    width: 184,
                    height: 204,
                    fit: ImageFit.cover,
                    decoration: CanvasDecoration(
                      borderRadius: EdgeInsets.all(18.0),
                      isClip: true,
                      borderColor: 0xFF00E5FF,
                      borderWidth: EdgeInsets.all(2.5),
                      shadow: CanvasShadow(
                        color: 0xFF00E5FF,
                        blurRadius: 22.0,
                        spreadRadius: 5.0,
                      ),
                    ),
                  ),
                  CanvasText(
                    "ImageFit.cover + Rounded(18)",
                    color: 0xFF38BDF8,
                    fontSize: 13.0,
                    weight: 800,
                  ),
                ],
              ),
              CanvasBox(
                width: 240,
                height: 310,
                padding: EdgeInsets.all(16.0),
                direction: FlexDir.column,
                justifyContent: FlexJustify.spaceBetween,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF0F172A,
                  borderRadius: EdgeInsets.all(20.0),
                  borderColor: 0xFFF43F5E,
                  borderWidth: EdgeInsets.all(2.0),
                  shadow: CanvasShadow(
                    color: 0x88F43F5E,
                    blurRadius: 20.0,
                    offsetY: 8.0,
                  ),
                ),
                children: [
                  CanvasImage(
                    base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                    width: 176,
                    height: 176,
                    fit: ImageFit.cover,
                    margin: EdgeInsets.only(top: 12.0),
                    decoration: CanvasDecoration(
                      shape: BoxShape.circle,
                      isClip: true,
                      borderColor: 0xFFFF2E93,
                      borderWidth: EdgeInsets.all(3.5),
                      shadow: CanvasShadow(
                        color: 0xFFFF0055,
                        blurRadius: 24.0,
                        spreadRadius: 8.0,
                      ),
                    ),
                  ),
                  CanvasText(
                    "BoxShape.circle + Neon Glow",
                    color: 0xFFFDA4AF,
                    fontSize: 13.0,
                    weight: 800,
                  ),
                ],
              ),
            ],
          ),
          CanvasBox(
            width: 510,
            height: 360,
            padding: EdgeInsets.all(18.0),
            direction: FlexDir.column,
            justifyContent: FlexJustify.start,
            alignItems: FlexAlign.center,
            gap: 12.0,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF090D16,
              borderRadius: EdgeInsets.all(22.0),
              borderColor: 0xFFA855F7,
              borderWidth: EdgeInsets.all(2.0),
            ),
            children: [
              CanvasText(
                "IMAGE WITH WATER MIRROR REFLECTION (IN PNG FRAMEBUFFER)",
                color: 0xFFD8B4FE,
                fontSize: 14.0,
                weight: 800,
              ),
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                width: 260,
                height: 160,
                fit: ImageFit.cover,
                decoration: CanvasDecoration(
                  borderRadius: EdgeInsets.all(16.0),
                  isClip: true,
                  mirror: CanvasReflection(
                    distance: 6.0,
                    blurRadius: 4.0,
                    opacity: 0.65,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.5: [FORMAT: JPG] Cinematic Rotated & Skewed Image Collage + BlendModes
  // ============================================================================
  static TestCase _case8_5() => TestCase(
    "8.5 [JPG] Rotated & Blended Image Collage (JPEG 95%)",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.jpg,
      exportQuality: 95,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFFFEF3C7, 0xFFFDE68A, 0xFFF59E0B],
          gradientAngle: 45.0,
        ),
        children: [
          CanvasBox(
            width: 520,
            height: 60,
            posType: PosType.absolute,
            top: 32,
            left: 37,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF0F172A,
              borderRadius: EdgeInsets.all(14.0),
            ),
            children: [
              CanvasText(
                "📸 8.5 NATIVE JPEG EXPORT (QUALITY: 95) + BLEND MODES",
                color: 0xFFFFEA00,
                fontSize: 15.0,
                weight: 900,
              ),
            ],
          ),
          CanvasBox(
            width: 340,
            height: 380,
            padding: EdgeInsets.all(14.0),
            direction: FlexDir.column,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(20.0),
              shadow: CanvasShadow(
                color: 0x77000000,
                offsetY: 16.0,
                blurRadius: 28.0,
              ),
            ),
            children: [
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                width: 312,
                height: 310,
                fit: ImageFit.cover,
              ),
              CanvasText(
                "STUDIO PORTRAIT MASTER (JPG)",
                color: 0xFF0F172A,
                fontSize: 15.0,
                weight: 900,
              ),
            ],
          ),
          CanvasBox(
            width: 220,
            height: 220,
            posType: PosType.absolute,
            top: 170,
            left: 55,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF00E5FF,
              borderRadius: EdgeInsets.all(110.0),
              blendMode: BlendMode.multiply,
            ),
            children: [
              CanvasText(
                "MULTIPLY\nBLEND OVER IMAGE",
                color: 0xFF0F172A,
                fontSize: 16.0,
                weight: 900,
                align: TextAlign.center,
              ),
            ],
          ),
          CanvasBox(
            width: 220,
            height: 220,
            posType: PosType.absolute,
            bottom: 140,
            right: 55,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFF007F,
              borderRadius: EdgeInsets.all(110.0),
              blendMode: BlendMode.multiply,
            ),
            children: [
              CanvasText(
                "COLOR OVERLAY\nON JPEG CANVAS",
                color: 0xFFFFFFFF,
                fontSize: 16.0,
                weight: 900,
                align: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.6: [FORMAT: WEBP] Lossless WebP Product Showcase + Mirror Reflection
  // ============================================================================
  static TestCase _case8_6() => TestCase(
    "8.6 [WEBP] Product Showcase Card (LibWebP Encoder)",
    CanvasDocument(
      format: const CanvasFormat(540.0, 680.0),
      targetFormat: TargetFormat.webp,
      exportQuality: 92,
      lossless: false,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(24.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceBetween,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF042F2E, 0xFF0F172A, 0xFF1E1B4B],
          gradientAngle: 120.0,
        ),
        children: [
          CanvasBox(
            widthPct: 100,
            height: 50,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF10B981,
              borderRadius: EdgeInsets.all(12.0),
            ),
            children: [
              CanvasText(
                "⚡ 8.6 NATIVE LIBWEBP EXPORT (.webp Format)",
                color: 0xFF042F2E,
                fontSize: 16.0,
                weight: 900,
              ),
            ],
          ),
          CanvasBox(
            width: 340,
            height: 360,
            padding: EdgeInsets.all(18.0),
            direction: FlexDir.column,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              gradient: const [0xFF1E293B, 0xFF0F172A],
              borderRadius: EdgeInsets.all(24.0),
              borderColor: 0xFF34D399,
              borderWidth: EdgeInsets.all(2.5),
              shadow: CanvasShadow(
                gradient: const [0xAA10B981, 0xAA38BDF8],
                offsetY: 14.0,
                blurRadius: 24.0,
                spreadRadius: 3.0,
              ),
              mirror: CanvasReflection(
                distance: 10.0,
                blurRadius: 5.0,
                opacity: 0.55,
              ),
            ),
            children: [
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                width: 300,
                height: 240,
                fit: ImageFit.cover,
                decoration: CanvasDecoration(
                  borderRadius: EdgeInsets.all(16.0),
                  isClip: true,
                ),
              ),
              CanvasText(
                "WEBP ULTRA-COMPRESSED CARD",
                color: 0xFF34D399,
                fontSize: 16.0,
                weight: 900,
              ),
              CanvasText(
                "Encoded directly in C++ via Google libwebp!",
                color: 0xFFCBD5E1,
                fontSize: 12.0,
              ),
            ],
          ),
          CanvasBox(height: 90),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.7: [FORMAT: GIF] 4 Tweeny Easing Curves Race (Side-by-Side Image Runners)
  // ============================================================================
  static TestCase _case8_7() {
    CanvasBox buildRunnerTrack(
        String label,
        TimingFunction curve,
        int accentColor,
        ) {
      return CanvasBox(
        width: 460,
        height: 92,
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        direction: FlexDir.row,
        justifyContent: FlexJustify.end,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          backgroundColor: 0xFF1E293B,
          borderRadius: EdgeInsets.all(14.0),
          borderColor: accentColor,
          borderWidth: EdgeInsets.all(1.5),
        ),
        children: [
          CanvasBox(
            posType: PosType.absolute,
            left: 16,
            top: 34,
            children: [
              CanvasText(
                label,
                color: accentColor,
                fontSize: 14.0,
                weight: 800,
              ),
            ],
          ),
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 72,
            height: 72,
            fit: ImageFit.cover,
            decoration: CanvasDecoration(
              borderRadius: EdgeInsets.all(12.0),
              borderColor: accentColor,
              borderWidth: EdgeInsets.all(2.5),
            ),
          ).animate(1000, curve: curve, fromX: -240.0, fromRotate: -45.0),
        ],
      );
    }

    return TestCase(
      "8.7 [GIF] 4 Tweeny Curves Race (Linear/Back/Elastic/Bounce)",
      CanvasDocument(
        format: const CanvasFormat(520.0, 520.0),
        targetFormat: TargetFormat.gif,
        body: CanvasBox(
          widthPct: 100,
          heightPct: 100,
          padding: EdgeInsets.all(22.0),
          direction: FlexDir.column,
          justifyContent: FlexJustify.spaceBetween,
          alignItems: FlexAlign.center,
          decoration: CanvasDecoration(backgroundColor: 0xFF090D16),
          children: [
            CanvasText(
              "🏁 8.7 TWEENY EASING CURVE RACE (20-FRAME GIF)",
              color: 0xFFFFFFFF,
              fontSize: 16.0,
              weight: 900,
            ),
            buildRunnerTrack(
              "1. TimingFunction.linear",
              TimingFunction.linear,
              0xFF38BDF8,
            ),
            buildRunnerTrack(
              "2. TimingFunction.easeOutBack",
              TimingFunction.easeOutBack,
              0xFFA855F7,
            ),
            buildRunnerTrack(
              "3. TimingFunction.easeOutElastic",
              TimingFunction.easeOutElastic,
              0xFFF43F5E,
            ),
            buildRunnerTrack(
              "4. TimingFunction.easeOutBounce",
              TimingFunction.easeOutBounce,
              0xFF10B981,
            ),
          ],
        ),
      ),
      category: _cat,
      needsImageFile: true,
    );
  }

  // ============================================================================
  // 🧪 Case 8.8: [FORMAT: HTML] Interactive HTML5/CSS3 Hero Poster with Images & Links
  // ============================================================================
  static TestCase _case8_8() => TestCase(
    "8.8 [HTML] Interactive HTML5/CSS3 Image Banner",
    CanvasDocument(
      format: CanvasFormat.a4,
      targetFormat: TargetFormat.html,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.all(32.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.spaceEvenly,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(
          gradient: const [0xFF0F172A, 0xFF1E1B4B, 0xFF0284C7],
          gradientAngle: 45.0,
        ),
        children: [
          CanvasText(
            "🌐 8.8 HTML5 / CSS3 DOM EXPORT",
            color: 0xFF38BDF8,
            fontSize: 22.0,
            weight: 900,
          ),
          CanvasBox(
            width: 340,
            height: 360,
            padding: EdgeInsets.all(16.0),
            direction: FlexDir.column,
            justifyContent: FlexJustify.spaceBetween,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFFFF,
              borderRadius: EdgeInsets.all(20.0),
              shadow: CanvasShadow(
                color: 0x88000000,
                offsetY: 16.0,
                blurRadius: 30.0,
              ),
            ),
            children: [
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                width: 308,
                height: 270,
                fit: ImageFit.cover,
              ),
              CanvasText(
                "CSS3 Transformed Image Card (-4 deg)",
                color: 0xFF0F172A,
                fontSize: 15.0,
                weight: 800,
              ),
            ],
          ).rotate(-4.0),
          CanvasBox(
            width: 320,
            height: 54,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            linkUrl: "https://flutter.dev",
            decoration: CanvasDecoration(
              gradient: const [0xFF10B981, 0xFF059669],
              borderRadius: EdgeInsets.all(27.0),
              shadow: CanvasShadow(
                color: 0x8810B981,
                blurRadius: 16.0,
                offsetY: 6.0,
              ),
            ),
            children: [
              CanvasText(
                "🔗 CLICKABLE HTML5 LINK (flutter.dev)",
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
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.9: [FORMAT: GIF] Kaleidoscope Counter-Rotating Image Vortex
  // ============================================================================
  static TestCase _case8_9() => TestCase(
    "8.9 [GIF] Kaleidoscope Counter-Rotating Image Vortex",
    CanvasDocument(
      format: const CanvasFormat(480.0, 480.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        justifyContent: FlexJustify.center,
        alignItems: FlexAlign.center,
        decoration: CanvasDecoration(backgroundColor: 0xFF050811),
        children: [
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 320,
            height: 320,
            fit: ImageFit.cover,
            posType: PosType.absolute,
            top: 80,
            left: 80,
            decoration: CanvasDecoration(
              borderRadius: EdgeInsets.all(36.0),
              borderColor: 0xFF7C3AED,
              borderWidth: EdgeInsets.all(4.0),
              opacity: 0.55,
            ),
          ).rotate(15.0).animate(
            1000,
            curve: TimingFunction.easeInOutCubic,
            fromRotate: -90.0,
            fromScale: 0.65,
            yoyo: true,
          ),
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 230,
            height: 230,
            fit: ImageFit.cover,
            posType: PosType.absolute,
            top: 125,
            left: 125,
            decoration: CanvasDecoration(
              borderRadius: EdgeInsets.all(28.0),
              borderColor: 0xFFEC4899,
              borderWidth: EdgeInsets.all(4.0),
              opacity: 0.80,
            ),
          ).rotate(-15.0).animate(
            1000,
            curve: TimingFunction.easeInOutCubic,
            fromRotate: 90.0,
            fromScale: 0.5,
            yoyo: true,
          ),
          CanvasImage(
            base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
            width: 140,
            height: 140,
            fit: ImageFit.cover,
            posType: PosType.absolute,
            top: 170,
            left: 170,
            decoration: CanvasDecoration(
              shape: BoxShape.circle,
              isClip: true,
              borderColor: 0xFF00E5FF,
              borderWidth: EdgeInsets.all(4.0),
              shadow: CanvasShadow(color: 0xCC00E5FF, blurRadius: 24.0),
            ),
          ).animate(
            1000,
            curve: TimingFunction.easeOutBack,
            fromScale: 0.2,
            yoyo: true,
          ),
          CanvasBox(
            width: 400,
            height: 36,
            posType: PosType.absolute,
            bottom: 18,
            left: 40,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xCC0F172A,
              borderRadius: EdgeInsets.all(18.0),
            ),
            children: [
              CanvasText(
                "8.9 COUNTER-ROTATING 3-LAYER IMAGE VORTEX (GIF)",
                color: 0xFF00E5FF,
                fontSize: 13.0,
                weight: 800,
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );

  // ============================================================================
  // 🧪 Case 8.10: [FORMAT: GIF] Grand Finale (SVG-Clipped Shield Image + RLottie + Mirror + Tweeny)
  // ============================================================================
  static TestCase _case8_10() => TestCase(
    "8.10 [GIF] Grand Finale: Shield Image + RLottie + Mirror",
    CanvasDocument(
      format: const CanvasFormat(500.0, 560.0),
      targetFormat: TargetFormat.gif,
      body: CanvasBox(
        widthPct: 100,
        heightPct: 100,
        padding: EdgeInsets.only(top: 20.0),
        direction: FlexDir.column,
        justifyContent: FlexJustify.start,
        alignItems: FlexAlign.center,
        gap: 14.0,
        decoration: CanvasDecoration(
          gradient: const [0xFF090D16, 0xFF1E1B4B, 0xFF0F172A],
          gradientAngle: 90.0,
        ),
        children: [
          CanvasText(
            "🏆 8.10 GRAND FINALE: SHIELD IMAGE + RLOTTIE + MIRROR",
            color: 0xFFFFEA00,
            fontSize: 14.5,
            weight: 900,
          ),
          CanvasBox(
            width: 260,
            height: 290,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF1E293B,
              isClip: true,
              clipSvgPath:
              "M 130 0 C 180 24 228 24 260 32 C 260 145 228 226 130 290 C 32 226 0 145 0 32 C 32 24 80 24 130 0 Z",
              shadow: CanvasShadow(
                color: 0xAA00E5FF,
                offsetY: 12.0,
                blurRadius: 22.0,
                spreadRadius: 2.0,
              ),
              mirror: CanvasReflection(
                distance: 10.0,
                blurRadius: 4.0,
                opacity: 0.55,
              ),
            ),
            children: [
              CanvasImage(
                base64Data: "DYNAMIC_IMAGE_PLACEHOLDER",
                width: 260,
                height: 290,
                fit: ImageFit.cover,
              ),
              CanvasLottie(
                lottieJson: _kSampleLottieJson,
                width: 190,
                height: 190,
                initialFrame: 0,
                endFrame: 59,
                posType: PosType.absolute,
                top: 50,
                left: 35,
              ),
            ],
          ).animate(
            1000,
            curve: TimingFunction.easeOutBack,
            fromScale: 0.45,
            fromY: -90.0,
            fromOpacity: 0.25,
          ),
        ],
      ),
    ),
    category: _cat,
    needsImageFile: true,
  );
}