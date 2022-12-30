---
layout: default
title: Finder Generation 
---

Generated Finders are located in `${my_test_file}.finders.dart`. The generated custom Finders are private by default and exposes a global variable for use.

### Naming convention
The generated custom Finder classes follows the pattern widget name appended with the text 'MatchFinder'.

```dart
class _MyWidgetMatchFinder extends MatchFinder{
    //Generated code 
}
```
 
The exposed global variable is named with a suffix 'find' followed by the widget name.

```dart
final findMyWidget = __MyWidgetMatchFinder();
```

### Generic support

### Usage