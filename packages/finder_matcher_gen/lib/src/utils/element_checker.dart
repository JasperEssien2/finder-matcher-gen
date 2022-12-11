import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// Throws an exception when class element does not comform to generation
/// class specifications
void checkBadTypeByClassElement(
  ClassElement element, {
  String generateFor = 'Finders',
}) {
  if (element.isPrivate) {
    throwException(
      'Cannot generate $generateFor for private Widgets',
      element: element,
    );
  }

  final classSuperTypes = element.allSupertypes
      .map(
        (e) => e.getDisplayString(withNullability: false),
      )
      .toList();

  final hasWidgetSuperType = classSuperTypes.contains('Widget');

  if (!hasWidgetSuperType) {
    throwException(
      '''Unsupported class: Finders or Matchers can only be generated for widgets''',
      element: element,
    );
  }
}

/// Throws an exception when [MethodElement] does not conform to
/// method generation specification
void checkBadTypeByMethodElement(MethodElement element) {
  if (element.parameters.isNotEmpty) {
    throwException(
      'Unsupported: annotated method should have no parameter',
      element: element,
    );
  }
  checkElementNotPrivate(element);

  checkBadTypeByDartType(element.returnType, element: element);
}

/// Throws an exception when [FieldElement] type does not conform to
/// field generation specification
void checkBadTypeByFieldElement(FieldElement element) {
  checkElementNotPrivate(element);
  checkBadTypeByDartType(element.type, element: element);
}

/// Throws an exception when [Element] is private
void checkElementNotPrivate(Element element) {
  if (element.isPrivate) {
    throwException(
      'Unsupported access modifer: Cannot utilise a private entity',
      element: element,
    );
  }
}

/// Checks if the [DartType] is supported, else throws an unsupported exception
void checkBadTypeByDartType(DartType dartType, {required Element element}) {
  
  if (!_supportedDartType(dartType)) {
    throwException(
      'Unsupported return type: $dartType',
      element: element,
    );
  }
}

bool _supportedDartType(DartType dartType) =>
    dartType.isDartCoreDouble ||
    dartType.isDartCoreNum ||
    dartType.isDartCoreInt ||
    dartType.isDartCoreList ||
    dartType.isDartCoreBool ||
    dartType.isDartCoreMap ||
    dartType.isDartCoreSet ||
    dartType.element?.kind == ElementKind.TYPE_PARAMETER ||
    dartType.isDartCoreString;

/// Throws an exception if the [Element] provided is not a field, getter,
/// or method
void checkAnnotationsKind(Element element) {
  final kind = element.kind;

  if (_unsupportedAnnotationKind(kind)) {
    throwException(
      '''Unsupported entity annotated: Apply annotations to Fields, Methods, or Getters only''',
      element: element,
    );
  }
}

/// A reusuable function that throws an [InvalidGenerationSourceError] exception
void throwException(String message, {required Element? element}) {
  throw InvalidGenerationSourceError(
    message,
    element: element,
  );
}

bool _supportedAnnotationKind(ElementKind kind) =>
    kind == ElementKind.FIELD ||
    kind == ElementKind.GETTER ||
    kind == ElementKind.METHOD;

bool _unsupportedAnnotationKind(ElementKind kind) =>
    !_supportedAnnotationKind(kind);
