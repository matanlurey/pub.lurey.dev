import 'package:lore/src/level.dart';
import 'package:lore/src/raw_logger.dart';
import 'package:meta/meta.dart';

/// A structured logging implementation.
abstract base mixin class Logger {
  /// Creates a new [Logger] that logs messaages to a single [RawLogger].
  factory Logger(RawLogger logger) = _Logger;

  /// Creates a new [Logger] that logs messages to multiple [RawLogger]s.
  ///
  /// Each logger can make independent decisions about whether to log a message,
  /// formatting, encoding, and where to store the message (e.g. console, file);
  /// however, all loggers will be called for each message logged by the
  /// [Logger].
  factory Logger.multi(Iterable<RawLogger> loggers) = _MultiLogger;

  /// Flushes any buffered log messages.
  Future<void> flush();

  /// Logs a message at the given [level].
  void log(Level level, String message, {DateTime? time});

  /// Invokes and logs a result of [callback] if [level] is enabled.
  void logLazy(Level level, String Function() callback, {DateTime? time});

  /// Logs a binary message at the given [level].
  void logBytes(Level level, List<int> bytes, {DateTime? time});

  /// Invokes and logs a binary result of [callback] if [level] is enabled.
  void logBytesLazy(
    Level level,
    List<int> Function() callback, {
    DateTime? time,
  });

  /// Logs a message at the [Level.debug] level.
  @nonVirtual
  void debug(String message, {DateTime? time}) {
    log(Level.debug, message, time: time);
  }

  /// Invokes and logs a result of [callback] at the [Level.debug] level.
  @nonVirtual
  void debugLazy(String Function() callback, {DateTime? time}) {
    logLazy(Level.debug, callback, time: time);
  }

  /// Logs a message at the [Level.status] level.
  @nonVirtual
  void status(String message, {DateTime? time}) {
    log(Level.status, message, time: time);
  }

  /// Invokes and logs a result of [callback] at the [Level.status] level.
  @nonVirtual
  void statusLazy(String Function() callback, {DateTime? time}) {
    logLazy(Level.status, callback, time: time);
  }

  /// Logs a message at the [Level.warning] level.
  @nonVirtual
  void warning(String message, {DateTime? time}) {
    log(Level.warning, message, time: time);
  }

  /// Invokes and logs a result of [callback] at the [Level.warning] level.
  @nonVirtual
  void warningLazy(String Function() callback, {DateTime? time}) {
    logLazy(Level.warning, callback, time: time);
  }

  /// Logs a message at the [Level.error] level.
  @nonVirtual
  void error(String message, {DateTime? time}) {
    log(Level.error, message, time: time);
  }

  /// Invokes and logs a result of [callback] at the [Level.error] level.
  @nonVirtual
  void errorLazy(String Function() callback, {DateTime? time}) {
    logLazy(Level.error, callback, time: time);
  }

  /// Logs a message at the [Level.fatal] level.
  @nonVirtual
  void fatal(String message, {DateTime? time}) {
    log(Level.fatal, message, time: time);
  }

  /// Invokes and logs a result of [callback] at the [Level.fatal] level.
  @nonVirtual
  void fatalLazy(String Function() callback, {DateTime? time}) {
    logLazy(Level.fatal, callback, time: time);
  }
}

final class _Logger with Logger {
  const _Logger(this._logger);
  final RawLogger _logger;

  @override
  Future<void> flush() => _logger.flush();

  @override
  void log(Level level, String message, {DateTime? time}) {
    _logger.logString(level, message, time: time);
  }

  @override
  void logLazy(Level level, String Function() callback, {DateTime? time}) {
    _logger.logStringLazy(level, callback, time: time);
  }

  @override
  void logBytes(Level level, List<int> bytes, {DateTime? time}) {
    _logger.logBytes(level, bytes, time: time);
  }

  @override
  void logBytesLazy(
    Level level,
    List<int> Function() callback, {
    DateTime? time,
  }) {
    _logger.logBytesLazy(level, callback, time: time);
  }
}

final class _MultiLogger with Logger {
  _MultiLogger(Iterable<RawLogger> loggers) : _loggers = List.of(loggers);
  final List<RawLogger> _loggers;

  @override
  Future<void> flush() => Future.wait(_loggers.map((logger) => logger.flush()));

  @override
  void log(Level level, String message, {DateTime? time}) {
    for (final logger in _loggers) {
      logger.logString(level, message, time: time);
    }
  }

  @override
  void logLazy(Level level, String Function() callback, {DateTime? time}) {
    for (final logger in _loggers) {
      logger.logStringLazy(level, callback, time: time);
    }
  }

  @override
  void logBytes(Level level, List<int> bytes, {DateTime? time}) {
    for (final logger in _loggers) {
      logger.logBytes(level, bytes, time: time);
    }
  }

  @override
  void logBytesLazy(
    Level level,
    List<int> Function() callback, {
    DateTime? time,
  }) {
    for (final logger in _loggers) {
      logger.logBytesLazy(level, callback, time: time);
    }
  }
}
