// ignore_for_file: type_annotate_public_apis

import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';
import 'package:finder_matcher_gen/src/writers/writers_export.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Matcher classes
class MatcherGenerator extends BaseAnnotationGenerator {
  final _typeToSpecification = <String, MatchSpecification>{};
  final _defaultConstructorFields = <String, Set<ConstructorFieldModel>>{};

  @override
  List<WidgetDartObject> generateFor(ConstantReader annotation) {
    final annotationFields = annotation.read('_matchers').listValue;
    final widgetTypes = <WidgetDartObject>[];

    for (final element in annotationFields) {
      final fieldTypeName = element
          .getField('_type')
          ?.toTypeValue()!
          .removeGenericParamSOrReturntr;

      final specificationDisplay =
          element.getField('_specification')!.variable!.displayName;

      final typeToSpecificationKey = '$fieldTypeName-$specificationDisplay';

      final specificationValue = specificationDisplay.specificationValue;

      _typeToSpecification[typeToSpecificationKey] = specificationValue;

      if (specificationValue == MatchSpecification.matchesNWidgets) {
        if (!_defaultConstructorFields.containsKey(fieldTypeName)) {
          _defaultConstructorFields[fieldTypeName!] = {};
        }
        _defaultConstructorFields[fieldTypeName]!
            .add(const ConstructorFieldModel(name: 'n', type: 'int'));
      }

      widgetTypes.add(
        WidgetDartObject(
          dartObject: element.getField('_type')!,
          id: typeToSpecificationKey,
        ),
      );
    }
    return widgetTypes;
  }

  @override
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    final matcherGenerator = WidgetMatcherClassWriter(
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
  String classSuffix(ClassElementExtract extract) =>
      _getClassSpecification(extract)!.matcherSuffix;

  MatchSpecification? _getClassSpecification(
    ClassElementExtract extract,
  ) =>
      _typeToSpecification[extract.id];

  @override
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields =>
      _defaultConstructorFields;
}
