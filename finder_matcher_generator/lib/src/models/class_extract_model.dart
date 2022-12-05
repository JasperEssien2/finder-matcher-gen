// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:equatable/equatable.dart';

class ClassElementExtract extends Equatable {
  const ClassElementExtract({
    this.className,
    this.classUri,
    this.declarations,
  });

  final String? className;
  final Uri? classUri;

  final List<DeclarationExtract>? declarations;

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    List<DeclarationExtract>? declarations,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      declarations: declarations ?? this.declarations,
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

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, methods: $declarations)''';
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
  });

  final String? name;
  final DartType? type;
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

  @override
  List<Object?> get props => [name, type, parameters, isMethod];
}
