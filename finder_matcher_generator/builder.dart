import 'package:build/build.dart';
import 'package:finder_matcher_generator/finder_matcher_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateFinder(BuilderOptions options) => LibraryBuilder(
      FinderGenerator(),
      generatedExtension: 'integration_test/finders/{{file}}.finder.dart',
    );
