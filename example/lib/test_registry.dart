// FILE: example/lib/test_registry.dart
import 'package:core_canvas_engine/widgets/core_widgets.dart';
export 'package:core_canvas_engine/widgets/core_widgets.dart';

import 'test0.dart';
import 'test1.dart';
import 'test2.dart';
import 'test3.dart';
import 'test4.dart';
import 'test5.dart';
import 'test6.dart';
import 'test7.dart';
import 'test8.dart';
import 'test9.dart';
import 'test10.dart';
import 'test11.dart';
import 'test12.dart';
import 'test13.dart';

class TestCase {
  final String name;
  final String? category;
  final CanvasDocument document;
  final bool needsSvgFile;
  final bool needsImageFile;

  TestCase(
      this.name,
      this.document, {
        this.category,
        this.needsSvgFile = false,
        this.needsImageFile = false,
      });
}

class AppTestRegistry {
  static String globalCustomSvgPath = "";
  static String globalCustomImagePath = "";

  static List<TestCase> getAllTests() {
    return [
      ...Test0Cases.getCases(),
      ...Test1Cases.getCases(),
      ...Test2Cases.getCases(),
      ...Test3Cases.getCases(),
      ...Test4Cases.getCases(),
      ...Test5Cases.getCases(),
      ...Test6Cases.getCases(),
      ...Test7Cases.getCases(),
      ...Test8Cases.getCases(),
      ...Test9Cases.getCases(),
      ...Test10Cases.getCases(),
      ...Test11Cases.getCases(),
      ...Test12Cases.getCases(),
      ...Test13Cases.getCases(),
    ];
  }
}