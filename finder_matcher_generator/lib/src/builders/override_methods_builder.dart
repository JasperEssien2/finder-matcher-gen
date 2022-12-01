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

    switch (overrideMethod.methodType) {
      case OverrideMethodType.getter:
        stringBuffer.write(
          '${overrideMethod.returnType} get ${overrideMethod.name} => ',
        );
        overrideMethod.writeMethodCode(stringBuffer);
        return;

      case OverrideMethodType.method:
        stringBuffer
            .writeln('${overrideMethod.returnType} ${overrideMethod.name} (');

        final methodTypeList = overrideMethod.paramTypeAndName!.keys;

        for (final dataType in methodTypeList) {
          stringBuffer
              .write('$dataType ${overrideMethod.paramTypeAndName![dataType]}');

          if (dataType == methodTypeList.last) {
            stringBuffer.write(') {');
            overrideMethod.writeMethodCode(stringBuffer);
            stringBuffer.writeln('}');
          } else {
            stringBuffer.write(', ');
          }
        }

        return;
      case OverrideMethodType.setter:
        break;
    }
  }
}
