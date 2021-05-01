import 'dart:async';

import 'package:flutter_test/flutter_test.dart' as flutter;

class WidgetDeclarer {
  WidgetDeclarer(
    WidgetDeclarer? parent,
  ) : _parent = parent;

  /// The parent declarer, or `null` if this corresponds to the root group.
  final WidgetDeclarer? _parent;

  /// The set-up functions to run for each test in this group.
  final _setUps = <Future<void> Function(flutter.WidgetTester tester)>[];

  /// The tear-down functions to run for each test in this group.
  final _tearDowns = <Future<void> Function(flutter.WidgetTester tester)>[];

  /// Runs [body] with this declarer as current [WidgetDeclarer].
  ///
  /// Returns the return value of [body].
  T declare<T>(T Function() body) => runZoned(body, zoneValues: {
        #test.widgetDeclarer: this,
        #test.declarer: Zone.current[#test.declarer],
      });

  /// Registers a function to be run before each test in this group.
  void setUp(Future<void> Function(flutter.WidgetTester tester) callback) {
    _setUps.add(callback);
  }

  /// Registers a function to be run after each test in this group.
  void tearDown(Future<void> Function(flutter.WidgetTester tester) callback) {
    _tearDowns.add(callback);
  }

  /// Creates a group of tests.
  void group(Object name, void Function() body) {
    var declarer = WidgetDeclarer(this);
    declarer.declare(() {
      flutter.group(name, () {
        runZoned(() {
          body();
        }, zoneValues: {
          #test.widgetDeclarer: declarer,
          #test.declarer: Zone.current[#test.declarer],
        });
      });
    });
  }

  /// Run the set-up functions for this and any parent groups.
  ///
  /// If no set-up functions are declared, this returns a [Future] that
  /// completes immediately.
  Future runSetUps(flutter.WidgetTester tester) async {
    if (_parent != null) await _parent!.runSetUps(tester);
    await Future.forEach<Function>(_setUps, (setUp) => setUp(tester));
  }

  /// Run the tear-down functions for this and any parent groups.
  ///
  /// If no tear-down functions are declared, this returns a [Future] that
  /// completes immediately.
  Future runTearDowns(flutter.WidgetTester tester) async {
    await Future.forEach<Function>(
        _tearDowns.reversed, (tearDown) => tearDown(tester));
    if (_parent != null) await _parent!.runTearDowns(tester);
  }
}
