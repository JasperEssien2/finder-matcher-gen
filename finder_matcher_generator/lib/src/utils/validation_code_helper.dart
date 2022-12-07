import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:source_gen/source_gen.dart';

/// Writes the code that validates if widget matches pattern
String getValidationCodeFromExtract(
  DeclarationExtract extract, {
  bool first = false,
  String? writeFirstKeyword,
}) {
  final validateCodeBuffer = StringBuffer();

  if (first) {
    validateCodeBuffer.write(
      writeFirstKeyword ?? 'return ',
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
  DeclarationExtract extract,
  StringBuffer validateCodeBuffer, {
  bool appendAnd = true,
}) {
  if (appendAnd) {
    validateCodeBuffer.write('&& ');
  }

  _writeValidation(
    validateCodeBuffer: validateCodeBuffer,
    extract: extract,
    equals:
        '''== ${extract.defaultValue ?? getDefaultValueForDartType(extract.type!)}''',
  );
}

void _writeValidation({
  required StringBuffer validateCodeBuffer,
  required DeclarationExtract extract,
  required String equals,
}) {
  validateCodeBuffer.write(
    'widget.${extract.name}${extract.isMethod ? '()' : ''} $equals',
  );
}

/// Returns a default value based on the [DartType]
String getDefaultValueForDartType(DartType type) {
  if (type.isDartCoreNum || type.isDartCoreInt) {
    return '0';
  } else if (type.isDartCoreDouble) {
    return '0.0';
  } else if (type.isDartCoreList) {
    return '[]';
  } else if (type.isDartCoreMap) {
    return '{}';
  } else if (type.isDartCoreString) {
    return "''";
  }
  throw InvalidGenerationSourceError('Unsupported type: $type');
}

/// Gets the field actual value from a [DartObject]
///
/// Throws an Unsupported exception when the field type is not supported
dynamic getDartObjectValue(DartObject dartObject) {
  final type = dartObject.type!;

  if (type.isDartCoreInt) {
    return dartObject.toIntValue();
  } else if (type.isDartCoreDouble) {
    return dartObject.toDoubleValue();
  } else if (type.isDartCoreList) {
    return dartObject.toListValue();
  } else if (type.isDartCoreMap) {
    return dartObject.toMapValue();
  } else if (type.isDartCoreString) {
    return "'${dartObject.toStringValue()}'";
  }

  throw InvalidGenerationSourceError('Unsupported type: $type');
}
