// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:equatable/equatable.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';

/// A class that contains elements extracted from annotated widget classes.
class ClassElementExtract extends Equatable {
  ///Constructor of [ClassElementExtract]
  ///
  ///[className]: The string name of the class
  ///
  ///[classUri]: The Uri of library housing this class
  ///
  ///[genericParam]: A string format of this class generic if any(E.g: <R, T>)
  ///
  ///[declarations]: A list of getters, methods, and fields that os annotated
  ///with @MatchDeclaration
  ///
  ///[constructorFields]: A set of fields to initialise in the generated class
  ///constructor
  ///
  ///[imports]: A set of imports that this class depends on, typically fields
  /// with data type defined in a different library
  const ClassElementExtract({
    this.className,
    this.classUri,
    this.declarations,
    this.genericParam = '',
    this.constructorFields,
    this.imports,
    this.id,
  });

  /// Widget class name
  final String? className;

  /// Uri of library housing this class
  final Uri? classUri;

  /// A string format of this class generic if any(E.g: <R, T>)
  final String genericParam;

  /// A list of getters, methods, and fields that os annotated with
  /// @MatchDeclaration
  final List<DeclarationExtract>? declarations;

  /// A set of fields to initialise in the generated class constructor
  final Set<ConstructorFieldModel>? constructorFields;

  /// A set of imports that this class depends on, typically fields
  /// with data type defined in a different library
  final Set<String>? imports;

  /// A unique id attached to this [ClassElementExtract]
  final String? id;

  /// Returns this class name prefixed with '_'
  String? get generatedClassName => className == null ? null : '_$className';

  ClassElementExtract copyWith({
    String? className,
    Uri? classUri,
    String? genericParam,
    List<DeclarationExtract>? declarations,
    Set<ConstructorFieldModel>? constructorFields,
    Set<String>? imports,
    String? id,
  }) {
    return ClassElementExtract(
      className: className ?? this.className,
      classUri: classUri ?? this.classUri,
      genericParam: genericParam ?? this.genericParam,
      declarations: declarations ?? this.declarations,
      constructorFields: constructorFields ?? this.constructorFields,
      imports: imports ?? this.imports,
      id: id ?? this.id,
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

  /// Adds a [fieldModel] to the set of [ConstructorFieldModel]
  ClassElementExtract copyWithConstructorField({
    required ConstructorFieldModel fieldModel,
  }) {
    final fieldList = (constructorFields ?? {})..add(fieldModel);

    return copyWith(constructorFields: fieldList);
  }

  /// Adds all [fieldModels] to the set of [ConstructorFieldModel]
  ClassElementExtract copyWithConstructorFields({
    required Set<ConstructorFieldModel> fieldModels,
  }) {
    final fieldList = (constructorFields ?? {})..addAll(fieldModels);

    return copyWith(constructorFields: fieldList);
  }

  /// Adds a [import] to the set of [imports]
  ClassElementExtract copyWithImport({
    required String import,
  }) {
    final importList = (imports ?? {})..add(import);

    return copyWith(imports: importList);
  }

  @override
  String toString() {
    return '''ClassElementExtract(className: $className, classUri: $classUri, isGeneric: $genericParam methods: $declarations, constructorFields: $constructorFields, imports: $imports, key: $id)''';
  }

  @override
  List<Object?> get props => [
        className,
        classUri,
        genericParam,
        declarations,
        constructorFields,
        imports,
        id,
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
