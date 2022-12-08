import 'package:analyzer/dart/element/element.dart';
import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/constructor_field_model.dart';
import 'package:finder_matcher_generator/src/models/override_method_model.dart';
import 'package:finder_matcher_generator/src/utils/utils_export.dart';
import 'package:meta/meta.dart';

///Builds Matcher classes string code for widgets
class WidgetMatcherClassBuilder extends ClassCodeBuilder {
  /// Accepts a [ClassElementExtract] and [MatchSpecification]
  /// The [MatchSpecification] an enum specifies the count the generated Matcher
  /// should validate as "matched"
  WidgetMatcherClassBuilder(
    super.classExtract,
    MatchSpecification specification,
  ) : _specification = specification;

  final MatchSpecification _specification;

  final _constructorFields = <ConstructorFieldModel>{};

  @override
  Iterable<ConstructorFieldModel> get constructorFields =>
      List.unmodifiable(_constructorFields);

  @override
  List<OverrideMethodModel> get methodsToOverride => [
        OverrideMethodModel(
          name: 'describe',
          returnType: 'Description',
          methodCategory: MethodCategory.method,
          paramTypeAndName: const {'Description': 'description'},
          methodCodeBuilder: (buffer) =>
              _getSpecificationCodeBuilder.writeDescribeMethod(buffer),
        ),
        OverrideMethodModel(
          name: 'matches',
          returnType: 'bool',
          paramTypeAndName: const {
            'covariant Finder': 'finder',
            'Map': 'matchState',
          },
          methodCategory: MethodCategory.method,
          methodCodeBuilder: (buffer) =>
              _getSpecificationCodeBuilder.writeMatchesMethod(buffer),
        ),
        OverrideMethodModel(
          name: 'describeMismatch',
          returnType: 'Description',
          paramTypeAndName: const {
            'covariant Finder': 'finder',
            'Description': 'mismatchDescription',
            'Map': 'matchState',
            'bool': 'verbose',
          },
          methodCategory: MethodCategory.method,
          methodCodeBuilder: (buffer) =>
              _getSpecificationCodeBuilder.writeDescribeMismatchMethod(buffer),
        ),
      ];

  BaseMatcherMethodsCodeBuilder get _getSpecificationCodeBuilder {
    switch (_specification) {
      case MatchSpecification.matchesNoWidget:
        return MatchNoWidgetMethodsBuilder(classExtract, _constructorFields);
      case MatchSpecification.matchesAtleastOneWidget:
        return MatchAtleastOneWidgetMethodsBuilder(
          classExtract,
          _constructorFields,
        );
      case MatchSpecification.matchesNWidgets:
        _constructorFields
            .add(const ConstructorFieldModel(name: 'n', type: 'int'));

        return MatchNWidgetMethodsBuilder(classExtract, _constructorFields);

      case MatchSpecification.matchesOneWidget:
        return MatchOneWidgetMethodsBuilder(classExtract, _constructorFields);
    }
  }

  @override
  String get suffix => 'Matcher';
}

/// A base class for writing Matcher method code to [StringBuffer]
abstract class BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  BaseMatcherMethodsCodeBuilder(
    this.extract,
    this.mutableConstructorFields,
  );

  /// [ClassElementExtract] contains extracted information from [ClassElement]
  final ClassElementExtract extract;

  /// A mutable set of constructor fields data that will be generated alonside
  /// constructor.
  final Set<ConstructorFieldModel> mutableConstructorFields;

  /// Responsible for writing all required methods into the [StringBuffer]
  void write(StringBuffer stringBuffer) {
    writeDescribeMethod(stringBuffer);

    writeMatchesMethod(stringBuffer);

    writeDescribeMismatchMethod(stringBuffer);
  }

  /// Class name
  String get className;

  /// Describes how many widgets were expected
  String get expectCount;

  /// Responsible for writing describe() into [StringBuffer]
  void writeDescribeMethod(StringBuffer stringBuffer) {
    stringBuffer.writeln(
      """return description.add('matches $expectCount $className widget').addDescriptionOf(this);""",
    );
  }

  /// Responsible for writing matches() into [StringBuffer]
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("matchState['custom.finder'] = finder;\n")
      ..writeln('try {')
      ..writeln('var matchedCount = 0;\n')
      ..writeln('final elements = finder.evaluate();\n')
      ..writeln('for(final element in elements) {')
      ..writeln(
        '''if (element.widget is ${extract.className}) {''',
      )
      ..writeln(_writeValidationCode())
      ..writeln('}')
      ..writeln('}\n')
      ..writeln("matchState['custom.matchedCount'] = matchedCount;\n")
      ..writeln(matchReturnStatement)
      ..writeln('} catch (exception, stack) {')
      ..writeln(exceptionHandlerCode)
      ..writeln('}\n')
      ..writeln('return false;');
  }

  String _writeValidationCode() {
    final buffer = StringBuffer();

    final fields = extract.declarations;

    if (fields?.isEmpty ?? true) {
      buffer.writeln('matchedCount++;');
    } else {
      buffer
        ..writeln('final widget = element.widget as ${extract.className};\n')
        ..write('if (');
      for (var i = 0; i < fields!.length; i++) {
        buffer.write(
          getConditionCodeFromExtract(
            fields[i],
            first: i == 0,
            writeFirstKeyword: '',
          ),
        );
      }
      buffer
        ..write(') {\n')
        ..writeln('matchedCount++;')
        ..writeln('}');
    }

    return buffer.toString();
  }

  /// Code string to handle exceptions
  String get exceptionHandlerCode => '''
      matchState['custom.exception'] = exception.toString();
      matchState['custom.stack'] = Chain.forTrace(stack)
            .foldFrames(
                (frame) =>
                    frame.package == 'test' ||
                    frame.package == 'stream_channel' ||
                    frame.package == 'matcher',
                terse: true)
            .toString();
''';

  /// Returns the string code that uses the match count to validate if
  /// this widget (and it's pr) was found
  String get matchReturnStatement;

  /// Responsible for writing describeMismatch() into [StringBuffer]
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if(matchState['custom.exception'] != null) {")
      ..writeln("mismatchDescription.add('threw')")
      ..writeln(
        '''.addDescriptionOf(matchState['custom.exception'])''',
      )
      ..writeln()
      ..writeln(".add(matchState['custom.stack'].toString());")
      ..writeln('}\n');
  }
}

/// Builds matcher method that ensures only one widget is matched
class MatchOneWidgetMethodsBuilder extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchOneWidgetMethodsBuilder(super.extract, super.mutableConstructorFields);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'one';

  @override
  String get matchReturnStatement => 'return matchedCount == 1;';

  @override
  String _writeValidationCode() {
    final buffer = StringBuffer();

    final fields = extract.declarations;

    if (fields?.isEmpty ?? true) {
      buffer
        ..writeln('matchedCount++;')
        ..writeln('break;');
    } else {
      for (var i = 0; i < fields!.length; i++) {
        buffer
          ..writeln('matchedCount++;')
          ..write(getConditionCodeFromExtract(fields[i], first: i == 0));
      }
    }

    return buffer.toString();
  }

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.count'] <= 0) {")
      ..writeln(
        """mismatchDescription.add('zero ${extract.className} widgets found but one was expected');""",
      )
      ..writeln('}\n')
      ..writeln("else if(matchState['custom.count'] > 1) {")
      ..writeln(
        """mismatchDescription.add('found multiple ${extract.className} widgets but one was expected');""",
      )
      ..writeln('}\n')
      ..write(_getWidgetInitializationCode(extract.declarations ?? []))
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(
          extract.declarations ?? [],
          mutableConstructorFields,
        ),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that ensures at least one widget is matched
class MatchAtleastOneWidgetMethodsBuilder
    extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchAtleastOneWidgetMethodsBuilder(
    super.extract,
    super.mutableConstructorFields,
  );

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'atleast one';

  @override
  String get matchReturnStatement => 'return matchedCount >= 1;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.matchedCount'] <= 0) {")
      ..writeln(
        """mismatchDescription.add('found zero ${extract.className} widgets but at least one was expected');""",
      )
      ..writeln('}\n')
      ..write(_getWidgetInitializationCode(extract.declarations ?? []))
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(
          extract.declarations ?? [],
          mutableConstructorFields,
        ),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that ensures exact N number of widgets is matched
class MatchNWidgetMethodsBuilder extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchNWidgetMethodsBuilder(super.extract, super.mutableConstructorFields);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => r'$_n';

  @override
  String get matchReturnStatement => 'return matchedCount == _n;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.matchedCount'] != _n) {")
      ..writeln(
        """mismatchDescription.add('found \${matchState['custom.matchedCount']} ${extract.className} widgets \$_n was expected');""",
      )
      ..writeln('}\n')
      ..write(_getWidgetInitializationCode(extract.declarations ?? []))
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(
          extract.declarations ?? [],
          mutableConstructorFields,
        ),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that ensures no widget is matched
class MatchNoWidgetMethodsBuilder extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchNoWidgetMethodsBuilder(super.extract, super.mutableConstructorFields);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'no';

  @override
  String get matchReturnStatement => 'return matchedCount == 0;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.count'] >= 1) {")
      ..writeln(
        """mismatchDescription.add('zero ${extract.className} widgets expected but found \${matchState['custom.count'] ?? 0}');""",
      )
      ..writeln('}')
      ..writeln('return mismatchDescription;');
  }
}

@visibleForTesting
// ignore: public_member_api_docs
Iterable<String> getMatchOneDeclarationsMismatchCheckCode(
  List<DeclarationExtract> declarations,
  Set<ConstructorFieldModel> mutableConstructorFields,
) {
  return declarations.map(
    (e) {
      final isBool = e.type!.isDartCoreBool;

      final conditionValue = e.defaultValue ??
          getConstructorNameInPlaceOfDefaultValue(e, isPrivate: true);

      if (e.defaultValue == null) {
        mutableConstructorFields.add(
          ConstructorFieldModel(
            name: getConstructorNameInPlaceOfDefaultValue(e),
            type: e.type!.dartTypeStr,
          ),
        );
      }
      final entityCode = '''widget.${e.name}${e.isMethod ? '()' : ''}''';

      var code = '';

      // TODO(jasperessien2): There's likely to be an issue here, when default value selected for booleans declaration
      code +=
          '''if(${isBool ? '!' : ''}$entityCode${!isBool ? '!= $conditionValue' : ''}) {\n''';

      if (e.defaultValue != null) {
        code +=
            """mismatchDescription.add("${e.name} is \${${isBool ? 'false' : entityCode}} but ${isBool ? true : conditionValue} was expected");\n""";
      } else {
        code +=
            '''mismatchDescription.add("${e.name} is \${$entityCode} but ${getConstructorNameInPlaceOfDefaultValue(e, isPrivate: true)} was expected");\n''';
      }

      return code += '}\n\n';
    },
  );
}

String _getWidgetInitializationCode(List<DeclarationExtract> declarations) {
  return declarations.isNotEmpty
      ? """final finder = matchState['custom.finder'];\nfinal widget = finder.evaluate().first.widget;\n\n"""
      : '';
}
