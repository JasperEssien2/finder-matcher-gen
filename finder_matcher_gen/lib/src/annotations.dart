/// Some matchers might depend on fields to validate it's matched.
/// This annotation indicates what fields to use for validation
class Match {
  ///
  const Match({
    this.matchers = const [],
    this.finders = const [],
  });

  /// Control
  final List<Type> matchers;
  final List<Type> finders;
}

class MatchField {
  const MatchField({this.initialiseInConstructor = false});

  //TODO: Set it up in such a way that, the variable can be passed
  final bool initialiseInConstructor;
}

class MatchMethod {
  const MatchMethod();
}

const matchField = MatchField();
const matchMethod = MatchMethod();
