import 'package:analyzer/dart/element/type.dart';

/// A data class for a constructor field
class ConstructorFieldModel {
  ///Required field [name] and [type]
  ConstructorFieldModel({required this.name, required this.type});


  /// Name of constructor field
  final String name;

  /// Return type of constructor field
  final DartType type;

  ///copyWith
  ConstructorFieldModel copyWith({
    String? name,
    DartType? type,
  }) {
    return ConstructorFieldModel(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
