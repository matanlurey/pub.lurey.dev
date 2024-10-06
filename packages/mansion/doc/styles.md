## Styling Text

One of the most popular usages of ANSI escape codes is to decorate text with
different colors, styles, and backgrounds. This can be done using the
`SetStyles` subtype of `Escape` and the `Style` class:

```dart
import 'dart:io';

import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsiAll([
    SetStyles(
      Style.bold,
      Style.underline,
      Style.italic,
      Style.foreground(Color.red),
      Style.background(Color.green),
    ),
    Print('Hello, World!'),
    SetStyles.reset,
    AsciiControl.lineFeed,
  ]);
}
```

<pre style="background: #000; padding: 10px">
<span style="color: #ff0000; background: #00cd00; font-weight: bold; text-decoration: underline; font-style: italic">Hello, World!</span>
</pre>

Styles are in ~3 categories: _colors_, _text styles_, and _resets_.

## Colors

Most modern terminal emulators support the full 24-bit color palette, which
allows for a wide range of colors to be used. Use `Style.foreground` and
`Style.background` to set the text and background colors, respectively:

```dart
SetStyles(Style.foreground(Color.red), Style.background(Color.green))
```

The `Color` class provides a number of predefined colors, but you can also use
the `Color.fromRGB` and `Color.from256` constructors to define custom colors:

```dart
// Sets the foreground to green.
SetStyles(Style.foreground(Color.fromRGB(0x00, 0xff, 0x00)))
```

```dart
// Sets the foreground to color 30 in the 256-color palette, which is black.
SetStyles(Style.foreground(Color.from256(30)))
```

If targeting a terminal with limited color support:

- 4-bit color terminals support 16 colors. Use `Color4` to select a color.
- 8-bit color terminals support 256 colors. Use `Color8` to select a color.

## Text Styles

Text styles are used to change the appearance of text.

A subset of the available text styles are:

- `Style.bold`: Bold text.
- `Style.italic`: Italic text.
- `Style.underline`: Underlined text.

> [!NOTE]
> Not all terminals support all text styles.

## Resetting Styles

ANSI terminals have a default style that is used when no other styles are set,
which is usually (but not always) a white foreground on a black background.
During execution, style changes are cumulative, so if you set a foreground
color to red, then set it to green, the text will be green until you reset the
foreground color.

There are a few different types of resets available:

1. Reset the foreground color: `Style.foreground(Color.reset)`.

    ```dart
    SetStyles(Style.foreground(Color.reset))
    ```

2. Reset the background color: `Style.background(Color.reset)`.

    ```dart
    SetStyles(Style.background(Color.reset))
    ```

3. Reset specific text styles: `Style.no*`:

    ```dart
    SetStyles(Style.noBoldOrDim, Style.noItalicOrFraktur, Style.noUnderline)
    ```

    > [!NOTE]
    > There is not always a 1:1 mapping between the reset and the style. For
    > example, the reset for `Style.bold` is `Style.noBoldOrDim`, which also
    > resets `Style.dim`.

4. Reset all styles: `SetStyles.reset`.

    ```dart
    SetStyles.reset
    ```

---

<div style="text-align: center">

[◄ Introduction](Introduction-topic.html) |
[Cursors and Positioning ►](Cursors%20and%20Positioning-topic.html)

</a>
