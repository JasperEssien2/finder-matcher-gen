import 'package:finder_matcher_gen/src/models/override_method_model.dart';
import 'package:meta/meta.dart';

/// An abstraction responsible for writing methods to override
abstract class OverrideMethodsBuiilder {
  /// The class body String buffer
  StringBuffer get classBodyBuffer;

  /// A list of methods information to override
  List<OverrideMethodModel> get methodsToOverride;

  /// Call to write overriden methods in class
  @visibleForOverriding
  void overrideMethods() {
    for (final element in methodsToOverride) {
      _overrideMethod(element);
      classBodyBuffer.writeln();
    }
  }

  void _overrideMethod(
    OverrideMethodModel overrideMethod,
  ) {
    classBodyBuffer.writeln('@override');

    switch (overrideMethod.methodCategory) {
      case MethodCategory.getter:
        classBodyBuffer.write(
          '${overrideMethod.returnType} get ${overrideMethod.name} => ',
        );
        overrideMethod.methodCodeBuilder(classBodyBuffer);
        return;

      case MethodCategory.method:
        classBodyBuffer
            .writeln('${overrideMethod.returnType} ${overrideMethod.name} (');

        final methodParametersTypeList = overrideMethod.paramTypeAndName!.keys;

        for (final dataType in methodParametersTypeList) {
          classBodyBuffer
              .write('$dataType ${overrideMethod.paramTypeAndName![dataType]}');

          if (dataType == methodParametersTypeList.last) {
            classBodyBuffer.write(') {');
            overrideMethod.methodCodeBuilder(classBodyBuffer);
            classBodyBuffer.writeln('}');
          } else {
            classBodyBuffer.write(', ');
          }
        }

        return;
      case MethodCategory.setter:
        break;
    }
  }
}
