// FILE: lib/ffi/engine_bridge.dart
// PURPOSE: Enterprise Dart FFI Bridge to C++ Core Canvas Engine
// Features: Pre-Flight Capability Validation, Typed CanvasExportResult, In-Memory Bytes Export,
// Parallel GPU Retina Mask Batching & Zero-Copy Native Memory Arena.

import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../models/canvas_result.dart';
import '../widgets/core_widgets.dart' show CanvasDocument;
import 'canvas_bindings.g.dart';

int _maskAssetCounter = 0;

/// High-performance FFI controller for the native C++ Core Canvas Engine.
class CoreCanvasEngine {
  static CanvasBindings? _bindings;
  static CanvasCapabilities? _cachedCapabilities;

  /// Lazy-loads the compiled native shared library for the current platform.
  static CanvasBindings get bindings {
    if (_bindings != null) return _bindings!;

    final ffi.DynamicLibrary dylib;
    if (Platform.isAndroid || Platform.isLinux) {
      dylib = ffi.DynamicLibrary.open('libcore_canvas_engine.so');
    } else if (Platform.isWindows) {
      dylib = ffi.DynamicLibrary.open('core_canvas_engine.dll');
    } else if (Platform.isIOS || Platform.isMacOS) {
      dylib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError(
        'CoreCanvasEngine is not supported on ${Platform.operatingSystem}.',
      );
    }

    _bindings = CanvasBindings(dylib);
    return _bindings!;
  }

  /// Native health check. Returns `200` if the native engine is loaded and healthy.
  static int pingEngine() {
    try {
      return bindings.ping_engine();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CoreCanvasEngine] pingEngine failed: $e');
      }
      return 0;
    }
  }

  /// Shorthand alias for [pingEngine].
  static int ping() => pingEngine();

  /// Returns the cached compile-time native module capabilities of the active binary.
  static CanvasCapabilities get capabilities {
    if (_cachedCapabilities != null) return _cachedCapabilities!;
    try {
      final int mask = bindings.get_engine_capabilities();
      _cachedCapabilities = CanvasCapabilities(mask);
      return _cachedCapabilities!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[CoreCanvasEngine] Failed to query native capabilities: $e',
        );
      }
      return CanvasCapabilities.none;
    }
  }

  /// Zero-Copy Binary Arena: copies raw image bytes directly into native RAM and
  /// returns a lightweight `mem://<assetId>` token (falls back to Base64 on failure).
  static String registerMemoryAsset(String assetId, Uint8List bytes) {
    if (bytes.isEmpty) return '';
    ffi.Pointer<ffi.Char> idPtr = ffi.nullptr;
    ffi.Pointer<ffi.Uint8> dataPtr = ffi.nullptr;

    try {
      idPtr = assetId.toNativeUtf8().cast<ffi.Char>();
      dataPtr = calloc<ffi.Uint8>(bytes.length);
      final Uint8List nativeSlice = dataPtr.asTypedList(bytes.length);
      nativeSlice.setAll(0, bytes);

      final int ok = bindings.register_memory_asset(
        idPtr,
        dataPtr,
        bytes.length,
      );
      if (ok == 1) {
        return 'mem://$assetId';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[CoreCanvasEngine] Memory arena unavailable, using Base64 fallback: $e',
        );
      }
    } finally {
      if (idPtr != ffi.nullptr) calloc.free(idPtr);
      if (dataPtr != ffi.nullptr) calloc.free(dataPtr);
    }
    return base64Encode(bytes);
  }

  /// Releases all binary assets stored in the native C++ Memory Arena.
  static void clearMemoryAssets() {
    try {
      _maskAssetCounter = 0;
      bindings.clear_memory_assets();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CoreCanvasEngine] clearMemoryAssets error: $e');
      }
    }
  }

  /// Synchronous FFI entrypoint returning the raw native status code (`1` = OK, `< 0` = error).
  static int executeNativeExport(String jsonPayload, String outputPath) {
    if (jsonPayload.isEmpty || outputPath.isEmpty) {
      return CanvasErrorCode.invalidArguments.nativeCode;
    }

    ffi.Pointer<ffi.Char> jsonPtr = ffi.nullptr;
    ffi.Pointer<ffi.Char> pathPtr = ffi.nullptr;

    try {
      final File outFile = File(outputPath);
      if (!outFile.parent.existsSync()) {
        outFile.parent.createSync(recursive: true);
      }

      jsonPtr = jsonPayload.toNativeUtf8().cast<ffi.Char>();
      pathPtr = outputPath.toNativeUtf8().cast<ffi.Char>();

      return bindings.generate_pdf(jsonPtr, pathPtr);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CoreCanvasEngine] Native FFI call failed: $e');
      }
      return CanvasErrorCode.internalNativeError.nativeCode;
    } finally {
      if (jsonPtr != ffi.nullptr) calloc.free(jsonPtr);
      if (pathPtr != ffi.nullptr) calloc.free(pathPtr);
    }
  }

  /// Synchronous boolean wrapper (retained for backward compatibility).
  static bool generatePdf(String jsonPayload, String outputPath) {
    return executeNativeExport(jsonPayload, outputPath) ==
        CanvasErrorCode.ok.nativeCode;
  }

  // ==========================================================================
  // ENTERPRISE EXPORT APIS (Structured CanvasExportResult & Diagnostics)
  // ==========================================================================

  /// Exports a [CanvasDocument] directly to [outputPath] and returns a typed [CanvasExportResult].
  ///
  /// Performs zero-cost pre-flight capability validation before invoking GPU rasterization
  /// or spawning a background Isolate.
  static Future<CanvasExportResult> exportDocument(
    CanvasDocument document,
    String outputPath, {
    bool autoClearArena = true,
    bool strictModuleChecks = false,
  }) {
    return exportFromMap(
      document.toJsonMap(),
      outputPath,
      autoClearArena: autoClearArena,
      strictModuleChecks: strictModuleChecks,
    );
  }

  /// Renders a [CanvasDocument] and returns the resulting artifact in memory (`result.bytes`).
  ///
  /// Automatically cleans up the temporary staging file after reading bytes.
  static Future<CanvasExportResult> exportToBytes(
    CanvasDocument document, {
    bool autoClearArena = true,
    bool strictModuleChecks = false,
  }) async {
    final Stopwatch sw = Stopwatch()..start();
    final String ext = _extensionForFormat(document.targetFormat.value);
    final String tempPath =
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'core_canvas_${DateTime.now().microsecondsSinceEpoch}.$ext';

    try {
      final CanvasExportResult fileResult = await exportDocument(
        document,
        tempPath,
        autoClearArena: autoClearArena,
        strictModuleChecks: strictModuleChecks,
      );

      if (!fileResult.isSuccess) {
        return fileResult;
      }

      final File tempFile = File(tempPath);
      if (!tempFile.existsSync()) {
        sw.stop();
        return CanvasExportResult.failure(
          error: CanvasEngineException.fromErrorCode(
            CanvasErrorCode.outputWriteFailed,
            detail: 'Rendered temporary file was not found on disk.',
          ),
          elapsed: sw.elapsed,
        );
      }

      final Uint8List bytes = await tempFile.readAsBytes();
      sw.stop();
      return CanvasExportResult.success(
        bytes: bytes,
        fileSizeBytes: bytes.length,
        elapsed: sw.elapsed,
      );
    } catch (e) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.internalNativeError,
          detail: 'Failed reading rendered artifact bytes.',
          originalError: e,
        ),
        elapsed: sw.elapsed,
      );
    } finally {
      try {
        final File tempFile = File(tempPath);
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      } catch (_) {}
    }
  }

  /// Exports a pre-built Document AST Map to [outputPath] with typed diagnostics.
  static Future<CanvasExportResult> exportFromMap(
    Map<String, dynamic> docMap,
    String outputPath, {
    bool autoClearArena = true,
    bool strictModuleChecks = false,
  }) async {
    final Stopwatch sw = Stopwatch()..start();

    if (outputPath.trim().isEmpty) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.invalidArguments,
          detail: 'Output file path must not be empty.',
        ),
        elapsed: sw.elapsed,
      );
    }

    // 1. Pre-flight native capability validation (fail-fast in <0.05 ms)
    final CanvasEngineException? preflightErr = _validateCapabilitiesForDoc(
      docMap,
      strictModuleChecks: strictModuleChecks,
    );
    if (preflightErr != null) {
      sw.stop();
      return CanvasExportResult.failure(
        error: preflightErr,
        elapsed: sw.elapsed,
        outputPath: outputPath,
      );
    }

    try {
      await _injectDocumentTextMasks(docMap);

      final String finalPayload = jsonEncode(docMap);
      final int nativeStatus = await Isolate.run(
        () => executeNativeExport(finalPayload, outputPath),
      );
      sw.stop();

      return _buildResultFromNativeStatus(
        nativeStatus: nativeStatus,
        outputPath: outputPath,
        targetFormat: _extractTargetFormat(docMap),
        elapsed: sw.elapsed,
      );
    } catch (e) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.internalNativeError,
          originalError: e,
        ),
        elapsed: sw.elapsed,
        outputPath: outputPath,
      );
    } finally {
      if (autoClearArena) {
        clearMemoryAssets();
      }
    }
  }

  /// Exports a raw JSON AST payload string to [outputPath] with typed diagnostics.
  static Future<CanvasExportResult> exportFromJson(
    String jsonPayload,
    String outputPath, {
    bool autoClearArena = true,
    bool strictModuleChecks = false,
  }) async {
    final Stopwatch sw = Stopwatch()..start();

    if (jsonPayload.trim().isEmpty || outputPath.trim().isEmpty) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.invalidArguments,
          detail: 'JSON payload and output path must not be empty.',
        ),
        elapsed: sw.elapsed,
      );
    }

    Map<String, dynamic> docMap;
    try {
      final dynamic decoded = jsonDecode(jsonPayload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Root JSON element must be an object.');
      }
      docMap = decoded;
    } catch (e) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.jsonParseFailed,
          detail: e.toString(),
          originalError: e,
        ),
        elapsed: sw.elapsed,
        outputPath: outputPath,
      );
    }

    final CanvasEngineException? preflightErr = _validateCapabilitiesForDoc(
      docMap,
      strictModuleChecks: strictModuleChecks,
    );
    if (preflightErr != null) {
      sw.stop();
      return CanvasExportResult.failure(
        error: preflightErr,
        elapsed: sw.elapsed,
        outputPath: outputPath,
      );
    }

    try {
      final bool modified = await _injectDocumentTextMasks(docMap);
      final String finalPayload = modified ? jsonEncode(docMap) : jsonPayload;

      final int nativeStatus = await Isolate.run(
        () => executeNativeExport(finalPayload, outputPath),
      );
      sw.stop();

      return _buildResultFromNativeStatus(
        nativeStatus: nativeStatus,
        outputPath: outputPath,
        targetFormat: _extractTargetFormat(docMap),
        elapsed: sw.elapsed,
      );
    } catch (e) {
      sw.stop();
      return CanvasExportResult.failure(
        error: CanvasEngineException.fromErrorCode(
          CanvasErrorCode.internalNativeError,
          originalError: e,
        ),
        elapsed: sw.elapsed,
        outputPath: outputPath,
      );
    } finally {
      if (autoClearArena) {
        clearMemoryAssets();
      }
    }
  }

  // ==========================================================================
  // BACKWARD-COMPATIBLE BOOLEAN WRAPPERS
  // ==========================================================================

  /// Backward-compatible wrapper around [exportFromMap] returning `bool`.
  static Future<bool> generatePdfFromMap(
    Map<String, dynamic> docMap,
    String outputPath, {
    bool autoClearArena = true,
  }) async {
    final CanvasExportResult result = await exportFromMap(
      docMap,
      outputPath,
      autoClearArena: autoClearArena,
    );
    if (!result.isSuccess && kDebugMode) {
      debugPrint(result.error.toString());
    }
    return result.isSuccess;
  }

  /// Backward-compatible wrapper around [exportFromJson] returning `bool`.
  static Future<bool> generatePdfAsync(
    String jsonPayload,
    String outputPath, {
    bool autoClearArena = true,
  }) async {
    final CanvasExportResult result = await exportFromJson(
      jsonPayload,
      outputPath,
      autoClearArena: autoClearArena,
    );
    if (!result.isSuccess && kDebugMode) {
      debugPrint(result.error.toString());
    }
    return result.isSuccess;
  }

  // ==========================================================================
  // INTERNAL HELPERS
  // ==========================================================================

  static CanvasExportResult _buildResultFromNativeStatus({
    required int nativeStatus,
    required String outputPath,
    required int targetFormat,
    required Duration elapsed,
  }) {
    final CanvasErrorCode errorCode = CanvasErrorCode.fromNativeCode(
      nativeStatus,
    );

    if (errorCode == CanvasErrorCode.ok) {
      int? fileSize;
      try {
        final File outFile = File(outputPath);
        if (outFile.existsSync()) {
          fileSize = outFile.lengthSync();
        }
      } catch (_) {}

      return CanvasExportResult.success(
        outputPath: outputPath,
        fileSizeBytes: fileSize,
        elapsed: elapsed,
      );
    }

    return CanvasExportResult.failure(
      error: CanvasEngineException.fromErrorCode(
        errorCode,
        detail: 'TargetFormat.${_formatLabel(targetFormat)}',
      ),
      elapsed: elapsed,
      outputPath: outputPath,
    );
  }

  static CanvasEngineException? _validateCapabilitiesForDoc(
    Map<String, dynamic> docMap, {
    required bool strictModuleChecks,
  }) {
    final CanvasCapabilities caps = capabilities;
    if (caps.rawMask == 0) {
      return null;
    }

    final int format = _extractTargetFormat(docMap);
    switch (format) {
      case 0:
        if (!caps.pdf) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledPdf,
            moduleName: 'pdf',
            requestedOperation: 'TargetFormat.pdf',
          );
        }
        break;
      case 1:
        if (!caps.imageExport) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledImageExport,
            moduleName: 'image_export',
            requestedOperation: 'TargetFormat.png',
          );
        }
        break;
      case 2:
        if (!caps.html) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledHtml,
            moduleName: 'html',
            requestedOperation: 'TargetFormat.html',
          );
        }
        break;
      case 3:
        if (!caps.imageExport) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledImageExport,
            moduleName: 'image_export',
            requestedOperation: 'TargetFormat.jpg',
          );
        }
        break;
      case 4:
        if (!caps.webp) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledWebp,
            moduleName: 'webp',
            requestedOperation: 'TargetFormat.webp',
            additionalModules: caps.imageExport
                ? const <String>[]
                : const <String>['image_export'],
          );
        }
        if (!caps.imageExport) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledImageExport,
            moduleName: 'image_export',
            requestedOperation: 'TargetFormat.webp',
          );
        }
        break;
      case 5:
        if (!caps.gif) {
          return CanvasEngineException.moduleDisabled(
            errorCode: CanvasErrorCode.moduleDisabledGif,
            moduleName: 'gif',
            requestedOperation: 'TargetFormat.gif',
          );
        }
        break;
    }

    if (strictModuleChecks) {
      for (final String section in const <String>['header', 'body', 'footer']) {
        final dynamic root = docMap[section];
        if (root is Map<String, dynamic>) {
          final CanvasEngineException? nodeErr = _validateNodeTreeCapabilities(
            root,
            caps,
          );
          if (nodeErr != null) return nodeErr;
        }
      }
    }

    return null;
  }

  static CanvasEngineException? _validateNodeTreeCapabilities(
    Map<String, dynamic> node,
    CanvasCapabilities caps,
  ) {
    final int type = (node['type'] as num?)?.toInt() ?? 0;
    if (type == 4 && !caps.lottie) {
      return CanvasEngineException.moduleDisabled(
        errorCode: CanvasErrorCode.moduleDisabledLottie,
        moduleName: 'lottie',
        requestedOperation: 'CanvasLottie animation node',
      );
    }
    if (type == 3 && !caps.svg) {
      return CanvasEngineException.moduleDisabled(
        errorCode: CanvasErrorCode.moduleDisabledSvg,
        moduleName: 'svg',
        requestedOperation: 'CanvasSvg vector node',
      );
    }

    final Map<String, dynamic>? deco =
        node['decoration'] as Map<String, dynamic>?;
    if (deco != null &&
        (deco['shadow'] != null || deco['mirror'] != null) &&
        !caps.shadows) {
      return CanvasEngineException.moduleDisabled(
        errorCode: CanvasErrorCode.moduleDisabledShadows,
        moduleName: 'shadows',
        requestedOperation: 'CanvasShadow / CanvasReflection FX',
      );
    }

    final dynamic children = node['children'];
    if (children is List) {
      for (final dynamic child in children) {
        if (child is Map<String, dynamic>) {
          final CanvasEngineException? err = _validateNodeTreeCapabilities(
            child,
            caps,
          );
          if (err != null) return err;
        }
      }
    }
    return null;
  }

  static Future<bool> _injectDocumentTextMasks(
    Map<String, dynamic> docMap,
  ) async {
    try {
      final double rootMaxW = _extractRootUsableWidth(docMap);
      final int rootDir = _extractRootDirection(docMap);
      final Map<String, dynamic>? registeredCppFonts =
          docMap['fonts'] as Map<String, dynamic>?;
      final Map<String, dynamic>? defaultTypo =
          docMap['defaultTypo'] as Map<String, dynamic>?;

      final List<Future<bool>> tasks = <Future<bool>>[];
      if (docMap['header'] is Map<String, dynamic>) {
        tasks.add(
          injectFlutterTextMasks(
            docMap['header'] as Map<String, dynamic>,
            parentMaxWidth: rootMaxW,
            registeredCppFonts: registeredCppFonts,
            defaultTypo: defaultTypo,
            inheritedDir: rootDir,
          ),
        );
      }
      if (docMap['body'] is Map<String, dynamic>) {
        tasks.add(
          injectFlutterTextMasks(
            docMap['body'] as Map<String, dynamic>,
            parentMaxWidth: rootMaxW,
            registeredCppFonts: registeredCppFonts,
            defaultTypo: defaultTypo,
            inheritedDir: rootDir,
          ),
        );
      }
      if (docMap['footer'] is Map<String, dynamic>) {
        tasks.add(
          injectFlutterTextMasks(
            docMap['footer'] as Map<String, dynamic>,
            parentMaxWidth: rootMaxW,
            registeredCppFonts: registeredCppFonts,
            defaultTypo: defaultTypo,
            inheritedDir: rootDir,
          ),
        );
      }

      if (tasks.isNotEmpty) {
        final List<bool> results = await Future.wait(tasks);
        return results.any((modified) => modified);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[CoreCanvasEngine] Raster mask pre-pass skipped (falling back to native font engine): $e',
        );
      }
    }
    return false;
  }

  static double _extractRootUsableWidth(Map<String, dynamic> docMap) {
    final config = docMap['config'] as Map<String, dynamic>? ?? {};
    double usableW = (config['w'] as num?)?.toDouble() ?? 595.0;
    final margin = config['margin'];
    if (margin is List && margin.length >= 4) {
      final double right = (margin[1] as num?)?.toDouble() ?? 0.0;
      final double left = (margin[3] as num?)?.toDouble() ?? 0.0;
      usableW = math.max(1.0, usableW - left - right);
    }
    return usableW;
  }

  static int _extractRootDirection(Map<String, dynamic> docMap) {
    final config = docMap['config'] as Map<String, dynamic>? ?? {};
    return (config['dir'] as num?)?.toInt() ?? 0;
  }

  static int _extractTargetFormat(Map<String, dynamic> docMap) {
    final config = docMap['config'] as Map<String, dynamic>? ?? {};
    return (config['format'] as num?)?.toInt() ?? 0;
  }

  static String _formatLabel(int targetFormat) {
    switch (targetFormat) {
      case 1:
        return 'png';
      case 2:
        return 'html';
      case 3:
        return 'jpg';
      case 4:
        return 'webp';
      case 5:
        return 'gif';
      case 0:
      default:
        return 'pdf';
    }
  }

  static String _extensionForFormat(int targetFormat) =>
      _formatLabel(targetFormat);
}

bool _containsNonAsciiOrEmoji(String text) {
  for (int i = 0; i < text.length; i++) {
    if (text.codeUnitAt(i) > 127) return true;
  }
  return false;
}

bool _containsDynamicPageTokens(String text) {
  return text.contains('{{page}}') || text.contains('{{totalPages}}');
}

bool _isStandardPdfFont(String? fontFamily) {
  if (fontFamily == null || fontFamily.isEmpty) return true;
  switch (fontFamily.toLowerCase()) {
    case 'helvetica':
    case 'times':
    case 'times-roman':
    case 'courier':
      return true;
    default:
      return false;
  }
}

TextDecoration _mapFlutterTextDecoration(int decoEnum) {
  switch (decoEnum) {
    case 1:
      return TextDecoration.underline;
    case 2:
      return TextDecoration.lineThrough;
    case 3:
      return TextDecoration.overline;
    default:
      return TextDecoration.none;
  }
}

/// Walks the AST concurrently on the Flutter UI isolate to pre-render 2x Retina
/// masks for Emoji, Indic/Unicode scripts, RichText runs, custom fonts, and text FX.
Future<bool> injectFlutterTextMasks(
  Map<String, dynamic> nodeJson, {
  double? parentMaxWidth,
  Map<String, dynamic>? registeredCppFonts,
  Map<String, dynamic>? defaultTypo,
  int inheritedDir = 0,
}) async {
  bool didInject = false;

  final Map<String, dynamic> constraints =
      (nodeJson['constraints'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  final double? fixedW = (constraints['w'] as num?)?.toDouble();
  final double? maxW = (constraints['maxW'] as num?)?.toDouble();
  final double? wPct = (constraints['wPct'] as num?)?.toDouble();

  final Map<String, dynamic>? layoutMap =
      nodeJson['layout'] as Map<String, dynamic>?;
  final int nodeDir = (layoutMap?['layoutDir'] as num?)?.toInt() ?? 0;
  final int activeDir = nodeDir != 0 ? nodeDir : inheritedDir;

  double? currentMaxWidth = fixedW ?? maxW;
  if (currentMaxWidth == null && wPct != null && parentMaxWidth != null) {
    currentMaxWidth = parentMaxWidth * (wPct / 100.0);
  }
  currentMaxWidth ??= parentMaxWidth;

  double? childAvailableWidth = currentMaxWidth;
  final padding = nodeJson['padding'];
  if (childAvailableWidth != null && padding is List && padding.length >= 4) {
    final double padRight = (padding[1] as num?)?.toDouble() ?? 0.0;
    final double padLeft = (padding[3] as num?)?.toDouble() ?? 0.0;
    childAvailableWidth = math.max(
      1.0,
      childAvailableWidth - padLeft - padRight,
    );
  }

  final deco = nodeJson['decoration'] as Map<String, dynamic>?;
  final borderWidth = deco?['borderWidth'];
  if (childAvailableWidth != null &&
      borderWidth is List &&
      borderWidth.length >= 4) {
    final double bRight = (borderWidth[1] as num?)?.toDouble() ?? 0.0;
    final double bLeft = (borderWidth[3] as num?)?.toDouble() ?? 0.0;
    childAvailableWidth = math.max(1.0, childAvailableWidth - bLeft - bRight);
  }

  if (nodeJson['type'] == 1 && nodeJson['content'] != null) {
    final String text = nodeJson['content'].toString();
    final typo =
        nodeJson['typography'] as Map<String, dynamic>? ?? defaultTypo ?? {};

    final bool hasShadow = deco != null && deco['shadow'] != null;
    final bool hasMirror = deco != null && deco['mirror'] != null;

    final String? rawFontFamily =
        (typo['font'] as String?) ?? (defaultTypo?['font'] as String?);
    final List<dynamic>? textRuns = typo['runs'] as List<dynamic>?;
    final bool hasRuns = textRuns != null && textRuns.isNotEmpty;
    final int overflowVal = (typo['overflow'] as num?)?.toInt() ?? 0;

    bool hasNonAscii = _containsNonAsciiOrEmoji(text);
    if (!hasNonAscii && hasRuns) {
      for (final dynamic r in textRuns) {
        if (r is Map &&
            r['text'] != null &&
            _containsNonAsciiOrEmoji(r['text'].toString())) {
          hasNonAscii = true;
          break;
        }
      }
    }

    final bool isCustomFont = !_isStandardPdfFont(rawFontFamily);

    final bool hasCppTtfFile =
        rawFontFamily != null &&
        registeredCppFonts != null &&
        registeredCppFonts.containsKey(rawFontFamily);

    // Skip pre-baking static mask if text contains dynamic {{page}} / {{totalPages}} tokens
    final bool hasDynamicTokens = _containsDynamicPageTokens(text);

    final bool needsFlutterRaster =
        !hasDynamicTokens &&
        (hasShadow ||
            hasMirror ||
            hasNonAscii ||
            hasRuns ||
            overflowVal == 1 ||
            (isCustomFont && !hasCppTtfFile));

    if (needsFlutterRaster && (text.isNotEmpty || hasRuns)) {
      final double fontSize =
          (typo['size'] as num?)?.toDouble() ??
          (defaultTypo?['size'] as num?)?.toDouble() ??
          12.0;
      final int colorVal =
          (typo['color'] as num?)?.toInt() ??
          (defaultTypo?['color'] as num?)?.toInt() ??
          0xFFFFFFFF;
      final int weightVal =
          (typo['weight'] as num?)?.toInt() ??
          (defaultTypo?['weight'] as num?)?.toInt() ??
          400;
      final int styleVal = (typo['style'] as num?)?.toInt() ?? 0;
      final int decoVal = (typo['decoration'] as num?)?.toInt() ?? 0;
      final int alignVal = (typo['align'] as num?)?.toInt() ?? 0;
      final double lineHeight =
          (typo['lineHeight'] as num?)?.toDouble() ?? 1.15;
      final double letterSpacing = (typo['spacing'] as num?)?.toDouble() ?? 0.0;
      final double wordSpacing =
          (typo['wordSpacing'] as num?)?.toDouble() ?? 0.0;
      final int? maxLines = (typo['maxLines'] as num?)?.toInt();

      String? effectiveFontFamily = rawFontFamily;
      String? fontPackage;
      if (rawFontFamily != null && rawFontFamily.startsWith('packages/')) {
        final parts = rawFontFamily.split('/');
        if (parts.length >= 3) {
          fontPackage = parts[1];
          effectiveFontFamily = parts.sublist(2).join('/');
        }
      }

      final double layoutMaxW = childAvailableWidth ?? double.infinity;

      final FontWeight fontWeight =
          FontWeight.values[((weightVal ~/ 100) - 1).clamp(0, 8)];
      final FontStyle flutterFontStyle = (styleVal == 1 || styleVal == 2)
          ? FontStyle.italic
          : FontStyle.normal;
      final TextDecoration flutterTextDeco = _mapFlutterTextDecoration(decoVal);

      final TextAlign textAlign = alignVal == 1
          ? TextAlign.center
          : (alignVal == 2
                ? TextAlign.right
                : (alignVal == 3 ? TextAlign.justify : TextAlign.left));

      final TextStyle baseStyle = TextStyle(
        fontSize: fontSize,
        color: Color(colorVal),
        fontWeight: fontWeight,
        fontStyle: flutterFontStyle,
        decoration: flutterTextDeco,
        decorationColor: Color(colorVal),
        fontFamily: effectiveFontFamily,
        package: fontPackage,
        height: lineHeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      );

      List<InlineSpan>? childSpans;
      if (hasRuns) {
        childSpans = <InlineSpan>[];
        for (final dynamic r in textRuns) {
          if (r is! Map) continue;
          final int? spanColor = (r['color'] as num?)?.toInt();
          final double? spanSize = (r['size'] as num?)?.toDouble();
          final int? spanWeight = (r['weight'] as num?)?.toInt();
          final int? spanStyle = (r['style'] as num?)?.toInt();

          childSpans.add(
            TextSpan(
              text: r['text']?.toString() ?? '',
              style: baseStyle.copyWith(
                color: spanColor != null ? Color(spanColor) : null,
                fontSize: spanSize,
                fontWeight: spanWeight != null
                    ? FontWeight.values[((spanWeight ~/ 100) - 1).clamp(0, 8)]
                    : null,
                fontStyle: spanStyle != null
                    ? ((spanStyle == 1 || spanStyle == 2)
                          ? FontStyle.italic
                          : FontStyle.normal)
                    : null,
              ),
            ),
          );
        }
      }

      final textPainter = TextPainter(
        text: TextSpan(text: text, style: baseStyle, children: childSpans),
        textAlign: textAlign,
        maxLines: maxLines,
        ellipsis: overflowVal == 1 ? '…' : null,
        textDirection: activeDir == 2 ? TextDirection.rtl : TextDirection.ltr,
      )..layout(maxWidth: layoutMaxW);

      final double logicalW = textPainter.width.ceilToDouble();
      final double logicalH = textPainter.height.ceilToDouble();

      if ((hasNonAscii || isCustomFont || hasRuns) &&
          logicalW > 0 &&
          logicalH > 0) {
        if (constraints['w'] == null && constraints['wPct'] == null) {
          constraints['w'] = logicalW;
        }
        if (constraints['h'] == null && constraints['hPct'] == null) {
          constraints['h'] = logicalH;
        }
        nodeJson['constraints'] = constraints;
      }

      const double retinaScale = 2.0;
      final int w = (textPainter.width * retinaScale).ceil();
      final int h = (textPainter.height * retinaScale).ceil();

      if (w > 0 && h > 0) {
        final recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(recorder);
        canvas.scale(retinaScale, retinaScale);
        textPainter.paint(canvas, ui.Offset.zero);
        final ui.Picture picture = recorder.endRecording();
        ui.Image? img;
        try {
          img = await picture.toImage(w, h);
          final ByteData? byteData = await img.toByteData(
            format: ui.ImageByteFormat.png,
          );

          if (byteData != null) {
            final Uint8List pngBytes = byteData.buffer.asUint8List();
            final String maskId = 'mask_${++_maskAssetCounter}';
            nodeJson['rasterMask'] = CoreCanvasEngine.registerMemoryAsset(
              maskId,
              pngBytes,
            );
            didInject = true;
          }
        } finally {
          img?.dispose();
          picture.dispose();
        }
      }
      textPainter.dispose();
    }
  }

  if (nodeJson['children'] is List) {
    final List<dynamic> childrenList = nodeJson['children'] as List<dynamic>;
    final List<Future<bool>> childFutures = <Future<bool>>[];
    for (final child in childrenList) {
      if (child is Map<String, dynamic>) {
        childFutures.add(
          injectFlutterTextMasks(
            child,
            parentMaxWidth: childAvailableWidth,
            registeredCppFonts: registeredCppFonts,
            defaultTypo: defaultTypo,
            inheritedDir: activeDir,
          ),
        );
      }
    }
    if (childFutures.isNotEmpty) {
      final List<bool> childResults = await Future.wait(childFutures);
      if (childResults.any((res) => res)) {
        didInject = true;
      }
    }
  }

  return didInject;
}
