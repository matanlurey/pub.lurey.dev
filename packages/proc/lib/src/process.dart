import 'package:proc/src/exit_code.dart';
import 'package:proc/src/process_signal.dart';
import 'package:proc/src/process_sink.dart';

/// Process interface
abstract interface class Process {
  /// The process ID.
  int get processId;

  /// Kills the process.
  ///
  /// Where possible, sends the [signal] to the process.
  ///
  /// Returns `true` if the signal was sent, `false` otherwise.
  bool kill([ProcessSignal signal]);

  /// Completes with an exit code when the process terminates.
  Future<ExitCode> get exitCode;

  /// A sink for writing to the process's stdin.
  ProcessSink get stdin;

  /// A stream of the raw bytes of `stdout`.
  Stream<List<int>> get stdout;

  /// A stream of the raw bytes of `stderr`.
  Stream<List<int>> get stderr;

  /// A stream of [stdout] decoded with the specified encoding.
  Stream<String> get stdoutText;

  /// A stream of [stderr] decoded with the specified encoding.
  Stream<String> get stderrText;
}
