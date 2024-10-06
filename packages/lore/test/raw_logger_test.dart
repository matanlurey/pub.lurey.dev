import 'dart:convert';

import 'package:lore/lore.dart';

import '_prelude.dart';

void main() {
  test('logs a string to a LogSink if the level is enabled', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(sink);

    logger.logString(Level.debug, 'hello');

    check(buffer.toString()).equals('hello\n');
  });

  test('logs a lazy string to a LogSink if the level is enabled', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(sink);

    logger.logStringLazy(Level.debug, () => 'hello');

    check(buffer.toString()).equals('hello\n');
  });

  test('logs bytes to a LogSink if the level is enabled', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(sink);

    logger.logBytes(Level.debug, [1, 2, 3, 4, 5]);

    check(buffer.toString()).equals('${base64.encode([1, 2, 3, 4, 5])}\n');
  });

  test('logs lazy bytes to a LogSink if the level is enabled', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(sink);

    logger.logBytesLazy(Level.debug, () => [1, 2, 3, 4, 5]);

    check(buffer.toString()).equals('${base64.encode([1, 2, 3, 4, 5])}\n');
  });

  test('throws if the level is fatal', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(sink);

    check(() => logger.logString(Level.fatal, 'hello')).throws<FatalError>();
  });

  test('throws a custom error if provided', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(
      sink,
      throwOnFatal: () {
        throw _CustomError();
      },
    );

    check(() => logger.logString(Level.fatal, 'hello')).throws<_CustomError>();
  });

  test('formats string output', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    logger.logString(Level.debug, 'hello');

    check(buffer.toString()).equals('debug: hello\n');
  });

  test('formats binary output', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final logger = RawLogger.fromLogSink(
      sink,
      formatBytes: (level, bytes, {time}) {
        return [level.index, ...bytes];
      },
    );

    logger.logBytes(Level.debug, [1, 2, 3, 4, 5]);

    check(buffer.toString()).equals('${base64.encode([0, 1, 2, 3, 4, 5])}\n');
  });

  test('delegates to sink.flush', () async {
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
}

final class _CustomError extends Error {}
