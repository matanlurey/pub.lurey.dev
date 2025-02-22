import 'dart:convert';

import 'package:lore/lore.dart';

import '_prelude.dart';

void main() {
  test('log a string', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(sink);
    final logger = Logger(raw);

    logger.log(Level.debug, 'hello');

    check(buffer.toString()).equals('hello\n');
  });

  test('log a lazy string', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(sink);
    final logger = Logger(raw);

    logger.logLazy(Level.debug, () => 'hello');

    check(buffer.toString()).equals('hello\n');
  });

  test('log bytes', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(sink);
    final logger = Logger(raw);

    logger.logBytes(Level.debug, [1, 2, 3, 4, 5]);

    check(buffer.toString()).equals('${base64.encode([1, 2, 3, 4, 5])}\n');
  });

  test('log lazy bytes', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(sink);
    final logger = Logger(raw);

    logger.logBytesLazy(Level.debug, () => [1, 2, 3, 4, 5]);

    check(buffer.toString()).equals('${base64.encode([1, 2, 3, 4, 5])}\n');
  });

  test('debug log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.debug('hello');

    check(buffer.toString()).equals('debug: hello\n');
  });

  test('debug lazy log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.debugLazy(() => 'hello');

    check(buffer.toString()).equals('debug: hello\n');
  });

  test('status log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.status('hello');

    check(buffer.toString()).equals('status: hello\n');
  });

  test('status lazy log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.statusLazy(() => 'hello');

    check(buffer.toString()).equals('status: hello\n');
  });

  test('warning log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.warning('hello');

    check(buffer.toString()).equals('warning: hello\n');
  });

  test('warning lazy log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.warningLazy(() => 'hello');

    check(buffer.toString()).equals('warning: hello\n');
  });

  test('error log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.error('hello');

    check(buffer.toString()).equals('error: hello\n');
  });

  test('error lazy log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    logger.errorLazy(() => 'hello');

    check(buffer.toString()).equals('error: hello\n');
  });

  test('fatal log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    check(() => logger.fatal('hello')).throws<FatalError>();

    check(buffer.toString()).equals('fatal: hello\n');
  });

  test('fatal lazy log', () {
    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(buffer);
    final raw = RawLogger.fromLogSink(
      sink,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger(raw);
    check(() => logger.fatalLazy(() => 'hello')).throws<FatalError>();

    check(buffer.toString()).equals('fatal: hello\n');
  });

  test('flush', () async {
    var flushed = false;

    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(
      buffer,
      flush: () async {
        if (flushed) {
          throw StateError('Already flushed');
        }
        flushed = true;
      },
    );
    final raw = RawLogger.fromLogSink(sink);
    final logger = Logger(raw);

    logger.log(Level.debug, 'hello');
    await logger.flush();

    check(buffer.toString()).equals('hello\n');
    check(flushed).isTrue();
  });

  test('multiple loggers and multiple flushes', () async {
    var flushed = 0;

    final buffer = StringBuffer();
    final sink = LogSink.fromStringSink(
      buffer,
      flush: () async {
        flushed++;
      },
    );
    final raw1 = RawLogger.fromLogSink(
      sink,
      level: Level.warning,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );
    final raw2 = RawLogger.fromLogSink(
      sink,
      level: Level.status,
      formatString: (level, message, {time}) {
        return '${level.name}: $message';
      },
    );

    final logger = Logger.multi([raw1, raw2]);
    logger.status('hello');
    logger.statusLazy(() => 'world');
    logger.logBytes(Level.status, [1, 2, 3, 4, 5]);
    logger.logBytesLazy(Level.status, () => [6, 7, 8, 9, 10]);

    await logger.flush();
    check(buffer.toString()).equals(
      'status: hello\n'
      'status: world\n'
      '${base64.encode([1, 2, 3, 4, 5])}\n'
      '${base64.encode([6, 7, 8, 9, 10])}\n',
    );
    check(flushed).equals(2);
  });
}
