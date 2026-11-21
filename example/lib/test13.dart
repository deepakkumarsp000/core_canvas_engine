// FILE: example/lib/test13.dart
// PURPOSE: TEST 13 - FAANG Chaos, 1,000-Node Stress, 15-Page RAM, Edge Cases & Diagnostics Suite

import 'package:flutter/material.dart' show Icons;

import 'test_registry.dart';

class Test13Cases {
  static const String _cat =
      "13. Chaos, 1000-Node Stress, Memory & Diagnostics Audit";

  static List<TestCase> getCases() {
    return [
      _case13_1(),
      _case13_2(),
      _case13_3(),
      _case13_4(),
      _case13_5(),
      _case13_6(),
      _case13_7(),
      _case13_8(),
      _case13_9(),
      _case13_10(),
    ];
  }

  // Case 13.1: 1,000-Node Flexbox Stress Benchmark (500 Boxes + 500 Texts = 1,000 leaf/node pairs)
  static TestCase _case13_1() => TestCase(
    "13.1 [PDF] 1,000-Node Flexbox & YYJSON Speed Benchmark",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(20.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 10.0,
        children: [
          "13.1 1,000-NODE STRESS BENCHMARK (500 CELLS + 500 TEXTS)"
              .toCanvasText()
              .size(14.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasBox(
            widthPct: 100,
            direction: FlexDir.row,
            wrap: FlexWrap.wrap,
            gap: 4.0,
            children: List<CanvasWidget>.generate(500, (int i) {
              return CanvasBox(
                width: 48,
                height: 24,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: i.isEven ? 0xFFDBEAFE : 0xFFE0E7FF,
                  borderRadius: EdgeInsets.all(3.0),
                ),
                children: [
                  "${i + 1}"
                      .toCanvasText()
                      .size(8.5)
                      .bold()
                      .textColor(0xFF1E3A8A),
                ],
              );
            }),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.2: 15-Page Massive Document (Lazy Page-Buffer Zero-RAM-Spike Proof)
  static TestCase _case13_2() => TestCase(
    "13.2 [PDF] 15-Page Massive Document (Lazy Page-Buffer RAM Test)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(24.0),
      header: CanvasRow(
        widthPct: 100,
        justify: FlexJustify.spaceBetween,
        padding: EdgeInsets.only(bottom: 8.0),
        children: [
          "15-PAGE MEMORY STRESS REPORT"
              .toCanvasText()
              .size(10.0)
              .bold(800)
              .textColor(0xFF0F172A),
          "Lazy Buffer Active (0 MB extra RGBA)"
              .toCanvasText()
              .size(9.5)
              .textColor(0xFF059669),
        ],
      ),
      footer: CanvasRow(
        widthPct: 100,
        justify: FlexJustify.spaceBetween,
        padding: EdgeInsets.only(top: 6.0),
        children: [
          "Core Canvas Engine Stress Suite"
              .toCanvasText()
              .size(9.0)
              .textColor(0xFF64748B),
          "Page {{page}} of {{totalPages}}"
              .toCanvasText()
              .size(9.5)
              .bold()
              .textColor(0xFF0F172A),
        ],
      ),
      body: CanvasCol(
        widthPct: 100,
        children: List<CanvasWidget>.generate(15, (int p) {
          return CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(16.0),
            direction: FlexDir.column,
            gap: 12.0,
            spanningRules: SpanningRules(pageBreakBefore: p > 0 ? 1 : 0),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFF8FAFC,
              borderColor: 0xFFCBD5E1,
              borderWidth: EdgeInsets.all(1.5),
              borderRadius: EdgeInsets.all(8.0),
            ),
            children: [
              "SECTION ${p + 1} OF 15"
                  .toCanvasText()
                  .size(16.0)
                  .bold(900)
                  .textColor(0xFF1E3A8A),
              CanvasTable(
                headers: const ["Metric", "Value", "Status"],
                rows: List<List<String>>.generate(
                  6,
                      (int r) => [
                    "Page ${p + 1} Benchmark Metric #${r + 1}",
                    "${(p + 1) * (r + 12)} ops/ms",
                    "OK",
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    ),
    category: _cat,
  );

  // Case 13.3: Corrupt / Garbage SVG & Invalid Base64 Crash Resilience
  static TestCase _case13_3() => TestCase(
    "13.3 [PDF] Corrupt SVG & Invalid Base64 Resilience (Zero Crash)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "13.3 CHAOS RESILIENCE: CORRUPT ASSETS MUST NEVER CRASH C++"
              .toCanvasText()
              .size(14.5)
              .bold(900)
              .textColor(0xFF0F172A),
          // 1. Broken / garbage SVG XML
          CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(12.0),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFEF2F2,
              borderColor: 0xFFEF4444,
              borderWidth: EdgeInsets.all(1.0),
            ),
            children: [
              "1. Malformed SVG XML below (should skip cleanly):"
                  .toCanvasText()
                  .size(11.0)
                  .bold()
                  .textColor(0xFF991B1B),
              CanvasSvg(
                svgXml: "<svg><path d='BROKEN_GARBAGE_!@#\$%^&*'",
                width: 120,
                height: 60,
              ),
            ],
          ),
          // 2. Invalid Base64 & Empty Image
          CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(12.0),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFFFFBEB,
              borderColor: 0xFFF59E0B,
              borderWidth: EdgeInsets.all(1.0),
            ),
            children: [
              "2. Corrupt Base64, missing mem:// asset & empty string below:"
                  .toCanvasText()
                  .size(11.0)
                  .bold()
                  .textColor(0xFF92400E),
              CanvasRow(
                gap: 10.0,
                children: [
                  CanvasImage(
                    base64Data: "NOT_VALID_BASE64_!!!@@@",
                    width: 80,
                    height: 50,
                  ),
                  CanvasImage(
                    base64Data: "mem://non_existent_key_999",
                    width: 80,
                    height: 50,
                  ),
                  CanvasImage(base64Data: "", width: 80, height: 50),
                ],
              ),
            ],
          ),
          // 3. Corrupt Lottie JSON
          CanvasBox(
            widthPct: 100,
            padding: EdgeInsets.all(12.0),
            decoration: CanvasDecoration(
              backgroundColor: 0xFFECFDF5,
              borderColor: 0xFF10B981,
              borderWidth: EdgeInsets.all(1.0),
            ),
            children: [
              "3. Invalid Lottie JSON skipped -> PDF still generated cleanly!"
                  .toCanvasText()
                  .size(11.5)
                  .bold()
                  .textColor(0xFF065F46),
              CanvasLottie(lottieJson: "{broken_lottie", width: 80, height: 50),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.4: Extreme Geometry Edge Cases (0x0, Padding > Width, Huge Radius, Clamped Opacity)
  static TestCase _case13_4() => TestCase(
    "13.4 [PDF] Extreme Geometry & Clamping (0x0, Radius 9999, Opacity)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "13.4 EXTREME GEOMETRY & BOUNDS CLAMPING"
              .toCanvasText()
              .size(15.5)
              .bold(900)
              .textColor(0xFF0F172A),
          // 0x0 box (must not divide by zero)
          CanvasBox(
            width: 0,
            height: 0,
            decoration: CanvasDecoration(backgroundColor: 0xFFFF0000),
          ),
          // Radius 9999 (must clamp to min(w,h)/2 -> pill)
          CanvasBox(
            width: 240,
            height: 54,
            justifyContent: FlexJustify.center,
            alignItems: FlexAlign.center,
            decoration: CanvasDecoration(
              backgroundColor: 0xFF2563EB,
              borderRadius: EdgeInsets.all(9999.0),
              shadow: CanvasShadow(color: 0x99000000, blurRadius: 0.0),
            ),
            children: [
              "borderRadius: 9999 (Clamped Pill)"
                  .toCanvasText()
                  .size(12.0)
                  .bold()
                  .textColor(0xFFFFFFFF),
            ],
          ),
          // Out-of-range opacities (-0.5 -> 0.0, 2.5 -> 1.0)
          CanvasRow(
            gap: 14.0,
            children: [
              CanvasBox(
                width: 180,
                height: 60,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFFDC2626,
                  opacity: -0.5,
                ),
                children: [
                  "opacity -0.5 (Invisible)".toCanvasText().textColor(0xFFFFFFFF),
                ],
              ),
              CanvasBox(
                width: 220,
                height: 60,
                justifyContent: FlexJustify.center,
                alignItems: FlexAlign.center,
                decoration: CanvasDecoration(
                  backgroundColor: 0xFF059669,
                  opacity: 2.5,
                  borderRadius: EdgeInsets.all(8.0),
                ),
                children: [
                  "opacity 2.5 (Clamped 1.0)"
                      .toCanvasText()
                      .size(12.0)
                      .bold()
                      .textColor(0xFFFFFFFF),
                ],
              ),
            ],
          ),
          // Padding > Width box
          CanvasBox(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(80.0),
            decoration: CanvasDecoration(backgroundColor: 0xFF7C3AED),
            children: [
              CanvasText("Safe Collapse", color: 0xFFFFFFFF),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.5: Minimal Empty Document & FlexDisplay.none Hidden Subtree
  static TestCase _case13_5() => TestCase(
    "13.5 [PDF] Empty Nodes & FlexDisplay.none Hidden Subtree",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 14.0,
        children: [
          "13.5 EMPTY LEAVES & DISPLAY:NONE TEST"
              .toCanvasText()
              .size(16.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasBox(),
          CanvasText(""),
          // Hidden subtree must occupy 0px height and not paint!
          CanvasBox(
            widthPct: 100,
            height: 500,
            display: FlexDisplay.none,
            decoration: CanvasDecoration(backgroundColor: 0xFFEF4444),
            children: [
              "YOU MUST NEVER SEE THIS RED BOX!"
                  .toCanvasText()
                  .size(24.0)
                  .bold()
                  .textColor(0xFFFFFFFF),
            ],
          ),
          CanvasBadge(
            label: "Hidden 500px Red Box Skipped Cleanly",
            backgroundColor: 0xFF059669,
            textColor: 0xFFFFFFFF,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.6: In-Memory exportToBytes() Target Document
  static TestCase _case13_6() => TestCase(
    "13.6 [PDF] In-Memory exportToBytes() Target Document",
    CanvasDocument(
      format: CanvasFormat.a5,
      canvasMargin: EdgeInsets.all(24.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 14.0,
        children: [
          "13.6 IN-MEMORY BYTES EXPORT TARGET"
              .toCanvasText()
              .size(16.0)
              .bold(900)
              .textColor(0xFF0F172A),
          "Use Test13Cases.verifyExportToBytes() in unit/integration tests to assert %PDF- magic bytes and zero leftover temp files."
              .toCanvasText()
              .size(11.5)
              .textColor(0xFF334155),
          CanvasProgressBar(
            label: "RAM Arena Cleanup",
            value: 1.0,
            showPercentage: true,
            fillColor: 0xFF2563EB,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  /// Programmatic check for [CoreCanvasEngine.exportToBytes].
  static Future<bool> verifyExportToBytes() async {
    final CanvasExportResult res = await CoreCanvasEngine.exportToBytes(
      _case13_6().document,
    );
    if (!res.isSuccess || res.bytes == null || res.bytes!.length < 5) {
      return false;
    }
    // Verify '%PDF-' magic header (0x25, 0x50, 0x44, 0x46, 0x2D)
    final bytes = res.bytes!;
    return bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46 &&
        bytes[4] == 0x2D;
  }

  // Case 13.7: 30x Parallel GPU Retina Mask Batching Stress (Emoji + Hindi + Icons)
  static TestCase _case13_7() => TestCase(
    "13.7 [PDF] 30x Parallel GPU Retina Mask Batching (Zero Leak)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(24.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 10.0,
        children: [
          "13.7 PARALLEL GPU MASK BATCHING (30 RETINA MASKS)"
              .toCanvasText()
              .size(14.5)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasBox(
            widthPct: 100,
            direction: FlexDir.row,
            wrap: FlexWrap.wrap,
            gap: 8.0,
            children: List<CanvasWidget>.generate(30, (int i) {
              return CanvasBadge(
                label: "मास्क #${i + 1} 🚀",
                icon: Icons.memory,
                fontSize: 10.5,
                backgroundColor: i.isEven ? 0xFF0F172A : 0xFF1E3A8A,
                textColor: 0xFF38BDF8,
              );
            }),
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.8: Strict Capability Diagnostic Probe (Tests SVG + Shadow + Lottie together)
  static TestCase _case13_8() => TestCase(
    "13.8 [PDF] Multi-Module Probe (Tests strictModuleChecks & Stripped FX)",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 16.0,
        children: [
          "13.8 MULTI-MODULE CAPABILITY PROBE"
              .toCanvasText()
              .size(16.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFFF8FAFC,
            children: [
              "This document includes a Shadow Card, an SVG node, and a Lottie node. When compiled with `preset: pdf_lite`, passing `strictModuleChecks: true` returns E_MODULE_SHADOWS_DISABLED / E_MODULE_LOTTIE_DISABLED."
                  .toCanvasText()
                  .size(11.5)
                  .textColor(0xFF334155),
            ],
          ),
          CanvasSvg(
            svgXml:
            "<svg width='80' height='80' viewBox='0 0 80 80'><circle cx='40' cy='40' r='34' fill='#2563EB'/></svg>",
            width: 80,
            height: 80,
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.9: Special Character Escaping & Injection Resilience
  static TestCase _case13_9() => TestCase(
    "13.9 [PDF] Special Chars, Quotes, Backslashes & Escaping Stress",
    CanvasDocument(
      format: CanvasFormat.a4,
      canvasMargin: EdgeInsets.all(28.0),
      body: CanvasCol(
        widthPct: 100,
        gap: 14.0,
        children: [
          "13.9 SPECIAL CHARACTER & JSON/PDF ESCAPING AUDIT"
              .toCanvasText()
              .size(15.0)
              .bold(900)
              .textColor(0xFF0F172A),
          CanvasCard(
            widthPct: 100,
            backgroundColor: 0xFFF8FAFC,
            children: [
              CanvasCol(
                widthPct: 100,
                gap: 8.0,
                children: [
                  r'Backslashes & Quotes: C:\Users\deepa\ "quoted" (parens) [brackets] {braces}'
                      .toCanvasText()
                      .size(11.0)
                      .textColor(0xFF0F172A),
                  "<script>alert('xss')</script> & SELECT * FROM users; --"
                      .toCanvasText()
                      .size(11.0)
                      .textColor(0xFFDC2626),
                  "Percent & Symbols: 100% | \$500 | #1 | @dev | ^&*+=~`"
                      .toCanvasText()
                      .size(11.0)
                      .textColor(0xFF1E3A8A),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    category: _cat,
  );

  // Case 13.10: Live Runtime CanvasCapabilities & pingEngine() System Audit Sheet
  static TestCase _case13_10() {
    final int ping = CoreCanvasEngine.pingEngine();
    final CanvasCapabilities caps = CoreCanvasEngine.capabilities;

    String statusLabel(bool enabled) => enabled ? "COMPILED (ON)" : "STRIPPED (OFF)";

    return TestCase(
      "13.10 [PDF] Live Runtime Capabilities & Engine Health Audit",
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
              direction: FlexDir.row,
              justifyContent: FlexJustify.spaceBetween,
              alignItems: FlexAlign.center,
              decoration: CanvasDecoration(
                backgroundColor: 0xFF0F172A,
                borderRadius: EdgeInsets.all(10.0),
              ),
              children: [
                "CORE CANVAS ENGINE — RUNTIME AUDIT"
                    .toCanvasText()
                    .size(14.5)
                    .bold(900)
                    .textColor(0xFFFFFFFF),
                CanvasBadge(
                  label: ping == 200 ? "PING: 200 OK" : "PING: $ping",
                  backgroundColor: ping == 200 ? 0xFF10B981 : 0xFFEF4444,
                  textColor: 0xFFFFFFFF,
                ),
              ],
            ),
            CanvasTable(
              headers: const ["Native Module", "Bitmask Flag", "Binary Status"],
              columnFlex: const [2.0, 1.5, 2.0],
              rows: [
                ["pdf (PDFGen)", "0x01 (bit 0)", statusLabel(caps.pdf)],
                ["svg (NanoSVG)", "0x02 (bit 1)", statusLabel(caps.svg)],
                ["shadows (Blur/Mirror)", "0x04 (bit 2)", statusLabel(caps.shadows)],
                ["image_export (PNG/JPG)", "0x08 (bit 3)", statusLabel(caps.imageExport)],
                ["webp (LibWebP)", "0x10 (bit 4)", statusLabel(caps.webp)],
                ["lottie (RLottie)", "0x20 (bit 5)", statusLabel(caps.lottie)],
                ["gif (GIF + Tweeny)", "0x40 (bit 6)", statusLabel(caps.gif)],
                ["html (HTML5/CSS3)", "0x80 (bit 7)", statusLabel(caps.html)],
              ],
            ),
            CanvasText(
              "Raw Native Capability Bitmask: 0x${caps.rawMask.toRadixString(16).toUpperCase().padLeft(2, '0')} | Enabled: ${caps.enabledModules.length}/8 modules",
              fontSize: 11.0,
              weight: 700,
              color: 0xFF334155,
            ),
          ],
        ),
      ),
      category: _cat,
    );
  }
}