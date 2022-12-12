// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MatcherGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:flutter/src/material/circle_avatar.dart';

matchesAtleastOneMyHomePage<T, R>(
        {required T? genericValue,
        required List<DataRow> incrementCounterValue}) =>
    _MyHomePageMatcher<T, R>(
        genericValue: genericValue,
        incrementCounterValue: incrementCounterValue);

final matchesOneMyApp = _MyAppMatcher();

final matchesNoCircleAvatar = _CircleAvatarMatcher();

matchesNMyWorldWidget({required int n}) => _MyWorldWidgetMatcher(n: n);

class _MyHomePageMatcher<T, R> extends Matcher {
  _MyHomePageMatcher({
    required T? genericValue,
    required List<DataRow> incrementCounterValue,
  })  : _genericValue = genericValue,
        _incrementCounterValue = incrementCounterValue;

  final T? _genericValue;

  final List<DataRow> _incrementCounterValue;

  @override
  Description describe(Description description) {
    return description
        .add('matches atleast one MyHomePage widget')
        .addDescriptionOf(this);
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

          if (widget.title == 'love-title' &&
              widget.generic == _genericValue &&
              widget.incrementCounter() == _incrementCounterValue) {
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

    final finder = matchState['custom.finder'];
    final widget = finder.evaluate().first.widget;

    if (widget.title != 'love-title') {
      mismatchDescription
          .add("title is ${widget.title} but 'love-title' was expected");
    }

    if (widget.generic != _genericValue) {
      mismatchDescription
          .add("generic is ${widget.generic} but _genericValue was expected");
    }

    if (widget.incrementCounter() != _incrementCounterValue) {
      mismatchDescription.add(
          "incrementCounter is ${widget.incrementCounter()} but _incrementCounterValue was expected");
    }

    return mismatchDescription;
  }
}

class _MyAppMatcher extends Matcher {
  _MyAppMatcher();

  @override
  Description describe(Description description) {
    return description.add('matches one MyApp widget').addDescriptionOf(this);
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
          break;
        }
      }

      matchState['custom.matchedCount'] = matchedCount;

      return matchedCount == 1;
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

    if (matchState['custom.count'] <= 0) {
      mismatchDescription.add('zero MyApp widgets found but one was expected');
    } else if (matchState['custom.count'] > 1) {
      mismatchDescription
          .add('found multiple MyApp widgets but one was expected');
    }

    return mismatchDescription;
  }
}

class _CircleAvatarMatcher extends Matcher {
  _CircleAvatarMatcher();

  @override
  Description describe(Description description) {
    return description
        .add('matches no CircleAvatar widget')
        .addDescriptionOf(this);
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

class _MyWorldWidgetMatcher extends Matcher {
  _MyWorldWidgetMatcher({
    required int n,
  }) : _n = n;

  final int _n;

  @override
  Description describe(Description description) {
    return description
        .add('matches $_n MyWorldWidget widget')
        .addDescriptionOf(this);
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
