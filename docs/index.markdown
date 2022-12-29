---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Overview
---
Finder-Matcher Gen is an open-source project that allows you to generate custom `Finder` and `Matcher` classes using annotations.

It is a companion tool for writing widget and integration tests. Before diving into why you should use this tool, it is essential to understand what `Finder` and `Matcher` is in Flutter.

### What is a Finder
Finder searches a widget tree for widgets that meets certain requirements or pattern. If you've written widget or integration tests before, you've most likely used Finders. The function call `find.byType(type)` and `find.text('title')` uses an implementation of the `Finder` class to locate widgets by type and text respectively.

Assume you have a widget named `TrafficLightWidget` that replicates an actual traffic light:

```dart
class TrafficLightWidget extends StatelessWidget {
  const TrafficLightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TrafficLightLampWidget(
          color: Colors.red,
          text: 'STOP',
          openBarricade: false,
        ),
         TrafficLightLampWidget(
          color: Colors.green,
          text: 'GO',
          openBarricade: true,
        ),
      ],
    );
  }
}

class TrafficLightLampWidget extends StatelessWidget {
  const TrafficLightLampWidget({
    super.key,
    required this.color,
    required this.text,
    required this.openBarricade,
  });

  final Color color;
  final String text;
  final bool openBarricade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundColor: color),
        Text(text),
      ],
    );
  }
}
```

Your widget test should assert that the red and green `TrafficLightLampWidget` is contained in the widget tree.

In this scenario, using `find.byType(TrafficLightLampWidget)` isn’t ideal, because two widgets with the same type are in the widget tree.

Without a custom Finder, your find code will probably be written as:

```dart
  testWidgets('Ensure red and green light widget exists',
      (WidgetTester tester) async {
  
    await _pumpWidget(tester);

    expect(
      find.byWidgetPredicate((widget) => 
          widget is TrafficLightLampWidget &&
          widget.color == Colors.red &&
          widget.text == 'STOP' &&
          !widget.openBarricade),
      findsOneWidget,
    );

     expect(
      find.byWidgetPredicate((widget) =>
          widget is TrafficLightLampWidget &&
          widget.color == Colors.green &&
          widget.text == 'GO' &&
          widget.openBarricade),
      findsOneWidget,
    );
  
  });
```

By introducing a custom Finder the test can be simplified to

```dart
  testWidgets('Ensure red and green light widget exists',
      (WidgetTester tester) async {
  
    await _pumpWidget(tester);

    expect(RedLightLampFinder(), findsOneWidget);
    expect(GreenLightLampFinder(), findsOneWidget);
  
  });
```

> Notice how introducing a custom Finder makes the code concise and clean.

When writing widget and integration tests, you pass an instance of a subclass of `Finder` as the first argument to the `expect()` function.


```dart
expect(find.text('title'), findsOneWidget);
```

The `expect()` function accepts a `Matcher` as the second parameter.

### What is a Matcher
Matcher makes your test code clean and concise by abstracting validation code.  Assume you have a class named `TrafficLightController` that contains logic to control a traffic light.

```dart

class TrafficLightController{

    final redLight = RedLight();
    final greenLight = GreenLight();

    void stop(){
        redLight.activate();
        greenLight.deactivate();
    }

    void go(){
       greenLight.activate();
       redLight.deactivate();
    }
}

class RedLight extends TrafficLight {
  @override
  Color get lightColor => isActive ? Colors.red : Colors.grey;

  @override
  String? get trafficText => isActive ? 'Stop' : null;

  @override
  bool get isBarricadeClosed => isActive ? true : false;

}
```

You want to write tests to validate that the red and green light behaves correctly when activated or deactivated by invoking the `stop()` or `go()` function.

Without introducing a custom Matcher, your test assertion logic for the above code will probably look like this.

```dart
 test(
    'Test traffic stop',
    () {
        final trafficController = TrafficLightController();

        trafficController.stop();

        expect(trafficController.redLight.lightColor, Colors.red);
        expect(trafficController.redLight.trafficText, 'Stop');
        expect(trafficController.redLight.isBarricadeClosed, true);

        trafficController.go();

        expect(trafficController.redLight.lightColor, Colors.grey);
        expect(trafficController.redLight.trafficText, null);
        expect(trafficController.redLight.isBarricadeClosed, false);

    },
  );    
```
By introducing a custom Matcher you hide (abstract) assertion logic. The test code above can then be refactored to the code below:


```dart
 test(
    'Test traffic stop',
    () {
        final trafficController = TrafficLightController();

        trafficController.stop();
        
        // Where ActiveRedLightMatcher is the name of a custom matcher
        expect(trafficController.redLight, ActiveRedLightMatcher());

        trafficController.go();

        // Where InActiveRedLightMatcher is the name of a custom matcher
        expect(trafficController.redLight, InactiveRedLightMatcher());
    },
  ); 
```

Given that custom finder and matcher aid in writing clean and concise test code, it begs the question, *why should you use this finder-matcher-gen package?*

### Why should you use Finder-Matcher Gen

This package aims to accomplish two things:

1. Speed up writing widget and integration test logic.
2. Make widget and integrations test code concise and readable.

It does this by easing the pain of writing these custom matchers or finders from you as a developer through code generation. 

For a quick start on using this package, go to the [quickstart page](https://jasperessien2.github.io/finder-matcher-gen/quickstart). For a deeper understanding of generating Finder and Matcher classes, go to the [generate finder](https://jasperessien2.github.io/finder-matcher-gen/generate-finder) and [generate matcher](https://jasperessien2.github.io/finder-matcher-gen/generate-matcher) pages.