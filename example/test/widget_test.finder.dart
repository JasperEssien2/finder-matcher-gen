// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:example/main.dart';
// **************************************************************************
// FinderGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MyHomePageMatchFinder extends MatchFinder {
  MyHomePageMatchFinder();

  @override
  String get description => 'Finds MyHomePage widget';

  @override
  bool matches(Element candidiate) {
    if (candidiate.widget is MyHomePage) {
      final widget = candidiate.widget as MyHomePage;
      return widget.title == '' && widget.incrementCounter() == [];
    }
    return false;
  }
}

class MyAppMatchFinder extends MatchFinder {
  MyAppMatchFinder();

  @override
  String get description => 'Finds MyApp widget';

  @override
  bool matches(Element candidiate) {
    return candidiate.widget is MyApp;
  }
}
