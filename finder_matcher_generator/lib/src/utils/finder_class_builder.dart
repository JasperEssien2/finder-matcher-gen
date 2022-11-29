import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/override_method_model.dart';
import 'package:finder_matcher_generator/src/utils/base_class_code_builder.dart';

class FinderClassBuilder extends ClassCodeBuilder {
  FinderClassBuilder(super.classExtract);

  @override
  void writeImport() {
    stringBuffer
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:flutter_test/flutter_test.dart';");
    super.writeImport();
  }

  @override
  List<OverrideMethodModel> get methodsToOverride => [
        OverrideMethodModel(
          name: 'description',
          returnType: 'String',
          methodType: OverrideMethodType.getter,
          writeMethodCode: (buffer) => buffer.write(
            'custom widget is ${classExtract.className}',
          ),
        ),
        OverrideMethodModel(
          name: 'matches',
          returnType: 'bool',
          paramTypeAndName: {
            'Element': 'candidiate',
          },
          methodType: OverrideMethodType.method,
          writeMethodCode: (codeBuffer) => writeMatchesMethodContent(
            codeBuffer,
            'candidiate',
            classExtract.methods ?? [],
          ),
        ),
      ];

  void writeMatchesMethodContent(
    StringBuffer codeBuffer,
    String overridenMethodParamName,
    List<MethodExtract> extracts,
  ) {
    final newExtracts = List<MethodExtract>.from(extracts);

    if (newExtracts.isEmpty) {
      codeBuffer
        ..write(';')
        ..writeln('}')
        ..writeln('return false;')
        ..writeln('}');
      return;
    }

    if (classExtract.methods?.isEmpty ?? true) {
      codeBuffer.writeln(
        'return $overridenMethodParamName.widget is ${classExtract.className}',
      );
    } else if (_isFirstCheckWrite(extracts)) {
      codeBuffer
        ..writeln(
          'if ($overridenMethodParamName.widget is ${classExtract.className}) {',
        )
        ..writeln(
          'final widget = $overridenMethodParamName.widget as ${classExtract.className};',
        )
        ..writeln(getValidationCodeFromExtract(extracts.first, first: true));
    } else {
      final methodExtract = newExtracts.removeAt(0);
      codeBuffer.write(getValidationCodeFromExtract(methodExtract));
    }

    /// Recursively write method check, pop method extract in the process
    writeMatchesMethodContent(
      codeBuffer,
      overridenMethodParamName,
      newExtracts,
    );
  }

  bool _isFirstCheckWrite(List<MethodExtract> extracts) {
    return classExtract.methods!.isNotEmpty &&
        classExtract.methods!.length == extracts.length;
  }

  String getValidationCodeFromExtract(
    MethodExtract extract, {
    bool first = false,
  }) {
    final validateCodeBuffer = StringBuffer();

    if (first) {
      validateCodeBuffer.write(
        'return ',
      );

      _codeFromDartType(
        extract,
        validateCodeBuffer,
        appendAnd: false,
      );
    } else {
      _codeFromDartType(extract, validateCodeBuffer);
    }
    return validateCodeBuffer.toString();
  }

  void _codeFromDartType(
    MethodExtract extract,
    StringBuffer validateCodeBuffer, {
    bool appendAnd = true,
  }) {
    if (appendAnd) {
      validateCodeBuffer.write('&& ');
    }
    if (extract.type!.isDartCoreBool) {
      validateCodeBuffer.write('widget.${extract.name}');
    } else if (extract.type!.isDartCoreNum) {
      validateCodeBuffer.write('widget.${extract.name} == 0');
    } else if (extract.type!.isDartCoreString) {
      validateCodeBuffer.write("widget.${extract.name} == '");
    }
  }

  @override
  String get suffix => 'MatchFinder';
}
