import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'model.dart';

extension ElementAnnotationExt on ElementAnnotation {
  bool get isMatchDeclaration {
    return this is PropertyAccessorElement &&
        element!.name == 'MatchDeclaration';
    //  && element.library.name == libraryName;
  }
}

/// An extension of [Element]
extension ElementExt on Element {
  /// Returns a list of annotated declaration object
  Iterable<DartObject> get getAnnotationObjects {
    const checker = TypeChecker.fromRuntime(MatchDeclaration);

    return checker.annotationsOf(this);
  }

  bool get isMatchDeclaration => const TypeChecker.fromRuntime(MatchDeclaration)
      .hasAnnotationOf(this, throwOnUnresolved: false);

  String? get declarationType {
    if (kind == ElementKind.GETTER || kind == ElementKind.METHOD) {
      return (this as MethodElement).returnType.toString();
    } else if (kind == ElementKind.FIELD) {
      return (this as FieldElement).type.toString();
    }
    return null;
  }

  AnnotationDefaultValueCheckModel get checkAnnotationDefaultValue {
    final annotationObjects = getAnnotationObjects;

    var correctType = true;

    final defaultValueObject = annotationObjects.isEmpty
        ? null
        : annotationObjects.first.getField('_defaultValue');

    if (defaultValueObject == null) {
      correctType = true;
    } else {
      if (defaultValueObject.isNull) {
        correctType = true;
      } else {
        correctType = defaultValueObject.type!.dartTypeStr == declarationType;
      }
    }

    return AnnotationDefaultValueCheckModel(
      correctType: correctType,
      expected: declarationType,
      given: defaultValueObject?.type!.dartTypeStr,
      defaultValue: getDartObjectStringValue(defaultValueObject),
    );
  }
}

String getDartObjectStringValue(DartObject? dartObject) {
  if (dartObject == null) return 'null';

  final type = dartObject.type!;

  if (type.isDartCoreInt) {
    return dartObject.toIntValue().toString();
  } else if (type.isDartCoreDouble) {
    return dartObject.toDoubleValue().toString();
  } else if (type.isDartCoreList) {
    return dartObject.toListValue().toString();
  } else if (type.isDartCoreMap) {
    return dartObject.toMapValue().toString();
  } else if (type.isDartCoreString) {
    return "'${dartObject.toStringValue()}'";
  }

  return 'null';
}

/// An extension of [DartType]
extension DartTypeExt on DartType {
  /// Replaces all asterisks from the [DartType] string
  String get dartTypeStr => toString().replaceAll('*', '');
}
