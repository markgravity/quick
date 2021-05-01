import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:quick_test/src/widget_declarer.dart';

WidgetDeclarer? _localWidgetDeclarer;
WidgetDeclarer get _widgetDeclarer {
  final WidgetDeclarer? declarer =
      Zone.current[#test.widgetDeclarer] as WidgetDeclarer?;
  if (declarer != null) {
    return declarer;
  }

  if (_localWidgetDeclarer == null) {
    _localWidgetDeclarer = WidgetDeclarer(null);
  }
  return _localWidgetDeclarer!;
}

/// Creates a group of tests.
///
/// A group's description (converted to a string) is included in the descriptions
/// of any tests or sub-groups it contains. [setUp] and [tearDown] are also scoped
/// to the containing group.
@isTestGroup
void describe(Object description, void Function() body) {
  context(description, body);
}

/// Creates a group of tests.
/// Equivalent to `describe`.
@isTestGroup
void context(Object description, void Function() body) {
  _widgetDeclarer.group(description, body);
}

/// Creates a new test case with the given description (converted to a string)
/// and body. These are like "testWidgets" in flutter_test.
@isTest
void it(String description, Future<void> Function(WidgetTester tester) body) {
  final widgetDeclarer = _widgetDeclarer;
  testWidgets(description, (tester) async {
    await widgetDeclarer.runSetUps(tester);
    await body(tester);
    await widgetDeclarer.runTearDowns(tester);
  });
}

/// Registers a function to be run before tests.
///
/// This function will be called before each test is run.
///
/// If this is called within a [describe]/[context], it applies only to tests in that
/// [describe]/[context]. The `body` will be run after any set-up callbacks in parent [describe]/[context] or
/// at the top level.
///
/// Each callback at the top level or in a given [describe]/[context] will be run in the order
/// they were declared.
void beforeEach(Future<void> Function(WidgetTester tester) body) {
  _widgetDeclarer.setUp(body);
}

/// Registers a function to be run after tests.
///
/// This function will be called after each test is run.
///
/// If this is called within a [describe]/[context], it applies only to tests in that
/// [describe]/[context]. The `body` will be run before any tear-down callbacks in parent
/// [describe]/[context] or at the top level.
///
/// Each callback at the top level or in a given [describe]/[context] will be run in the
/// reverse of the order they were declared.
void afterEach(Future<void> Function(WidgetTester tester) body) {
  _widgetDeclarer.tearDown(body);
}
