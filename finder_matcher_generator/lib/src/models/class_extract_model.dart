// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class ClassElementExtract {
  ClassElementExtract({
    this.className,
    this.classUri,
    this.fields,
    this.methods,
  });

  final String? className;
  final Uri? classUri;
  final List<FieldExtract>? fields;
  final List<MethodExtract>? methods;

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    List<FieldExtract>? fields,
    List<MethodExtract>? methods,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      fields: fields ?? this.fields,
      methods: methods ?? this.methods,
    );
  }

  ClassElementExtract addMethodExtract({
    required MethodExtract methodExtract,
  }) {
    final methodsNew = (methods ?? [])..add(methodExtract);

    return copyWith(
      methods: methods ?? methodsNew,
    );
  }

  ClassElementExtract addFieldExtract({
    required FieldExtract fieldExtract,
  }) {
    final fieldsNew = (fields ?? [])..add(fieldExtract);

    return copyWith(
      fields: fields ?? fieldsNew,
    );
  }

  @override
  String toString() {
    return 'ClassElementExtract(className: $className, classUri: $classUri, fields: $fields, methods: $methods)';
  }
}

abstract class NameTypeExtract {
  NameTypeExtract({this.name, this.type});

  final String? name;
  final DartType? type;

  @override
  String toString() => 'NameTypeExtract(name: $name, type: $type)';
}

class FieldExtract extends NameTypeExtract {
  FieldExtract({super.name, super.type});

  FieldExtract copyWith({
    String? name,
    DartType? type,
  }) {
    return FieldExtract(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}

class MethodExtract extends NameTypeExtract {
  MethodExtract({super.name, super.type, this.parameters});

  final List<ParameterElement>? parameters;

  MethodExtract copyWith({
    String? name,
    DartType? type,
    List<ParameterElement>? parameters,
  }) {
    return MethodExtract(
      name: name ?? this.name,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  String toString() => 'MethodExtract(parameters: $parameters)';
}
