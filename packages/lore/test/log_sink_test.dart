import 'dart:convert';

import 'package:lore/lore.dart';

import '_prelude.dart';

void main() {
  group('LogSink.fromBinarySink', () {
    test('writes binary data to a sink', () {
      final bytes = <int>[];
      final sink = LogSink.fromBinarySink(_TestByteSink(bytes));

      sink.writeBytes([1, 2, 3, 4, 5]);

      check(bytes).deepEquals([1, 2, 3, 4, 5]);
    });

    test('encodes string messages as UTF-8 by default', () {
      final bytes = <int>[];
      final sink = LogSink.fromBinarySink(_TestByteSink(bytes));

      sink.writeString('hello');

      check(bytes).deepEquals(utf8.encode('hello'));
    });

    test('encoding can be overwritten', () {
      final bytes = <int>[];
      final sink = LogSink.fromBinarySink(
        _TestByteSink(bytes),
        encoding: latin1,
      );

      sink.writeString('hello');

      check(bytes).deepEquals(latin1.encode('hello'));
    });

    test('flushes buffered data', () async {
      var flushed = false;
      final sink = LogSink.fromBinarySink(
        _TestByteSink([]),
        flush: () async {
          if (flushed) {
            throw StateError('Already flushed');
          }
          flushed = true;
        },
      );

      await sink.flush();
      check(flushed).isTrue();
    });
  });

  group('LogSink.fromStringSink', () {
    test('writes string data to a sink', () {
      final buffer = StringBuffer();
      final sink = LogSink.fromStringSink(buffer);

      sink.writeString('hello');
      sink.writeString('world');

      check(buffer.toString()).equals('hello\nworld\n');
    });

    test('encodes binary data as base64 by default', () {
      final buffer = StringBuffer();
      final sink = LogSink.fromStringSink(buffer);

      sink.writeBytes([1, 2, 3, 4, 5]);

      check(buffer.toString()).equals('${base64.encode([1, 2, 3, 4, 5])}\n');
    });

    test('encoding can be overwritten', () {
      final buffer = StringBuffer();
      final sink = LogSink.fromStringSink(buffer, encoder: ascii.decoder);

      sink.writeBytes([1, 2, 3, 4, 5]);

      check(
        buffer.toString(),
      ).equals('${ascii.decoder.convert([1, 2, 3, 4, 5])}\n');
    });

    test('flushes buffered data', () async {
      var flushed = false;
      final sink = LogSink.fromStringSink(
        StringBuffer(),
        flush: () async {
          if (flushed) {
            throw StateError('Already flushed');
          }
          flushed = true;
        },
      );

      await sink.flush();
      check(flushed).isTrue();
    });
  });
}

final class _TestByteSink implements Sink<List<int>> {
  const _TestByteSink(this._sink);
  final List<int> _sink;

  @override
  void add(List<int> data) {
    _sink.addAll(data);
  }

  @override
  void close() {
    throw UnimplementedError();
  }
}
