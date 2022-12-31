---
layout: page
title: Generate Matcher 

---
Annotate the `main()` function of your test file with the `@Match` annotation. Pass a list of `MatchWidget` to the `matchers` param to generate a matcher counterpart.

```dart
@Match(matchers: [ 
    MatchWidget(MyWidget, MatchSpecification.hasAncestorOf, secondaryType: Dialog),
])
void main() {
    //Test code in here
}
```
A `${my_test_file}.matchers.dart` file containing generated custom matcher classes is created after running the generation command. The generated custom matchers are private by default and expose a global variable or function for use.

### Match specifications 
There are a number of cases you can assert a widget with. The enum `MatchSpecification` is provided to specify the generated matcher assertion behaviour. The table below summarises the `MatchSpecification` values that can be set.

#### One widget matcher
Set `MatchSpecification.matchesOneWidget` to generate a matcher that asserts **exactly one** widget with specified properties is found in the widget tree. Throw an error otherwise.

The generated code header follows the pattern:

```dart
final matchesOneMyWidget = _MyWidgetOneMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesOneMyWidget);
```

#### No widget matcher
Set `MatchSpecification.matchesNoWidget` to generate a matcher that asserts **no** widget with specified properties is found in the widget tree. Throw an error otherwise.

The generated global function follows the pattern:

```dart
final matchesNoMyWidget = _MyWidgetNoneMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesNoMyWidget);
```

#### Atleast one widget matcher
Set `MatchSpecification.matchesAtleastOneWidget` to generate a matcher that asserts **atleast one** widget with specified properties is found in the widget tree. Throw an error otherwise.

The generated global function follows the pattern:

```dart
final matchesAtleastOneMyWidget = _MyWidgetAtleastOneMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesAtleastOneMyWidget);
```

#### N widget matcher
Set `MatchSpecification.matchesNWidget` to generate a matcher that asserts **N** number of widget with specified properties is found in the widget tree. Throw an error otherwise.

The generated global function follows the pattern:

```dart
matchesNMyWidget(required int n) => _MyWidgetNMatcher(n: n);
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesNMyWidget(n: 5));
```

#### Has ancestor of widget matcher
Set `MatchSpecification.hasAncestorOf` to generate a matcher that asserts has a widget has a parent of specified widget. Throw an error otherwise.

By setting `MatchSpecification.hasAncestorOf` the `secondaryType` cannot be null. Pass the ancestor type as the `secondaryType` to `MatchWidget` object.

The generated global function follows the pattern:

```dart
final myWidgetHasAncestorOfParentWidget = _MyWidgetHasAncestorOfParentWidgetMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, myWidgetHasAncestorOfParentWidget);
```

#### No ancestor of widget matcher
Set `MatchSpecification.doesNotHaveAncestorOf` to generate a matcher that asserts that a widget does not have a parent of specified widget. Throw an error otherwise.

By setting `MatchSpecification.doesNotHaveAncestorOf` the `secondaryType` cannot be null. Pass the ancestor type as the `secondaryType` to `MatchWidget` object.

The generated global function follows the pattern:

```dart
final myWidgetDoesNotHaveAncestorOfParentWidget = _MyWidgetHasNoAncestorOfParentWidgetMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, myWidgetDoesNotHaveAncestorOfParentWidget);
```


### Annotated declarations
The generated code will contain a constructor field for every declaration marked without a default value.

```dart
matchesOneMyWidget(String text) => _MyWidgetOneMatcher(text: text);

class _MyWidgetOneMatcher extends Matcher {
  _MyWidgetOneMatcher({
    required String text,
  })  : _text = text;

  final String _text;
  
  ...
}
```
### Generic widget support
In cases of a generic type widget, finder-gen-matcher takes this into account.

Assuming we have a generic widget.

```dart
class MyGenericWidget<K, V> extends StatelessWidget {
    /// Widget code
}
```

The generated code header output will be:

```dart
matchesOneMyGenericWidget<K, V>() => _MyGenericWidgetOneMatcher<K, V>();
```

 To request a feature or file an issue check out the [GitHub page](https://github.com/JasperEssien2/finder-matcher-gen/issues).
