// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_gen/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/writers/writers_export.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Finder classes
class FinderGenerator extends BaseAnnotaionGenerator {
  @override
  List<DartObject> generateFor(ConstantReader annotation) =>
      annotation.read('_finders').listValue;

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
  String prefix(ClassElementExtract extract) => 'find';

  @override
  String get suffix => 'MatchFinder';

  @override
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields => {};
}
