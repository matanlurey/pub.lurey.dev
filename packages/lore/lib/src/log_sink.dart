import 'dart:convert';

/// A low level interface for logging raw messages or bytes to a sink.
///
/// This type is intended to be wrapped to provide a more user-friendly API.
///
/// A [LogSink] is not intended to take ownership of the underlying resource,
/// and as such there is no `close` method. Instead, it is recommended to call
/// [LogSink.flush] before closing the underlying resource or terminating the
/// program, and close the underlying resource separately (if necessary).
///
/// There are two built-in implementations:
/// - [LogSink.fromBinarySink] writes binary data to a `Sink<List<int>>`.
/// - [LogSink.fromStringSink] writes string messages to a [StringSink].
abstract interface class LogSink {
  /// Creates a new [LogSink] that writes binary data to [sink].
  ///
  /// [encoding] is used to encode string messages, and defaults to UTF-8.
  ///
  /// If [flush] is provided, it is called when [LogSink.flush] is called.
  ///
  /// ## Example
  ///
  /// The following example demonstrates how to write binary data to a file:
  ///
  /// ```dart
  /// import 'dart:io' as io;
  ///
  /// void main() async {
  ///   final file = io.File('log.txt').openWrite();
  ///   final sink = LogSink.fromBinarySink(file);
  ///   try {
  ///     sink.writeBytes([1, 2, 3, 4, 5]);
  ///   } finally {
  ///     await sink.flush();
  ///     await file.close();
  ///   }
  /// }
  /// ```
  factory LogSink.fromBinarySink(
    Sink<List<int>> sink, {
    Encoding encoding,
    Future<void> Function()? flush,
  }) = _BinaryLogSink;

  /// Creates a new [LogSink] that writes string messages to [sink].
  ///
  /// [encoder] is used to encode binary data, and defaults to base64.
  ///
  /// If [flush] is provided, it is called when [LogSink.flush] is called.
  ///
  /// ## Example
  ///
  /// The following example demonstrates how to write string data to a buffer:
  ///
  /// ```dart
  /// void main() {
  ///   final buffer = StringBuffer();
  ///   final sink = LogSink.fromStringSink(buffer);
  ///   sink.writeString('Hello World');
  ///
  ///   print(buffer.toString());
  /// }
  /// ```
  ///
  /// The above program outputs:
  ///
  /// ```txt
  /// Hello World
  /// ```
  factory LogSink.fromStringSink(
    StringSink sink, {
    Converter<List<int>, String> encoder,
    Future<void> Function()? flush,
  }) = _StringLogSink;

  /// Flushes any buffered data to the sink.
  ///
  /// This method is not required to be implemented by all sinks, and may be a
  /// no-op if the sink does not buffer data, but is a best practice to call
  /// this method before closing the underlying resource or terminating the
  /// program.
  ///
  /// The future completes when the data has been successfully written.
  Future<void> flush();

  /// Writes a string message to the sink.
  ///
  /// Unless otherwise specified, the [message] is encoded as UTF-8.
  void writeString(String message);

  /// Writes a list of bytes to the sink.
  ///
  /// Each element of [bytes] must be an integer in the range 0..255.
  ///
  /// The implementation decides how to interpret the bytes; for example a sink
  /// that can only accept UTF-8 encoded text may choose to ignore invalid byte
  /// sequences or convert the bytes to base64 before writing them.
  void writeBytes(List<int> bytes);
}

final class _BinaryLogSink implements LogSink {
  const _BinaryLogSink(
    this._sink, {
    Encoding encoding = utf8,
    Future<void> Function()? flush,
  })  : _encoding = encoding,
        _flush = flush;

  @override
  Future<void> flush() async {
    if (_flush != null) {
      await _flush();
    }
  }

  final Future<void> Function()? _flush;

  @override
  void writeString(String message) {
    writeBytes(_encoding.encode(message));
  }

  final Encoding _encoding;

  @override
  void writeBytes(List<int> bytes) {
    _sink.add(bytes);
  }

  final Sink<List<int>> _sink;
}

final class _StringLogSink implements LogSink {
  const _StringLogSink(
    this._sink, {
    Converter<List<int>, String> encoder = const Base64Encoder(),
    Future<void> Function()? flush,
  })  : _encoder = encoder,
        _flush = flush;

  @override
  Future<void> flush() async {
    if (_flush != null) {
      await _flush();
    }
  }

  final Future<void> Function()? _flush;

  @override
  void writeString(String message) {
    _sink.writeln(message);
  }

  final StringSink _sink;

  @override
  void writeBytes(List<int> bytes) {
    _sink.writeln(_encoder.convert(bytes));
  }

  final Converter<List<int>, String> _encoder;
}
