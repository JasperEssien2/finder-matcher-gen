import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:source_gen/source_gen.dart';

/// Writes the code that validates if widget matches pattern
String getConditionCodeFromExtract(
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
        '''== ${extract.defaultValue ?? getConstructorNameInPlaceOfDefaultValue(extract, isPrivate: true)}''',
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

/// When [DeclarationExtract] defaultValue is null, a constructor field will be
/// generated to use for validation.
///
/// Returns the name of the constructor, if [isPrivate] set to true,
/// an undersccore would be appended to the generated field
String getConstructorNameInPlaceOfDefaultValue(
  DeclarationExtract extract, {
  bool isPrivate = false,
}) {
  return "${isPrivate ? '_' : ''}${extract.name}Value";
}
