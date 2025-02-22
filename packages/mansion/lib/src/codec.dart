part of '_mansion.dart';

/// An instance of the default implementation of the [AnsiCodec].
///
/// Provides conivenient access to the most common ANSI use cases.
///
/// # Example
///
/// ```dart
/// final encoded = ansi.encode([SetColors.background(Color4.red)]);
/// final decoded = ansi.deocde('\x1b[41m');
/// ```
///
/// {@category Parsing ANSI Text}
const ansi = AnsiCodec();

/// Decodes ANSI escape codes from UTF-16 encoded strings to [Sequence]s.
///
/// Shorthand for `ansi.decode`. Useful if a local variable shadows the global
/// `ansi` constant.
///
/// {@category Parsing ANSI Text}
List<Sequence> decodeAnsi(String input) => ansi.decode(input);

/// Encodes [Sequence]s to UTF-16 encoded strings.
///
/// Shorthand for `ansi.encode`. Useful if a local variable shadows the global
/// `ansi` constant.
///
/// {@category Parsing ANSI Text}
String encodeAnsi(List<Sequence> input) => ansi.encode(input);

/// An [AnsiCodec] allows encoding and decoding ANSI escape codes.
///
/// {@category Parsing ANSI Text}
@immutable
final class AnsiCodec extends Codec<List<Sequence>, String> {
  /// Creates an ANSI codec.
  @literal
  const AnsiCodec({this.allowInvalid = false});

  /// Whether to allow malformed input.
  ///
  /// See [AnsiDecoder.allowInvalid] for more information.
  final bool allowInvalid;

  @override
  Converter<String, List<Sequence>> get decoder {
    return allowInvalid
        ? const AnsiDecoder(allowInvalid: true)
        : const AnsiDecoder();
  }

  @override
  Converter<List<Sequence>, String> get encoder {
    return allowInvalid
        ? const AnsiEncoder(allowInvalid: true)
        : const AnsiEncoder();
  }
}

/// Encodes [Sequence]s to ANSI escape codes.
///
/// This class is provided for completeness, i.e. as part of [AnsiCodec].
///
/// Most users should use an [AnsiStringSink] instead.
///
/// {@category Parsing ANSI Text}
@immutable
final class AnsiEncoder extends Converter<List<Sequence>, String> {
  /// Creates an ANSI encoder.
  @literal
  const AnsiEncoder({this.allowInvalid = false});

  /// Whether to allow malformed input.
  ///
  /// If `false` (the default), an exception is thrown if [Unknown] sequences
  /// are encountered. Otherwise, the encoder prints out the malformed input
  /// as-is.
  final bool allowInvalid;

  @override
  String convert(List<Sequence> input) {
    final buffer = StringBuffer();
    if (allowInvalid) {
      for (final sequence in input) {
        if (sequence is Unknown) {
          buffer.write(sequence.code);
        } else {
          buffer.writeAnsi(sequence);
        }
      }
    } else {
      buffer.writeAnsiAll(input);
    }
    return buffer.toString();
  }
}

/// Converts a string with ANSI escape codes to a list of [Sequence]s.
///
/// By default, throws a [FormatException] if any input is malformed, i.e.
/// contains unrecognized or incomplete escape codes. Set [allowInvalid] to
/// `true` to replace malformed input with [Unknown] sequences instead.
///
/// There are two ways to use this decoder:
///
/// 1. As a 1-off conversion, `AnsiDecoder().convert(input)`.
/// 2. As a chunked conversion, `AnsiDecoder().startChunkedConversion(sink)`.
///
/// The latter is necessary when decoding a stream of input, as it allows the
/// decoder to buffer incomplete escape codes between chunks.
///
/// # Example
///
/// ```dart
/// final decoder = AnsiDecoder();
/// final decoded = decoder.convert('\x1b[31mHello, World!\x1b[0m');
/// ```
///
/// ```dart
/// final decoder = AnsiDecoder();
/// final sink = decoder.startChunkedConversion(outputSink);
///
/// // Would throw a FormatException if this wasn't a chunked conversion.
/// sink.add('\x1b[');
/// sink.add('31mHello, World!\x1b[0m');
/// sink.close();
/// ```
///
/// {@category Parsing ANSI Text}
@immutable
final class AnsiDecoder extends Converter<String, List<Sequence>> {
  /// Creates an ANSI decoder.
  @literal
  const AnsiDecoder({this.allowInvalid = false});

  /// Whether to allow malformed input.
  ///
  /// If `false` (the default), an exception is thrown if encountered, otherwise
  /// the decoder replaces the malformed input with [Unknown].
  final bool allowInvalid;

  @override
  List<Sequence> convert(String input) {
    final output = <Sequence>[];
    final result = parseAnsi(input, output);

    if (allowInvalid) {
      if (result != null) {
        output.add(result);
      }
      return output;
    }

    final invalid = output.whereType<Unknown>().firstOrNull ?? result;
    if (invalid != null) {
      throw FormatException(
        'Invalid ANSI escape code: ${invalid.code}',
        input,
        invalid.offset,
      );
    }

    return output;
  }

  @override
  Sink<String> startChunkedConversion(Sink<List<Sequence>> sink) {
    return _ChunkedAnsiDecoder(sink, allowMalformed: allowInvalid);
  }
}

final class _ChunkedAnsiDecoder implements Sink<String> {
  _ChunkedAnsiDecoder(this._sink, {required bool allowMalformed})
    : _allowMalformed = allowMalformed;

  final Sink<List<Sequence>> _sink;
  final bool _allowMalformed;

  var _previousChunk = '';
  Unknown? _previous;

  @override
  void add(String chunk) {
    // Use the previous chunk if we had a possibly malformed escape code.
    chunk = (_previous?.code ?? '') + chunk;
    _previous = null;

    // Parse the ANSI escape codes.
    final output = <Sequence>[];
    final result = parseAnsi(chunk, output);

    // Check for malformed escape codes.
    if (!_allowMalformed) {
      final invalid = output.whereType<Unknown>().firstOrNull;
      if (invalid != null) {
        throw FormatException(
          'Invalid ANSI escape code: ${invalid.code}',
          chunk,
          invalid.offset,
        );
      }
    }

    // Otherwise, if the last chunk is malformed, store it for the next chunk.
    if (result != null) {
      _previous = result;
      _previousChunk = chunk;
    }

    if (output.isNotEmpty) {
      _sink.add(output);
    }
  }

  @override
  void close() {
    if (_previous case final Unknown previous) {
      throw FormatException(
        'Invalid ANSI escape code: ${previous.code}',
        _previousChunk,
        previous.offset,
      );
    }
    _sink.close();
  }
}
