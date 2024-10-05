import 'dart:convert';
import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:proc/src/exit_code.dart';
import 'package:proc/src/process.dart' as base;
import 'package:proc/src/process_exception.dart' as base;
import 'package:proc/src/process_host.dart' as base;
import 'package:proc/src/process_run_mode.dart';
import 'package:proc/src/process_signal.dart';
import 'package:proc/src/process_sink.dart';

@internal
final class ProcessHost extends base.ProcessHost {
  static const isSupported = true;

  ProcessHost({
    super.stdoutEncoding = io.systemEncoding,
    super.stderrEncoding = io.systemEncoding,
    String? workingDirectory,
    super.runMode,
    super.environment,
    super.includeParentEnvironment,
    super.runInShell,
  }) : super.base(
          workingDirectory: workingDirectory ?? io.Directory.current.path,
        );

  @override
  ProcessHost copyWith({
    String? workingDirectory,
    Map<String, String>? environment,
    ProcessRunMode? runMode,
    bool? includeParentEnvironment,
    bool? runInShell,
    Encoding? stdoutEncoding,
    Encoding? stderrEncoding,
  }) {
    workingDirectory ??= this.workingDirectory;
    environment ??= this.environment;
    runMode ??= this.runMode;
    includeParentEnvironment ??= this.includeParentEnvironment;
    runInShell ??= this.runInShell;
    stdoutEncoding ??= this.stdoutEncoding;
    stderrEncoding ??= this.stderrEncoding;
    return ProcessHost(
      workingDirectory: workingDirectory,
      environment: environment,
      runMode: runMode,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    );
  }

  @override
  Future<base.Process> start(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    ProcessRunMode? runMode,
    bool? includeParentEnvironment,
    bool? runInShell,
    Encoding? stdoutEncoding,
    Encoding? stderrEncoding,
  }) async {
    workingDirectory ??= this.workingDirectory;
    environment ??= this.environment;
    runMode ??= this.runMode;
    includeParentEnvironment ??= this.includeParentEnvironment;
    runInShell ??= this.runInShell;
    stdoutEncoding ??= this.stdoutEncoding;
    stderrEncoding ??= this.stderrEncoding;

    try {
      return _Process(
        await io.Process.start(
          executable,
          arguments,
          workingDirectory: workingDirectory,
          environment: environment,
          includeParentEnvironment: includeParentEnvironment,
          runInShell: runInShell,
        ),
        stdoutEncoding,
        stderrEncoding,
      );
    } on io.ProcessException catch (e) {
      throw base.ProcessException(
        executable: executable,
        arguments: arguments,
        workingDirectory: workingDirectory,
        message: e.message,
        errorCode: e.errorCode,
      );
    }
  }

  @override
  Stream<void> watch(ProcessSignal signal) {
    final hostSignal = switch (signal) {
      ProcessSignal.sigint => io.ProcessSignal.sigint,
      ProcessSignal.sigterm => io.ProcessSignal.sigterm,
      ProcessSignal.sigkill => io.ProcessSignal.sigkill,
      // coverage:ignore-start
      _ => throw UnsupportedError('Unsupported signal: $signal'),
      // coverage:ignore-end
    };
    // coverage:ignore-start
    return _override?.call(hostSignal) ?? hostSignal.watch();
    // coverage:ignore-end
  }
}

/// Resets the process host watch to the default implementation.
@visibleForTesting
void resetProcessHostWatch() => _override = null;

/// Overrides the process host watch implementation.
@visibleForTesting
void overrideProcessHostWatch(
  Stream<void> Function(io.ProcessSignal signal) fn,
) {
  _override = fn;
}

Stream<void> Function(io.ProcessSignal signal)? _override;

final class _Process with base.Process {
  _Process(this._process, this._stdoutEncoding, this._stderrEncoding);
  final io.Process _process;
  final Encoding _stdoutEncoding;
  final Encoding _stderrEncoding;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    final hostSignal = switch (signal) {
      ProcessSignal.sigint => io.ProcessSignal.sigint,
      ProcessSignal.sigterm => io.ProcessSignal.sigterm,
      ProcessSignal.sigkill => io.ProcessSignal.sigkill,
      // coverage:ignore-start
      _ => throw UnsupportedError('Unsupported signal: $signal'),
      // coverage:ignore-end
    };
    return _process.kill(hostSignal);
  }

  @override
  int get processId => _process.pid;

  @override
  Future<ExitCode> get exitCode async {
    final exitCode = await _process.exitCode;
    return ExitCode.from(exitCode);
  }

  @override
  late final stdin = _ProcessSink(_process);

  @override
  Stream<List<int>> get stdout => _process.stdout;

  @override
  Stream<List<int>> get stderr => _process.stderr;

  @override
  late final stdoutText = stdout.transform(_stdoutEncoding.decoder);

  @override
  late final stderrText = stderr.transform(_stderrEncoding.decoder);
}

final class _ProcessSink with ProcessSink {
  _ProcessSink(this._process);
  final io.Process _process;

  @override
  late Encoding encoding = io.systemEncoding;

  @override
  void add(List<int> event) {
    _process.stdin.add(event);
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) {
    return _process.stdin.addStream(stream);
  }

  @override
  Future<void> close() {
    return _process.stdin.close();
  }

  @override
  Future<void> get done => _process.stdin.done;
}
