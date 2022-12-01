import 'package:finder_matcher_generator/src/models/override_method_model.dart';

/// An abstraction responsible for writing methods to override
abstract class OverrideMethodsBuiilder {
  /// String buffer to write class to
  StringBuffer get stringBuffer;

  /// A list of methods information to override
  List<OverrideMethodModel> get methodsToOverride;

  /// Call to write overriden methods in class
  void overrideMethods() {
    for (final element in methodsToOverride) {
      _overrideMethod(element);
      stringBuffer.writeln();
    }
  }

  void _overrideMethod(
    OverrideMethodModel overrideMethod,
  ) {
    stringBuffer.writeln('@override');

    switch (overrideMethod.methodCategory) {
      case MethodCategory.getter:
        stringBuffer.write(
          '${overrideMethod.returnType} get ${overrideMethod.name} => ',
        );
        overrideMethod.methodCodeBuilder(stringBuffer);
        return;

      case MethodCategory.method:
        stringBuffer
            .writeln('${overrideMethod.returnType} ${overrideMethod.name} (');

        final methodParametersTypeList = overrideMethod.paramTypeAndName!.keys;

        for (final dataType in methodParametersTypeList) {
          stringBuffer
              .write('$dataType ${overrideMethod.paramTypeAndName![dataType]}');

          if (dataType == methodParametersTypeList.last) {
            stringBuffer.write(') {');
            overrideMethod.methodCodeBuilder(stringBuffer);
            stringBuffer.writeln('}');
          } else {
            stringBuffer.write(', ');
          }
        }

        return;
      case MethodCategory.setter:
        break;
    }
  }
}
