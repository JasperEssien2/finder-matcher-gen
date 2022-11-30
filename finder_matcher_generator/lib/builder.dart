import 'package:build/build.dart';
import 'package:finder_matcher_generator/finder_matcher_generator.dart';
import 'package:source_gen/source_gen.dart';

/// An entry point for build_runner to generate Finder classes
Builder generateFinder(BuilderOptions options) => LibraryBuilder(
      FinderGenerator(),
      options: options,
      generatedExtension: '.finder.dart',
    );

// Builder generateMatcher(BuilderOptions options) => LibraryBuilder(
//       FinderGenerator(),
//       generatedExtension: 'integration_test/matchers/{{}}.matcher.dart',
//     );
