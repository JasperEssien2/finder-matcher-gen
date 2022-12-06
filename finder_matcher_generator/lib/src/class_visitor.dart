import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/element_checker.dart';
import 'package:finder_matcher_generator/src/utils/extensions.dart';

/// A visitor that visits widget elements and extracts neccessary widget info
class ClassVisitor extends SimpleElementVisitor<void> {
  ClassElementExtract _classExtract = const ClassElementExtract();

  /// Extracts of this class found in the class element
  ClassElementExtract get classExtract => _classExtract;

  @override
  void visitConstructorElement(ConstructorElement element) {
    _classExtract = _classExtract.copyWith(
      className: element.type.returnType.toString(),
      classUri: element.librarySource.uri,
    );
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (element.hasMatchFieldAnnotation) {
      ///Should throw an error when this field element does not conform
      ///to this package standard
      checkBadTypeByFieldElement(element);

      _classExtract = _classExtract.addFieldOrMethodExtract(
        extract: DeclarationExtract(
          name: element.name,
          type: element.type,
          isMethod: false,
        ),
      );
    }
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (element.hasMatchFieldAnnotation) {
      ///Should throw an error when this method element does not conform
      ///to this package standard
      checkBadTypeByMethodElement(element);

      _classExtract = _classExtract.addFieldOrMethodExtract(
        extract: DeclarationExtract(
          name: element.name,
          type: element.type.returnType,
          parameters: element.parameters,
          isMethod: true,
        ),
      );
    }
  }
}
