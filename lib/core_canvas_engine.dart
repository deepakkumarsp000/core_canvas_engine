// FILE: lib/core_canvas_engine.dart
// PURPOSE: Official Single-Import Barrel File for Core Canvas Engine
// Usage: import 'package:core_canvas_engine/core_canvas_engine.dart';

library;

// 1. FFI Bridge & Native Bindings
export 'ffi/canvas_bindings.g.dart';
export 'ffi/engine_bridge.dart';

// 2. Core AST Models, Configuration & Typed Export Diagnostics
export 'models/canvas_result.dart';
export 'models/engine_config.dart';
export 'models/super_container.dart';

// 3. Enums, Design System Styles, Declarative DSL, Extensions & Macro Widgets
export 'widgets/canvas_enums.dart';
export 'widgets/canvas_style.dart';
export 'widgets/core_widgets.dart';
export 'widgets/canvas_extensions.dart';
export 'widgets/macro_widgets.dart';
