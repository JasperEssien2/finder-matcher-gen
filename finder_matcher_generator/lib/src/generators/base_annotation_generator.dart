// ignore_for_file: type_annotate_public_apis

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/utils_export.dart';
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
///
///
abstract class BaseAnnotaionGenerator extends GeneratorForAnnotation<Match> {
  final _importsStringBuffer = StringBuffer();
  final _classesStringBuffer = StringBuffer();

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

        if (elements.hasAtleastOneMatchFieldAnnotation) {
          final classVisitor = ClassVisitor();

          classElement.visitChildren(classVisitor);

          writeImports(classUri: classVisitor.classExtract.classUri);
          writeClassToBuffer(classVisitor.classExtract, _classesStringBuffer);
        } else {
          final classUri = classElement.librarySource.uri;

          writeImports(classUri: classUri);
          writeClassToBuffer(
            ClassElementExtract(className: className, classUri: classUri),
            _classesStringBuffer,
          );
        }
      } else {
        writeClassToBuffer(
          ClassElementExtract(className: className),
          _classesStringBuffer,
        );
      }
    }

    // return (importsStringBuffer
    //       ..write('\n')
    //       ..writeln(classesStringBuffer.toString()))
    //     .toString();

    return '''
      ${_importsStringBuffer
          ..write('\n')
          ..writeln(_classesStringBuffer.toString())}
  ''';
  }

  /// A getter specifying the annotation field name to generate for
  List<DartObject> generateFor(ConstantReader annotation);

  /// Responsible for writing the required imports for the generated class
  void writeImports({Uri? classUri}) {
    if (_importsStringBuffer.isEmpty) {
      /// Write the Flutter imports first
      _importsStringBuffer
        ..writeln("import 'package:flutter/material.dart';")
        ..writeln("import 'package:flutter_test/flutter_test.dart';");
    }
    if (classUri == null) return;
    final uriImport = "import '${classUri.toString()}';";

    if (!_importsStringBuffer.toString().split('\n').contains(uriImport)) {
      _importsStringBuffer.writeln('$uriImport\n\n');
    }
  }

  /// Implement this method to write class code to the [StringBuffer]
  ///
  /// The [ClassElementExtract] contains all the class information extracted
  ///  from [ClassElement].
  ///
  /// The [StringBuffer] is where you write the code to
  void writeClassToBuffer(
    ClassElementExtract extract,
    StringBuffer classStringBuffer,
  );
}
