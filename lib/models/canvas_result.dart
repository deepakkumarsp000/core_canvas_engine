// FILE: lib/models/canvas_result.dart
// PURPOSE: Enterprise-Grade Typed Diagnostics, Native Capability Bitmask & Export Results
// Zero casual logging. 100% synced with C++ status codes and capability bitmask.

import 'dart:typed_data';

/// Standardized error codes mapped 1:1 with the native C++ engine return values.
enum CanvasErrorCode {
  /// Operation completed successfully.
  ok(1, 'OK'),

  /// Null or empty payload/output path supplied to the native bridge.
  invalidArguments(-1, 'E_INVALID_ARGUMENTS'),

  /// Native YYJSON parser rejected the serialized AST payload.
  jsonParseFailed(-2, 'E_JSON_PARSE_FAILED'),

  /// Meta Yoga failed to construct or resolve the document layout tree.
  layoutFailed(-3, 'E_LAYOUT_FAILED'),

  /// Native exporter could not write the final artifact to the target path.
  outputWriteFailed(-4, 'E_OUTPUT_WRITE_FAILED'),

  /// The `pdf` native module was excluded at compile time.
  moduleDisabledPdf(-10, 'E_MODULE_PDF_DISABLED', requiredModule: 'pdf'),

  /// The `image_export` native module (PNG/JPG) was excluded at compile time.
  moduleDisabledImageExport(
    -11,
    'E_MODULE_IMAGE_EXPORT_DISABLED',
    requiredModule: 'image_export',
  ),

  /// The `webp` native module (LibWebP) was excluded at compile time.
  moduleDisabledWebp(-12, 'E_MODULE_WEBP_DISABLED', requiredModule: 'webp'),

  /// The `gif` native module (GIF/Tweeny) was excluded at compile time.
  moduleDisabledGif(-13, 'E_MODULE_GIF_DISABLED', requiredModule: 'gif'),

  /// The `html` native module (HTML5/CSS3 DOM) was excluded at compile time.
  moduleDisabledHtml(-14, 'E_MODULE_HTML_DISABLED', requiredModule: 'html'),

  /// The `lottie` native module (RLottie) was excluded at compile time.
  moduleDisabledLottie(
    -15,
    'E_MODULE_LOTTIE_DISABLED',
    requiredModule: 'lottie',
  ),

  /// The `svg` native module (NanoSVG) was excluded at compile time.
  moduleDisabledSvg(-16, 'E_MODULE_SVG_DISABLED', requiredModule: 'svg'),

  /// The `shadows` native module (Drop Shadow & Mirror) was excluded at compile time.
  moduleDisabledShadows(
    -17,
    'E_MODULE_SHADOWS_DISABLED',
    requiredModule: 'shadows',
  ),

  /// Shared library could not be opened or required FFI symbol is missing.
  nativeLibraryLoadFailed(-98, 'E_NATIVE_LIBRARY_LOAD_FAILED'),

  /// Unhandled C++ or Dart runtime exception during rendering.
  internalNativeError(-99, 'E_INTERNAL_NATIVE_ERROR');

  const CanvasErrorCode(this.nativeCode, this.code, {this.requiredModule});

  /// Integer status returned directly by the C++ FFI layer.
  final int nativeCode;

  /// Machine-readable diagnostic identifier suitable for telemetry/logging.
  final String code;

  /// `pubspec.yaml` feature flag key required to resolve this error, if applicable.
  final String? requiredModule;

  /// Whether this status represents a disabled native module.
  bool get isModuleDisabled => requiredModule != null;

  /// Resolves a raw C++ FFI return integer into its strongly typed [CanvasErrorCode].
  static CanvasErrorCode fromNativeCode(int code) {
    for (final value in CanvasErrorCode.values) {
      if (value.nativeCode == code) return value;
    }
    return code > 0 ? CanvasErrorCode.ok : CanvasErrorCode.internalNativeError;
  }
}

/// Bitmask representation of the C++ modules compiled into the active binary.
///
/// Mirrors `get_engine_capabilities()` in `src/canvas_interface.h`:
/// - bit 0 (`0x01`): `pdf`
/// - bit 1 (`0x02`): `svg`
/// - bit 2 (`0x04`): `shadows`
/// - bit 3 (`0x08`): `image_export`
/// - bit 4 (`0x10`): `webp`
/// - bit 5 (`0x20`): `lottie`
/// - bit 6 (`0x40`): `gif`
/// - bit 7 (`0x80`): `html`
class CanvasCapabilities {
  static const int bitPdf = 1 << 0;
  static const int bitSvg = 1 << 1;
  static const int bitShadows = 1 << 2;
  static const int bitImageExport = 1 << 3;
  static const int bitWebp = 1 << 4;
  static const int bitLottie = 1 << 5;
  static const int bitGif = 1 << 6;
  static const int bitHtml = 1 << 7;

  /// Raw 32-bit capability bitmask returned by the native library.
  final int rawMask;

  const CanvasCapabilities(this.rawMask);

  /// Fallback capabilities representing an uninitialized or unreachable engine.
  static const CanvasCapabilities none = CanvasCapabilities(0);

  bool get pdf => (rawMask & bitPdf) != 0;
  bool get svg => (rawMask & bitSvg) != 0;
  bool get shadows => (rawMask & bitShadows) != 0;
  bool get imageExport => (rawMask & bitImageExport) != 0;
  bool get webp => (rawMask & bitWebp) != 0;
  bool get lottie => (rawMask & bitLottie) != 0;
  bool get gif => (rawMask & bitGif) != 0;
  bool get html => (rawMask & bitHtml) != 0;

  /// Returns `true` if the compiled native binary supports the given target format enum value.
  /// (0: PDF, 1: PNG, 2: HTML, 3: JPG, 4: WEBP, 5: GIF)
  bool supportsTargetFormat(int targetFormatValue) {
    switch (targetFormatValue) {
      case 0:
        return pdf;
      case 1:
      case 3:
        return imageExport;
      case 2:
        return html;
      case 4:
        return imageExport && webp;
      case 5:
        return gif;
      default:
        return false;
    }
  }

  /// List of all native modules currently compiled into this binary.
  List<String> get enabledModules => <String>[
    if (pdf) 'pdf',
    if (svg) 'svg',
    if (shadows) 'shadows',
    if (imageExport) 'image_export',
    if (webp) 'webp',
    if (lottie) 'lottie',
    if (gif) 'gif',
    if (html) 'html',
  ];

  /// List of all native modules stripped from this binary.
  List<String> get disabledModules => <String>[
    if (!pdf) 'pdf',
    if (!svg) 'svg',
    if (!shadows) 'shadows',
    if (!imageExport) 'image_export',
    if (!webp) 'webp',
    if (!lottie) 'lottie',
    if (!gif) 'gif',
    if (!html) 'html',
  ];

  @override
  String toString() =>
      'CanvasCapabilities(enabled: [${enabledModules.join(', ')}], '
      'disabled: [${disabledModules.join(', ')}])';
}

/// Structured, actionable exception thrown or returned by Core Canvas Engine.
class CanvasEngineException implements Exception {
  final CanvasErrorCode errorCode;
  final String message;
  final String? cause;
  final String? resolution;
  final String? requiredModule;
  final Object? originalError;

  const CanvasEngineException({
    required this.errorCode,
    required this.message,
    this.cause,
    this.resolution,
    this.requiredModule,
    this.originalError,
  });

  /// Constructs a standardized diagnostic for a disabled native module.
  factory CanvasEngineException.moduleDisabled({
    required CanvasErrorCode errorCode,
    required String moduleName,
    required String requestedOperation,
    List<String> additionalModules = const <String>[],
  }) {
    final List<String> allModules = <String>[
      moduleName,
      ...additionalModules.where((m) => m != moduleName),
    ];
    final String yamlLines = allModules.map((m) => '      $m: true').join('\n');

    return CanvasEngineException(
      errorCode: errorCode,
      requiredModule: moduleName,
      message: "Native module '$moduleName' is not compiled into this binary.",
      cause:
          "Module '$moduleName' was excluded by your pubspec.yaml build configuration. "
          "Attempted '$requestedOperation', which requires: ${allModules.join(', ')}.",
      resolution:
          "1. Enable the required module(s) under 'core_canvas_engine:' in pubspec.yaml:\n"
          '    core_canvas_engine:\n'
          '$yamlLines\n'
          "   (Or remove the 'core_canvas_engine:' block completely to enable all modules by default.)\n"
          "2. Run 'flutter clean' and rebuild the application.",
    );
  }

  /// Constructs a standardized diagnostic from a native [CanvasErrorCode].
  factory CanvasEngineException.fromErrorCode(
    CanvasErrorCode code, {
    String? detail,
    Object? originalError,
  }) {
    if (code.isModuleDisabled && code.requiredModule != null) {
      final bool needsImageExport = code == CanvasErrorCode.moduleDisabledWebp;
      return CanvasEngineException.moduleDisabled(
        errorCode: code,
        moduleName: code.requiredModule!,
        requestedOperation: detail ?? 'export operation',
        additionalModules: needsImageExport
            ? const <String>['image_export']
            : const <String>[],
      );
    }

    switch (code) {
      case CanvasErrorCode.invalidArguments:
        return CanvasEngineException(
          errorCode: code,
          message: 'Invalid arguments passed to native engine.',
          cause: detail ?? 'Document payload or output path was null/empty.',
          resolution:
              'Verify that the document payload and target file path are non-empty.',
          originalError: originalError,
        );
      case CanvasErrorCode.jsonParseFailed:
        return CanvasEngineException(
          errorCode: code,
          message: 'Failed to parse document AST payload in native engine.',
          cause: detail ?? 'Malformed JSON syntax or unsupported schema.',
          resolution:
              'Ensure the payload is generated via CanvasDocument.toJsonMap() or valid JSON.',
          originalError: originalError,
        );
      case CanvasErrorCode.layoutFailed:
        return CanvasEngineException(
          errorCode: code,
          message: 'Native layout resolution failed.',
          cause:
              detail ?? 'Meta Yoga could not build or compute the root tree.',
          resolution:
              'Check root CanvasConfig dimensions and node constraints for NaN or invalid values.',
          originalError: originalError,
        );
      case CanvasErrorCode.outputWriteFailed:
        return CanvasEngineException(
          errorCode: code,
          message: 'Failed to write rendered output to disk.',
          cause:
              detail ??
              'Insufficient storage permissions, read-only directory, or invalid path.',
          resolution:
              'Write to an app-writable directory (e.g., getApplicationDocumentsDirectory() or getTemporaryDirectory()).',
          originalError: originalError,
        );
      case CanvasErrorCode.nativeLibraryLoadFailed:
        return CanvasEngineException(
          errorCode: code,
          message: 'Failed to load native core_canvas_engine library.',
          cause: detail ?? originalError?.toString(),
          resolution:
              'Verify native build artifacts exist for the target ABI and run a full rebuild.',
          originalError: originalError,
        );
      case CanvasErrorCode.ok:
      case CanvasErrorCode.internalNativeError:
      default:
        return CanvasEngineException(
          errorCode: CanvasErrorCode.internalNativeError,
          message: 'Unexpected native engine error during export.',
          cause: detail ?? originalError?.toString(),
          resolution:
              'Inspect native device logs under tag "CANVAS_ENGINE" for stack details.',
          originalError: originalError,
        );
    }
  }

  /// Concise single-line summary ideal for SnackBars, banners, or UI alerts.
  String get shortMessage => '[${errorCode.code}] $message';

  @override
  String toString() {
    final StringBuffer sb = StringBuffer()
      ..writeln('[CoreCanvasEngine] ${errorCode.code}: $message');
    if (cause != null && cause!.isNotEmpty) {
      sb
        ..writeln('  Cause:')
        ..writeln('    $cause');
    }
    if (resolution != null && resolution!.isNotEmpty) {
      sb
        ..writeln('  Resolution:')
        ..writeln('    ${resolution!.replaceAll('\n', '\n    ')}');
    }
    return sb.toString().trimRight();
  }
}

/// Immutable result returned by [CoreCanvasEngine.exportDocument] and [CoreCanvasEngine.exportToBytes].
class CanvasExportResult {
  final bool isSuccess;
  final CanvasErrorCode statusCode;
  final String? outputPath;
  final Uint8List? bytes;
  final int? fileSizeBytes;
  final Duration elapsed;
  final CanvasEngineException? error;

  const CanvasExportResult._({
    required this.isSuccess,
    required this.statusCode,
    required this.elapsed,
    this.outputPath,
    this.bytes,
    this.fileSizeBytes,
    this.error,
  });

  factory CanvasExportResult.success({
    required Duration elapsed,
    String? outputPath,
    Uint8List? bytes,
    int? fileSizeBytes,
  }) {
    return CanvasExportResult._(
      isSuccess: true,
      statusCode: CanvasErrorCode.ok,
      outputPath: outputPath,
      bytes: bytes,
      fileSizeBytes: fileSizeBytes ?? bytes?.length,
      elapsed: elapsed,
    );
  }

  factory CanvasExportResult.failure({
    required CanvasEngineException error,
    required Duration elapsed,
    String? outputPath,
  }) {
    return CanvasExportResult._(
      isSuccess: false,
      statusCode: error.errorCode,
      outputPath: outputPath,
      elapsed: elapsed,
      error: error,
    );
  }

  bool get isFailure => !isSuccess;

  /// Throws [error] if the export failed; useful for try/catch workflows.
  void throwIfFailed() {
    if (!isSuccess) {
      throw error ?? CanvasEngineException.fromErrorCode(statusCode);
    }
  }

  /// Compact telemetry-friendly summary string.
  String get summary {
    if (isSuccess) {
      final String kb = fileSizeBytes != null
          ? '${(fileSizeBytes! / 1024).toStringAsFixed(1)} KB'
          : 'unknown size';
      return 'Export succeeded ($kb in ${elapsed.inMilliseconds} ms)';
    }
    return error?.shortMessage ?? '[${statusCode.code}] Export failed';
  }

  @override
  String toString() => isSuccess ? summary : (error?.toString() ?? summary);
}
