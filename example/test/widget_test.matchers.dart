// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MatcherGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

import 'package:stack_trace/stack_trace.dart' show Chain;

class MyHomePageMatcher extends Matcher {
  MyHomePageMatcher();

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

          if (widget.title == '' && widget.incrementCounter() == []) {
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

    if (widget.title != '') {
      mismatchDescription
          .add('title is "${widget.title}" but ' ' was expected');
    }

    if (widget.incrementCounter() != []) {
      mismatchDescription.add(
          'incrementCounter is "${widget.incrementCounter()}" but [] was expected');
    }

    return mismatchDescription;
  }
}

class MyAppMatcher extends Matcher {
  MyAppMatcher();

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

class FileImageMatcher extends Matcher {
  FileImageMatcher();

  @override
  Description describe(Description description) {
    return description
        .add('matches no FileImage widget')
        .addDescriptionOf(this);
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is FileImage) {
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
          'zero FileImage widgets expected but found ${matchState['custom.count'] ?? 0}');
    }
    return mismatchDescription;
  }
}

class MyWorldWidgetMatcher extends Matcher {
  MyWorldWidgetMatcher({
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
