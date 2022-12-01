import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/override_method_model.dart';
import 'package:finder_matcher_generator/src/utils/base_class_code_builder.dart';

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
          methodType: OverrideMethodType.getter,
          writeMethodCode: (buffer) => buffer.write(
            "'Finds ${classExtract.className} widget';\n",
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

  /// Writes the code that validates if widget matches pattern
  String getValidationCodeFromExtract(
    FieldMethodExtract extract, {
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
    FieldMethodExtract extract,
    StringBuffer validateCodeBuffer, {
    bool appendAnd = true,
  }) {
    if (appendAnd) {
      validateCodeBuffer.write('&& ');
    }

    var equals = '';
    final extractType = extract.type!;

    //TODO: HANDLE OTHER TYPES
    if (extract.type!.isDartCoreBool) {
      //DO nothing
    } else if (extractType.isDartCoreNum || extractType.isDartCoreInt) {
      equals = '== 0';
    } else if (extractType.isDartCoreDouble) {
      equals = '== 0.0';
    } else if (extractType.isDartCoreList) {
      equals = '== []';
    } else if (extractType.isDartCoreMap) {
      equals = '== {}';
    } else if (extractType.isDartCoreString) {
      equals = "== ''";
    }

    _writeValidation(
      validateCodeBuffer: validateCodeBuffer,
      extract: extract,
      equals: equals,
    );
  }

  void _writeValidation({
    required StringBuffer validateCodeBuffer,
    required FieldMethodExtract extract,
    required String equals,
  }) {
    validateCodeBuffer.write(
      'widget.${extract.name}${extract.isMethod ? '()' : ''} $equals',
    );
  }

  @override
  String get suffix => 'MatchFinder';
}
