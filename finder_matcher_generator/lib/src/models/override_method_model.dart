typedef OverridenMethodCodeBuilder = void Function(StringBuffer buffer);

class OverrideMethodModel {
  OverrideMethodModel({
    required this.name,
    required this.returnType,
    this.paramTypeAndName,
    required this.methodType,
    required this.writeMethodCode,
  }) {
    assert(methodType != OverrideMethodType.getter && paramTypeAndName != null);
  }

  final String name;
  final String returnType;
  final Map<String, String>? paramTypeAndName;
  final OverrideMethodType methodType;
  final OverridenMethodCodeBuilder writeMethodCode;
}

enum OverrideMethodType {
  getter,
  setter,
  method,
}
