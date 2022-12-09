// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:equatable/equatable.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';

class ClassElementExtract extends Equatable {
  const ClassElementExtract({
    this.className,
    this.classUri,
    this.declarations,
    this.constructorFields,
  });

  final String? className;
  final Uri? classUri;

  final List<DeclarationExtract>? declarations;
  final Set<ConstructorFieldModel>? constructorFields;

  String? get generatedClassName => className == null ? null : '_$className';

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    List<DeclarationExtract>? declarations,
    Set<ConstructorFieldModel>? constructorFields,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      declarations: declarations ?? this.declarations,
      constructorFields: constructorFields ?? this.constructorFields,
    );
  }

  ClassElementExtract copyWithDeclarationExtract({
    required DeclarationExtract extract,
  }) {
    final newDeclarations = (declarations ?? [])..add(extract);

    return copyWith(
      declarations: newDeclarations,
    );
  }

  ClassElementExtract copyWithConstructorField({
    required ConstructorFieldModel fieldModel,
  }) {
    final fieldList = (constructorFields ?? {})..add(fieldModel);

    return copyWith(constructorFields: fieldList);
  }

  ClassElementExtract copyWithConstructorFields({
    required Set<ConstructorFieldModel> fieldModels,
  }) {
    final fieldList = (constructorFields ?? {})..addAll(fieldModels);

    return copyWith(constructorFields: fieldList);
  }

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, methods: $declarations, constructorFields: $constructorFields)''';
  }

  @override
  List<Object?> get props => [className, classUri, declarations];
}

class DeclarationExtract extends Equatable {
  const DeclarationExtract({
    this.name,
    this.type,
    required this.isMethod,
    this.parameters,
    this.defaultValue,
  });

  final String? name;
  final DartType? type;
  final List<ParameterElement>? parameters;
  final bool isMethod;
  final dynamic defaultValue;

  DeclarationExtract copyWith({
    String? name,
    DartType? type,
    List<ParameterElement>? parameters,
    bool? isMethod,
    DartObject? defaultValue,
  }) {
    return DeclarationExtract(
      name: name ?? this.name,
      type: type ?? this.type,
      isMethod: isMethod ?? this.isMethod,
      parameters: parameters ?? this.parameters,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  @override
  String toString() =>
      '''DeclarationExtract(name: $name, parameters: $parameters, isMethod: $isMethod, defaultValue: $defaultValue)''';

  @override
  List<Object?> get props => [name, type, parameters, isMethod, defaultValue];
}
