part of '_mansion.dart';

/// Represents a color that can be used in ANSI escape codes, i.e. [SetStyles].
///
/// This is a minimal representation of a color, and is not intended to be
/// exhaustive. For more advanced color manipulation, consider using a library
/// more suited to that purpose.
///
/// Most modern terminal emulators support the full range of 24-bit colors,
/// which can be defined using [Color.fromRGB] or [Color24] to create a color
/// from an RGB value:
/// ```dart
/// // Equivalent.
/// SetStyles(Style.foreground(Color.fromRGB(255, 0, 0)));
/// SetStyles(Style.foreground(Color24(0xFF0000)));
/// ```
///
/// For compatibility with older terminals, the 256-color palette can be used
/// with [Color.from256] or [Color8]:
/// ```dart
/// // Equivalent.
/// SetStyles(Style.foreground(Color.from256(196)));
/// SetStyles(Style.foreground(Color8.fromIndex(196)));
/// ```
///
/// The base 16 colors are also available as [Color4]:
/// ```dart
/// // Equivalent.
/// SetStyles(Style.foreground(Color.red));
/// SetStyles(Style.foreground(Color4.red));
/// ```
///
/// {@category Styles and Colors}
@immutable
sealed class Color {
  /// A color that resets the current color to the terminal's default.
  static const Color reset = ColorReset._();

  /// The color black.
  static const Color black = Color4.black;

  /// The color red.
  static const Color red = Color4.red;

  /// The color green.
  static const Color green = Color4.green;

  /// The color yellow.
  static const Color yellow = Color4.yellow;

  /// The color blue.
  static const Color blue = Color4.blue;

  /// The color magenta.
  static const Color magenta = Color4.magenta;

  /// The color cyan.
  static const Color cyan = Color4.cyan;

  /// The color white.
  static const Color white = Color4.white;

  /// The color bright black.
  static const Color brightBlack = Color4.brightBlack;

  /// The color bright red.
  static const Color brightRed = Color4.brightRed;

  /// The color bright green.
  static const Color brightGreen = Color4.brightGreen;

  /// The color bright yellow.
  static const Color brightYellow = Color4.brightYellow;

  /// The color bright blue.
  static const Color brightBlue = Color4.brightBlue;

  /// The color bright magenta.
  static const Color brightMagenta = Color4.brightMagenta;

  /// The color bright cyan.
  static const Color brightCyan = Color4.brightCyan;

  /// The color bright white.
  static const Color brightWhite = Color4.brightWhite;

  /// Creates a color from an 8-bit index in the 256-color palette.
  ///
  /// The index should be in the range 0-255.
  ///
  /// See [Color8] for a more detailed representation of 8-bit colors.
  const factory Color.from256(int index) = Color8.fromIndex;

  /// Creates a color from an 24-bit RGB value.
  ///
  /// The [red], [green], and [blue] values should be in the range 0-255.
  ///
  /// See [Color24] for a more detailed representation of 24-bit colors.
  const factory Color.fromRGB(int red, int green, int blue) = Color24.fromRGB;
}

/// A sentinel value that resets the current color to the terminal's default.
///
/// See [Color.reset] for a singleton instance of this type.
///
/// {@category Styles and Colors}
final class ColorReset implements Color {
  @literal
  const ColorReset._();

  @override
  bool operator ==(Object other) => other is ColorReset;

  @override
  int get hashCode => (ColorReset).hashCode;

  @override
  String toString() => 'Color.reset';
}

/// The base 16 (4-bit) colors available on almost all terminals.
///
/// There are 8 original ([dim]) colors, and 8 [bright] colors:
///
/// Bright/Light    | Dim/Dark
/// --------------- | ---------
/// [brightBlack]   | [black]
/// [brightRed]     | [red]
/// [brightGreen]   | [green]
/// [brightYellow]  | [yellow]
/// [brightBlue]    | [blue]
/// [brightMagenta] | [magenta]
/// [brightCyan]    | [cyan]
/// [brightWhite]   | [white]
///
/// In practice, most modern terminal emulators support [Color8] or [Color24],
/// but [Color4] is still useful for compatibility with older terminals or for
/// completeness.
///
/// {@category Styles and Colors}
enum Color4 implements Color {
  /// The color black.
  black,

  /// The color red, which is closer to a dark red.
  red,

  /// The color green, which is closer to a dark green.
  green,

  /// The color yellow, which is closer to a dark yellow.
  yellow,

  /// The color blue, which is closer to a dark blue.
  blue,

  /// The color magenta, which is closer to a dark magenta.
  magenta,

  /// The color cyan, which is closer to a dark cyan.
  cyan,

  /// The color white, which is closer to a medium gray.
  white,

  /// The color bright black, which is closer to a dark gray.
  brightBlack,

  /// The color bright red, which is closer to a regular red.
  brightRed,

  /// The color bright green, which is closer to a regular green.
  brightGreen,

  /// The color bright yellow, which is closer to a regular yellow.
  brightYellow,

  /// The color bright blue, which is closer to a regular blue.
  brightBlue,

  /// The color bright magenta, which is closer to a regular magenta.
  brightMagenta,

  /// The color bright cyan, which is closer to a regular cyan.
  brightCyan,

  /// The color bright white, which is closer to a white.
  brightWhite;

  /// A subset of [values]; 8 original colors, sometimes called _dim_ or _dark_.
  static const dim = [
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
  ];

  /// A subset of [values]; 8 bright colors, sometimes called _light_.
  static const bright = [
    brightBlack,
    brightRed,
    brightGreen,
    brightYellow,
    brightBlue,
    brightMagenta,
    brightCyan,
    brightWhite,
  ];

  /// Whether this color is a _dim_ or _dark_ color.
  bool get isDim => index < 8;

  /// Whether this color is a _bright_ or _light_ color.
  bool get isBright => index >= 8;

  @override
  String toString() {
    return 'Color4.$name';
  }
}

/// An extended color palette that includes the base 16 colors and 240 more.
///
/// The 240 colors are a 6x6x6 color cube, with 216 colors, and 24 grayscale
/// colors. The grayscale colors are in the range 0-23, and the color cube is
/// in the range 16-231.
///
/// See <https://www.ditig.com/publications/256-colors-cheat-sheet> for details.
///
/// {@category Styles and Colors}
final class Color8 implements Color {
  /// The 256-color palette.
  ///
  /// This list is unmodifiable and contains all 256 colors in the palette.
  static final values = List<Color8>.unmodifiable(
    List.generate(256, Color8.fromIndex),
  );

  /// Creates a [Color8] with the bottom 8-bits of the provided [int] value.
  @literal
  const Color8.fromIndex(int value) : index = value & 0xFF;

  /// The index of the color in the 256-color palette.
  final int index;

  @override
  bool operator ==(Object other) => other is Color8 && other.index == index;

  @override
  int get hashCode => Object.hash(Color8, index);

  @override
  String toString() {
    return 'Color.from256(0x${index.toRadixString(16).padLeft(2, '0')})';
  }
}

/// A 24-bit RGB color.
///
/// The values in [red], [green], and [blue] are in the range 0-255.
///
/// {@category Styles and Colors}
final class Color24 implements Color {
  /// The 24-bit color palette.
  ///
  /// Unlike [Color4.values] and [Color8.values], this is a generator that
  /// yields up to all 16,777,216 colors in the 24-bit palette, as it is
  /// impractical to store them all in memory.
  ///
  /// May optionally provide a [sample] value to limit the number of colors
  /// generated to every `sample`-th color for every component. For example,
  /// a sample value of `2` will generate every other color, resulting in
  /// 1/8th of the total colors.
  static Iterable<Color24> generate({int sample = 1}) sync* {
    RangeError.checkNotNegative(sample, 'sample');
    for (var r = 0; r < 256; r += sample) {
      for (var g = 0; g < 256; g += sample) {
        for (var b = 0; b < 256; b += sample) {
          yield Color24.fromRGB(r, g, b);
        }
      }
    }
  }

  /// Creates a [Color24] from the lower 24-bits of the provided [int] value.
  ///
  /// The value should be in the format `0xRRGGBB`.
  @literal
  const Color24(int value) : _value = value & 0xFFFFFF;

  /// Creates a [Color24] from the provided [red], [green], and [blue] values.
  ///
  /// Each value should be in the range 0-255.
  @literal
  const Color24.fromRGB(
    int red,
    int green,
    int blue,
  ) : _value = ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | blue & 0xFF;

  final int _value;

  /// The 8-bit red component of the color.
  int get red => (_value >> 16) & 0xFF;

  /// The 8-bit green component of the color.
  int get green => (_value >> 8) & 0xFF;

  /// The 8-bit blue component of the color.
  int get blue => _value & 0xFF;

  @override
  bool operator ==(Object other) => other is Color24 && other._value == _value;

  @override
  int get hashCode => Object.hash(Color24, _value);

  @override
  String toString() {
    return 'Color.fromRGB('
        '0x${red.toRadixString(16).padLeft(2, '0')}, '
        '0x${green.toRadixString(16).padLeft(2, '0')}, '
        '0x${blue.toRadixString(16).padLeft(2, '0')})';
  }

  /// Returns the 24-bit RGB value of the color.
  int toRGB() => _value;
}
