// ignore_for_file: unused_field

/// Annotation for marking widgets to generate Finder or Matcher classes
class Match {
  ///Accepts two parametera
  ///* A list of [MatchWidget] that specifies widgets to generate 
  ///a corresponding matcher
  ///* A list [Type] widgets to generate corresponsing finder classes
  const Match({
    List<MatchWidget> matchers = const [],
    List<Type> finders = const [],
  })  : _matchers = matchers,
        _finders = finders;

  final List<MatchWidget> _matchers;
  final List<Type> _finders;
}

/// Pass to the [Match] annotation. Includes widgets to generate a corresponding
/// Matcher
class MatchWidget {
  /// Accepts [Type] of the widget. E.g MyHomePage
  /// An enum [MatchSpecification] that indicates how many widgets should be
  /// matched by generated Matcher.
  ///
  /// * MatchSpecification.matchesOneWidget: Generates a matcher that ensures
  /// exactly one widget was matched
  ///
  /// * MatchSpecification.matchesNoWidget: Generates a matcher that ensures
  /// no widget was matched
  ///
  /// * MatchSpecification.matchesAtleastOneWidget: Generates a matcher that
  /// ensures at least one widget was matched
  ///
  /// * MatchSpecification.matchesNWidgets: Generates a matcher that ensures
  /// the specified number of widgets was matched
  const MatchWidget(Type type, MatchSpecification specification)
      : _type = type,
        _specification = specification;

  final Type _type;
  final MatchSpecification _specification;
}

/// An enum [MatchDeclaration]
enum MatchSpecification {
  /// Generate matcher that matches exactly one widget
  matchesOneWidget,

  /// Generate matcher that matches no widget
  matchesNoWidget,

  /// Generate matcher that matches at least one widget
  matchesAtleastOneWidget,

  /// Generate matcher that matches "n" widgets
  matchesNWidgets,
}

/// Annotations to mark declarations that would be used to validate a
/// Finder or Matcher
///
/// Supported declarations are as follows
///   * setters
///   * fields
///   * non-void method
///
///Only limited Return types are supported: int, bool, double, String, List, Map
class MatchDeclaration<T> {
  ///
  const MatchDeclaration({T? defaultValue}) : _defaultValue = defaultValue;

  final T? _defaultValue;
}
