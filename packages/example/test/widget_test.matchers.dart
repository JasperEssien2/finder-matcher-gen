// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MatcherGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:flutter/src/material/circle_avatar.dart';

matchesAtleastOneMyHomePage<T, R>(
        {required T? genericValue,
        required List<DataRow> incrementCounterValue}) =>
    _MyHomePageAtleastOneMatcher<T, R>(
        genericValue: genericValue,
        incrementCounterValue: incrementCounterValue);

final matchesAtleastOneMyApp = _MyAppAtleastOneMatcher();

final matchesAtleastOneMyApp = _MyAppAtleastOneMatcher();

final matchesNoCircleAvatar = _CircleAvatarNoneMatcher();

matchesNMyWorldWidget({required int n}) => _MyWorldWidgetNMatcher(n: n);

class _MyHomePageAtleastOneMatcher<T, R> extends Matcher {
  _MyHomePageAtleastOneMatcher({
    required T? genericValue,
    required List<DataRow> incrementCounterValue,
  })  : _genericValue = genericValue,
        _incrementCounterValue = incrementCounterValue;

  final T? _genericValue;

  final List<DataRow> _incrementCounterValue;

  @override
  Description describe(Description description) {
    return description.add('matches atleast one MyHomePage widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is MyHomePage) {
          final widget = element.widget as MyHomePage;

          var expectedDeclarationCount = 0;

          if (widget.title == 'love-leads') {
            expectedDeclarationCount++;
          } else {
            matchState['widget.title-expected'] = 'love-leads';

            if (matchState['widget.title-found'] == null) {
              matchState['widget.title-found'] = <dynamic>{};
            }

            matchState['widget.title-found'].add(widget.title);
          }

          if (widget.generic == _genericValue) {
            expectedDeclarationCount++;
          } else {
            matchState['widget.generic-expected'] = _genericValue;

            if (matchState['widget.generic-found'] == null) {
              matchState['widget.generic-found'] = <dynamic>{};
            }

            matchState['widget.generic-found'].add(widget.generic);
          }

          if (listEquals(widget.incrementCounter(), _incrementCounterValue)) {
            expectedDeclarationCount++;
          } else {
            matchState['widget.incrementCounter()-expected'] =
                _incrementCounterValue;

            if (matchState['widget.incrementCounter()-found'] == null) {
              matchState['widget.incrementCounter()-found'] = <dynamic>{};
            }

            matchState['widget.incrementCounter()-found']
                .add(widget.incrementCounter());
          }

          if (expectedDeclarationCount == 3) {
            matchedCount++;
          }
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount >= 1;
    } catch (exception, stack) {
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
          .foldFrames(
              (frame) =>
                  frame.package == 'test' ||
                  frame.package == 'stream_channel' ||
                  frame.package == 'matcher',
              terse: true)
          .toString();
    }

    return false;
  }

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    if (matchState['custom.exception'] != null) {
      mismatchDescription
          .add('threw')
          .addDescriptionOf(matchState['custom.exception'])
          .add(matchState['custom.stack'].toString());
    }

    if (matchState['custom.matchedCount'] <= 0) {
      mismatchDescription
          .add('found zero MyHomePage widgets but at least one was expected');
    }

    if (matchState['widget.title-found'] != null &&
        matchState['widget.title-expected'] != null) {
      mismatchDescription.add(
          "title is ${matchState['widget.title-found']} but ${matchState['widget.title-expected']} was expected \n\n");
    }

    if (matchState['widget.generic-found'] != null &&
        matchState['widget.generic-expected'] != null) {
      mismatchDescription.add(
          "generic is ${matchState['widget.generic-found']} but ${matchState['widget.generic-expected']} was expected \n\n");
    }

    if (matchState['widget.incrementCounter()-found'] != null &&
        matchState['widget.incrementCounter()-expected'] != null) {
      mismatchDescription.add(
          "incrementCounter is ${matchState['widget.incrementCounter()-found']} but ${matchState['widget.incrementCounter()-expected']} was expected \n\n");
    }

    return mismatchDescription;
  }
}

class _MyAppAtleastOneMatcher extends Matcher {
  _MyAppAtleastOneMatcher();

  @override
  Description describe(Description description) {
    return description.add('matches atleast one MyApp widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is MyApp) {
          matchedCount++;
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount >= 1;
    } catch (exception, stack) {
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
          .foldFrames(
              (frame) =>
                  frame.package == 'test' ||
                  frame.package == 'stream_channel' ||
                  frame.package == 'matcher',
              terse: true)
          .toString();
    }

    return false;
  }

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    if (matchState['custom.exception'] != null) {
      mismatchDescription
          .add('threw')
          .addDescriptionOf(matchState['custom.exception'])
          .add(matchState['custom.stack'].toString());
    }

    if (matchState['custom.matchedCount'] <= 0) {
      mismatchDescription
          .add('found zero MyApp widgets but at least one was expected');
    }

    return mismatchDescription;
  }
}

class _MyAppAtleastOneMatcher extends Matcher {
  _MyAppAtleastOneMatcher();

  @override
  Description describe(Description description) {
    return description.add('matches atleast one MyApp widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is MyApp) {
          matchedCount++;
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount >= 1;
    } catch (exception, stack) {
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
          .foldFrames(
              (frame) =>
                  frame.package == 'test' ||
                  frame.package == 'stream_channel' ||
                  frame.package == 'matcher',
              terse: true)
          .toString();
    }

    return false;
  }

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    if (matchState['custom.exception'] != null) {
      mismatchDescription
          .add('threw')
          .addDescriptionOf(matchState['custom.exception'])
          .add(matchState['custom.stack'].toString());
    }

    if (matchState['custom.matchedCount'] <= 0) {
      mismatchDescription
          .add('found zero MyApp widgets but at least one was expected');
    }

    return mismatchDescription;
  }
}

class _CircleAvatarNoneMatcher extends Matcher {
  _CircleAvatarNoneMatcher();

  @override
  Description describe(Description description) {
    return description.add('matches no CircleAvatar widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is CircleAvatar) {
          matchedCount++;
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount == 0;
    } catch (exception, stack) {
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
          .foldFrames(
              (frame) =>
                  frame.package == 'test' ||
                  frame.package == 'stream_channel' ||
                  frame.package == 'matcher',
              terse: true)
          .toString();
    }

    return false;
  }

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    if (matchState['custom.exception'] != null) {
      mismatchDescription
          .add('threw')
          .addDescriptionOf(matchState['custom.exception'])
          .add(matchState['custom.stack'].toString());
    }

    if (matchState['custom.count'] >= 1) {
      mismatchDescription.add(
          'zero CircleAvatar widgets expected but found ${matchState['custom.count'] ?? 0}');
    }
    return mismatchDescription;
  }
}

class _MyWorldWidgetNMatcher extends Matcher {
  _MyWorldWidgetNMatcher({
    required int n,
  }) : _n = n;

  final int _n;

  @override
  Description describe(Description description) {
    return description.add('matches $_n MyWorldWidget widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is MyWorldWidget) {
          matchedCount++;
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount == _n;
    } catch (exception, stack) {
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
          .foldFrames(
              (frame) =>
                  frame.package == 'test' ||
                  frame.package == 'stream_channel' ||
                  frame.package == 'matcher',
              terse: true)
          .toString();
    }

    return false;
  }

  @override
  Description describeMismatch(covariant Finder finder,
      Description mismatchDescription, Map matchState, bool verbose) {
    if (matchState['custom.exception'] != null) {
      mismatchDescription
          .add('threw')
          .addDescriptionOf(matchState['custom.exception'])
          .add(matchState['custom.stack'].toString());
    }

    if (matchState['custom.matchedCount'] != _n) {
      mismatchDescription.add(
          'found ${matchState['custom.matchedCount']} MyWorldWidget widgets $_n was expected');
    }

    return mismatchDescription;
  }
}
