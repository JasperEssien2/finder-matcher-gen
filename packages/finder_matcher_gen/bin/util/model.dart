import 'package:analyzer/dart/element/element.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable/equatable.dart';

class AnnotationDefaultValueCheckModel extends Equatable {
  const AnnotationDefaultValueCheckModel({
    required this.correctType,
    required this.expected,
    required this.given,
    required this.defaultValue,
  });

  final bool correctType;
  final String? expected;
  final String? given;
  final String? defaultValue;

  @override
  List<Object?> get props => [correctType, expected, given, defaultValue];
}

// class AnnotationElementInfo {

//   final Element element;

//   LintLocation get lintLocation{

//   }
// }