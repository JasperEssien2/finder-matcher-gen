// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class ClassElementExtract {
  ClassElementExtract({
    this.className,
    this.classUri,
    this.fields,
  });

  final String? className;
  final Uri? classUri;

  final List<FieldMethodExtract>? fields;

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    List<FieldMethodExtract>? fields,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      fields: fields ?? this.fields,
    );
  }

  ClassElementExtract addFieldOrMethodExtract({
    required FieldMethodExtract extract,
  }) {
    final newFields = (fields ?? [])..add(extract);

    return copyWith(
      fields: fields ?? newFields,
    );
  }

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, methods: $fields)''';
  }
}

abstract class NameTypeExtract {
  NameTypeExtract({this.name, this.type});

  final String? name;
  final DartType? type;

  @override
  String toString() => 'NameTypeExtract(name: $name, type: $type)';
}

class FieldMethodExtract extends NameTypeExtract {
  FieldMethodExtract({
    super.name,
    super.type,
    required this.isMethod,
    this.parameters,
  });

  final List<ParameterElement>? parameters;
  final bool isMethod;

  FieldMethodExtract copyWith({
    String? name,
    DartType? type,
    List<ParameterElement>? parameters,
    bool? isMethod,
  }) {
    return FieldMethodExtract(
      name: name ?? this.name,
      type: type ?? this.type,
      isMethod: isMethod ?? this.isMethod,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  String toString() =>
      'FieldMethodExtract(parameters: $parameters, isMethod: $isMethod)';
}
