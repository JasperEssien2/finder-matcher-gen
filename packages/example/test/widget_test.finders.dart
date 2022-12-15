// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FinderGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

import 'package:flutter/foundation.dart';

findMyHomePage<T, R>(
        {required T? genericValue,
        required List<DataRow> incrementCounterValue}) =>
    _MyHomePageMatchFinder<T, R>(
        genericValue: genericValue,
        incrementCounterValue: incrementCounterValue);

final findMyApp = _MyAppMatchFinder();

class _MyHomePageMatchFinder<T, R> extends MatchFinder {
  _MyHomePageMatchFinder({
    required T? genericValue,
    required List<DataRow> incrementCounterValue,
  })  : _genericValue = genericValue,
        _incrementCounterValue = incrementCounterValue;

  final T? _genericValue;

  final List<DataRow> _incrementCounterValue;

  @override
  String get description => 'Finds MyHomePage widget';

  @override
  bool matches(Element candidiate) {
    if (candidiate.widget is MyHomePage) {
      final widget = candidiate.widget as MyHomePage;

      return widget.title == 'love-leads' &&
          widget.generic == _genericValue &&
          listEquals(widget.incrementCounter(), _incrementCounterValue);
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
