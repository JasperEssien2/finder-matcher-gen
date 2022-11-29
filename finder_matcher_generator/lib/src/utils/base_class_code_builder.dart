import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/override_methods_builder.dart';

/// The base class for class generator
abstract class ClassCodeBuilder extends OverrideMethodsBuiilder {
  /// Pass in class element extract model
  ClassCodeBuilder(this.classExtract);

  /// Information extract of class, gotten from []
  final ClassElementExtract classExtract;

  final StringBuffer _stringBuffer = StringBuffer();
  StringBuffer get stringBuffer => _stringBuffer;

  String get suffix;

  void writeImport() {
    _stringBuffer.writeln('import ${classExtract.classUri!.toString()};\n\n');
  }

  void writeClassHeader() {
    _stringBuffer.writeln(
      'class ${classExtract.className!}$suffix extends $suffix {',
    );
  }

  void writeConstructor() {
    _stringBuffer.writeln('const ${classExtract.className!}$suffix();');
  }

  void closeClass() {
    _stringBuffer.writeln('}');
  }
}
