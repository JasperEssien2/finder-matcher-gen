import 'package:equatable/equatable.dart';

/// A data class for a constructor field
class ConstructorFieldModel extends Equatable {
  ///Required field [name] and [type]
  const ConstructorFieldModel({
    required this.name,
    required this.type,
    this.isNullable = false,
  });

  /// Name of constructor field
  final String name;

  /// Return type of constructor field
  final String type;

  /// A flag to set the nullability of this constructor field
  final bool isNullable;

  ///copyWith
  ConstructorFieldModel copyWith({
    String? name,
    String? type,
    bool? isNullable,
  }) {
    return ConstructorFieldModel(
      name: name ?? this.name,
      type: type ?? this.type,
      isNullable: isNullable ?? this.isNullable,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [name, type, isNullable];
}
