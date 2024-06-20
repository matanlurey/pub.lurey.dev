part of '_mansion.dart';

/// A marker type that represents a style that can be applied to the terminal.
///
/// All of the possible styles are represented as subtypes of [Style] and also
/// are available as static constants or factory constructors on the class
/// itself.
///
/// {@category Styles and Colors}
@immutable
sealed class Style {
  /// Resets all styles to their default values.
  static const Style reset = StyleReset._();

  /// Creates a style that sets the foreground color to [color].
  const factory Style.foreground(Color color) = StyleForeground;

  /// Creates a style that sets the background color to [color].
  const factory Style.background(Color color) = StyleBackground;

  /// Increases the text intensity.
  static const Style bold = StyleText.bold;

  /// Decreases the text intensity.
  static const Style dim = StyleText.dim;

  /// Emphasizes the text.
  static const Style italic = StyleText.italic;

  /// Underlines the text.
  static const Style underline = StyleText.underline;

  /// Slow blink, typically less than 150 blinks per minute.
  static const Style blinkSlow = StyleText.blinkSlow;

  /// Rapid blink, typically 150+ blinks per minute.
  static const Style blinkRapid = StyleText.blinkRapid;

  /// Inverts the foreground and background colors.
  static const Style invert = StyleText.invert;

  /// Hides the text.
  static const Style hidden = StyleText.hidden;

  /// Strikes through the text.
  static const Style strikeThrough = StyleText.strikeThrough;

  /// Fraktur text, which is a German style of blackletter.
  static const Style fraktur = StyleText.fraktur;

  /// Disables the [bold] or [ideogramDoubleUnderline] attribute.
  static const Style noBoldOrDoubleUnderline =
      StyleText.noBoldOrDoubleUnderline;

  /// Disables [bold] or [dim] attribute.
  static const Style noBoldOrDim = StyleText.noBoldOrDim;

  /// Disables the [italic] or [fraktur] attribute.
  static const Style noItalicOrFraktur = StyleText.noItalicOrFraktur;

  /// Disables [underline] attribute.
  static const Style noUnderline = StyleText.noUnderline;

  /// Disables [blinkSlow] or [blinkRapid] attribute.
  static const Style noBlink = StyleText.noBlink;

  /// Disables the [invert] attribute.
  static const Style noReverse = StyleText.noReverse;

  /// Disables the [hidden] attribute.
  static const Style noHidden = StyleText.noHidden;

  /// Disables the [strikeThrough] attribute.
  static const Style noStrikeThrough = StyleText.noStrikeThrough;

  /// Framed text.
  static const Style framed = StyleText.framed;

  /// Encircled text.
  static const Style encircled = StyleText.encircled;

  /// Overlined text.
  static const Style overlined = StyleText.overlined;

  /// Disables the [framed] or [encircled] attribute.
  static const Style noFramedOrEncircled = StyleText.noFramedOrEncircled;

  /// Disables the [overlined] attribute.
  static const Style noOverlined = StyleText.noOverlined;

  /// Ideogram underline.
  static const Style ideogramUnderline = StyleText.ideogramUnderline;

  /// Ideogram double underline.
  static const Style ideogramDoubleUnderline =
      StyleText.ideogramDoubleUnderline;

  /// Ideogram overline.
  static const Style ideogramOverline = StyleText.ideogramOverline;

  /// Ideogram double overline.
  static const Style ideogramDoubleOverline = StyleText.ideogramDoubleOverline;

  /// Ideogram stress marking.
  static const Style ideogramStressMarking = StyleText.ideogramStressMarking;

  /// No ideogram attributes.
  ///
  /// Disables the following attributes:
  /// - [ideogramUnderline]
  /// - [ideogramDoubleUnderline]
  /// - [ideogramOverline]
  /// - [ideogramDoubleOverline]
  /// - [ideogramStressMarking]
  static const Style noIdeogramAttributes = StyleText.noIdeogramAttributes;
}

/// Style for setting the foreground color.
///
/// {@category Styles and Colors}
final class StyleForeground implements Style {
  /// Resets the foreground color to the terminal default.
  static const reset = StyleForeground(Color.reset);

  /// Creates a [StyleForeground] with the given [color].
  const StyleForeground(this.color);

  /// The color to set the foreground to.
  final Color color;

  @override
  bool operator ==(Object other) {
    return other is StyleForeground && other.color == color;
  }

  @override
  int get hashCode => Object.hash(StyleForeground, color);

  @override
  String toString() {
    return 'Style.foreground($color)';
  }
}

/// Style for setting the background color.
///
/// {@category Styles and Colors}
final class StyleBackground implements Style {
  /// Resets the background color to the terminal default.
  static const reset = StyleBackground(Color.reset);

  /// Creates a [StyleBackground] with the given [color].
  const StyleBackground(this.color);

  /// The color to set the background to.
  final Color color;

  @override
  bool operator ==(Object other) {
    return other is StyleBackground && other.color == color;
  }

  @override
  int get hashCode => Object.hash(StyleBackground, color);

  @override
  String toString() {
    return 'Style.background($color)';
  }
}

/// Resets all styles to their default values.
///
/// See [Style.reset] for the singleton instance.
///
/// {@category Styles and Colors}
final class StyleReset implements Style {
  const StyleReset._();

  @override
  String toString() {
    return 'Style.reset';
  }
}

/// Represents an attribute that effects the _style_ of the text.
///
/// For colors, see [Color].
///
/// {@category Styles and Colors}
enum StyleText implements Style {
  /// Increases the text intensity.
  bold(1),

  /// Decreases the text intensity.
  dim(2),

  /// Emphasizes the text.
  italic(3),

  /// Underlines the text.
  underline(4),

  /// Slow blink, typically less than 150 blinks per minute.
  blinkSlow(5),

  /// Rapid blink, typically 150+ blinks per minute.
  blinkRapid(6),

  /// Inverts the foreground and background colors.
  invert(7),

  /// Hides the text.
  hidden(8),

  /// Strikes through the text.
  strikeThrough(9),

  /// Fraktur text, which is a German style of blackletter.
  fraktur(20),

  /// Disables the [bold] or [ideogramDoubleUnderline] attribute.
  noBoldOrDoubleUnderline(21),

  /// Disables [bold] or [dim] attribute.
  noBoldOrDim(22),

  /// Disables the [italic] or [fraktur] attribute.
  noItalicOrFraktur(23),

  /// Disables [underline] attribute.
  noUnderline(24),

  /// Disables [blinkSlow] or [blinkRapid] attribute.
  noBlink(25),

  /// Disables the [invert] attribute.
  noReverse(27),

  /// Disables the [hidden] attribute.
  noHidden(28),

  /// Disables the [strikeThrough] attribute.
  noStrikeThrough(29),

  /// Framed text.
  framed(51),

  /// Encircled text.
  encircled(52),

  /// Overlined text.
  overlined(53),

  /// Disables the [framed] or [encircled] attribute.
  noFramedOrEncircled(54),

  /// Disables the [overlined] attribute.
  noOverlined(55),

  /// Ideogram underline.
  ideogramUnderline(60),

  /// Ideogram double underline.
  ideogramDoubleUnderline(61),

  /// Ideogram overline.
  ideogramOverline(62),

  /// Ideogram double overline.
  ideogramDoubleOverline(63),

  /// Ideogram stress marking.
  ideogramStressMarking(64),

  /// No ideogram attributes.
  ///
  /// Disables the following attributes:
  /// - [ideogramUnderline]
  /// - [ideogramDoubleUnderline]
  /// - [ideogramOverline]
  /// - [ideogramDoubleOverline]
  /// - [ideogramStressMarking]
  noIdeogramAttributes(65);

  const StyleText(this._value);

  final int _value;

  @override
  String toString() => 'Style.$name';
}

/// Sets one or more text [Style]s.
///
/// {@category Styles and Colors}
final class SetStyles implements Escape {
  /// A [SetStyles] that resets all styles to their default values.
  static const reset = SetStyles.from({Style.reset});

  /// Creates a [SetStyles] with up to 10 styles.
  ///
  /// If you need more than 10 styles, see [SetStyles.from].
  factory SetStyles(
    Style a, [
    Style b,
    Style c,
    Style d,
    Style e,
    Style f,
    Style g,
    Style h,
    Style i,
    Style j,
  ]) = SetStyles._variadic;

  /// Creates a [SetStyles] with a list of styles.
  const SetStyles.from(this.styles);

  SetStyles._variadic(
    Style a, [
    Style? b,
    Style? c,
    Style? d,
    Style? e,
    Style? f,
    Style? g,
    Style? h,
    Style? i,
    Style? j,
  ]) : styles = {
          a,
          if (b != null) b,
          if (c != null) c,
          if (d != null) d,
          if (e != null) e,
          if (f != null) f,
          if (g != null) g,
          if (h != null) h,
          if (i != null) i,
          if (j != null) j,
        };

  /// The styles to set.
  ///
  /// It is undefined behavior to modify the contents of this list.
  final Set<Style> styles;

  @override
  bool operator ==(Object other) {
    if (other is! SetStyles || styles.length != other.styles.length) {
      return false;
    }
    return styles.every(other.styles.contains);
  }

  @override
  int get hashCode => Object.hashAllUnordered(styles);

  @override
  String toString() {
    if (this == reset) {
      return 'SetStyles.reset';
    }
    return 'SetStyles(${styles.join(', ')})';
  }

  @override
  void writeAnsiString(StringSink out) {
    // Build one big 'm' sequence with all the styles.
    final buffer = StringBuffer();
    for (final style in styles) {
      if (buffer.isNotEmpty) {
        buffer.write(';');
      }
      switch (style) {
        case StyleReset():
          buffer.write('0');
        case StyleForeground(:final color):
          _writeFgColor(buffer, color);
        case StyleBackground(:final color):
          _writeBgColor(buffer, color);
        case final StyleText style:
          buffer.write(style._value);
      }
    }
    if (buffer.isEmpty) {
      return;
    }
    out.write('$_csiString${buffer}m');
  }

  void _writeFgColor(StringBuffer out, Color color) {
    out.write(
      switch (color) {
        ColorReset() => '39',
        Color4(:final index) => color.isDim ? '${30 + index}' : '${82 + index}',
        Color8(:final index) => '38;5;$index',
        Color24(:final red, :final green, :final blue) =>
          '38;2;$red;$green;$blue',
      },
    );
  }

  void _writeBgColor(StringBuffer out, Color color) {
    out.write(
      switch (color) {
        ColorReset() => '49',
        Color4(:final index) => color.isDim ? '${40 + index}' : '${92 + index}',
        Color8(:final index) => '48;5;$index',
        Color24(:final red, :final green, :final blue) =>
          '48;2;$red;$green;$blue',
      },
    );
  }
}
