import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

@isTestGroup
void describe(Object description, void Function() body) {
  group(description, body);
}

@isTestGroup
void context(Object description, void Function() body) {
  group(description, body);
}

@isTestGroup
void xcontext(Object description, void Function() body) {
  group(description, body, skip: true);
}

@isTest
void it(Object description, void Function() body) {
  test(description, body);
}

void beforeEach(dynamic Function() body) {
  setUp(body);
}

void afterEach(dynamic Function() body) {
  tearDown(body);
}
