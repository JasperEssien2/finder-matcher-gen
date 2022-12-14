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

  Lint? get lint {
    if (!lintError) return null;

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

  bool get lintError;
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

  @override
  bool get lintError => !element.checkAnnotationDefaultValue.correctType;
}

class InvalidMatchDeclaration extends AnalysisErrorLint {
  InvalidMatchDeclaration({required super.element});

  @override
  String get code => AnaylsisCode.invalidMatchDeclaration;

  @override
  String get correction {
    switch (getInvalidType) {
      case InvalidType.private:
        return '''Change declaration to public and annotate  with @visibleForTesting''';
      case InvalidType.setter:
        return '''Move declaration to a getter''';
      case InvalidType.classType:
        return '''Annotate class fields, methods, or getters instead''';
      case InvalidType.static:
        return 'Remove static declaration';

      case null:
        return '';
      case InvalidType.voidReturnType:
        return 'Remove @MatchDeclaration on void method';
    }
  }

  @override
  String get message {
    var message = '@MatchDeclaration cannot be used on a ';

    switch (getInvalidType) {
      case InvalidType.private:
        message += 'private declaration';
        break;
      case InvalidType.setter:
        message += 'setter';
        break;
      case InvalidType.classType:
        message += 'class';
        break;
      case InvalidType.static:
        message += 'static declaration';
        break;

      case null:
        message += 'declaration';
        break;
      case InvalidType.voidReturnType:
        message += 'void declaration';
        break;
    }
    return message;
  }

  @override
  bool get lintError => getInvalidType != null;

  InvalidType? get getInvalidType {
    if (element.isPrivate) return InvalidType.private;

    if (element.kind == ElementKind.SETTER) return InvalidType.setter;
    if (element.kind == ElementKind.CLASS) return InvalidType.classType;

    if ((element.kind == ElementKind.FIELD) &&
        (element as FieldElement).isStatic) return InvalidType.static;
    if (element.kind == ElementKind.METHOD ||
        element.kind == ElementKind.GETTER) {
      final methodElement = element as MethodElement;

      if (methodElement.isStatic) return InvalidType.static;

      if (methodElement.returnType.isVoid) return InvalidType.voidReturnType;
    }
    return null;
  }
}

enum InvalidType {
  private,
  setter,
  classType,
  static,
  voidReturnType,
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

  @override
  bool get lintError => element.getAnnotationObjects.length > 1;
}

List<AnalysisErrorLint> analysisErrorLintList(Element element) {
  return [
    UnexpectedDefaultTypeLint(element: element),
    InvalidMatchDeclaration(element: element),
    DuplicateDeclarationAnnotation(element: element),
  ];
}
