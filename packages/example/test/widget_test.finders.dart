// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FinderGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

findMyHomePage<T, R>({required List<DataRow> incrementCounterValue}) =>
    _MyHomePageMatchFinder<T, R>(incrementCounterValue: incrementCounterValue);

final findMyApp = _MyAppMatchFinder();

class _MyHomePageMatchFinder<T, R> extends MatchFinder {
  _MyHomePageMatchFinder({
    required List<DataRow> incrementCounterValue,
  }) : _incrementCounterValue = incrementCounterValue;

  final List<DataRow> _incrementCounterValue;

  @override
  String get description => 'Finds MyHomePage widget';

  @override
  bool matches(Element candidiate) {
    if (candidiate.widget is MyHomePage) {
      final widget = candidiate.widget as MyHomePage;

      return widget.title == 'love-title' &&
          widget.incrementCounter() == _incrementCounterValue;
    }
    return false;
  }
}

class _MyAppMatchFinder extends MatchFinder {
  _MyAppMatchFinder();

  @override
  String get description => 'Finds MyApp widget';

  @override
  bool matches(Element candidiate) {
    return candidiate.widget is MyApp;
  }
}
