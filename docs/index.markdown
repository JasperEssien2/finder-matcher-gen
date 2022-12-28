---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
title: Overview
---

Finder-Matcher Gen is an open source project that allows you to generate custom `Finder` and `Matcher` classes by using annotations.

It is a companion tool for writing widget and integration tests. Before diving into why you should use this tool, we need to understand what `Finder` and `Matcher` is in Flutter.

### What is a Finder
Finder searches a widget tree for widgets with specified patterns. You've probably have been using Finders all along. These codes: `find.byWidget(widget)` and `find.text('title')` uses the `Finder` class under the hood.

When writing widget and integration tests, you pass and instance of a subclass of `Finder` as the first argument of the `expect()` function.

```dart
expect(find.text('title'), findsOneWidget);
```

The `expect()` paramter accepts a `Matcher` as the second parameter.

### What is a Matcher

### Why should you use Finder-Matcher Gen

It aims to accomplish the following: 
- Speed up writing widget and integration test logic 
- Make widget and  integrations test concise and readable
