import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';

/// A visitor that visits widget elements and extracts neccessary widget info
class ClassVisitor extends SimpleElementVisitor<void> {
  ClassElementExtract _classExtract = ClassElementExtract();

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
    _classExtract = _classExtract.addFieldExtract(
      fieldExtract: FieldExtract(
        name: element.name,
        type: element.type,
      ),
    );
  }

  @override
  void visitMethodElement(MethodElement element) {
    assert(element.isPublic, 'Method must be public');

    assert(!element.returnType.isVoid, 'Return type must not be void');

    _classExtract = _classExtract.addMethodExtract(
      methodExtract: MethodExtract(
        name: element.name,
        type: element.type.returnType,
        parameters: element.parameters,
      ),
    );
  }
}
