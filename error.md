
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:992:9: Error: Type 'SemanticsFlags' not found.
  final SemanticsFlags flagsCollection;
        ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3024:3: Error: Type 'SemanticsFlags' not found.
  SemanticsFlags _flags = SemanticsFlags.none;
  ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3027:3: Error: Type 'SemanticsFlags' not found.
  SemanticsFlags get flagsCollection => _flags;
  ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:5881:3: Error: Type 'SemanticsFlags' not found.
  SemanticsFlags _flags = SemanticsFlags.none;
  ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:6256:16: Error: Type 'SemanticsFlags' not found.
int _toBitMask(SemanticsFlags flags) {
               ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/widgets/media_query.dart:304:57: Error: The getter 'supportsAnnounce' isn't defined for the class 'AccessibilityFeatures'.
 - 'AccessibilityFeatures' is from 'dart:ui'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'supportsAnnounce'.
          view.platformDispatcher.accessibilityFeatures.supportsAnnounce,
                                                        ^^^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:142:19: Error: Member not found: 'complementary'.
    SemanticsRole.complementary => _semanticsComplementary,
                  ^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:143:19: Error: Member not found: 'contentInfo'.
    SemanticsRole.contentInfo => _semanticsContentInfo,
                  ^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:144:19: Error: Member not found: 'main'.
    SemanticsRole.main => _semanticsMain,
                  ^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:145:19: Error: Member not found: 'navigation'.
    SemanticsRole.navigation => _semanticsNavigation,
                  ^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:146:19: Error: Member not found: 'region'.
    SemanticsRole.region => _semanticsRegion,
                  ^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:363:38: Error: Member not found: 'complementary'.
      nodeData.role == SemanticsRole.complementary ||
                                     ^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:364:38: Error: Member not found: 'contentInfo'.
      nodeData.role == SemanticsRole.contentInfo ||
                                     ^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:365:38: Error: Member not found: 'main'.
      nodeData.role == SemanticsRole.main ||
                                     ^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:366:38: Error: Member not found: 'navigation'.
      nodeData.role == SemanticsRole.navigation ||
                                     ^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:367:38: Error: Member not found: 'region'.
      nodeData.role == SemanticsRole.region;
                                     ^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:992:9: Error: 'SemanticsFlags' isn't a type.
  final SemanticsFlags flagsCollection;
        ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3024:3: Error: 'SemanticsFlags' isn't a type.
  SemanticsFlags _flags = SemanticsFlags.none;
  ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3024:27: Error: Undefined name 'SemanticsFlags'.
  SemanticsFlags _flags = SemanticsFlags.none;
                          ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3388:5: Error: 'SemanticsFlags' isn't a type.
    SemanticsFlags flags = _flags;
    ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:3654:7: Error: No named parameter with the name 'locale'.
      locale: data.locale,
      ^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:5881:3: Error: 'SemanticsFlags' isn't a type.
  SemanticsFlags _flags = SemanticsFlags.none;
  ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:5881:27: Error: Undefined name 'SemanticsFlags'.
  SemanticsFlags _flags = SemanticsFlags.none;
                          ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:6256:16: Error: 'SemanticsFlags' isn't a type.
int _toBitMask(SemanticsFlags flags) {
               ^^^^^^^^^^^^^^
/D:/Downloads/flutter_windows/flutter/packages/flutter/lib/src/semantics/semantics.dart:121:80: Error: The type 'SemanticsRole' is not exhaustively matched by the switch cases since it doesn't match 'SemanticsRole.searchBox'.
 - 'SemanticsRole' is from 'dart:ui'.
Try adding a wildcard pattern or cases that match 'SemanticsRole.searchBox'.
  static FlutterError? _checkSemanticsData(SemanticsNode node) => switch (node.role) {