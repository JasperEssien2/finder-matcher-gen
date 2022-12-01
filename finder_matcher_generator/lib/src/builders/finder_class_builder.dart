import 'package:finder_matcher_generator/src/builders/base_class_code_builder.dart';
import 'package:finder_matcher_generator/src/models/models_export.dart';
import 'package:finder_matcher_generator/src/utils/validation_code_helper.dart';

/// Builds a Finder class. Extends [ClassCodeBuilder] class
class FinderClassBuilder extends ClassCodeBuilder {
  /// [FinderClassBuilder] uses the information gotten from
  /// [ClassElementExtract] to write the Finder class
  FinderClassBuilder(super.classExtract);

  @override
  List<OverrideMethodModel> get methodsToOverride => [
        OverrideMethodModel(
          name: 'description',
          returnType: 'String',
          methodCategory: MethodCategory.getter,
          methodCodeBuilder: (buffer) => buffer.write(
            "'Finds ${classExtract.className} widget';\n",
          ),
        ),
        OverrideMethodModel(
          name: 'matches',
          returnType: 'bool',
          paramTypeAndName: {
            'Element': 'candidiate',
          },
          methodCategory: MethodCategory.method,
          methodCodeBuilder: (codeBuffer) => writeMatchesMethodContent(
            codeBuffer,
            'candidiate',
            classExtract.fields ?? [],
          ),
        ),
      ];

  /// A recursive function that writes the code content of MatchFinder `matches`
  /// method
  void writeMatchesMethodContent(
    StringBuffer codeBuffer,
    String overridenMethodParamName,
    List<FieldMethodExtract> extracts,
  ) {
    if (classExtract.fields?.isEmpty ?? true) {
      codeBuffer.writeln(
        'return $overridenMethodParamName.widget is ${classExtract.className};',
      );
      return;
    }

    final newExtracts = List<FieldMethodExtract>.from(extracts);

    if (newExtracts.isEmpty) {
      codeBuffer
        ..write(';')
        ..writeln('}')
        ..writeln('return false;');
      return;
    } else if (_isFirstCheckWrite(extracts)) {
      final methodExtract = newExtracts.removeAt(0);

      codeBuffer
        ..writeln(
          'if ($overridenMethodParamName.widget is ${classExtract.className}) {',
        )
        ..writeln(
          'final widget = $overridenMethodParamName.widget as ${classExtract.className};',
        )
        ..writeln(getValidationCodeFromExtract(methodExtract, first: true));
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

  bool _isFirstCheckWrite(List<FieldMethodExtract> extracts) {
    return classExtract.fields!.isNotEmpty &&
        classExtract.fields!.length == extracts.length;
  }


  @override
  String get suffix => 'MatchFinder';
}
