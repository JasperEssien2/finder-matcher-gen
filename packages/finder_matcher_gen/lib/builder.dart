import 'package:build/build.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';

import 'package:source_gen/source_gen.dart';

/// An entry point for build_runner to generate Finder classes
Builder generateFinder(BuilderOptions options) => LibraryBuilder(
      FinderGenerator(),
      options: options,
      generatedExtension: '.finders.dart',
    );

/// An entry point for build_runner to generate Matcher classes
Builder generateMatcher(BuilderOptions options) => LibraryBuilder(
      MatcherGenerator(),
      options: options,
      generatedExtension: '.matchers.dart',
    );
