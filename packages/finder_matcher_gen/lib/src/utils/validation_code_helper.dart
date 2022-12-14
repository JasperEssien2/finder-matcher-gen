import 'package:analyzer/dart/constant/value.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';

/// Writes the code that validates if widget matches pattern
String getMatcherConditionCodeFromExtract(
  DeclarationExtract extract, {
  bool last = false,
  required int declarationCount,
}) {
  final validateCodeBuffer = StringBuffer()..writeln('if(');

  final extractValue = extract.defaultValue ??
      getConstructorNameInPlaceOfDefaultValue(extract, isPrivate: true);

  writeValidation(
    validateCodeBuffer: validateCodeBuffer,
    extract: extract,
    equals: '''$extractValue''',
  );

  validateCodeBuffer
    ..writeln('expectedDeclarationCount++;')
    ..writeln('} else {')
    ..writeln(
      '''matchState['${extractCode(extract)}-expected'] = ${extract.defaultValue == null ? '$extractValue' : '${extract.defaultValue}'};\n''',
    )
    ..writeln('''if(matchState['${extractCode(extract)}-found'] == null) {''')
    ..writeln('''matchState['${extractCode(extract)}-found'] = <dynamic>{};''')
    ..writeln('}\n')
    ..writeln(
      '''matchState['${extractCode(extract)}-found'].add(${extractCode(extract)});''',
    )
    ..writeln('}\n');

  if (last) {
    validateCodeBuffer
      ..writeln('if(expectedDeclarationCount == $declarationCount){')
      ..writeln(' matchedCount++;')
      ..writeln('}\n');
  }
  return validateCodeBuffer.toString();
}

///
void writeValidation({
  required StringBuffer validateCodeBuffer,
  required DeclarationExtract extract,
  required String equals,
  bool closeWithCurlyBrace = true,
}) {
  final close = closeWithCurlyBrace ? '){' : '';

  if (extract.fieldEquality != null) {
    validateCodeBuffer
        .write('${collectionEqualityCode(extract, equals)}$close');
  } else {
    validateCodeBuffer.write(
      '${extractCode(extract)} == $equals$close',
    );
  }
}

/// Returns the equivalent check for for collection data types.
///
/// Using `==` for collection data types gives incorrect result. This method
/// addressed it.
///
/// Example: [List] data type returns a `listEquals(a, b)`
String collectionEqualityCode(DeclarationExtract extract, String equals) {
  switch (extract.fieldEquality!) {
    case FieldEquality.map:
      return 'mapEquals(${extractCode(extract)}, $equals)';
    case FieldEquality.list:
      return 'listEquals(${extractCode(extract)}, $equals)';
    case FieldEquality.set:
      return 'setEquals(${extractCode(extract)}, $equals)';
  }
}

///
String extractCode(DeclarationExtract extract) =>
    'widget.${extract.name}${extract.isMethod ? '()' : ''}';

/// Gets the field actual value from a [DartObject]
///
/// Returns null when the field type is not supported
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

  return null;
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
