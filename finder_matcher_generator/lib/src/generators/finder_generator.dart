// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Finder classes
class FinderGenerator extends BaseAnnotaionGenerator {
  @override
  List<DartObject> generateFor(ConstantReader annotation) =>
      annotation.read('finders').listValue;

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final finderGenerator = FinderClassBuilder(extract)..buildClassCode();

    classStringBuffer
      ..write(finderGenerator.classCode)
      ..writeln('\n\n');
  }
}
