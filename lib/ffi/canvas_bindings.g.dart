// FILE: lib/ffi/canvas_bindings.g.dart
// PURPOSE: Native FFI Bindings for Core Canvas Engine (Structured Status Codes, Capability Bitmask & Zero-Copy Arena)
// ignore_for_file: type=lint, unused_import
import 'dart:ffi' as ffi;

/// Low-level Dart FFI bindings for the native Core Canvas Engine library.
class CanvasBindings {
  /// Holds the native symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
  _lookup;

  /// Looks up symbols in [dynamicLibrary].
  CanvasBindings(ffi.DynamicLibrary dynamicLibrary)
    : _lookup = dynamicLibrary.lookup;

  /// Looks up symbols using a custom [lookup] function.
  CanvasBindings.fromLookup(
    ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName) lookup,
  ) : _lookup = lookup;

  /// Master document export entrypoint.
  /// Returns `1` (CANVAS_OK) on success, or a negative `CANVAS_ERR_*` status code.
  int generate_pdf(
    ffi.Pointer<ffi.Char> json_payload,
    ffi.Pointer<ffi.Char> output_path,
  ) {
    return _generate_pdf(json_payload, output_path);
  }

  late final _generate_pdfPtr =
      _lookup<
        ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)
        >
      >('generate_pdf');
  late final _generate_pdf = _generate_pdfPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)>();

  /// Native health check. Returns `200` when the shared library is loaded.
  int ping_engine() {
    return _ping_engine();
  }

  late final _ping_enginePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'ping_engine',
  );
  late final _ping_engine = _ping_enginePtr.asFunction<int Function()>();

  /// Returns a 32-bit capability bitmask of all opt-in modules compiled into the binary.
  int get_engine_capabilities() {
    return _get_engine_capabilities();
  }

  late final _get_engine_capabilitiesPtr =
      _lookup<ffi.NativeFunction<ffi.Uint32 Function()>>(
        'get_engine_capabilities',
      );
  late final _get_engine_capabilities = _get_engine_capabilitiesPtr
      .asFunction<int Function()>();

  /// Zero-Copy Binary Arena: registers raw binary bytes in native RAM under [asset_id].
  int register_memory_asset(
    ffi.Pointer<ffi.Char> asset_id,
    ffi.Pointer<ffi.Uint8> data,
    int length,
  ) {
    return _register_memory_asset(asset_id, data, length);
  }

  late final _register_memory_assetPtr =
      _lookup<
        ffi.NativeFunction<
          ffi.Int Function(
            ffi.Pointer<ffi.Char>,
            ffi.Pointer<ffi.Uint8>,
            ffi.Int,
          )
        >
      >('register_memory_asset');
  late final _register_memory_asset = _register_memory_assetPtr
      .asFunction<
        int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Uint8>, int)
      >();

  /// Releases all binary assets currently cached in the native Memory Arena.
  void clear_memory_assets() {
    return _clear_memory_assets();
  }

  late final _clear_memory_assetsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('clear_memory_assets');
  late final _clear_memory_assets = _clear_memory_assetsPtr
      .asFunction<void Function()>();
}
