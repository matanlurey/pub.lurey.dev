import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

/// A sink that represents a `stdin` sink of either bytes or strings.
abstract mixin class ProcessSink implements StreamSink<List<int>>, StringSink {
  /// Which encoding to use when writing strings.
  ///
  /// Depending on the implementation, this may be mutable.
  abstract Encoding encoding;

  /// **Unsupported**: Cnnot send errors to a process sink.
  @override
  @nonVirtual
  @visibleForTesting
  Never addError(Object error, [StackTrace? stackTrace]) {
    throw UnsupportedError('Cannot send errors to a process sink');
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) {
    return stream.listen(add).asFuture();
  }

  @override
  Future<void> close();

  @override
  Future<void> get done;

  @override
  void write(Object? object) {
    final string = object.toString();
    add(encoding.encode(string));
  }

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) {
    var first = true;
    for (final object in objects) {
      if (!first) {
        write(separator);
      }
      first = false;
      write(object);
    }
  }

  @override
  void writeCharCode(int charCode) {
    write(String.fromCharCode(charCode));
  }

  @override
  void writeln([Object? object = '']) {
    write(object);
    write('\n');
  }
}
