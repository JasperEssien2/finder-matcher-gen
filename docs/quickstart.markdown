---
layout: page
title: Quick Start
permalink: quickstart
id: quickstart
next_page: generate-finder
previous_page: overview
---

To get started add this package to your codebase.

## Add to project
Run the following command on your terminal:

```
flutter pub add finder_matcher_annotation
```

```
flutter pub add finder_matcher_gen --dev
```

```
flutter pub add build_runner --dev
```

Or add it manually to your pubspec.yaml file.

```yaml
dependencies:
  finder_matcher_annotation: ^[version]

dev_dependencies:
  finder_matcher_gen: ^[version]
  build_runner: ^[version]
```

Run the command below to install.

```
flutter pub get
```

Copy and paste the code below into your test file to import.

```dart
 import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
```

## Annotation usage
Finder-matcher-gen makes use of annotation declarations to generate code. This tool provides two annotations: `@Match` and `@MatchDeclaration` annotations.

### @Match annotation
Apply `@Match` annotation to a declaration, usually, the test `main()` function to specify widgets to generate a finder or matcher counterpart.

```dart
@Match(finders: [], matchers: [])
void main() {
    //Test code in here
}
```

The `@Match` annotation accepts two parameters: a list of `Type` for finders; a list of `MatchWidget` for matchers.

#### Finders
For a widget named `TrafficLightLampWidget` pass the type of the widget to the finders param of the `@Match` annotation to generate a finder counterpart.

```dart
@Match(finders: [TrafficLightLampWidget])
```
> You can pass any number of widget types to the `finders` param to generate a finder counterpart.

#### Matcher
Pass a list of `MatchWidget` to the `matchers` param. `MatchWidgets` accepts three params.

- A required `type`: The runtime representation of *this* widget to generate a matcher counterpart.

- A required `matchSpecification`: An enum of `MatchSpecification` to define the kind of Matcher to generate for this widget.

- An optional `secondaryType`: The runtime representation of another widget that this Matcher will utilise.

    > Some Matcher specifications involve a different widget. For example, to generate a matcher that asserts if `WidgetA` is contained in `WidgetB`, `WidgetB` will be passed as the `secondaryType`. 

```dart
@Match(matchers: [ 
    MatchWidget(TrafficLightLampWidget, MatchSpecification.matchesOneWidget),
])
```

To learn more about the different match specifications you can set, click [here](https://jasperessien2.github.io/finder-matcher-gen/generate-matcher).

### @MatchDeclaration annotation
In most cases, declarations (*getters*, *fields*, *functions*) defined in a widget are essential to the widget’s identity. In other words, they will be used for asserting *this* widget behaviour.

Annotate widget fields, getters, or functions with `@MatchDeclaration` to mark them for use in the validation code. The `@MatchDeclaration` annotation accepts a `defaultValue` argument used to compare to the actual value of the widget found in the test environment. A constructor field for this declaration will be added to the generated code if no default value is provided.

```dart
class RedTrafficLightLampWidget extends StatelessWidget{

    @MatchDeclaration()
    final Color lightColor;

    @MatchDeclaration(defaultValue: 'STOP')
    final String text;
} 
```

The code below highlights the result of providing a default value and otherwise.

```dart
/// Where `_lightColor` is a constructor field of this generated code
return widget.lightColor == _lightColor && widget.text == 'STOP';
```

### Linting
A common pitfall while using this annotation is passing a wrong data type (*different from the data type of the annotated property*) to the `defaultValue`.

Fortunately, this package provides static analysis to throw an error when this kind of mistake is made.

> **Note:** The annotation `@MatchDeclaration` can only be used on *getters*, *fields*, and *non-void methods*

## Generate code
Run the command below to generate the custom finder and matcher code.

```
flutter pub run build_runner build
```

After a successful run, you should notice two newly generated files.

- A `${my_test_file}.finders.dart` file containing generated finders.
- A `${my_test_file}.matchers.dart` file containing generated matchers.

For more information, see [generate section](https://jasperessien2.github.io/finder-matcher-gen/finder) to explore how to use generated files.

## Limitations
There are some current limitations concerning this tool. Here are some:
- Can only generate Matcher for widget classes.
- Annotated declarations in the State class of a Stateful widget are ignored.

 To request a feature or file an issue check out the [GitHub page](https://github.com/JasperEssien2/finder-matcher-gen/issues).
