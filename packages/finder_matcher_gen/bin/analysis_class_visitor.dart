import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'util/extensions.dart';
import 'util/lints.dart';

class AnalysisClassVisitor extends SimpleElementVisitor<void> {
  AnalysisClassVisitor();

  List<Lint> lintErrors = [];

  @override
  void visitMethodElement(MethodElement element) => _checkAndAddLint(element);

  @override
  void visitFieldElement(FieldElement element) => _checkAndAddLint(element);

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) =>
      _checkAndAddLint(element);

  void _checkAndAddLint(Element element) {
    if (element.isMatchDeclaration) {
      final lintCheckLint = analysisErrorLintList(element);

      for (final lintCheck in lintCheckLint) {
        final lint = lintCheck.lint;

        if (lint != null) {
          lintErrors.add(lint);
        }
      }
    }
  }
}
