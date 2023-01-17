// ignore_for_file: type_annotate_public_apis

import 'package:finder_matcher_gen/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/writers/writers_export.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Finder classes
class FinderGenerator extends BaseAnnotationGenerator {
  @override
  List<WidgetDartObject> generateFor(ConstantReader annotation) => annotation
      .read('_finders')
      .listValue
      .map((e) => WidgetDartObject(dartObject: e))
      .toList();

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final finderGenerator = FinderClassWriter(extract)..buildClassCode();

    classStringBuffer
      ..write(finderGenerator.classCode)
      ..writeln('\n\n');

    super.writeClassToBuffer(extract, classStringBuffer);
  }

  @override
  String globalVariableNamePrefix(ClassElementExtract extract) =>
      'find${extract.className}${extract.genericParam}';

  @override
  String classSuffix(ClassElementExtract extract) => 'MatchFinder';

  @override
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields => {};

  @override
  String get generatorName => 'Finder';
}
