// ignore_for_file: type_annotate_public_apis

import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';

/// A generator for generating Finder classes
class FinderGenerator extends BaseAnnotaionGenerator {
  @override
  String get annotationFieldName => 'finders';

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final finderGenerator = FinderClassBuilder(extract)
      ..writeClassHeader()
      ..writeConstructor()
      ..overrideMethods()
      ..closeClass();

    classStringBuffer
      ..write(finderGenerator.stringBuffer.toString())
      ..writeln('\n\n');
  }
}
