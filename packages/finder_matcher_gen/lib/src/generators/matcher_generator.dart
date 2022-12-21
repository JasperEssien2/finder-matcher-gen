// ignore_for_file: type_annotate_public_apis

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/generators/base_annotation_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';
import 'package:finder_matcher_gen/src/writers/writers_export.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// A generator for generating Matcher classes
class MatcherGenerator extends BaseAnnotationGenerator {
  final _idToSpecification = <String, MatcherGeneratorSpecification>{};
  final _idToDefaultConstructorFields = <String, Set<ConstructorFieldModel>>{};

  @visibleForTesting
  // ignore: public_member_api_docs
  void addToSpecification(String key, MatcherGeneratorSpecification spec) =>
      _idToSpecification[key] = spec;

  @visibleForTesting
  // ignore: public_member_api_docs
  void addToDefaultConstructorFields(
    String key,
    Set<ConstructorFieldModel> fields,
  ) =>
      _idToDefaultConstructorFields[key] = fields;

  @override
  List<WidgetDartObject> generateFor(ConstantReader annotation) {
    final annotationFields = annotation.read('_matchers').listValue;
    final widgetTypes = <WidgetDartObject>[];

    for (final element in annotationFields) {
      final elementId = _populateMaps(element);

      widgetTypes.add(
        WidgetDartObject(
          dartObject: element.getField('_type')!,
          id: elementId,
        ),
      );
    }
    return widgetTypes;
  }

  String _populateMaps(DartObject element) {
    final fieldTypeName =
        element.getField('_type')?.toTypeValue()!.removeGenericParams;

    final specificationDisplay =
        element.getField('_specification')!.variable!.displayName;

    final typeToSpecificationKey = '$fieldTypeName-$specificationDisplay';

    final specificationValue = specificationDisplay.specificationValue;

    final secondaryType = element.getField('_secondaryType')?.toTypeValue();

    if (specificationValue == MatchSpecification.hasAncestorOf ||
        specificationValue == MatchSpecification.doesNotHaveAncestorOf) {
      assert(
        secondaryType != null,
        'secondaryType cannot be null for $specificationValue',
      );
    }
    _idToSpecification[typeToSpecificationKey] =
        MatcherGeneratorSpecification(specificationValue, secondaryType);

    if (specificationValue == MatchSpecification.matchesNWidgets) {
      if (!_idToDefaultConstructorFields.containsKey(typeToSpecificationKey)) {
        _idToDefaultConstructorFields[typeToSpecificationKey] = {};
      }
      _idToDefaultConstructorFields[typeToSpecificationKey]!
          .add(const ConstructorFieldModel(name: 'n', type: 'int'));
    }
    return typeToSpecificationKey;
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
  String globalVariableNamePrefix(ClassElementExtract extract) {
    final spec = _getClassSpecification(extract);
    switch (spec?.specification) {
      case MatchSpecification.matchesOneWidget:
        return 'matchesOne${extract.className}${extract.genericParam}';
      case MatchSpecification.matchesNoWidget:
        return 'matchesNo${extract.className}${extract.genericParam}';
      case MatchSpecification.matchesAtleastOneWidget:
        return 'matchesAtleastOne${extract.className}${extract.genericParam}';
      case MatchSpecification.matchesNWidgets:
        return 'matchesN${extract.className}${extract.genericParam}';
      case null:
        return 'matches${extract.className}${extract.genericParam}';
      case MatchSpecification.hasAncestorOf:
        assert(
          spec!.secondaryType != null,
          'secondaryType must be initialised',
        );

        final secondaryType = spec!.secondaryType!;
        return '''${extract.className!.firstToLowerCase}HasAncestorOf${secondaryType.dartTypeStr}''';
      case MatchSpecification.doesNotHaveAncestorOf:
        assert(
          spec!.secondaryType != null,
          'secondaryType must be initialised',
        );

        final secondaryType = spec!.secondaryType!;
        return '''${extract.className!.firstToLowerCase}DoesNotHaveAncestorOf${secondaryType.dartTypeStr}''';
    }
  }

  @override
  String classSuffix(ClassElementExtract extract) =>
      _getClassSpecification(extract)!.matcherSuffix;

  MatcherGeneratorSpecification? _getClassSpecification(
    ClassElementExtract extract,
  ) =>
      _idToSpecification[extract.id];

  @override
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields =>
      _idToDefaultConstructorFields;
}

///
class MatcherGeneratorSpecification {
  ///
  MatcherGeneratorSpecification(this.specification, this.secondaryType);

  ///
  final MatchSpecification specification;

  ///
  final DartType? secondaryType;
}
