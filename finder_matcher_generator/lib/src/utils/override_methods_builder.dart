import 'package:finder_matcher_generator/src/models/override_method_model.dart';

abstract class OverrideMethodsBuiilder {
  final _stringBuffer = StringBuffer();

  List<OverrideMethodModel> get methodsToOverride;

  String overrideMethods() {
    for (final element in methodsToOverride) {
      _overrideMethod(element);
    }

    return _stringBuffer.toString();
  }

  void _overrideMethod(
    OverrideMethodModel overrideMethod,
  ) {
    _stringBuffer.writeln('@override');

    switch (overrideMethod.methodType) {
      case OverrideMethodType.getter:
        _stringBuffer.write(
          '${overrideMethod.returnType} get ${overrideMethod.name} => ',
        );
        overrideMethod.writeMethodCode(_stringBuffer);
        return;

      case OverrideMethodType.method:
        _stringBuffer
            .writeln('${overrideMethod.returnType} ${overrideMethod.name} (');

        final methodTypeList = overrideMethod.paramTypeAndName!.keys;

        for (final dataType in methodTypeList) {
          _stringBuffer
              .write('$dataType ${overrideMethod.paramTypeAndName![dataType]}');

          if (dataType == methodTypeList.last) {
            _stringBuffer.write(') {');
            overrideMethod.writeMethodCode(_stringBuffer);
            _stringBuffer.writeln('}');
          } else {
            _stringBuffer.write(', ');
          }
        }

        return;
      case OverrideMethodType.setter:
        break;
    }
  }
}
