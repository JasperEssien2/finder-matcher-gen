// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FinderGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/widgets.dart';

final findAddTargetBottomSheet = _AddTargetBottomSheetMatchFinder();

final findAppFloatingActionButton = _AppFloatingActionButtonMatchFinder();

class _AddTargetBottomSheetMatchFinder extends MatchFinder {
  _AddTargetBottomSheetMatchFinder();

  @override
  String get description => 'Finds AddTargetBottomSheet widget';

  @override
  bool matches(Element candidiate) {
    return candidiate.widget is AddTargetBottomSheet;
  }
}

class _AppFloatingActionButtonMatchFinder extends MatchFinder {
  _AppFloatingActionButtonMatchFinder();

  @override
  String get description => 'Finds AppFloatingActionButton widget';

  @override
  bool matches(Element candidiate) {
    if (candidiate.widget is AppFloatingActionButton) {
      final widget = candidiate.widget as AppFloatingActionButton;

      return widget.fabText == 'Add Task';
    }
    return false;
  }
}
