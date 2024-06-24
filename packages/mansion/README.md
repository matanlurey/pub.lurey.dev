# Mansion

A stately library for crafting and deciphering ANSI escape codes.

[![CI](https://github.com/matanlurey/mansion/actions/workflows/ci.yaml/badge.svg)](https://github.com/matanlurey/mansion/actions/workflows/ci.yaml)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/mansion/badge.svg?branch=main)](https://coveralls.io/github/matanlurey/mansion?branch=main)
[![Pub Package](https://img.shields.io/pub/v/mansion.svg)](https://pub.dev/packages/mansion)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/mansion/latest/)

![Demo](https://github.com/asciinema/agg/assets/168174/6832d773-22f9-47b9-a83c-0e6f260da849)

Styling text is ~1-line with lots of possibilities:

```dart
print('Hello World'.style(Style.foreground(Color.red), Style.bold));
```

When you're ready, graduate to a full-featured package for more control:

```dart
stdout.writeAnsiAll([
  // Sets the cursor position to the top-left corner.
  CursorPosition.reset,

  // Clear the screen.
  Clear.all,

  // Set a bunch of styles.
  SetStyles(
    Style.bold,
    Style.underline,
    Style.italic,
    Style.foreground(Color.red),
    Style.background(Color.green),
  ),

  // Print some text.
  Print('Hello, World!'),

  // Reset all styles.
  SetStyles.reset,

  // Move the cursor to the next line.
  AsciiControl.lineFeed,
]);
```

Includes a full-featured ANSI escape _decoder_ for writing terminal emulators!

## Features

- Cross-platform support for most popular ANSI escape codes.
- Fully tested and documented with examples and explanations.
- Walkthroughs for common use-cases and best practices.
- Intuitive API using the latest Dart features.
- Practically _zero_ dependencies (only `meta` for annotations).

Importantly, `mansion` is _not_ a general purpose terminal library; it does not
provide terminal emulation, any real input handling other than event code
parsing, anything to do with FFI or native code, or any other terminal-related
functionality.

Build on top of `mansion` to create your own terminal libraries, or use it to
style text in your command-line applications.

## Contributing

To run the tests, run:

```shell
dart test
```

To check code coverage locally, run:

```shell
dart tool/coverage.dart
```

To preview `dartdoc` output locally, run:

```shell
dart tool/dartdoc.dart
```
