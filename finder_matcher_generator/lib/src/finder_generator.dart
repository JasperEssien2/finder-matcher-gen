// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/utils/finder_class_builder.dart';
import 'package:source_gen/source_gen.dart';

class FinderGenerator extends GeneratorForAnnotation<MatcherAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final classVisitor = ClassVisitor();

    element.visitChildren(classVisitor);

    final finderGenerator = FinderClassBuilder(classVisitor.classExtract)
      ..writeImport()
      ..writeClassHeader()
      ..writeConstructor()
      ..overrideMethods()
      ..closeClass();

    return '''
    ${finderGenerator.stringBuffer.toString()}
  ''';
  }
}
