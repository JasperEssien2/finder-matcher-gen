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
  ],
  finders: [AddTargetBottomSheet, AppFloatingActionButton],
)
void main() {
  testWidgets('Ensure HomeScreen exists when App running',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await _pumpApp(tester);

    expect(find.byType(HomeScreen), matchesOneHomeScreen);
    expect(find.byType(TaskListView), matchesOneTaskListView(tasksValue: []));
  });

  testWidgets('Ensure addTaskBottomSheet is pushed when FAB pressed',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    _addTaskByInteractionWithWidgets(tester, 'Task');

    expect(findAppFloatingActionButton, findsNothing);
  });

  testWidgets('Ensure adding task with 0 priority works as expecting',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    await _addTaskByInteractionWithWidgets(tester, 'Task');

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

  testWidgets('Ensure adding task with 1 priority works as expecting',
      (WidgetTester tester) async {
    await _pumpApp(tester);

    await _addTaskByInteractionWithWidgets(tester, 'Task');

    final context = tester.state(find.byType(HomeScreen)).context;
    final spinnerWidth = MediaQuery.of(context).size.width - 32;

    expect(
      find.byType(ItemTask),
      matchesNItemTask(
        priorityColorValue: Colors.green,
        taskModelValue: TaskModel('Task', 0),
        n: 1,
      ),
    );
  });
}

Future<void> _addTaskByInteractionWithWidgets(
    WidgetTester tester, String taskName,
    {double? drag}) async {
  await tester.tap(findAppFloatingActionButton);

  await tester.pumpAndSettle();

  expect(findAddTargetBottomSheet, findsOneWidget);

  await tester.enterText(find.byKey(const ValueKey('task-field')), taskName);

  if (drag != null) {
    await tester.drag(find.byType(Slider), Offset(drag, 0));
  }

  await tester.tap(find.byType(SaveButton));

  await tester.pumpAndSettle();
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
}
