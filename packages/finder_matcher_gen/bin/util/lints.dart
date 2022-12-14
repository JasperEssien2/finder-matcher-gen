import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'extensions.dart';

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

  Lint get lint {
    final annotationDefault = element.checkAnnotationDefaultValue;
    final elementLintLocation = element.nameLintLocation!;

    final completeDeclarationString =
        '@MatchDeclaration(defaultValue: ${annotationDefault.defaultValue})';

    final declarationLength = completeDeclarationString.length;

    return Lint(
      code: code,
      message: message,
      correction: correction,
      location: LintLocation(
        startLine: elementLintLocation.startLine - 1,
        startColumn: 2,
        endLine: elementLintLocation.startLine - 1,
        endColumn: 2 + declarationLength,
        filePath: elementLintLocation.filePath,
        offset: elementLintLocation.offset,
        length: declarationLength,
      ),
      severity: LintSeverity.error,
    );
  }

  String get code;

  String get message;

  String get correction;
}

class UnexpectedDefaultTypeLint extends AnalysisErrorLint {
  UnexpectedDefaultTypeLint({required super.element});

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
      '''Change declaration to public and annotate  with @visibleForTesting''';

  @override
  String get message =>
      '@MatchDeclaration cannot be used on a private declaration';
}

enum InvalidType{
  
}

class DuplicateDeclarationAnnotation extends AnalysisErrorLint {
  DuplicateDeclarationAnnotation({required super.element});

  @override
  String get code => AnaylsisCode.duplicateDeclarationAnnotation;

  @override
  String get correction => '''You can only annotate this declaration once''';

  @override
  String get message => 'Dupplicate @MatchDeclaration on $declarationType';

  String get declarationType {
    if (element.kind == ElementKind.GETTER) return 'getter';
    if (element.kind == ElementKind.FIELD) return 'field';
    if (element.kind == ElementKind.METHOD) return 'method';

    return 'declaration';
  }
}
