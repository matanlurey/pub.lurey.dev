import 'package:meta/meta.dart';

/// Specifies how to run a process.
@immutable
final class ProcessRunMode {
  /// Runs the process normally.
  ///
  /// Both `stdout`, `stderr`, and `stdin` are available.
  static const normal = ProcessRunMode._('normal');

  /// Inherits the parent process's `stdin`, `stdout`, and `stderr`.
  ///
  /// Handles are automatically forwarded to the parent process.
  static const inheritStdio = ProcessRunMode._('inheritStdio');

  /// Detaches the process from the parent process.
  ///
  /// No communication is possible with the process after it is started.
  static const detached = ProcessRunMode._('detached');

  /// Detaches the process from the parent process.
  ///
  /// Both `stdout` and `stderr` are   available.
  static const detachedWithOutput = ProcessRunMode._('detachedWithOutput');

  const ProcessRunMode._(this._name);
  final String _name;

  @override
  String toString() => 'ProcessRunMode.$_name';
}
