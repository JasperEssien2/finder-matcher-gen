import 'dart:async';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/generators/matcher_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late MatcherGenerator generator;
  late Resolver resolver;
  final resolverDone = Completer<void>();
  late AssetId assetId;

  setUpAll(() async {
    assetId = AssetId('_resolve_source', 'lib/_resolve_source.dart');
    resolver = await resolveSource(
      '''
    @Match(
      matchers: [
        MatchWidget(HomeScreen, MatchSpecification.matchesOneWidget),
        MatchWidget(ItemTask, MatchSpecification.matchesNWidgets),
        MatchWidget(TaskListView, MatchSpecification.matchesOneWidget),
        MatchWidget(TaskListView, MatchSpecification.doesNotHaveAncestorOf),
      ],
    )

    void main() {
    }
''',
      (resolver) => resolver,
      tearDown: resolverDone.future,
      inputId: assetId,
    );

    generator = MatcherGenerator();
  });

  group(
    'Test globalVariableNamePrefix()',
    () {
      test(
        'Ensure that globalVariableNamePrefix() returns correct prefix '
        'for MatchSpecification.matchesOneWidget configuration',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.matchesOneWidget,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            generator.globalVariableNamePrefix(classExtract),
            'matchesOne',
          );
        },
      );

      test(
        'Ensure that globalVariableNamePrefix() returns correct prefix '
        'for MatchSpecification.matchesNoWidget configuration',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.matchesNoWidget,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            generator.globalVariableNamePrefix(classExtract),
            'matchesNo',
          );
        },
      );

      test(
        'Ensure that globalVariableNamePrefix() returns correct prefix '
        'for MatchSpecification.matchesAtleastOneWidget configuration',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.matchesAtleastOneWidget,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            generator.globalVariableNamePrefix(classExtract),
            'matchesAtleastOne',
          );
        },
      );

      test(
        'Ensure that globalVariableNamePrefix() returns correct prefix '
        'for MatchSpecification.matchesNWidgets configuration',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.matchesNWidgets,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            generator.globalVariableNamePrefix(classExtract),
            'matchesN',
          );
        },
      );

      test(
        'Ensure that globalVariableNamePrefix() returns correct prefix '
        'for null configuration',
        () {
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            generator.globalVariableNamePrefix(classExtract),
            'matches',
          );
        },
      );

      test(
        'Ensure that globalVariableNamePrefix() throws assertion error '
        'when MatchSpecification.hasAncestorOf and _secondaryType is null',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.hasAncestorOf,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            () => generator.globalVariableNamePrefix(classExtract),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      // test(
      //   'Ensure that globalVariableNamePrefix() returns correct prefix '
      //   'for MatchSpecification.hasAncestorOf configuration',
      //   () async {
      //     final libraryElement = await resolver.libraryFor(assetId);

      //     generator.
      //     generator.generate(LibraryReader(libraryElement), BuildStepImpl());
      //     generator.addToSpecification(
      //       'elementId',
      //       MatcherGeneratorSpecification(
      //         MatchSpecification.hasAncestorOf,
      //         DartObjectImpl(ClassElementExtract).toTypeValue(),
      //       ),
      //     );
      //     const classExtract = ClassElementExtract(id: 'elementId');
      //     expect(
      //       generator.globalVariableNamePrefix(classExtract),
      //       'matchesN',
      //     );
      //   },
      // );

      test(
        'Ensure that globalVariableNamePrefix() throws assertion error '
        'when MatchSpecification.doesNotHaveAncestorOf and _secondaryType is '
        'null',
        () {
          generator.addToSpecification(
            'elementId',
            MatcherGeneratorSpecification(
              MatchSpecification.doesNotHaveAncestorOf,
              null,
            ),
          );
          const classExtract = ClassElementExtract(id: 'elementId');
          expect(
            () => generator.globalVariableNamePrefix(classExtract),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    },
  );
}
