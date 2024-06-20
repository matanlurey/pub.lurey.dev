part of '_mansion.dart';

/// Provides extension methods for writing ANSI [Sequence]s to a [StringSink].
///
/// {@category Introduction}
/// {@category Best Practices}
extension AnsiStringSink<W extends StringSink> on W {
  /// Writes the given [sequence] as an ANSI escaped string.
  ///
  /// # Example
  ///
  /// ```dart
  /// import 'dart:io' as io;
  /// import 'package:mansion/mansion.dart';
  ///
  /// // Writes "Hello, World!" in red text.
  /// void main() {
  ///   io.stdout.writeAnsi(SetColors.foreground(BaseColor.red));
  ///   io.stdout.writeln('Hello, World!\n');
  ///   io.stdout.writeAnsi(SetColors.reset);
  /// }
  /// ```
  void writeAnsi(Sequence sequence) {
    return sequence.writeAnsiString(this);
  }

  /// Writes the given [sequences] as multiple ANSI escaped strings.
  ///
  /// This is equivalent to calling [writeAnsi] on each element in [sequences].
  ///
  /// # Example
  ///
  /// ```dart
  /// import 'dart:io' as io;
  /// import 'package:mansion/mansion.dart';
  ///
  /// // Writes "Hello, World!" in red text.
  /// void main() {
  ///   io.stdout.writeAnsiAll([
  ///     SetColors.foreground(BaseColor.red),
  ///     // Can also interleave with literal text.
  ///     LiteralText('Hello, World!\n'),
  ///     SetColors.reset,
  ///   ]);
  /// }
  /// ```
  void writeAnsiAll(Iterable<Sequence> sequences) {
    for (final sequence in sequences) {
      sequence.writeAnsiString(this);
    }
  }

  /// Performs a set of actions within a synchronous update block.
  ///
  /// Updates within supported ANSI terminals will be suspended until the block
  /// completes. This can be useful for updating the terminal in a single frame
  /// to prevent flickering.
  ///
  /// # Example
  ///
  /// ```dart
  /// import 'dart:io' as io;
  /// import 'package:mansion/mansion.dart';
  ///
  /// void main() async {
  ///   await io.stdout.syncAnsiUpdate((out) {
  ///     out.writeAnsiAll([
  ///       SetColors.foreground(BaseColor.red),
  ///       LiteralText('Hello, World!\n'),
  ///       SetColors.resetForeground,
  ///     ]);
  ///
  ///     // The effects of the above sequences will be present in the terminal
  ///     // buffer, but not visible until the block completes.
  ///   });
  /// }
  /// ```
  T syncAnsiUpdate<T>(T Function(W) update) {
    writeAnsi(SynchronousUpdates.start);
    try {
      final result = update(this);
      writeAnsi(SynchronousUpdates.end);
      return result;
    } on Object catch (_) {
      writeAnsi(SynchronousUpdates.end);
      rethrow;
    }
  }
}

/// Provides extension methods for transforming strings into ANSI strings.
///
/// The preferred method for converting a string to an escaped string is to use
/// [Sequence.writeAnsiString] or methods on [AnsiStringSink], as they are more
/// efficient when writing multiple sequences to a buffer, and have less wasted
/// escape codes when applying multiple styles (as a more compact sequence can
/// be generated).
///
/// However, this extension can be useful when getting started with ANSI escape
/// codes, have less performance-sensitive requirements, or just value the
/// ergonomics of string interpolation more.
///
/// # Example
///
/// ```dart
/// void main() {
///   print('Hello, World!'.style(Style.bold, Style.foreground(Color.red)));
/// }
/// ```
///
/// {@category Introduction}
extension AnsifyString on String {
  String _apply(Sequence before, [Sequence after = SetStyles.reset]) {
    final buffer = StringBuffer();
    buffer.writeAnsi(before);
    buffer.write(this);
    buffer.writeAnsi(after);
    return buffer.toString();
  }

  /// Transforms the given string into having a one or more styles applied.
  ///
  /// # Example
  ///
  /// ```dart
  /// print('Hello, World!'.style(Style.bold));
  /// ```
  String style(
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
  ]) {
    return _apply(SetStyles._variadic(a, b, c, d, e, f, g, h, i, j));
  }
}

/// Provides extension methods for converting sequences to escaped strings.
///
/// The preferred method for converting a sequence to an escaped string is to
/// use [writeAnsiString] or methods on [AnsiStringSink], as they are more
/// efficient when writing multiple sequences to a buffer.
///
/// However, this extension can be useful when you need to convert a single
/// sequence to a string, or have less performance-sensitive requirements.
///
/// {@category Introduction}
extension ToAnsiString on Sequence {
  /// Returns the sequence as an escaped ANSI string.
  ///
  /// Prefer using [writeAnsiString] or [AnsiStringSink] when writing multiple
  /// sequences to a buffer.
  ///
  /// # Example
  ///
  /// ```dart
  /// final sequence = SetColors(
  ///   foreground: Color.red,
  ///   background: Color.blue,
  /// );
  ///
  /// final escaped = sequence.toAnsiString();
  /// print(escaped); // '\x1B[31;44m'
  /// ```
  String toAnsiString() {
    final buffer = StringBuffer();
    writeAnsiString(buffer);
    return buffer.toString();
  }
}
