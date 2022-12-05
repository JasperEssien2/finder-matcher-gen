// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class ClassElementExtract {
  ClassElementExtract({
    this.className,
    this.classUri,
    this.declarations,
    this.constructorFields,
  });

  final String? className;
  final Uri? classUri;

  final List<DeclarationExtract>? declarations;
  final List<ConstructorFieldExtract>? constructorFields;

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    List<DeclarationExtract>? declarations,
    List<ConstructorFieldExtract>? constructorFields,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      declarations: declarations ?? this.declarations,
      constructorFields: constructorFields ?? this.constructorFields,
    );
  }

  ClassElementExtract addFieldOrMethodExtract({
    required DeclarationExtract extract,
  }) {
    final newDeclarations = (declarations ?? [])..add(extract);

    return copyWith(
      declarations: declarations ?? newDeclarations,
    );
  }

  ClassElementExtract addConstructorFieldExtract({
    required ConstructorFieldExtract extract,
  }) {
    final newConstructorFields = (constructorFields ?? [])..add(extract);

    return copyWith(
      constructorFields: constructorFields ?? newConstructorFields,
    );
  }

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, methods: $declarations)''';
  }
}

abstract class NameTypeExtract {
  NameTypeExtract({this.name, this.type});

  final String? name;
  final DartType? type;

  @override
  String toString() => 'NameTypeExtract(name: $name, type: $type)';
}

class DeclarationExtract extends NameTypeExtract {
  DeclarationExtract({
    super.name,
    super.type,
    required this.isMethod,
    this.parameters,
  });

  final List<ParameterElement>? parameters;
  final bool isMethod;

  DeclarationExtract copyWith({
    String? name,
    DartType? type,
    List<ParameterElement>? parameters,
    bool? isMethod,
  }) {
    return DeclarationExtract(
      name: name ?? this.name,
      type: type ?? this.type,
      isMethod: isMethod ?? this.isMethod,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  String toString() =>
      'DeclarationExtract(parameters: $parameters, isMethod: $isMethod)';
}

class ConstructorFieldExtract extends NameTypeExtract {
  ConstructorFieldExtract({super.name, super.type});

  ConstructorFieldExtract copyWith({
    String? name,
    DartType? type,
  }) {
    return ConstructorFieldExtract(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
