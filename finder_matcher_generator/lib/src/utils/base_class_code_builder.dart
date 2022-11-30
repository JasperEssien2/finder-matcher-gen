import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/utils/override_methods_builder.dart';

/// The base class for class generator
abstract class ClassCodeBuilder with OverrideMethodsBuiilder {
  /// Pass in class element extract model
  ClassCodeBuilder(this.classExtract);

  /// Information extract of annotated class. Extractef by [ClassVisitor]
  final ClassElementExtract classExtract;

  final StringBuffer _stringBuffer = StringBuffer();

  /// A string buffer containing the written code
  @override
  StringBuffer get stringBuffer => _stringBuffer;

  /// The name to attach to existing class name, e.g ClassMatchFinder
  /// where MatchFinder is the suffix
  String get suffix;

  /// Indicates if this class should be marked const or not
  bool get isClassConst => false;

  /// Handles writing class header and opening a class curly brace
  void writeClassHeader() {
    if (classExtract.className == null) {
      //TODO: Throw an exception

      return;
    }
    _stringBuffer.writeln(
      'class ${classExtract.className!}$suffix extends $suffix {',
    );
  }

  /// Handles writing the class constructor
  void writeConstructor() {
    if (classExtract.className == null) {
      //TODO: Throw an exception

      return;
    }

    _stringBuffer.writeln(
      '${isClassConst ? 'const' : ''} ${classExtract.className!}$suffix();\n',
    );
  }

  /// Closes class with its close curly brace
  void closeClass() {
    _stringBuffer.writeln('}');
  }
}
