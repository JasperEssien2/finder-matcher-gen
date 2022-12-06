import 'package:finder_matcher_gen/finder_matcher_gen.dart';

/// Extension on [MatchSpecification]
extension MatchSpecificationExt on MatchSpecification {
  /// Returns a string value of [MatchSpecification]
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

/// Extension on [String]
extension StringExt on String {
  /// Returns a [MatchSpecification] value from a given string value
  /// Throws an exception when the string is invalid
  MatchSpecification get specificationValue {
    switch (this) {
      case 'matchesOneWidget':
        return MatchSpecification.matchesOneWidget;
      case 'matchesNoWidget':
        return MatchSpecification.matchesNoWidget;
      case 'matchesAtleastOneWidget':
        return MatchSpecification.matchesAtleastOneWidget;
      case 'matchesNWidgets':
        return MatchSpecification.matchesNWidgets;
    }

    throw Exception('Unrecognised MatchSpecification: $this');
  }
}
