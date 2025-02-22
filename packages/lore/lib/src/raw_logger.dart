/// @docImport 'package:lore/src/logger.dart';
library;

import 'package:lore/src/level.dart';
import 'package:lore/src/level_enabler.dart';
import 'package:lore/src/log_sink.dart';

/// A fatal error that should stop the program.
final class FatalError extends Error {
  FatalError._();
}

/// A raw logging implementation that conditionally logs messages to a sink.
///
/// Formatting and encoding is handled by the higher-level [Logger] class.
interface class RawLogger {
  @pragma('vm:invisible')
  static Never _throwOnFatal() => throw FatalError._();

  static String _defaultString(Level level, String message, {DateTime? time}) {
    return message;
  }

  static List<int> _defaultBytes(
    Level level,
    List<int> bytes, {
    DateTime? time,
  }) {
    return bytes;
  }

  /// Creates a new [RawLogger] that logs messages to [LogSink].
  ///
  /// Custom formatting can be provided by setting [formatString] and
  /// [formatBytes] respectively.
  ///
  /// In addition:
  ///
  /// - If [level] is provided, only messages of an equal or higher level are
  /// logged.
  ///
  /// - If [throwOnFatal] is provided, it is used instead of throwing
  /// [FatalError].
  const RawLogger.fromLogSink(
    this._sink, {
    Level? level,
    String Function(Level, String, {DateTime? time})? formatString,
    List<int> Function(Level, List<int>, {DateTime? time})? formatBytes,
    Never Function()? throwOnFatal,
  }) : _formatString = formatString ?? _defaultString,
       _formatBytes = formatBytes ?? _defaultBytes,
       _level = level ?? Level.debug,
       _throwFatal = throwOnFatal ?? _throwOnFatal;

  final LogSink _sink;
  final String Function(Level, String, {DateTime? time}) _formatString;
  final List<int> Function(Level, List<int>, {DateTime? time}) _formatBytes;
  final LevelEnabler _level;
  final Never Function() _throwFatal;

  /// Flushes any buffered log messages to the sink.
  Future<void> flush() async {
    await _sink.flush();
  }

  void _throwIfFatal(Level level) {
    if (level == Level.fatal) {
      _throwFatal();
    }
  }

  /// Logs a string message at the given [level].
  void logString(Level level, String message, {DateTime? time}) {
    if (_level.isEnabled(level)) {
      _sink.writeString(_formatString(level, message, time: time));
    }
    _throwIfFatal(level);
  }

  /// Invokes and logs a string result of [callback] if [level] is enabled.
  void logStringLazy(
    Level level,
    String Function() callback, {
    DateTime? time,
  }) {
    if (_level.isEnabled(level)) {
      _sink.writeString(_formatString(level, callback(), time: time));
    }
    _throwIfFatal(level);
  }

  /// Logs a binary message at the given [level].
  void logBytes(Level level, List<int> bytes, {DateTime? time}) {
    if (_level.isEnabled(level)) {
      _sink.writeBytes(_formatBytes(level, bytes, time: time));
    }
    _throwIfFatal(level);
  }

  /// Invokes and logs a binary result of [callback] if [level] is enabled.
  void logBytesLazy(
    Level level,
    List<int> Function() callback, {
    DateTime? time,
  }) {
    if (_level.isEnabled(level)) {
      _sink.writeBytes(_formatBytes(level, callback(), time: time));
    }
    _throwIfFatal(level);
  }
}
