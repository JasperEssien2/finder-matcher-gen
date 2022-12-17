// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MatcherGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

import 'package:stack_trace/stack_trace.dart' show Chain;
import 'package:example/widgets.dart';

import 'package:example/models.dart';
import 'package:flutter/foundation.dart';

final matchesOneHomeScreen = _HomeScreenMatcher();

matchesNItemTask(
        {required Color priorityColorValue,
        required TaskModel taskModelValue,
        required int n}) =>
    _ItemTaskMatcher(
        priorityColorValue: priorityColorValue,
        taskModelValue: taskModelValue,
        n: n);

matchesOneTaskListView({required List<TaskModel> tasksValue}) =>
    _TaskListViewMatcher(tasksValue: tasksValue);

class _HomeScreenMatcher extends Matcher {
  _HomeScreenMatcher();

  @override
  Description describe(Description description) {
    return description.add('matches one HomeScreen widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is HomeScreen) {
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
      mismatchDescription
          .add('zero HomeScreen widgets found but one was expected');
    } else if (matchState['custom.count'] > 1) {
      mismatchDescription
          .add('found multiple HomeScreen widgets but one was expected');
    }

    return mismatchDescription;
  }
}

class _ItemTaskMatcher extends Matcher {
  _ItemTaskMatcher({
    required Color priorityColorValue,
    required TaskModel taskModelValue,
    required int n,
  })  : _priorityColorValue = priorityColorValue,
        _taskModelValue = taskModelValue,
        _n = n;

  final Color _priorityColorValue;

  final TaskModel _taskModelValue;

  final int _n;

  @override
  Description describe(Description description) {
    return description.add('matches $_n ItemTask widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is ItemTask) {
          final widget = element.widget as ItemTask;

          var expectedDeclarationCount = 0;

          if (widget.priorityColor == _priorityColorValue) {
            expectedDeclarationCount++;
          } else {
            matchState['widget.priorityColor-expected'] = _priorityColorValue;

            if (matchState['widget.priorityColor-found'] == null) {
              matchState['widget.priorityColor-found'] = <dynamic>{};
            }

            matchState['widget.priorityColor-found'].add(widget.priorityColor);
          }

          if (widget.taskModel == _taskModelValue) {
            expectedDeclarationCount++;
          } else {
            matchState['widget.taskModel-expected'] = _taskModelValue;

            if (matchState['widget.taskModel-found'] == null) {
              matchState['widget.taskModel-found'] = <dynamic>{};
            }

            matchState['widget.taskModel-found'].add(widget.taskModel);
          }

          if (expectedDeclarationCount == 2) {
            matchedCount++;
          }
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
          'found ${matchState['custom.matchedCount']} ItemTask widgets $_n was expected');
    }

    if (matchState['widget.priorityColor-found'] != null &&
        matchState['widget.priorityColor-expected'] != null) {
      mismatchDescription.add(
          "priorityColor is ${matchState['widget.priorityColor-found']} but ${matchState['widget.priorityColor-expected']} was expected \n\n");
    }

    if (matchState['widget.taskModel-found'] != null &&
        matchState['widget.taskModel-expected'] != null) {
      mismatchDescription.add(
          "taskModel is ${matchState['widget.taskModel-found']} but ${matchState['widget.taskModel-expected']} was expected \n\n");
    }

    return mismatchDescription;
  }
}

class _TaskListViewMatcher extends Matcher {
  _TaskListViewMatcher({
    required List<TaskModel> tasksValue,
  }) : _tasksValue = tasksValue;

  final List<TaskModel> _tasksValue;

  @override
  Description describe(Description description) {
    return description.add('matches one TaskListView widget');
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    matchState['custom.finder'] = finder;

    try {
      var matchedCount = 0;

      final elements = finder.evaluate();

      for (final element in elements) {
        if (element.widget is TaskListView) {
          if (listEquals(widget.tasks, _tasksValue)) {
            expectedDeclarationCount++;
          } else {
            matchState['widget.tasks-expected'] = _tasksValue;

            if (matchState['widget.tasks-found'] == null) {
              matchState['widget.tasks-found'] = <dynamic>{};
            }

            matchState['widget.tasks-found'].add(widget.tasks);
          }

          if (expectedDeclarationCount == 1) {
            matchedCount++;
          }
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
      mismatchDescription
          .add('zero TaskListView widgets found but one was expected');
    } else if (matchState['custom.count'] > 1) {
      mismatchDescription
          .add('found multiple TaskListView widgets but one was expected');
    }

    if (matchState['widget.tasks-found'] != null &&
        matchState['widget.tasks-expected'] != null) {
      mismatchDescription.add(
          "tasks is ${matchState['widget.tasks-found']} but ${matchState['widget.tasks-expected']} was expected \n\n");
    }

    return mismatchDescription;
  }
}
