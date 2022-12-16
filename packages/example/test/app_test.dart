import 'package:example/main.dart';
import 'package:example/widgets.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test.matchers.dart';

@Match(
  matchers: [
    MatchWidget(HomeScreen, MatchSpecification.matchesOneWidget),
    MatchWidget(ItemTask, MatchSpecification.matchesNWidgets),
  ],
  finders: [AddTargetBottomSheet, AppFloatingActionButton],
)
void main() {
  testWidgets('Ensure HomeScreen exists when App running',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await _pumpApp(tester);

    expect(find.byType(HomeScreen), matchesOneHomeScreen);
  });

  testWidgets('Ensure addTaskBottomSheet is pushed when FAB pressed',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await _pumpApp(tester);

    tester.tap();
    expect(find.byType(HomeScreen), matchesOneHomeScreen);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
}
