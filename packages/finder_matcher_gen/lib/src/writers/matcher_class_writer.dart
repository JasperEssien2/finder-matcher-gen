import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:finder_matcher_gen/src/generators/matcher_generator.dart';
import 'package:finder_matcher_gen/src/models/class_extract_model.dart';
import 'package:finder_matcher_gen/src/models/override_method_model.dart';
import 'package:finder_matcher_gen/src/utils/utils_export.dart';
import 'package:finder_matcher_gen/src/writers/writers_export.dart';
import 'package:meta/meta.dart';

///Builds Matcher classes string code for widgets
class WidgetMatcherClassWriter extends ClassCodeWriter {
  /// Accepts a [ClassElementExtract] and [MatchSpecification]
  /// The [MatchSpecification] an enum specifies the count the generated Matcher
  /// should validate as "matched"
  WidgetMatcherClassWriter(
    super.classExtract,
    MatcherGeneratorSpecification specification,
  ) : _specification = specification;

  final MatcherGeneratorSpecification _specification;

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
    switch (_specification.specification) {
      case MatchSpecification.matchesNoWidget:
        return MatchNoWidgetMethodsBuilder(classExtract);
      case MatchSpecification.matchesAtleastOneWidget:
        return MatchAtleastOneWidgetMethodsBuilder(classExtract);
      case MatchSpecification.matchesNWidgets:
        return MatchNWidgetMethodsBuilder(classExtract);

      case MatchSpecification.matchesOneWidget:
        return MatchOneWidgetMethodsBuilder(classExtract);
      case MatchSpecification.hasAncestorOf:
        return MatchHasAncestorOfWidgetMethodsBuilder(
          classExtract,
          ancestorType: _specification.secondaryType!,
        );
      case MatchSpecification.doesNotHaveAncestorOf:
        return MatchHasNoAncestorOfWidgetMethodsBuilder(
          classExtract,
          ancestorType: _specification.secondaryType!,
        );
    }
  }

  @override
  String get extendsName => 'Matcher';

  @override
  String get classNameSuffix => _specification.matcherSuffix;
}

/// A base class for writing Matcher override methods code to [StringBuffer]
abstract class BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  BaseMatcherMethodsCodeBuilder(
    this.extract,
  );

  /// [ClassElementExtract] contains extracted information from [ClassElement]
  final ClassElementExtract extract;

  /// Responsible for writing matches() method into [StringBuffer]
  void writeMatchesMethod(StringBuffer stringBuffer);

  /// Responsible for writing describe() method into [StringBuffer]
  void writeDescribeMethod(StringBuffer stringBuffer);

  /// Responsible for writing describeMismatch() method into [StringBuffer]
  void writeDescribeMismatchMethod(StringBuffer stringBuffer);
}

/// A base class for writing Matcher override methods code to [StringBuffer]
abstract class BaseMatcherCountMethodsCodeBuilder
    extends BaseMatcherMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  BaseMatcherCountMethodsCodeBuilder(
    super.extract,
  );

  /// Class name
  String get className;

  /// Describes how many widgets were expected
  String get expectCount;

  /// Responsible for writing describe() into [StringBuffer]
  @override
  void writeDescribeMethod(StringBuffer stringBuffer) {
    stringBuffer.writeln(
      """return description.add('matches $expectCount $className widget');""",
    );
  }

  /// Responsible for writing matches() into [StringBuffer]
  @override
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("matchState['custom.finder'] = finder;\n")
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
      ..writeln(matchReturnStatement);
  }

  String _writeValidationCode() {
    final buffer = StringBuffer();

    final fields = extract.declarations;

    if (fields?.isEmpty ?? true) {
      buffer.writeln('matchedCount++;');
    } else {
      buffer
        ..writeln('final widget = element.widget as ${extract.className};\n')
        ..writeln('var expectedDeclarationCount = 0;\n');

      for (var i = 0; i < fields!.length; i++) {
        buffer.write(
          getMatcherConditionCodeFromExtract(
            fields[i],
            last: i == fields.length - 1,
            declarationCount: fields.length,
          ),
        );
      }
    }

    return buffer.toString();
  }

  /// Returns the string code that uses the match count to validate if
  /// this widget (and it's pr) was found
  String get matchReturnStatement;

  /// Responsible for writing describeMismatch() into [StringBuffer]
  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer);

  /// Start mismatch description text
  String get mismatchSymbol => '---';
}

/// Builds matcher method that asserts only one widget is matched
class MatchOneWidgetMethodsBuilder extends BaseMatcherCountMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchOneWidgetMethodsBuilder(super.extract);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'one';

  @override
  String get matchReturnStatement => 'return matchedCount == 1;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if((matchState['custom.count'] ?? 0) <= 0) {")
      ..writeln(
        """mismatchDescription.add('$mismatchSymbol zero ${extract.className} widgets found but one was expected\\n\\n');""",
      )
      ..writeln('}\n')
      ..writeln("else if(matchState['custom.count'] > 1) {")
      ..writeln(
        """mismatchDescription.add('$mismatchSymbol found multiple ${extract.className} widgets but one was expected\\n\\n');""",
      )
      ..writeln('}\n')
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(extract.declarations ?? []),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that asserts at least one widget is matched
class MatchAtleastOneWidgetMethodsBuilder
    extends BaseMatcherCountMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchAtleastOneWidgetMethodsBuilder(super.extract);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'atleast one';

  @override
  String get matchReturnStatement => 'return matchedCount >= 1;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if(matchState['custom.matchedCount'] <= 0) {")
      ..writeln(
        """mismatchDescription.add('$mismatchSymbol found zero ${extract.className} widgets but at least one was expected\\n\\n');""",
      )
      ..writeln('}\n')
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(extract.declarations ?? []),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that asserts exact N number of widgets is matched
class MatchNWidgetMethodsBuilder extends BaseMatcherCountMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchNWidgetMethodsBuilder(super.extract);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => r'$_n';

  @override
  String get matchReturnStatement => 'return matchedCount == _n;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if(matchState['custom.matchedCount'] != _n) {")
      ..writeln(
        """mismatchDescription.add('$mismatchSymbol found \${matchState['custom.matchedCount']} ${extract.className} widgets \$_n was expected\\n\\n');""",
      )
      ..writeln('}\n')
      ..writeAll(
        getMatchOneDeclarationsMismatchCheckCode(extract.declarations ?? []),
        '\n',
      )
      ..writeln('return mismatchDescription;');
  }
}

/// Builds matcher method that asserts no widget is matched
class MatchNoWidgetMethodsBuilder extends BaseMatcherCountMethodsCodeBuilder {
  /// Mandatory [ClassElementExtract]
  MatchNoWidgetMethodsBuilder(super.extract);

  @override
  String get className => extract.className!;

  @override
  String get expectCount => 'no';

  @override
  String get matchReturnStatement => 'return matchedCount == 0;';

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln("if(matchState['custom.count'] >= 1) {")
      ..writeln(
        """mismatchDescription.add('$mismatchSymbol zero ${extract.className} widgets expected but found \${matchState['custom.count'] ?? 0}\\n\\n');""",
      )
      ..writeln('}')
      ..writeln('return mismatchDescription;');
  }
}

@visibleForTesting
// ignore: public_member_api_docs
Iterable<String> getMatchOneDeclarationsMismatchCheckCode(
  List<DeclarationExtract> declarations,
) {
  return declarations.map(
    (e) {
      final entityCode = '''widget.${e.name}${e.isMethod ? '()' : ''}''';

      var code = '';

      code +=
          ''' if(matchState['$entityCode-found'] != null && matchState['$entityCode-expected'] != null){''';

      code +=
          """mismatchDescription.add("--- ${e.name} is \${matchState['$entityCode-found']} but \${matchState['$entityCode-expected']} was expected \\n\\n");\n""";

      return code += '}\n\n';
    },
  );
}

/// Builds a Matcher that asserts a single widget is in the specified widget
class MatchHasAncestorOfWidgetMethodsBuilder
    extends BaseMatcherMethodsCodeBuilder {
  /// A mandatory [ClassElementExtract]
  /// The ancestor widget to check
  MatchHasAncestorOfWidgetMethodsBuilder(
    super.extract, {
    required this.ancestorType,
  });

  ///[ancestorType]
  final DartType ancestorType;

  @override
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln(
        '''bool predicate(widget) => widget.runtimeType == ${ancestorType.dartTypeStrWithGeneric};\n''',
      )
      ..writeln('final nodes = finder.evaluate();\n')
      ..writeln('if(nodes.length != 1){')
      ..writeln('''matchState['custom.length'] = nodes.length;''')
      ..writeln('return false;')
      ..writeln('}\n')
      ..writeln('bool result = false;\n')
      ..writeln('nodes.single.visitAncestorElements((Element ancestor) {')
      ..writeln('if (predicate(ancestor.widget)) {')
      ..writeln('result = true;')
      ..writeln('return false;')
      ..writeln('}')
      ..writeln('return true;')
      ..writeln('});\n')
      ..writeln('''matchState['custom.ancestorOf'] = result;''')
      ..writeln('return result;');
  }

  @override
  void writeDescribeMethod(StringBuffer stringBuffer) {
    stringBuffer.write(
      """return description.add('${extract.className} is in ${ancestorType.dartTypeStrWithGeneric}');""",
    );
  }

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln(
        """if(matchState.containsKey('custom.length') && matchState['custom.length'] > 1) {""",
      )
      ..writeln(
        """mismatchDescription.add('--- Found more than one ${extract.className} widgets, 1 was expected but found \${matchState['custom.length'] ?? 0}\\n\\n');""",
      )
      ..writeln('}')
      ..writeln(
        """if(matchState.containsKey('custom.ancestorOf') && !matchState['custom.ancestorOf']) {""",
      )
      ..writeln(
        """mismatchDescription.add('--- ${extract.className} is not contained in ${ancestorType.dartTypeStrWithGeneric}\\n\\n');""",
      )
      ..writeln('}')
      ..writeln('return mismatchDescription;');
  }
}

/// Builds a Matcher that asserts a single widget is not in the specified widget
class MatchHasNoAncestorOfWidgetMethodsBuilder
    extends BaseMatcherMethodsCodeBuilder {
  /// A mandatory [ClassElementExtract]
  /// The ancestor widget to check
  MatchHasNoAncestorOfWidgetMethodsBuilder(
    super.extract, {
    required this.ancestorType,
  });

  ///[ancestorType]
  final DartType ancestorType;

  @override
  void writeMatchesMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln(
        '''bool predicate(widget) => widget.runtimeType == ${ancestorType.dartTypeStrWithGeneric};\n''',
      )
      ..writeln('final nodes = finder.evaluate();\n')
      ..writeln('if(nodes.length != 1){')
      ..writeln('''matchState['custom.length'] = nodes.length;''')
      ..writeln('return false;')
      ..writeln('}\n')
      ..writeln('bool found = false;\n')
      ..writeln('nodes.single.visitAncestorElements((Element ancestor) {')
      ..writeln('if (predicate(ancestor.widget)) {')
      ..writeln('found = true;')
      ..writeln('return false;')
      ..writeln('}')
      ..writeln('return true;')
      ..writeln('});\n')
      ..writeln('''matchState['custom.foundAncestor'] = found;''')
      ..writeln('return !found;');
  }

  @override
  void writeDescribeMethod(StringBuffer stringBuffer) {
    stringBuffer.write(
      """return description.add('${extract.className} is in ${ancestorType.dartTypeStrWithGeneric}');""",
    );
  }

  @override
  void writeDescribeMismatchMethod(StringBuffer stringBuffer) {
    stringBuffer
      ..writeln(
        """if(matchState.containsKey('custom.length') && matchState['custom.length'] > 1) {""",
      )
      ..writeln(
        """mismatchDescription.add('--- Found more than one ${extract.className} widgets, 1 was expected but found \${matchState['custom.length'] ?? 0}\\n\\n');""",
      )
      ..writeln('}')
      ..writeln(
        """if(matchState.containsKey('custom.foundAncestor') && matchState['custom.foundAncestor']) {""",
      )
      ..writeln(
        """mismatchDescription.add('--- ${extract.className} found in ${ancestorType.dartTypeStrWithGeneric} but expected otherwise\\n\\n');""",
      )
      ..writeln('}')
      ..writeln('return mismatchDescription;');
  }
}
