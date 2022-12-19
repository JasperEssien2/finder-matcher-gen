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
    this.genericParam = '',
    this.constructorFields,
    this.imports,
  });

  final String? className;
  final Uri? classUri;
  final String genericParam;
  final List<DeclarationExtract>? declarations;
  final Set<ConstructorFieldModel>? constructorFields;
  final Set<String>? imports;

  String? get generatedClassName => className == null ? null : '_$className';

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    String? genericParam,
    List<DeclarationExtract>? declarations,
    Set<ConstructorFieldModel>? constructorFields,
    Set<String>? imports,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      genericParam: genericParam ?? this.genericParam,
      declarations: declarations ?? this.declarations,
      constructorFields: constructorFields ?? this.constructorFields,
      imports: imports ?? this.imports,
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

  ClassElementExtract copyWithImport({
    required String import,
  }) {
    final importList = (imports ?? {})..add(import);

    return copyWith(imports: importList);
  }

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, isGeneric: $genericParam methods: $declarations, constructorFields: $constructorFields, imports: $imports)''';
  }

  @override
  List<Object?> get props => [
        className,
        classUri,
        genericParam,
        declarations,
        constructorFields,
        imports
      ];
}

class DeclarationExtract extends Equatable {
  const DeclarationExtract({
    this.name,
    this.type,
    required this.isMethod,
    this.parameters,
    this.defaultValue,
    this.fieldEquality,
  });

  final String? name;
  final DartType? type;
  final List<ParameterElement>? parameters;
  final bool isMethod;
  final dynamic defaultValue;
  final FieldEquality? fieldEquality;

  DeclarationExtract copyWith({
    String? name,
    DartType? type,
    List<ParameterElement>? parameters,
    bool? isMethod,
    DartObject? defaultValue,
    FieldEquality? fieldEquality,
  }) {
    return DeclarationExtract(
      name: name ?? this.name,
      type: type ?? this.type,
      isMethod: isMethod ?? this.isMethod,
      parameters: parameters ?? this.parameters,
      defaultValue: defaultValue ?? this.defaultValue,
      fieldEquality: fieldEquality ?? this.fieldEquality,
    );
  }

  @override
  String toString() =>
      '''DeclarationExtract(name: $name, parameters: $parameters, isMethod: $isMethod, defaultValue: $defaultValue, fieldEquality: $fieldEquality)''';

  @override
  List<Object?> get props =>
      [name, type, parameters, isMethod, defaultValue, fieldEquality];
}

enum FieldEquality {
  map,
  list,
  set,
}
