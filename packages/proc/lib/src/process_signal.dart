import 'package:meta/meta.dart';

/// Represents a process signal.
@immutable
final class ProcessSignal {
  /// The `SIGINT` signal, sent when the user interrupts the process.
  static const sigint = ProcessSignal._('sigint');

  /// The `SIGTERM` signal, sent when the process is requested to terminate.
  static const sigterm = ProcessSignal._('sigterm');

  /// The `SIGKILL` signal, sent when the process is forcefully terminated.
  static const sigkill = ProcessSignal._('sigkill');

  const ProcessSignal._(this.name);

  /// The POSIX-standardized name of the signal.
  final String name;

  @override
  String toString() => 'ProcessSignal.$name';
}
