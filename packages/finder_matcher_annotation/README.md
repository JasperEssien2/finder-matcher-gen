
# Finder Matcher Gen
❗ **This package contains annotations for [finder_matcher_gen](https://pub.dev/packages/finder_matcher_gen). You cannot use this package independently of [finder_matcher_gen](https://pub.dev/packages/finder_matcher_gen).**



- [Motivation  ✨](#motivation---)
- [Installation 💻](#installation---)
- [Annotation usage 🎮](#annotation-usage)
  * [@Match annotation](#-match-annotation)
    + [Finders 🔍](#finders)
    + [Matcher](#matcher)
  * [@MatchDeclaration annotation](#-matchdeclaration-annotation)
  * [Linting](#linting)
- [Generate code](#generate-code)
  * [Configure generation for integration tests](#configure-generation-for-integration-tests)
- [Detailed Documentation 📄](#detailed-documentation)
- [Bugs/Request 🐛](#bugsrequest)
- [Continuous Integration 🤖](#continuous-integration---)
- [Running Tests 🧪](#running-tests---)


[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Flutter package for generating custom Finder and Matcher for widget tests. Not sure what a Matcher or Finder is? Visit finder-matcher-gen [documentation](https://jasperessien2.github.io/finder-matcher-gen/).


## ✨ Motivation
I find myself writing custom Finder and Matcher to abstract validation code for widget/integration tests. Implementing these can be tedious.

Finder-Matcher-Gen tries to fix this by implementing these custom classes for you.

||Before|After|
|---|---|---|
|**Finder**|![before-finder](https://raw.githubusercontent.com/jasperessien2/finder-matcher-gen/master/resources/before-finder.png)|![after-finder](https://raw.githubusercontent.com/jasperessien2/finder-matcher-gen/master/resources/after-finder.png)|
|**Matcher**|![before-matcher](https://raw.githubusercontent.com/jasperessien2/finder-matcher-gen/master/resources/before-matcher.png)|![after-matcher](https://raw.githubusercontent.com/jasperessien2/finder-matcher-gen/master/resources/after-matcher.png)|

## 💻 Installation 

**❗ In order to start using Finder Matcher Gen you must have the [Dart SDK][dart_install_link] installed on your machine.**

Add `finder_matcher_gen` to your `pubspec.yaml`:

Run the following command on your terminal:

```sh
flutter pub add finder_matcher_annotation
```

```sh
flutter pub add finder_matcher_gen --dev
```

```sh
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

Install it:

```sh
flutter pub get
```

Copy and paste the code below into your test file to import.

```dart
 import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
```

---


## 🚀 Annotation usage
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

## 🏭 Generate code
Run the command below to generate the custom finder and matcher code.

```
flutter pub run build_runner build
```

After a successful run, you should notice two newly generated files.

- A `${my_test_file}.finders.dart` file containing generated finders.
- A `${my_test_file}.matchers.dart` file containing generated matchers.

For more information, see [generate section](https://jasperessien2.github.io/finder-matcher-gen/finder) to explore how to use generated files.

### Configure generation for integration tests
Create a `build.yaml` file in the top-level folder of your project. Insert the code below in the newly created file.

```yaml
targets:
  $default:
    sources:
      - integration_test/**
      - lib/**
      - test/**
      # Note that it is important to include these in the default target.
      - pubspec.*
      - $package$
 
```
> You can also include custom folders where you need to generate matchers and finders. 

---
## 📄 Detailed Documentation

For more detailed information of using this tool, visit the [documentation](https://jasperessien2.github.io/finder-matcher-gen/).

---

## 🐛 Bugs/Request

If you encounter any problems feel free to open an issue. If you feel the library is missing a feature, please raise a ticket on Github and I'll look into it. Pull requests are also welcomed.

---

## 🤖 Continuous Integration 

Finder Matcher Gen comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

<!-- ## 🧪 Running Tests 

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

-->

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
