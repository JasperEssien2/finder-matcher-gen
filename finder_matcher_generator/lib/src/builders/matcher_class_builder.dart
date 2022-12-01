import 'package:finder_matcher_gen/finder_matcher_gen.dart';
import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/models/class_extract_model.dart';
import 'package:finder_matcher_generator/src/models/override_method_model.dart';
import 'package:finder_matcher_generator/src/utils/validation_code_helper.dart';

///
class WidgetMatcherClassBuilder extends ClassCodeBuilder {
  /// Accepts a [ClassElementExtract] and [MatchSpecification]
  /// The [MatchSpecification] an enum specifies the count the generated Matcher
  /// should validate as "matched"
  WidgetMatcherClassBuilder(
    super.classExtract,
    MatchSpecification specification,
  ) : _specification = specification;

  final MatchSpecification _specification;

  @override
  List<OverrideMethodModel> get methodsToOverride => [
        OverrideMethodModel(
          name: 'describe',
          returnType: 'Description',
          methodCategory: MethodCategory.method,
          paramTypeAndName: {'Description': 'description'},
          methodCodeBuilder: _getSpecificationCodeBuilder.writeDescribeMethod,
        ),
        OverrideMethodModel(
          name: 'matches',
          returnType: 'bool',
          paramTypeAndName: {
            'covariant Finder': 'finder',
            'Map': 'matchState',
          },
          methodCategory: MethodCategory.method,
          methodCodeBuilder: _getSpecificationCodeBuilder.writeMatchesMethod,
        ),
        OverrideMethodModel(
          name: 'describeMismatch',
          returnType: 'Description',
          paramTypeAndName: {
            'covariant Finder': 'finder',
            'Description': 'mismatchDescription',
            'Map': 'matchState',
            'bool': 'verbose',
          },
          methodCategory: MethodCategory.method,
          methodCodeBuilder:
              _getSpecificationCodeBuilder.writeDescribeMismatchMethod,
        ),
      ];

  BaseMatcherMethodsCodeBuilder get _getSpecificationCodeBuilder {
    switch (_specification) {
      case MatchSpecification.matchesNoWidget:
        // TODO: Handle this case.
        break;
      case MatchSpecification.matchesAtleastOneWidget:
        return MatchAtleastOneWidgetMethodsBuilder(classExtract);
      case MatchSpecification.matchesNWidgets:
        // TODO: Handle this case.
        break;
      case MatchSpecification.matchesOneWidget:
        return MatchOneWidgetMethodsBuilder(classExtract);
    }

    return MatchOneWidgetMethodsBuilder(classExtract);
  }

  @override
  String get suffix => 'Matcher';
}

/// A base class for writing Matcher method code to [StringBuffer]
abstract class BaseMatcherMethodsCodeBuilder {
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
  void writeMatchesMethod(StringBuffer stringBuffer);

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
            .toString()
''';

  /// Responsible for writing describeMismatch() into [StringBuffer]
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if(matchState['custom.exception'] != null) {")
      ..writeln("mismatchDescription.add('threw')")
      ..writeln(
        '''mismatchDescription.addDescriptionOf('matchState['custom.exception']')''',
      )
      ..writeln('\n')
      ..writeln("'matchState['custom.stack'].toString();");
  }
}

/// Builds matcher method that ensures only one widget is matched
class MatchOneWidgetMethodsBuilder extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchOneWidgetMethodsBuilder(this.extract);

  /// The class element extract
  final ClassElementExtract extract;

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'one';

  @override
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("matchState['custom.finder'] = finder")
      ..writeln('try {')
      ..writeln('final elements = finder.evaluate();')
      ..writeln('if(elements.length > 1) {')
      ..writeln("matchState['custom.count'] = elements.length;")
      ..writeln('return false;')
      ..writeln(
        '''} else if(elements.count == 1 && elements.first.widget is ${extract.className}) {''',
      )
      ..writeln(_writeValidationCode())
      ..writeln('}')
      ..writeln('return false;')
      ..writeln('} catch (exception, stack) {')
      ..writeln(exceptionHandlerCode)
      ..writeln('}');
  }

  String _writeValidationCode() {
    final buffer = StringBuffer();

    final fields = extract.fields;

    if (fields?.isEmpty ?? true) {
      buffer.writeln('return true;');
    } else {
      for (var i = 0; i < fields!.length; i++) {
        buffer.write(getValidationCodeFromExtract(fields[i], first: i == 0));
      }
    }

    return buffer.toString();
  }

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.count'] == 0) {")
      ..writeln(
        """mismatchDescription.add('zero ${extract.className} widgets found but one was expected');""",
      )
      ..writeln("if(matchState['custom.count'] > 1) {")
      ..writeln(
        """mismatchDescription.add('found multiple ${extract.className} widgets but one was expected');""",
      )
      ..writeln('}')
      ..writeln("final finder = matchState['custom.finder'];")
      ..writeln('final widget = finder.evaluate().first.widget;')
      ..writeAll(
        extract.fields?.map(
              (e) {
                final isBool = e.type!.isDartCoreBool;
                final defaultValue = getDefaultValueForDartType(e.type!);

                final entityCode = 'widget.${e.name}${e.isMethod ? '()' : ''}';

                var code = '';
                code +=
                    '''if(!$entityCode${!isBool ? '!= $defaultValue' : ''}) {\n''';
                code +=
                    """mismatchDescription.add('${e.name} is ${isBool ? 'false' : entityCode} but ${isBool ? true : defaultValue} was expected');\n""";
                code += '}\n';

                return code;
              },
            ) ??
            [],
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that ensures at least one widget is matched
class MatchAtleastOneWidgetMethodsBuilder
    extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchAtleastOneWidgetMethodsBuilder(this.extract);

  /// The class element extract
  final ClassElementExtract extract;

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'atleast one';

  @override
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("matchState['custom.finder'] = finder")
      ..writeln('try {')
      ..writeln('var matchedCount = 0;')
      ..writeln('final elements = finder.evaluate();')
      ..writeln('for(final element in elements) {')
      ..writeln(
        '''if (element.widget is ${extract.className}) {''',
      )
      ..writeln('final widget = element.widget;')
      ..writeln(_writeValidationCode())
      ..writeln('}')
      ..writeln('}')
      ..writeln("matchState['custom.matchedCount'] = matchedCount;")
      ..writeln('return matchedCount >= 1;')
      ..writeln('} catch (exception, stack) {')
      ..writeln(exceptionHandlerCode)
      ..writeln('}');
  }

  String _writeValidationCode() {
    final buffer = StringBuffer();

    final fields = extract.fields;

    if (fields?.isEmpty ?? true) {
      buffer.writeln('matchedCount++;');
    } else {
      buffer.write('if (');
      for (var i = 0; i < fields!.length; i++) {
        buffer.write(
          getValidationCodeFromExtract(
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

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    super.writeDescribeMismatchMethod(stringBuffer);

    stringBuffer
      ..writeln("if(matchState['custom.matchedCount'] <= 0) {")
      ..writeln(
        """mismatchDescription.add('found zero ${extract.className} widgets but at least one was expected');""",
      )
      ..writeln('}')
      ..writeln("final finder = matchState['custom.finder'];")
      ..writeln('final widget = finder.evaluate().first.widget;')
      ..writeAll(
        extract.fields?.map(
              (e) {
                final isBool = e.type!.isDartCoreBool;
                final defaultValue = getDefaultValueForDartType(e.type!);

                final entityCode = 'widget.${e.name}${e.isMethod ? '()' : ''}';

                var code = '';
                code +=
                    '''if(!$entityCode${!isBool ? '!= $defaultValue' : ''}) {\n''';
                code +=
                    """mismatchDescription.add('${e.name} is ${isBool ? 'false' : entityCode} but ${isBool ? true : defaultValue} was expected');\n""";
                code += '}\n';

                return code;
              },
            ) ??
            [],
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}
