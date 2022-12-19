import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/utils/element_checker.dart';
import 'package:source_gen/source_gen.dart';

/// An extension to provide additional functionalities for String
extension StringExt on String {
  /// Removes all asterisk symbol for a given string
  String get replaceAsterisk => replaceAll('*', '');
}

/// An extension of [DartType]
extension DartTypeExt on DartType {
  /// Replaces all asterisks and generic from the [DartType] string
  String get dartTypeStr =>
      toString().replaceAsterisk.replaceAll(typeGenericParamStr ?? '', '');

  /// If this [DartType] has an associated param, it returns it.
  ///
  /// For example: a [HomePage<T, R>] returns <T, R>
  String? get typeGenericParamStr {
    if (element == null) return null;

    var className = '';

    if (element is ClassElement) {
      className = (element! as ClassElement)
          .thisType
          .getDisplayString(withNullability: false);
    }

    final start = className.indexOf('<');
    final end = className.indexOf('>') + 1;

    if (start == -1 || end == -1) return null;

    final generic = className.substring(start, end);
    return generic;
  }

  ///
  String get removeGenericParamSOrReturntr {
    final string = toString();

    final start = string.indexOf('<');
    final end = string.indexOf('>') + 1;

    if (start == -1 || end == -1) return toString().replaceAsterisk;

    return string.replaceRange(start, end, '').replaceAsterisk;
  }
}

/// An extension of [Element]
extension ElementExt on Element {
  /// Check if element is annotated with the [MatchDeclaration] annotation
  bool get hasMatchFieldAnnotation {
    const checker = TypeChecker.fromRuntime(MatchDeclaration);

    return checker.hasAnnotationOf(this, throwOnUnresolved: false);
  }

  /// Returns a list of annotated declaration object
  Iterable<DartObject> get getAnnotationObjects {
    const checker = TypeChecker.fromRuntime(MatchDeclaration);

    return checker.annotationsOf(this);
  }
}

/// An extension of [List<Element>]
extension ElementListExt on List<Element> {
  /// Checks all element, Return true if annotated with [MatchDeclaration]
  /// otherwise return false
  bool get hasAtleastOneMatchDeclarationAnnotation {
    for (final element in this) {
      if (element.hasMatchFieldAnnotation) {
        /// Ensures that annotation kind is supported
        checkAnnotationsKind(element);
        return true;
      }
    }

    return false;
  }
}

/// Extension on [MatchSpecification]
extension MatchSpecificationExt on MatchSpecification {
  /// Retuns a widget matcher class name suffix based on [MatchSpecification]
  String get matcherSuffix {
    var prefix = '';

    switch (this) {
      case MatchSpecification.matchesNoWidget:
        prefix = 'None';
        break;
      case MatchSpecification.matchesAtleastOneWidget:
        prefix = 'AtleastOne';
        break;
      case MatchSpecification.matchesNWidgets:
        prefix = 'N';
        break;
      case MatchSpecification.matchesOneWidget:
        prefix = 'One';
        break;
    }
    return '${prefix}Matcher';
  }
}
