import 'package:finder_matcher_generator/src/builders/override_methods_builder.dart';
import 'package:finder_matcher_generator/src/class_visitor.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/constructor_field_model.dart';
import 'package:finder_matcher_generator/src/utils/utils_export.dart';
import 'package:meta/meta.dart';

/// The base class for class generator
abstract class ClassCodeBuilder with OverrideMethodsBuiilder {
  /// Pass in class element extract model
  ClassCodeBuilder(this.classExtract);

  /// Information extract of annotated class. Extractef by [ClassVisitor]
  final ClassElementExtract classExtract;

  final StringBuffer _classBodyBuffer = StringBuffer();
  final StringBuffer _classHeaderBuffer = StringBuffer();

  @override
  @visibleForTesting
  StringBuffer get classBodyBuffer => _classBodyBuffer;

  /// The complete class string
  String get classCode =>
      _classHeaderBuffer.toString() + _classBodyBuffer.toString();

  /// Defines the generated constructor fields and parameters
  Iterable<ConstructorFieldModel> get constructorFields;

  /// The name to attach to existing class name, e.g HomePageMatchFinder
  /// where MatchFinder is the suffix and HomePage is the class name
  String get suffix;

  /// Indicates if this class should be marked const or not
  bool get isClassConst => false;

  ///Writes class header and body into a [StringBuffer] 
  void buildClassCode() {
    //Constructors and methods writes to different buffers.
    // Constructor parameters may sometimes depend on the generated methods.
    // Example, the matchNWidget needs an int parameter, which is passed via
    //the generated constructor
    // ignore: invalid_use_of_visible_for_overriding_member
    overrideMethods();
    writeClassHeader();
    writeConstructor();
    closeClass();
  }

  /// Handles writing class header and opening a class curly brace
  @visibleForOverriding
  void writeClassHeader() {
    if (classExtract.className == null) {
      throwException('Class name cannot be null', element: null);

      return;
    }
    _classHeaderBuffer.writeln(
      'class ${classExtract.className!}$suffix extends $suffix {',
    );
  }

  /// Handles writing the class constructor
  @visibleForOverriding
  void writeConstructor() {
    if (classExtract.className == null) {
      throwException('Class not found', element: null);
      return;
    }

    final constructorParamsCodeList = _getConstructorParamFields();

    assert(
      constructorParamsCodeList.length == 3,
      '''constructorParamsCodeList must contain three strings: param, initialisation, private field codes''',
    );

    _classHeaderBuffer
      ..write(
        '${isClassConst ? 'const' : ''} ${classExtract.className!}$suffix(',
      )
      ..write(constructorParamsCodeList[0])
      ..write(')${constructorParamsCodeList[1]}')
      ..writeln(constructorParamsCodeList[2])
      ..writeln(';\n');
  }

  List<String> _getConstructorParamFields() {
    final paramBuffer = StringBuffer(constructorFields.isEmpty ? '' : '{');
    final initialisationBuffer =
        StringBuffer(constructorFields.isEmpty ? '' : ':');
    final privateFieldsBuffer = StringBuffer();

    for (final field in constructorFields) {
      final isLastField = field == constructorFields.last;

      paramBuffer.write(
        field.isNullable ? '' : '''required ${field.type} ${field.name},''',
      );

      initialisationBuffer.write(
        '_${field.name} = ${field.name} ${isLastField ? ';' : ','}\n',
      );

      privateFieldsBuffer.writeln(
        "final ${field.type} _${field.name} ${isLastField ? '' : ';'}",
      );
    }

    paramBuffer.write(constructorFields.isEmpty ? '' : '}');

    return [
      paramBuffer.toString(),
      initialisationBuffer.toString(),
      privateFieldsBuffer.toString(),
    ];
  }

  /// Handle writing other methods
  void writeHelperMethods() {
    throw UnimplementedError();
  }

  /// Closes class with its close curly brace
  @visibleForOverriding
  void closeClass() {
    _classBodyBuffer.writeln('}');
  }
}
