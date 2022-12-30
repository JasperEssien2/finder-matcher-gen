---
layout: default
title: Quick Start
---

## Add to project
To get started, run the following command on your terminal:

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

## Annotation usage
Finder-matcher-gen makes use of annotation declarations to generate code. There are two annotations provided by this tool: `@Match` and `@MatchDeclaration`.

### @Match annotation
Apply `@Match` annotation to a declaration, usually the test `main()` function to specify widgets to generate a finder or matcher counterpart.

```dart
@Match(finders: [], matchers: [])
void main() {
    //Test code in here
}
```

The `@MatchAnnotation` accepts two parameters: a list of `Type` for finders; a list of `MatchWidget` for matchers.

#### Finders
For a widget named `TrafficLightLampWidget` pass the type of the widget to the finders param of `@Match` annotation to generate a finder counterpart .

```dart
@Match(finders: [TrafficLightLampWidget])
```
> You can pass any number of widget type to the `finders` param to generate a finder counterpart.

#### Matcher
Pass a list of `MatchWidget` to the `matchers` param. `MatchWidgets` accepts three params.

- A required `type`: The runtime representation of *this* widget to generate a matcher counterpart.

- A required `matchSpecification`: An enum of `MatchSpecification` to define the kind of Matcher to generate for this widget.

- An optional `secondaryType`: The runtime representation of another widget that this Matcher will utilise.

    > Some Matcher specifications involves a different widget. For example, to generate a matcher that asserts if `WidgetA` is contained in `WidgetB`, `WidgetB` will be passed as the `secondaryType`. 

To learn more on the different match specification you can set, click [here](https://jasperessien2.github.io/finder-matcher-gen/generate-matcher).

### @MatchDeclaration annotation
In most cases, declarations (*getters*, *fields*, *functions*) defined in a widget are an essential part of the widget identity. In other words, they will be used for assertion test code.

Annotate widget fields, getters, or functions with `@MatchDeclaration` to let this tool utilise them for validation code. The `@MatchDeclaration` annotation accepts a `defaultValue` argument used to assert this declaration. If none is provided, a constructor field for this declaration will be added to the generated code.

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

A common pitfall while using this annotation is passing a wrong data type (*different from the data type of annotated declaration*) to the `defaultValue`. Fortunately, this package provides static analysis to throw an error when you make these kind of mistakes.

> **Note:** The annotation `@MatchDeclaration` can only be used on *getters*, *fields*, and *non-void methods*

## Generate code

### Limitations
- Can only generate Matcher for widget classes
- Annotated declarations in the State class of a Stateful widget is ignored.

Head over to the github page to request for a feature or see existing issues.