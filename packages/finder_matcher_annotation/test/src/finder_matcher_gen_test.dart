// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:test/test.dart';

void main() {
  test('Test StringExt', () {
    expect(
      'matchesOneWidget'.specificationValue,
      MatchSpecification.matchesOneWidget,
    );

    expect(
      'matchesNoWidget'.specificationValue,
      MatchSpecification.matchesNoWidget,
    );

    expect(
      'matchesAtleastOneWidget'.specificationValue,
      MatchSpecification.matchesAtleastOneWidget,
    );

    expect(
      'matchesNWidgets'.specificationValue,
      MatchSpecification.matchesNWidgets,
    );

    expect(
      'hasAncestorOf'.specificationValue,
      MatchSpecification.hasAncestorOf,
    );

    expect(
      'doesNotHaveAncestorOf'.specificationValue,
      MatchSpecification.doesNotHaveAncestorOf,
    );

    expect(()=>'randomStr'.specificationValue, throwsException);
  });

  test('Test MatchSpecificationExt', () {
    expect(
      MatchSpecification.matchesOneWidget.toStringValue,
      'matchesOneWidget',
    );

    expect(
      MatchSpecification.matchesNoWidget.toStringValue,
      'matchesNoWidget',
    );

    expect(
      MatchSpecification.matchesAtleastOneWidget.toStringValue,
      'matchesAtleastOneWidget',
    );

    expect(
      MatchSpecification.matchesNWidgets.toStringValue,
      'matchesNWidgets',
    );

    expect(
      MatchSpecification.hasAncestorOf.toStringValue,
      'hasAncestorOf',
    );

    expect(
      MatchSpecification.doesNotHaveAncestorOf.toStringValue,
      'doesNotHaveAncestorOf',
    );
  });
}
