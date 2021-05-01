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

@isTestGroup
void context(Object description, void Function() body) {
  _widgetDeclarer.group(description, body);
}

@isTest
void it(String description, Future<void> Function(WidgetTester tester) body) {
  final widgetDeclarer = _widgetDeclarer;
  testWidgets(description, (tester) async {
    await widgetDeclarer.runSetUps(tester);
    await body(tester);
    await widgetDeclarer.runTearDowns(tester);
  });
}

void beforeEach(Future<void> Function(WidgetTester tester) body) {
  _widgetDeclarer.setUp(body);
}

void afterEach(Future<void> Function(WidgetTester tester) body) {
  _widgetDeclarer.tearDown(body);
}
