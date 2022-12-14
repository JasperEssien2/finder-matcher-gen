import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'model.dart';

class AnaylsisCode {
  AnaylsisCode._();

  static const String unexpectedDefaultValue = 'unexpected_default_value_type';
  static const String invalidMatchDeclaration = 'invalid_match_declaration';
  static const String invalidMatchClass = 'invalid_match_class';
  static const String duplicateDeclarationAnnotation =
      'duplicate_declaration_annotation';
}

abstract class AnalysisErrorLint {
  AnalysisErrorLint({required this.element});

  final Element element;

  Lint get lint => Lint(
        code: code,
        message: message,
        correction: correction,
        location: element.nameLintLocation!,
        severity: LintSeverity.error,
      );

  String get code;

  String get message;

  String get correction;
}

class UnexpectedDefaultTypeLint extends AnalysisErrorLint {
  UnexpectedDefaultTypeLint({
    required super.element,
    required this.expected,
    required this.given,
  });

  final String expected;
  final String given;

  @override
  String get code => AnaylsisCode.unexpectedDefaultValue;

  @override
  String get correction =>
      '''@MatchDeclaration defaultValue should be of type ${element.declarationType}''';

  @override
  String get message => 'The defaultValue type is invalid';
}

class InvalidMatchDeclaration extends AnalysisErrorLint {
  InvalidMatchDeclaration({required super.element});

  @override
  String get code => AnaylsisCode.invalidMatchDeclaration;

  @override
  String get correction =>
      '''Change declaration to public and annotate  with @visibleForTesting to only use in test environment''';

  @override
  String get message =>
      '@MatchDeclaration cannot be used on a private declaration';
}

class DuplicateDeclarationAnnotation extends AnalysisErrorLint {
  DuplicateDeclarationAnnotation({required super.element});

  @override
  String get code => AnaylsisCode.duplicateDeclarationAnnotation;

  @override
  String get correction => '''You can only annotate this declaration once''';

  @override
  String get message => 'Dupplicate @MatchDeclaration on field';
}

extension ElementAnnotationExt on ElementAnnotation {
  bool get isMatchDeclaration {
    return this is PropertyAccessorElement &&
        element!.name == 'MatchDeclaration';
    //  && element.library.name == libraryName;
  }
}

/// An extension of [Element]
extension ElementExt on Element {
  /// Returns a list of annotated declaration object
  Iterable<DartObject> get getAnnotationObjects {
    const checker = TypeChecker.fromRuntime(MatchDeclaration);

    return checker.annotationsOf(this);
  }

  String? get declarationType {
    if (kind == ElementKind.GETTER || kind == ElementKind.METHOD) {
      return (this as MethodElement).returnType.toString();
    } else if (kind == ElementKind.FIELD) {
      return (this as FieldElement).type.toString();
    }
    return null;
  }

  AnnotationDefaultValueCheckModel get checkDefaultValue {
    final annotationObjects = getAnnotationObjects;

    var correctType = true;

    final defaultValueObject = annotationObjects.isEmpty
        ? null
        : annotationObjects.first.getField('_defaultValue');

    if (defaultValueObject == null) {
      correctType = true;
    } else {
      correctType = defaultValueObject.type!.dartTypeStr == declarationType;
    }

    return AnnotationDefaultValueCheckModel(
      correctType: correctType,
      expected: declarationType,
      given: defaultValueObject?.type!.dartTypeStr,
    );
  }
}

/// An extension of [DartType]
extension DartTypeExt on DartType {
  /// Replaces all asterisks from the [DartType] string
  String get dartTypeStr => toString().replaceAll('*', '');
}
