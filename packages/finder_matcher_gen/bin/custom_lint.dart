import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'analysis_class_visitor.dart';

void main(List<String> args, SendPort sendPort) {
  startPlugin(sendPort, _FinderMatcherAnnotationLint());
}

class _FinderMatcherAnnotationLint extends PluginBase {
  @override
  Stream<Lint> getLints(ResolvedUnitResult unit) async* {
    final library = unit.libraryElement;

    for (final element in library.topLevelElements.whereType<ClassElement>()) {
      final visitor = AnalysisClassVisitor();
      element.visitChildren(visitor);

      for (final lint in visitor.lintErrors) {
        yield lint;
      }
    }
  }
}
