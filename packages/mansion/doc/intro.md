## Getting Started

To get started, follow the [package installation instructions][install-pkg], or:

```shell
dart pub add mansion
```

[install-pkg]: https://pub.dev/packages/mansion/install

There is only a single library in the package, `mansion`:

```dart
import 'package:mansion/mansion.dart';
```

## What is an ANSI Escape Code?

An ANSI escape code is a sequence of characters that is used to control the formatting, color, and other output options of a text terminal. It is used to control the cursor position, clear the screen, change the text color, and other functions.

For example, the following will print the text "Hello, World!" in red:

```dart
print('\x1B[31mHello, World!\x1B[0m');
```

Above, the escape code `\x1B[31m` sets the text color to red, and the escape
code `\x1B[0m` resets the text color to the default. The characters `\x1B[` are
the escape sequence, and `31` is the color code for red.

For more details, see:

- [Everything you never wanted to know about ANSI escape codes](https://notes.burke.libbey.me/ansi-escape-codes/)
- [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code) on Wikipedia

## Where can I use ANSI Escape Codes?

ANSI escape codes are supported by most modern terminals, including the Windows
10 console, macOS Terminal, and most Linux terminals. They are also supported
by many terminal emulators, such as [Alacritty](https://github.com/alacritty/alacritty), [Hyper](https://hyper.is/), and even in the browser using libraries like [xterm.js](https://xtermjs.org/).

In a Dart command-line application, you can check if ANSI escape codes are
supported by the terminal by using the `supportsAnsiEscapes` getter from the
`dart:io` library:

```dart
import 'dart:io';

void main() {
  if (stdout.supportsAnsiEscapes) {
    print('ANSI escape codes are supported!');
  } else {
    print('ANSI escape codes are not supported.');
  }
}
```

> [!NOTE]
> This is a simple heuristic, and it may not always be accurate.

## Using this library

Now that you have a basic understanding of ANSI escape codes, you can use the
`mansion` library to generate them programmatically, no weird strings required!

The basic building block of the library if the `Sequence` type.

For example, let's create a sequence that just prints 'Hello World':

```dart
import 'dart:io';

import 'package:mansion/mansion.dart';

void main() {
  final sequence = Print('Hello, World!');
  stdout.writeAnsi(sequence);
}
```

This probably doesn't seem all that impressive, after-all we could have just
used `print('Hello, World!')`. But the real power of the library comes from
combining sequences together to create more complex output.

Now let's create a sequence that prints 'Hello, World!' in red:

```dart
import 'dart:io';

import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsiAll([
    SetStyles.foreground(Color.red),
    Print('Hello, World!'),
    SetStyles.reset,
    AsciiControl.lineFeed,
  ]);
}
```

<pre style="background: #000; padding: 10px">
<span style="color: #cd0000">Hello, World!</span>
</pre>

In this example, we use the `SetStyles(Style.foreground(...))` sequence to set
the text color to red, then print 'Hello, World!', then reset the text color
back to the default using `SetStyles.reset`, and finally add a line feed using
`AsciiControl.lineFeed`.

You can combine sequences in any way you like to create complex output. The
library provides a wide range of sequences to control text formatting, colors,
cursor position, and more.

## Where did `writeAnsiAll` come from?

There are a few different ways to convert a `Sequence` to a string. Unlike
some other libraries `toString()` is _not_ used to convert a `Sequence` to a
string (it returns a debug-friendly string instead that describes the sequence).

1. Use `<Sequence>.toAnsiString()` (an _extension method_ on `Sequence`):

   ```dart
   final sequence = Print('Hello, World!');
   print(sequence.toAnsiString());
   ```

   This is the most direct way to convert a `Sequence` to a string, but is not
   the most efficient, especially if you are writing to a buffer or stream. You
   won't see many examples of this in the documentation.

2. Use `<String>.style` (an _extension method_ on `String`):

   ```dart
   print('Hello World'.style(Style.bold, Style.foreground(Color.red)));
   ```

   The easiest way to get started, similar to the APIs of other popular packages
   like `chalk` or `colored`. It is not as flexible as the other methods, and
   doesn't contain every feature of the library but could be good enough for
   simple CLI tools and scripts.

3. Use `<StringSink>.writeAnsi(<Sequence>)` (an _extension method_ on
  `StringSink`):

   ```dart
   final sequence = Print('Hello, World!');
   final buffer = StringBuffer();
   buffer.writeAnsi(sequence);
   print(buffer.toString());
   ```

   This is the most efficient way to convert a `Sequence` to a string, as it
   writes directly to a `StringSink` (which includes [`StringBuffer`][],
   [`Stdout`][], [`IOSink`][], etc.). This is the most common way to convert a
   `Sequence` to a string in the documentation.

   There is also a `writeAnsiAll` method that takes an `Iterable<Sequence>`:

   ```dart
   stdout.writeAnsiAll([
     SetStyles(Style.foreground(Color.red))
     Print('Hello, World!'),
     SetStyles.reset,
     AsciiControl.lineFeed,
   ]);
   ```

   [`StringBuffer`]: https://api.dart.dev/dart-core/StringBuffer-class.html
   [`Stdout`]: https://api.dart.dev/dart-io/Stdout-class.html
   [`IOSink`]: https://api.dart.dev/dart-io/IOSink-class.html

4. Use `AnsiCodec`, `AnsiEncoder` or `encodeAnsi`.

   These are provided mostly for completeness and compatibility with
   `dart:convert` types, and are not particularly useful for general use.

   See [`Parsing ANSI Text`](Parsing%20ANSI%20Text-topic.html) for more
   information.

---

<div style="text-align: center">

[Styles & Colors ►](Styles%20and%20Colors-topic.html)

</a>
