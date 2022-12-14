import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'util/extensions.dart';
import 'util/lints.dart';

class AnalysisClassVisitor extends SimpleElementVisitor<void> {
  AnalysisClassVisitor();

  List<Lint> lintErrors = [];

  @override
  void visitFieldElement(FieldElement element) {
    _checkAndAddLint(element);
  }

  @override
  void visitMethodElement(MethodElement element) => _checkAndAddLint(element);

  void _checkAndAddLint(Element element) {
    if (_annotatedWithMatchDeclaration(element)) {
      final lint = getAnalysisError(element)?.lint;

      if (lint != null) {
        lintErrors.add(lint);
      }
    }
  }

  bool _annotatedWithMatchDeclaration(Element element) =>
      const TypeChecker.fromRuntime(MatchDeclaration)
          .hasAnnotationOf(element, throwOnUnresolved: false);

  AnalysisErrorLint? getAnalysisError(Element element) {
    if (element.isPrivate) {
      return InvalidMatchDeclaration(element: element);
    }

    final matchDeclarationsElements = element.getAnnotationObjects;

    if (matchDeclarationsElements.length > 1) {
      return DuplicateDeclarationAnnotation(element: element);
    } else {
      final check = element.checkAnnotationDefaultValue;

      if (!check.correctType) {
        return UnexpectedDefaultTypeLint(element: element);
      }
    }
    return null;
  }
}
