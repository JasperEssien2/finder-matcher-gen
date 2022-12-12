import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:finder_matcher_gen/src/models/constructor_field_model.dart';
import 'package:finder_matcher_gen/src/models/models_export.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';

/// A visitor that visits widget elements and extracts neccessary widget info
class ClassVisitor extends SimpleElementVisitor<void> {
  ClassElementExtract _classExtract = const ClassElementExtract();

  /// Extracts of this class found in the class element
  ClassElementExtract get classExtract => _classExtract;

  @override
  void visitConstructorElement(ConstructorElement element) {
    _classExtract = _classExtract.copyWith(
      className: element.type.returnType.dartTypeStr,
      classUri: element.librarySource.uri,
    );
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (element.hasMatchFieldAnnotation) {
      final defaultValue = _getAnnotationDefaultValue(element);

      /// Checks if annotation has a default value set, if not pass it as a
      /// variable to the generated constructor
      if (defaultValue == null) {
        _classExtract = _classExtract.copyWithConstructorField(
          fieldModel: ConstructorFieldModel(
            name: '${element.name}Value',
            type: element.type.dartTypeStr,
          ),
        );
      }

      ///Should throw an error when this field element does not conform
      ///to this package standard
      checkBadTypeByFieldElement(element);

      _classExtract = _classExtract.copyWithDeclarationExtract(
        extract: DeclarationExtract(
          name: element.name,
          type: element.type,
          isMethod: false,
          defaultValue: defaultValue,
          fieldEquality: getEqualityType(element.type),
        ),
      );
    }
  }

  /// Returns the [FieldEquality] to use when [type] falls under any of these
  /// [List], [Map], [Set]
  FieldEquality? getEqualityType(DartType type) {
    if (type.isDartCoreList) return FieldEquality.list;
    if (type.isDartCoreMap) return FieldEquality.map;
    if (type.isDartCoreSet) return FieldEquality.set;
    return null;
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (element.hasMatchFieldAnnotation) {
      ///Should throw an error when this method element does not conform
      ///to this package standard
      checkBadTypeByMethodElement(element);

      final defaultValue = _getAnnotationDefaultValue(element);

      /// Checks if annotation has a default value set, if not pass it as a
      /// variable to the generated constructor
      if (defaultValue == null) {
        _classExtract = _classExtract.copyWithConstructorField(
          fieldModel: ConstructorFieldModel(
            name: '${element.name}Value',
            type: element.returnType.dartTypeStr,
          ),
        );
      }

      _classExtract = _classExtract.copyWithDeclarationExtract(
        extract: DeclarationExtract(
          name: element.name,
          type: element.type.returnType,
          parameters: element.parameters,
          isMethod: true,
          fieldEquality: getEqualityType(element.returnType),
        ),
      );
    }
  }

  dynamic _getAnnotationDefaultValue(Element element) {
    final annotationObjects = element.getAnnotationObjects;

    final defaultValueObject = annotationObjects.isEmpty
        ? null
        : annotationObjects.first.getField('_defaultValue');

    dynamic defaultValue;

    if (defaultValueObject != null) {
      defaultValue = getDartObjectValue(defaultValueObject);
    }
    return defaultValue;
  }
}
