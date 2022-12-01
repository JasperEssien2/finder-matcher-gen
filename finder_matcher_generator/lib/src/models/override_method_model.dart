/// A typedef pointing to a function that accepts [StringBuffer]
typedef OverrideMethodCodeBuilder = void Function(StringBuffer buffer);

/// A data class information of method to override
class OverrideMethodModel {
  ///
  OverrideMethodModel({
    required this.name,
    required this.returnType,
    this.paramTypeAndName,
    required this.methodCategory,
    required this.methodCodeBuilder,
  }) : assert(
          methodCategory != MethodCategory.getter && paramTypeAndName != null,
          'Getter cannot have parameters',
        );

  /// The name of the method
  final String name;

  /// The return type of the method
  final String returnType;

  /// Map of parameter to parameter type
  final Map<String, String>? paramTypeAndName;

  /// The method category: getter, method, or setter
  final MethodCategory methodCategory;

  /// A callback that writes this method code to [StringBuffer]
  final OverrideMethodCodeBuilder methodCodeBuilder;
}

/// An enum of method categories
enum MethodCategory {
  /// This method is a getter
  getter,

  /// This method is a setter
  setter,

  /// This method is, well a method
  method,
}
