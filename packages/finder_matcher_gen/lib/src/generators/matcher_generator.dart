// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/builders/builders_export.dart';
import 'package:finder_matcher_gen/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Matcher classes
class MatcherGenerator extends BaseAnnotaionGenerator {
  final _typeToSpecification = <String, MatchSpecification>{};
  final _defaultConstructorFields = <String, Set<ConstructorFieldModel>>{};

  @override
  List<DartObject> generateFor(ConstantReader annotation) {
    final annotationFields = annotation.read('_matchers').listValue;
    final types = <DartObject>[];

    for (final element in annotationFields) {
      types.add(element.getField('_type')!);

      final fieldTypeName =
          element.getField('_type')!.toTypeValue().toString().replaceAsterisk;

      final specificationValue = element
          .getField('_specification')!
          .variable!
          .displayName
          .specificationValue;

      _typeToSpecification[fieldTypeName] = specificationValue;

      if (specificationValue == MatchSpecification.matchesNWidgets) {
        if (!_defaultConstructorFields.containsKey(fieldTypeName)) {
          _defaultConstructorFields[fieldTypeName] = {};
        }
        _defaultConstructorFields[fieldTypeName]!
            .add(const ConstructorFieldModel(name: 'n', type: 'int'));
      }
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
      _getClassSpecification(extract)!,
    )..buildClassCode();

    classStringBuffer
      ..write(matcherGenerator.classCode)
      ..writeln('\n\n');

    super.writeClassToBuffer(extract, classStringBuffer);
  }

  @override
  String prefix(ClassElementExtract extract) {
    switch (_getClassSpecification(extract)) {
      case MatchSpecification.matchesOneWidget:
        return 'matchesOne';
      case MatchSpecification.matchesNoWidget:
        return 'matchesNo';
      case MatchSpecification.matchesAtleastOneWidget:
        return 'matchesAtleastOne';
      case MatchSpecification.matchesNWidgets:
        return 'matchesN';
      case null:
        return 'matches';
    }
  }

  @override
  String get suffix => 'Matcher';

  MatchSpecification? _getClassSpecification(ClassElementExtract extract) =>
      _typeToSpecification[extract.className];

  @override
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields =>
      _defaultConstructorFields;
}
