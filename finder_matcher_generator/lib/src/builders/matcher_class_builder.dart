import 'package:finder_matcher_generator/src/builders/builders_export.dart';
import 'package:finder_matcher_generator/src/models/override_method_model.dart';

class MatcherClassBuilder extends ClassCodeBuilder {
  MatcherClassBuilder(super.classExtract);

  @override

  List<OverrideMethodModel> get methodsToOverride => throw UnimplementedError();

  @override
  // TODO: implement suffix
  String get suffix => throw UnimplementedError();
}
