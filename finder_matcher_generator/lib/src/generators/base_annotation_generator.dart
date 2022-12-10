// ignore_for_file: type_annotate_public_apis

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/constructor_field_model.dart';
import 'package:finder_matcher_generator/src/utils/utils_export.dart';
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
abstract class BaseAnnotaionGenerator extends GeneratorForAnnotation<Match> {
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

    for (final matcher in matchersObjects) {
      final className = matcher.toTypeValue()!.dartTypeStr;

      final classLibraryElements = element.library!.importedLibraries
          .map((e) => e.getClass(className))
          .where((element) => element != null);

      ///Ideally you should only get one class element (widget) matching this
      ///class name from any of the imported library
      if (classLibraryElements.isNotEmpty) {
        if (classLibraryElements.length > 1) {
          throwException(
            'Found multiple classes with name $className. '
            'Consider changing the name of one class to avoid name conflict',
            element: element,
          );
        }
        final classElement = classLibraryElements.first;

        checkBadTypeByClassElement(classElement!);

        final elements = List<Element>.from([])
          ..addAll(classElement.fields)
          ..addAll(classElement.methods);

        if (elements.hasAtleastOneMatchDeclarationAnnotation) {
          _buildClassWithDeclarationValidation(classElement);
        } else {
          _buildClassWithTypeValidation(classElement, className);
        }
      } else {
        writeClassToBuffer(
          ClassElementExtract(className: className),
          _classesStringBuffer,
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

  void _buildClassWithDeclarationValidation(ClassElement classElement) {
    final classVisitor = ClassVisitor();

    classElement.visitChildren(classVisitor);

    final classExtract = classVisitor.classExtract.copyWithConstructorFields(
      fieldModels:
          defaultConstructorFields[classVisitor.classExtract.className] ?? {},
    );

    writeImports(
      _importsStringBuffer,
      classUri: classVisitor.classExtract.classUri,
    );
    writeClassToBuffer(classExtract, _classesStringBuffer);
  }

  void _buildClassWithTypeValidation(
    ClassElement classElement,
    String className,
  ) {
    final classUri = classElement.librarySource.uri;

    writeImports(_importsStringBuffer, classUri: classUri);

    final extract = ClassElementExtract(
      className: className,
      classUri: classUri,
      constructorFields: defaultConstructorFields[className],
    );

    writeClassToBuffer(extract, _classesStringBuffer);
  }

  /// A getter specifying the annotation field name to generate for
  List<DartObject> generateFor(ConstantReader annotation);

  /// Responsible for writing the required imports for the generated class
  @mustCallSuper
  void writeImports(StringBuffer importBuffer, {Uri? classUri}) {
    if (_importsStringBuffer.isEmpty) {
      /// Write the Flutter imports first
      _importsStringBuffer
        ..writeln("import 'package:flutter/material.dart';")
        ..writeln("import 'package:flutter_test/flutter_test.dart';");
    }
    if (classUri == null) return;
    final uriImport = "import '${classUri.toString()}';";

    if (doesNotContainImport(uriImport)) {
      _importsStringBuffer.writeln('$uriImport\n\n');
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
    final generatedClassName = '${extract.generatedClassName}$suffix';

    final constructorFields = extract.constructorFields ?? {};

    if (constructorFields.isNotEmpty) {
      _globalVariablesStringBuffer
        ..write('${prefix(extract)}${extract.className}({')
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
  String get suffix;
}
