/// @docImport 'process_host.dart';
library;

import 'dart:convert';

import 'package:proc/src/exit_code.dart';
import 'package:proc/src/process_controller.dart';
import 'package:proc/src/process_signal.dart';
import 'package:proc/src/process_sink.dart';

/// Represents a process.
///
/// To create a process, see [ProcessHost] or [ProcessController].
abstract mixin class Process {
  /// Returns a new process that completes with the given [exitCode].
  ///
  /// This is a convenience method for creating a process that emits exactly
  /// the given [stdout] and [stderr] blobs, with an unspecified order, and
  /// then completes with the given [exitCode].
  ///
  /// For more control over the process, use [ProcessController] directly.
  factory Process.complete({
    int? processId,
    ExitCode exitCode = ExitCode.success,
    Encoding stdoutEncoding = utf8,
    List<String> stdout = const [],
    Encoding stderrEncoding = utf8,
    List<String> stderr = const [],
  }) {
    final controller = ProcessController(
      processId: processId,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    );
    for (final line in stderr) {
      controller.addStderr(line);
    }
    for (final line in stdout) {
      controller.addStdout(line);
    }
    controller.complete(exitCode);
    return controller.process;
  }

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
