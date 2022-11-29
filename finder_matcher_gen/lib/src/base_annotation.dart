/// An annotation to indicate classes to generate matchers or finders
class MatcherAnnotation {
  ///[generateFinder] defaults to true
  const MatcherAnnotation({this.generateFinder = true});

  ///A flag to indicate if to generate finder alongside matcher
  final bool generateFinder;
}

/// Some matchers might depend on fields to validate it's matched.
/// This annotation indicates what fields to use for validation
class FieldMatcherAnnotation extends MatcherAnnotation {

  ///
  const FieldMatcherAnnotation({
    this.generateType = GenerateType.finderAndMatcher,
  });

  /// Control 
  final GenerateType generateType;
}

//
enum GenerateType {
  finder,
  matcher,
  finderAndMatcher,
}

const match = MatcherAnnotation();
const matchField = FieldMatcherAnnotation();
