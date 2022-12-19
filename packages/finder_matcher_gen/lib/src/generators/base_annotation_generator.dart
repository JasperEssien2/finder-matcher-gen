// ignore_for_file: type_annotate_public_apis

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/class_visitor.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// Extends this class to create a generate a class code that conforms to
/// the [Match] annoation specifications.
///
/// It's superclass [GeneratorForAnnotation] invokes
/// [generateForAnnotatedElement] for every top level element in the source file
/// annotated with [Match].
///
/// It depends on [ClassVisitor] which visit classes specified via the match
/// annotation, performs checks and extract neccessary information need to
/// generate a class code.
abstract class BaseAnnotationGenerator extends GeneratorForAnnotation<Match> {
  final _importsStringBuffer = StringBuffer();
  final _globalVariablesStringBuffer = StringBuffer();
  final _classesStringBuffer = StringBuffer();

  /// Default constructor fields are fields that is needed by the generated
  /// Finder or Matcher. For instance, to generate a Matcher with specification
  /// `matchNWidget`, this will mean that a variable `n` will need to be
  /// generated in the constructor.
  ///
  /// [defaultConstructorFields] is map that maps a `className` to
  /// [Set<ConstructorFieldModel>], where [ConstructorFieldModel] is a data
  /// class containing
  Map<String, Set<ConstructorFieldModel>> get defaultConstructorFields;

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final matchersObjects = generateFor(annotation);

    for (final object in matchersObjects) {
      final type = object.dartObject.toTypeValue()!;

      assert(
        type.element != null && type.element is ClassElement,
        'Element should be a class',
      );

      final classElement = type.element! as ClassElement;

      final generic = classElement.thisType.typeGenericParamStr;

      final className = classElement.thisType.dartTypeStr;

      checkBadTypeByClassElement(classElement);

      final elements = List<Element>.from([])
        ..addAll(classElement.fields)
        ..addAll(classElement.methods)
        ..addAll(classElement.accessors);

      if (elements.hasAtleastOneMatchDeclarationAnnotation) {
        _buildClassWithDeclarationValidation(classElement, generic, object.id);
      } else {
        _buildClassWithTypeValidation(
          classElement,
          className,
          generic,
          object.id,
        );
      }
    }

    _importsStringBuffer
      ..writeln('\n')
      ..writeln(_globalVariablesStringBuffer.toString())
      ..writeln('\n')
      ..writeln(_classesStringBuffer.toString());

    return _importsStringBuffer.toString();
  }

  void _buildClassWithDeclarationValidation(
    ClassElement classElement,
    String? genericParam,
    String? id,
  ) {
    final classVisitor = ClassVisitor();

    classElement.visitChildren(classVisitor);

    final classExtract = classVisitor.classExtract
        .copyWithConstructorFields(
          fieldModels:
              defaultConstructorFields[classVisitor.classExtract.className] ??
                  {},
        )
        .copyWith(genericParam: genericParam, id: id);

    writeImports(
      _importsStringBuffer,
      classExtract: classVisitor.classExtract,
    );
    writeClassToBuffer(classExtract, _classesStringBuffer);
  }

  void _buildClassWithTypeValidation(
    ClassElement classElement,
    String className,
    String? genericParams,
    String? id,
  ) {
    final classUri = classElement.librarySource.uri;
    final extract = ClassElementExtract(
      className: className,
      classUri: classUri,
      constructorFields: defaultConstructorFields[className],
      genericParam: genericParams ?? '',
      id: id,
    );

    writeImports(_importsStringBuffer, classExtract: extract);

    writeClassToBuffer(extract, _classesStringBuffer);
  }

  /// Returns a list of [DartObject] to generate Matcher or Finder
  List<WidgetDartObject> generateFor(ConstantReader annotation);

  /// Responsible for writing the required imports for the generated class
  @mustCallSuper
  void writeImports(
    StringBuffer importBuffer, {
    required ClassElementExtract classExtract,
  }) {
    if (_importsStringBuffer.isEmpty) {
      /// Write the Flutter imports first
      _importsStringBuffer
        ..writeln("import 'package:flutter/material.dart';")
        ..writeln("import 'package:flutter_test/flutter_test.dart';");
    }
    if (classExtract.classUri == null) return;
    final uriImport = "import '${classExtract.classUri.toString()}';";

    if (doesNotContainImport(uriImport)) {
      _importsStringBuffer.writeln('$uriImport\n\n');
    }

    if (_requiresFoundation(classExtract)) {
      _writeImport("import 'package:flutter/foundation.dart';");
    }

    for (final import in classExtract.imports ?? {}) {
      _writeImport("import '$import';");
    }
  }

  bool _requiresFoundation(ClassElementExtract classExtract) {
    return classExtract.declarations
            ?.where((element) => element.fieldEquality != null)
            .isNotEmpty ??
        false;
  }

  void _writeImport(String import) {
    if (doesNotContainImport(import)) {
      _importsStringBuffer.writeln(import);
    }
  }

  /// Return true if [importToWrite] does not exist in import string buffer
  /// Returns false otherwise
  bool doesNotContainImport(String importToWrite) =>
      !_importsStringBuffer.toString().split('\n').contains(importToWrite);

  /// Implement this method to write class code to the [StringBuffer]
  ///
  /// The [ClassElementExtract] contains all the class information extracted
  ///  from [ClassElement].
  ///
  /// The [StringBuffer] is where you write the code to

  @mustCallSuper
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  ) {
    writeGlobalVariables(extract);
  }

  /// Writes global instantiation of generated classes
  void writeGlobalVariables(ClassElementExtract extract) {
    final generatedClassName =
        '''${extract.generatedClassName}${classSuffix(extract)}${extract.genericParam}''';

    final constructorFields = extract.constructorFields ?? {};

    if (constructorFields.isNotEmpty) {
      _globalVariablesStringBuffer
        ..write(
          '${prefix(extract)}${extract.className}${extract.genericParam}({',
        )
        ..write(
          constructorFields
              .map((e) => 'required ${e.type} ${e.name}')
              .toList()
              .join(', '),
        )
        ..write('}) => $generatedClassName(')
        ..write(
          constructorFields
              .map((e) => '${e.name}: ${e.name}')
              .toList()
              .join(', '),
        )
        ..write('); \n\n');
    } else {
      _globalVariablesStringBuffer.writeln(
        '''final ${prefix(extract)}${extract.className} = $generatedClassName(); \n''',
      );
    }
  }

  /// Used to prefix global variables names
  ///
  /// [ClassElementExtract] get neccessary class information
  String prefix(ClassElementExtract extract);

  /// A name that is appended to generated class
  String classSuffix(ClassElementExtract extract);
}

// ignore: public_member_api_docs
class WidgetDartObject {
  // ignore: public_member_api_docs
  WidgetDartObject({required this.dartObject, this.id});

  // ignore: public_member_api_docs
  final DartObject dartObject;

  // ignore: public_member_api_docs
  final String? id;
}
