---
layout: page
title: Generate Matcher 
permalink: matcher
id: generate-matcher
previous_page: generate-finder
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
A `${my_test_file}.matchers.dart` is created after a successful build_runner build. It contains generated custom matcher code. The generated custom matchers are private by default and expose a global variable or function for use.

You can generate different matchers for the same widget, by passing different instances of `MatchWidget` with same widget type and different `MatchSpecification` to the `@Match` annotation.

```dart
@Match(matchers: [ 
    MatchWidget(MyWidget, MatchSpecification.matchesOneWidget),
    MatchWidget(MyWidget, MatchSpecification.hasAncestorOf, secondaryType: Dialog),
])
void main() {
    //Test code in here
}
```

### Match specifications 
There are several test cases to assert a widget. The enum `MatchSpecification` is provided to specify the generated matcher assertion case. The following sections summarises the `MatchSpecification` values that can be set.

#### One widget matcher
Set `MatchSpecification.matchesOneWidget` to generate a matcher that asserts **exactly one** widget with specified properties is found in the widget tree.

The code below shows the format of the exposed function or variable:

```dart
final matchesOneMyWidget = _MyWidgetOneMatcher();
```
> Where `MyWidget` is the name of the widget

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesOneMyWidget);
```

#### No widget matcher
Set `MatchSpecification.matchesNoWidget` to generate a matcher that asserts **no** widget with specified properties is found in the widget tree.

The code below shows the format of the exposed function or variable:

```dart
final matchesNoMyWidget = _MyWidgetNoneMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesNoMyWidget);
```

#### At least one widget matcher
Set `MatchSpecification.matchesAtleastOneWidget` to generate a matcher that asserts **at least one** widget with specified properties is found in the widget tree.

The code below shows the format of the exposed function or variable:

```dart
final matchesAtleastOneMyWidget = _MyWidgetAtleastOneMatcher();
```

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, matchesAtleastOneMyWidget);
```

#### N widget matcher
Set `MatchSpecification.matchesNWidget` to generate a matcher that asserts **N** number of widgets with specified properties are found in the widget tree.

The code below shows the format of the exposed function:

```dart
matchesNMyWidget(required int n) => _MyWidgetNMatcher(n: n);
```

##### Usage
Pass generated matcher to the second param of the `expect()` function passing in the expected count of widgets.

```dart
expect(finder, matchesNMyWidget(n: 5));
```

#### Has ancestor matcher
Set `MatchSpecification.hasAncestorOf` to generate a matcher that asserts `MyWidget` is in another specified widget.

By setting this specification, the `secondaryType` cannot be null. Pass the potential ancestor widget type as the `secondaryType` argument to the `MatchWidget` object.

The code below shows the format of the exposed function or variable:

```dart
final myWidgetHasAncestorOfParentWidget = _MyWidgetHasAncestorOfParentWidgetMatcher();
```

> Where `ParentWidget` is the potential ancestor widget type.

##### Usage
Pass generated matcher to the second param of the `expect()` function.

```dart
expect(finder, myWidgetHasAncestorOfParentWidget);
```

#### No ancestor matcher
Set `MatchSpecification.doesNotHaveAncestorOf` to generate a matcher that asserts that `MyWidget` is not in the specified widget.

By setting this specification, the `secondaryType` cannot be null. Pass the potential ancestor widget type as the `secondaryType` argument to the `MatchWidget` object.

The code below shows the format of the exposed function or variable:

```dart
final myWidgetDoesNotHaveAncestorOfParentWidget = _MyWidgetHasNoAncestorOfParentWidgetMatcher();
```
> Where `ParentWidget` is the potential ancestor widget type.

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

### Handling Exceptions
While running the command to generate files, you might encounter some build failures. The table below summarises the exceptions that are likely to be thrown during development to better equip you in resolving them.
|Triggers| Message|
|------|------|
|Passing a non-widget class type to `@Match` annotation|Unsupported class: Matcher can only be generated for widgets|
|Applying `@MatchDeclaration` annotation on a method with parameters|Unsupported: annotated method should have no parameter|
|Applying `@MatchDeclaration` annotation on a private declaration|Unsupported access modifier: Cannot utilise a private declaration|
|Applying `@MatchDeclaration` annotation to a declaration that isn’t a field, getter, or method |Unsupported entity annotated: Apply annotations to Fields, Methods, or Getters only|


To request a feature or file an issue check out the [GitHub page](https://github.com/JasperEssien2/finder-matcher-gen/issues).

