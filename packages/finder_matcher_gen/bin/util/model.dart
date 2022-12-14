import 'package:equatable/equatable.dart';

class AnnotationDefaultValueCheckModel extends Equatable {
  const AnnotationDefaultValueCheckModel({
    required this.correctType,
    required this.expected,
    required this.given,
  });

  final bool correctType;
  final String? expected;
  final String? given;

  @override
  List<Object?> get props => [correctType, expected, given];
}
