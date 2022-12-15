import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_gen/src/class_visitor.dart';
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
void checkBadTypeByMethodElement(MethodGetterElementWrapper element) {
  if (element.parameters.isNotEmpty) {
    throwException(
      'Unsupported: annotated method should have no parameter',
      element: element.element,
    );
  }
  checkElementNotPrivate(element.element);
}

/// Throws an exception when [FieldElement] type does not conform to
/// field generation specification
void checkBadTypeByFieldElement(FieldElement element) {
  checkElementNotPrivate(element);
}

/// Checks if this [DartType] is not core library
bool isNotPartOfDartCore(DartType dartType) =>
    !dartType.isDartCoreBool &&
    !dartType.isDartCoreDouble &&
    !dartType.isDartCoreEnum &&
    !dartType.isDartCoreInt &&
    !dartType.isDartCoreIterable &&
    !dartType.isDartCoreList &&
    !dartType.isDartCoreMap &&
    !dartType.isDartCoreNull &&
    !dartType.isDartCoreNum &&
    !dartType.isDartCoreObject &&
    !dartType.isDartCoreRecord &&
    !dartType.isDartCoreSet &&
    !dartType.isDartCoreString &&
    !dartType.isDartCoreSymbol;

/// Throws an exception when [Element] is private
void checkElementNotPrivate(Element element) {
  if (element.isPrivate) {
    throwException(
      'Unsupported access modifer: Cannot utilise a private entity',
      element: element,
    );
  }
}

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
