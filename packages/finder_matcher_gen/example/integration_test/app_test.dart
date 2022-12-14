import 'package:example/main.dart';
import 'package:example/models.dart';
import 'package:example/widgets.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test.finders.dart';
import 'app_test.matchers.dart';

@Match(
  matchers: [
    MatchWidget(HomeScreen, MatchSpecification.matchesOneWidget),
    MatchWidget(ItemTask, MatchSpecification.matchesNWidgets),
    MatchWidget(TaskListView, MatchSpecification.matchesOneWidget),
    MatchWidget(TaskListView, MatchSpecification.matchesNoWidget),
  ],
  finders: [AddTargetBottomSheet, AppFloatingActionButton],
)
void main() {
  testWidgets('Ensure HomeScreen exists when App running',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await _pumpApp(tester);

    expect(find.byType(HomeScreen), matchesOneHomeScreen);
    expect(find.byType(TaskListView), findsNothing);
  });

  testWidgets('Ensure addTaskBottomSheet is pushed when FAB pressed',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    await _inputTaskNameAndPriority(tester, 'Task');

    expect(findAddTargetBottomSheet, findsOneWidget);

    await _saveTaskEntry(tester);

    expect(findAddTargetBottomSheet, findsNothing);
  });

  testWidgets('Ensure adding task with 5 priority works as expected',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _inputTaskNameAndPriority(tester, 'Task',
        drag: MediaQuery.of(context).size.width / 2);

    await _saveTaskEntry(tester);

    final expectedTask = TaskModel('Task', 5);

    expect(
      find.byType(ItemTask),
      matchesNItemTask(
        priorityColorValue: Colors.red,
        taskModelValue: expectedTask,
        n: 1,
      ),
    );
  });

  testWidgets('Ensure adding task with 0 priority works as expecting',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    await _inputTaskNameAndPriority(tester, 'Task');

    await _saveTaskEntry(tester);

    final expectedTask = TaskModel('Task', 0);

    expect(
      find.byType(ItemTask),
      matchesNItemTask(
        priorityColorValue: Colors.green,
        taskModelValue: expectedTask,
        n: 1,
      ),
    );
  });
}

Future<void> _inputTaskNameAndPriority(WidgetTester tester, String taskName,
    {double? drag}) async {
  await tester.tap(findAppFloatingActionButton);

  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const ValueKey('task-field')), taskName);

  if (drag != null) {
    await tester.drag(find.byType(Slider), Offset(drag, 0));
  }

  await tester.pumpAndSettle();
}

Future<void> _saveTaskEntry(WidgetTester tester) async {
  await tester.tap(find.byType(SaveButton));

  await tester.pumpAndSettle();
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  await tester.pumpAndSettle();
}
