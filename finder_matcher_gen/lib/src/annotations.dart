/// Some matchers might depend on fields to validate it's matched.
/// This annotation indicates what fields to use for validation
class Match {
  ///
  const Match({
    this.matchers = const [],
    this.finders = const [],
  });

  /// Control
  final List<MatchWidget> matchers;
  final List<Type> finders;
}

class MatchWidget {
  const MatchWidget(this.type, this.specification);

  final Type type;
  final MatchSpecification specification;
}

enum MatchSpecification {
  matchesOneWidget,
  matchesNoWidget,
  matchesAtleastOneWidget,
  matchesNWidgets,
}

extension _MatchSpecificationExt on MatchSpecification {
  String get toStringValue {
    switch (this) {
      case MatchSpecification.matchesOneWidget:
        return 'matchesOneWidget';
      case MatchSpecification.matchesNoWidget:
        return 'matchesNoWidget';
      case MatchSpecification.matchesAtleastOneWidget:
        return 'matchesAtleastOneWidget';
      case MatchSpecification.matchesNWidgets:
        return 'matchesNWidgets';
    }
  }
}

class MatchDeclaration {
  const MatchDeclaration({this.initialiseInConstructor = false});

  //TODO: Set it up in such a way that, the variable can be passed
  final bool initialiseInConstructor;
}

const matchDeclaration = MatchDeclaration();
