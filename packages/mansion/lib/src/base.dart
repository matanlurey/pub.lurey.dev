part of '_mansion.dart';

/// Base class for [Print] and [Escape], i.e. a sequences of characters.
///
/// Nearly every type in this library is a sub-type of [Sequence], which is a
/// sequence of characters that can be written to a [StringSink] as an ANSI
/// escaped string [writeAnsiString].
///
/// {@category Introduction}
@immutable
sealed class Sequence {
  /// An empty sequence.
  ///
  /// This is equivalent to a [Print] with an empty string.
  static const Sequence empty = Print.empty;

  /// @nodoc
  const Sequence();

  /// Write as a UTF-16 ANSI escaped string to the given [StringSink].
  ///
  /// ## Example
  ///
  /// Writing to stdout:
  /// ```dart
  /// import 'dart:io' as io;
  ///
  /// void main() {
  ///   final sequence = /*...*/;
  ///   sequence.writeAnsiString(io.stdout);
  /// }
  /// ```
  ///
  /// Writing to a string buffer:
  /// ```dart
  /// void main() {
  ///   final buffer = StringBuffer();
  ///   final sequence = /*...*/;
  ///   sequence.writeAnsiString(buffer);
  /// }
  /// ```
  void writeAnsiString(StringSink out);

  /// Returns a textual representation of this sequence for debugging.
  ///
  /// Do _not_ use this for rendering the sequence, or for testing/expectations:
  /// - For rendering, use [writeAnsiString] to write to a [StringSink].
  /// - For testing, rely on [operator==] for equality checks.
  @override
  String toString();
}

/// A sequence that is a literal [text] value that contains no escape codes.
///
/// While not strictly necessary for output, this type has two main purposes:
///
/// 1. A sealed subtype represntation of [Sequence] for decoding.
/// 2. A safe way to represent user-provided text that should not contain escape
///    codes, with optional validation.
///
/// See also: [AnsiDecoder] for decoding ANSI escape codes from a string.
///
/// ## Output
///
/// Print writes the [text] value to the output at the current cursor position.
///
/// Assuming a starting cursor position of `█`:
///
/// ```txt
/// █
/// ```
///
/// Print writes the text value to the output, advancing the cursor to the
/// current position after the text:
///
/// ```dart
/// sink.writeAnsi(Print('Hello, World!'));
/// ```
///
/// Resulting in:
///
/// ```txt
/// Hello, World!█
/// ```
///
/// Note that [String.length] is _not_ a reliable way to determine the cursor
/// position after writing a [Print] sequence, as it does not account for
/// extended characters. See [`package:characters`][] for working with Unicode
/// characters and grapheme clusters in a predictable way, including measuring
/// the width of text.
///
/// [`package:characters`]: https://pub.dev/packages/characters
///
/// ## Example
///
/// ```dart
/// final sequence = Print('Hello, World!');
/// final buffer = StringBuffer();
/// sequence.writeAnsiString(buffer);
/// print(buffer.toString()); // 'Hello, World!'
/// ```
///
/// By default, [Print] will _escape_ any escape or control characters:
///
/// ```dart
/// final sequence = Print('\x1BHello\nWorld!');
/// final buffer = StringBuffer();
/// sequence.writeAnsiString(buffer);
/// print(buffer.toString()); // '\\x1BHello\\nWorld!'
/// ```
///
/// However, there are options to either:
/// - Allow ASCII control characters (e.g. `\x07` for bell) with `allowAscii`.
/// - Check for invalid characters and throw instead with [Print.checkInvalid].
///
/// {@category Introduction}
final class Print extends Sequence {
  /// An empty literal text.
  ///
  /// This is equivalent to a [Print] with an empty string.
  static const empty = Print.fromUnchecked('');

  static final _asciiEscape = RegExp(r'[\x00-\x1F\x7F]');

  /// Returns a new string with escape or control characters escaped.
  ///
  /// Provide `allowAscii: true` to allow ASCII control characters:
  /// ```dart
  /// Print.escape('hello\x07', allowAscii: true); // 'hello\x07'
  /// ```
  ///
  /// This is provided as a convenience, i.e. for use in [toString] or logging
  /// without needing to create a [Print] instance.
  static String escape(String text, {bool allowAscii = false}) {
    if (allowAscii) {
      return text.replaceAll('\x1b', r'\x1b');
    }
    return text.replaceAllMapped(_asciiEscape, (match) {
      return '\\x${match.group(0)!.codeUnitAt(0).toRadixString(16)}';
    });
  }

  /// Creates a [Print] from the given [text] with control characters escaped.
  ///
  /// This constructor replaces escape sequences with their literal (escaped)
  /// representation, so that the text is guaranteed to be safe and contain no
  /// escape codes.
  ///
  /// This is useful when the text is user-provided and throwing is not desired.
  ///
  /// ```dart
  /// Print('hello'); // 'hello'
  /// Print('hello\x1b'); // 'hello\\x1b'
  /// ```
  ///
  /// Provide `allowAscii: true` to allow ASCII control characters:
  ///
  /// ```dart
  /// Print('hello\x07', allowAscii: true); // 'hello\x07'
  /// ```
  factory Print(
    String text, {
    bool allowAscii = false,
  }) {
    return Print.fromUnchecked(escape(text, allowAscii: allowAscii));
  }

  /// Creates a [Print] from the given [text] value.
  ///
  /// Throws a [FormatException] if the [text] contains an escape sequence:
  /// ```dart
  /// Print.checkInvalid('hello'); // OK
  /// Print.checkInvalid('hello\x1B'); // Throws
  /// ```
  ///
  /// Provide `allowAscii: true` to allow ASCII control characters.
  factory Print.checkInvalid(
    String text, {
    bool allowAscii = false,
  }) {
    if (allowAscii) {
      final index = text.indexOf('\x1B');
      if (index != -1) {
        throw FormatException('Contains escape sequence', text, index);
      }
      return Print.fromUnchecked(text);
    }

    final match = _asciiEscape.firstMatch(text);
    if (match != null) {
      throw FormatException(
        'Contains control character',
        text,
        match.start,
      );
    }
    return Print.fromUnchecked(text);
  }

  /// Creates a [Print] from the given [text] value.
  ///
  /// ## Safety
  ///
  /// It is undefined behavior to provide a string that contains escape codes,
  /// so this constructor should only be used when the text is known to be safe
  /// (i.e. other parsing/validation has already been done).
  @literal
  const Print.fromUnchecked(this.text);

  /// The literal text value.
  final String text;

  @override
  bool operator ==(Object other) => other is Print && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  void writeAnsiString(StringSink out) {
    return out.write(text);
  }

  @override
  String toString() => 'Print($text)';
}

const _escString = '\x1B';
const _csiString = '$_escString[';

/// Base type for escape codes, a sequence with a special non-literal meaning.
///
/// This type is a marker interface for escape codes to allow for more specific
/// handling of escape codes in a sequence of characters, i.e. by using pattern
/// matching or type checking:
///
/// ```dart
/// for (final sequence in sequences) {
///   switch (sequence) {
///     case Print p:
///       // Handle literal text.
///     case Escape e:
///       // Handle escape code.
///       // In practice, you might also match specific escape codes.
///   }
/// }
/// ```
///
/// {@category Introduction}
sealed class Escape implements Sequence {
  /// The character code for the escape byte ('\x1B').
  ///
  /// Used in escape codes to indicate the start of an escape sequence.
  static const escByte = 0x1B;

  /// The string representation of [escByte]
  ///
  /// Used in escape codes to indicate the start of an escape sequence.
  static const escString = _escString;

  /// The character code '[' for the Control Sequence Introducer (CSI).
  ///
  /// Used after [escByte] to indicate a specific type of control sequence.
  static const csiByte = 0x5B;

  /// The string representation of [csiByte].
  ///
  /// Used after [escString] to indicate a specific type of control sequence.
  static const csiString = '[';

  /// A compact representation of both [escByte] and [csiByte] as a single byte.
  ///
  /// Most modern terminal emulators support this as a more compact form of the
  /// Control Sequence Introducer (CSI) escape code, i.e. `'\x1B['`.
  static const csiByteCompact = 0x9B;

  /// The string representation of [csiByteCompact].
  ///
  /// Most modern terminal emulators support this as a more compact form of the
  /// Control Sequence Introducer (CSI) escape code, i.e. `'\x1B['`.
  static const csiStringCompact = '\x9B';

  /// The character code ']' for the Operating System Command (OSC).
  ///
  /// Used after [escByte] to indicate a specific type of control sequence.
  static const osiByte = 0x5D;

  /// The string representation of [osiByte].
  ///
  /// Used after [escString] to indicate a specific type of control sequence.
  static const osiString = ']';
}

/// Represents an escape code that was not recognized, i.e. during parsing.
///
/// This is created internally when parsing escape codes that are not recognized
/// by [AnsiDecoder], mostly to give clients flexibility in handling unknown
/// escape codes, such as ignoring them, escaping them, transforming them, etc.
///
/// Notably, [writeAnsiString] is not supported, as the escape code is unknown
/// and not escaped, so it is not safe to write to a terminal or buffer. To
/// write unknown escape codes, write [code] directly:
///
/// ```dart
/// final buffer = StringBuffer();
/// buffer.write(unknown.code);
/// ```
///
/// {@category Parsing ANSI Text}
final class Unknown implements Escape {
  /// Creates an [Unknown] with the given [code].
  ///
  /// Unless you are writing a parser or unit tests for handling unknown escape
  /// codes, you should not need to use this class directly; instead, use the
  /// provided [AnsiDecoder] to decode ANSI escape codes.
  @literal
  const Unknown(this.code, {this.offset});

  /// The raw escape code.
  final String code;

  /// The offset in the input string where the escape code was found.
  final int? offset;

  @override
  bool operator ==(Object other) {
    return other is Unknown && other.code == code && other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(Unknown, code, offset);

  @override
  void writeAnsiString(StringSink out) {
    throw UnsupportedError('Cannot write unknown escape code');
  }

  @override
  String toString() {
    final escapedText = Print.escape(code);
    if (offset != null) {
      return 'Unknown($escapedText, offset: $offset)';
    }
    return 'Unknown($escapedText)';
  }
}

/// An escaped code that represents a single ASCII control character.
///
/// While not escape codes in the traditional sense, these characters are
/// considered escape codes in the context of ANSI escape codes, as they are
/// used to control the terminal in-band.
///
/// # Example
///
/// ```dart
/// final buffer = StringBuffer();
/// buffer.writeAnsi(AsciiControl.lineFeed);
/// print(buffer.toString()); // '\n'
/// ```
///
/// {@category Introduction}
enum AsciiControl implements Escape {
  /// Terminal bell.
  ///
  /// Typically produces an audible alert or visual flash.
  terminalBell('\x07'),

  /// Backspace.
  ///
  /// Moves the cursor one position to the left, deleting the character there.
  ///
  /// ## Output
  ///
  /// Assuming a starting cursor position of `█`:
  ///
  /// ```txt
  /// Hello█
  /// ```
  ///
  /// Writing a backspace:
  ///
  /// ```dart
  /// sink.writeAnsi(AsciiControl.backspace);
  /// ```
  ///
  /// Deletes the character at the cursor, moving the cursor back:
  ///
  /// ```txt
  /// Hell█
  /// ```
  ///
  /// A backspace at the start of a line has no effect.
  backspace('\x08'),

  /// Horizontal tab.
  ///
  /// Moves the cursor to the next tab stop.
  ///
  /// ## Output
  ///
  /// Assuming a starting cursor position of `█`:
  ///
  /// ```txt
  /// Hello█
  /// ```
  ///
  /// Writing a horizontal tab:
  ///
  /// ```dart
  /// sink.writeAnsi(AsciiControl.horizontalTab);
  /// ```
  ///
  /// Moves the cursor to the next tab stop:
  ///
  /// ```txt
  /// Hello   █
  /// ```
  ///
  /// The default tab stop is often every 8 characters.
  horizontalTab('\x09'),

  /// Line feed.
  ///
  /// Moves the cursor to the next line.
  ///
  /// On Unix-like systems, this is the newline character.
  ///
  /// ## Output
  ///
  /// Assuming a starting cursor position of `█`:
  ///
  /// ```txt
  /// Hello█
  /// ```
  ///
  /// Writing a line feed:
  ///
  /// ```dart
  /// sink.writeAnsi(AsciiControl.lineFeed);
  /// ```
  ///
  /// Moves the cursor to the next line:
  ///
  /// ```txt
  /// Hello
  /// █
  /// ```
  ///
  /// On Windows, a line feed is often followed by a [carriageReturn] to move
  /// the cursor to the start of the next line. On POSIX systems, a line feed is
  /// often sufficient to move the cursor to the next line.
  lineFeed('\x0A'),

  /// Vertical tab.
  ///
  /// Moves the cursor to the next vertical tab stop.
  ///
  /// > [!WARNING]
  /// > Not widely supported in modern terminal emulators.
  verticalTab('\x0B'),

  /// Form feed.
  ///
  /// Moves the cursor to the next page.
  ///
  /// > [!WARNING]
  /// > Not widely supported in modern terminal emulators.
  formFeed('\x0C'),

  /// Carriage return.
  ///
  /// Moves the cursor to the beginning of the line.
  ///
  /// ## Output
  ///
  /// Assuming a starting cursor position of `█`:
  ///
  /// ```txt
  /// Hello█
  /// ```
  ///
  /// Writing a carriage return:
  ///
  /// ```dart
  /// sink.writeAnsi(AsciiControl.carriageReturn);
  /// ```
  ///
  /// Moves the cursor to the beginning of the line:
  ///
  /// ```txt
  /// █ello
  /// ```
  ///
  /// A carriage return at the start of a line has no effect.
  carriageReturn('\x0D'),

  /// Delete.
  ///
  /// Removes the character at the cursor.
  ///
  /// ## Output
  ///
  /// Assuming a starting cursor position of `█`:
  ///
  /// ```txt
  /// █ello
  /// ```
  ///
  /// Writing a delete:
  ///
  /// ```dart
  /// sink.writeAnsi(AsciiControl.delete);
  /// ```
  ///
  /// Deletes the character at the cursor:
  ///
  /// ```txt
  /// █llo
  /// ```
  ///
  /// A delete at the end of a line has no effect.
  delete('\x7F');

  const AsciiControl(this._char);
  final String _char;

  @override
  void writeAnsiString(StringSink out) {
    return out.write(_char);
  }
}
