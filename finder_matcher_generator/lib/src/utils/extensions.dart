import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_generator/src/utils/element_checker.dart';
import 'package:source_gen/source_gen.dart';

/// An extension to provide additional functionalities for String
extension StringExt on String {
  /// Removes all asterisk symbol for a given string
  String get replaceAsterisk => replaceAll('*', '');
}

/// An extension of [DartType]
extension DartTypeExt on DartType {
  /// Utilises String extension to get the string [DartType] without asterisks
  String get dartTypeStr => toString().replaceAsterisk;
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
