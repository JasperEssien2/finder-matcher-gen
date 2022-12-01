// ignore_for_file: type_annotate_public_apis

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/element_checker.dart';
import 'package:finder_matcher_generator/src/utils/extensions.dart';
import 'package:finder_matcher_generator/src/utils/finder_class_builder.dart';
import 'package:source_gen/source_gen.dart';

class FinderGenerator extends GeneratorForAnnotation<Match> {
  final _importsStringBuffer = StringBuffer();
  final _classesStringBuffer = StringBuffer();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final matchersObjects = annotation.read('finders').listValue;

    for (final matcher in matchersObjects) {
      final className = matcher.toTypeValue()!.dartTypeStr;

      final classLibraryElements = element.library!.importedLibraries
          .map((e) => e.getClass(className))
          .where((element) => element != null);

      ///Idealy you should only get one class element (widget) matching this
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
          writeFinderClassToBuffer(classVisitor.classExtract);
        } else {
          final classUri = classElement.librarySource.uri;

          writeImports(classUri: classUri);
          writeFinderClassToBuffer(
            ClassElementExtract(className: className, classUri: classUri),
          );
        }
      } else {
        writeFinderClassToBuffer(ClassElementExtract(className: className));
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

  void writeImports({Uri? classUri}) {
    if (_importsStringBuffer.isEmpty) {
      /// Write the neccessary imports first
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

  void writeFinderClassToBuffer(ClassElementExtract extract) {
    final finderGenerator = FinderClassBuilder(extract)
      ..writeClassHeader()
      ..writeConstructor()
      ..overrideMethods()
      ..closeClass();

    _classesStringBuffer
      ..write(finderGenerator.stringBuffer.toString())
      ..writeln('\n\n');
  }
}
