// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/utils_export.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Matcher classes
class MatcherGenerator extends BaseAnnotaionGenerator {
  final _typeToSpecification = <String, MatchSpecification>{};

  @override
  List<DartObject> generateFor(ConstantReader annotation) {
    final annotationFields = annotation.read('_matchers').listValue;
    final types = <DartObject>[];

    for (final element in annotationFields) {
      types.add(element.getField('_type')!);

      final fieldTypeName =
          element.getField('_type')!.toTypeValue().toString().replaceAsterisk;

      _typeToSpecification[fieldTypeName] = element
          .getField('_specification')!
          .variable!
          .displayName
          .specificationValue;
    }
    return types;
  }

  @override
  void writeImports(StringBuffer importBuffer, {Uri? classUri}) {
    super.writeImports(importBuffer, classUri: classUri);
    const stackTraceImport =
        "import 'package:stack_trace/stack_trace.dart' show Chain;";

    if (doesNotContainImport(stackTraceImport)) {
      importBuffer.writeln(stackTraceImport);
    }
  }

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final matcherGenerator = WidgetMatcherClassBuilder(
      extract,
      _typeToSpecification[extract.className]!,
    )..buildClassCode();

    classStringBuffer
      ..write(matcherGenerator.classCode)
      ..writeln('\n\n');
  }
}
