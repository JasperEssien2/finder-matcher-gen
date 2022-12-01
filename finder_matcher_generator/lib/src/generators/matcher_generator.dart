// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Matcher classes
class MatcherGenerator extends BaseAnnotaionGenerator {
  final _typeToSpecification = <String, MatchSpecification>{};

  @override
  List<DartObject> generateFor(ConstantReader annotation) {
    final annotationFields = annotation.read('matchers').listValue;
    final types = <DartObject>[];

    for (final element in annotationFields) {
      types.add(element.getField('type')!);
      _typeToSpecification[element.getField('type').toString()] =
          // ignore: cast_nullable_to_non_nullable
          element.getField('specification') as MatchSpecification;
    }
    return types;
  }

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final matcherGenerator = WidgetMatcherClassBuilder(
      extract,
      _typeToSpecification[extract.className]!,
    )
      ..writeClassHeader()
      ..writeConstructor()
      ..overrideMethods()
      ..closeClass();

    classStringBuffer
      ..write(matcherGenerator.stringBuffer.toString())
      ..writeln('\n\n');
  }
}
