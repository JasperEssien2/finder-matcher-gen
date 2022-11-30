import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

void checkBadTypeByElement(Element element) {}

void checkBadTypeByClassElement(ClassElement element) {}

void checkBadTypeByMethodElement(MethodElement element) {
  
   checkBadTypeByDartType(element.type);
}

void checkBadTypeByFieldElement(FieldElement element) {

  checkBadTypeByDartType(element.type);
}

void checkBadTypeByDartType(DartType dartType) {}
