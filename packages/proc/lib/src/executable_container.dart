import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:proc/src/process.dart';
import 'package:proc/src/process_exception.dart';
import 'package:proc/src/process_host.dart';
import 'package:proc/src/process_run_mode.dart';
import 'package:proc/src/process_signal.dart';

/// Parameters for starting a process.
///
/// [StartProcess] contains every parameter that otherwise would be passed to
/// either [ProcessHost.start] (or implicitly to an instance of [ProcessHost]),
/// so that it can be passed to a callback that either runs the process or
/// creates a fake in-memory process for testing or emulation purposes.
@immutable
final class StartProcess {
  const StartProcess._(
    this.arguments, {
    this.workingDirectory,
    this.environment = const {},
    this.runMode = ProcessRunMode.normal,
    this.includeParentEnvironment = true,
    this.runInShell = false,
    this.stdoutEncoding = utf8,
    this.stderrEncoding = utf8,
  });

  /// Arguments to pass to the executable.
  final List<String> arguments;

  /// Working directory to run the process in.
  final String? workingDirectory;

  /// Environment variables to set for the process.
  final Map<String, String> environment;

  /// The run mode for the process.
  final ProcessRunMode runMode;

  /// Whether to include the parent environment when running the process.
  final bool includeParentEnvironment;

  /// Whether to run the process in a shell.
  final bool runInShell;

  /// Encoding to use for `stdout`.
  final Encoding stdoutEncoding;

  /// Encoding to use for `stderr`.
  final Encoding stderrEncoding;
}

/// A virtual container for executables that can be viewed as a [ProcessHost].
///
/// This class is useful for testing or emulating processes without actually
/// running them. It allows you to set up a container with executables that
/// return a [Process] when run, and produce a [ProcessHost] that responds to
/// the executables in the container.
///
/// ## Example
///
/// Creating a container with an executable that echoes input on stdout:
///
/// ```dart
/// import 'package:proc/proc.dart';
///
/// void main() async {
///   final container = ExecutableContainer();
///   container.setExecutable('echo', (start) async {
///     late final ProcessController controller;
///     controller = ProcessController(
///       onInput: (data) {
///         controller.addStdoutBytes(data);
///       },
///     );
///     return controller.process;
///   });
/// }
/// ```
final class ExecutableContainer {
  /// Creates a new executable container.
  ///
  /// The [context] is used to resolve the path to the executable; if omitted,
  /// the default context is used. The [onWatch] callback is invoked when
  /// [ProcessHost.watch] is called.
  ///
  /// ## Example
  ///
  /// ```dart
  /// import 'package:path/path.dart' as p;
  /// import 'package:proc/proc.dart';
  ///
  /// void main() async {
  ///   final container = ExecutableContainer(
  ///     context: p.posix,
  ///     onWatch: (signal) {
  ///       // ...
  ///     }
  ///   );
  /// }
  /// ```
  factory ExecutableContainer({
    p.Context? context,
    Stream<void> Function(ProcessSignal)? onWatch,
  }) {
    return ExecutableContainer._(
      context: context ?? p.context,
      onWatch: onWatch ?? (_) => const Stream.empty(),
    );
  }

  ExecutableContainer._({required this.context, required this.onWatch});

  /// The path context used to resolve the path to the executable.
  ///
  /// Defaults to the current platform's path context (i.e. [p.context]).
  final p.Context context;

  /// Invoked when [ProcessHost.watch] is called.
  ///
  /// The stream should emit a value when the process receives the signal. To
  /// never emit a value, omit this callback entirely or return an empty stream:
  ///
  /// ```dart
  /// final container = ExecutableContainer();
  /// container.onWatch = (_) => const Stream.empty();
  /// ```
  Stream<void> Function(ProcessSignal) onWatch;

  /// Sets the executable to the container at the provided [path].
  ///
  /// The callback is invoked when the executable is run.
  ///
  /// ## Example
  ///
  /// ```dart
  /// container.setExecutable('echo', (start) async {
  ///   late final ProcessController controller;
  ///   controller = ProcessController(
  ///     onInput: (data) {
  ///       controller.addStdoutBytes(data);
  ///     },
  ///   );
  ///   return controller.process;
  /// });
  /// ```
  void setExecutable(
    String path,
    FutureOr<Process> Function(StartProcess) run,
  ) {
    _executables[path] = run;
  }

  final _executables = <String, FutureOr<Process> Function(StartProcess)>{};

  /// Creates a [ProcessHost] that runs executables in the container.
  ///
  /// The [stdoutEncoding] and [stderrEncoding] are used for the default
  /// encodings of the process's `stdout` and `stderr` streams, respectively,
  /// and the remaining parameters, similarly, configure the default inputs to
  /// [ProcessHost.start] with the specified values.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final host = container.createProcessHost();
  /// final process = await host.start('echo', ['Hello, World!']);
  /// ```
  ProcessHost createProcessHost({
    Encoding stdoutEncoding = utf8,
    Encoding stderrEncoding = utf8,
    String? workingDirectory,
    ProcessRunMode runMode = ProcessRunMode.normal,
    Map<String, String> environment = const {},
    bool includeParentEnvironment = true,
    bool runInShell = false,
  }) {
    return _ExecutableContainerHost(
      this,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
      workingDirectory: workingDirectory ?? context.current,
      runMode: runMode,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
    );
  }
}

final class _ExecutableContainerHost extends ProcessHost {
  _ExecutableContainerHost(
    this._container, {
    required super.stdoutEncoding,
    required super.stderrEncoding,
    required super.workingDirectory,
    super.runMode,
    super.environment,
    super.includeParentEnvironment,
    super.runInShell,
  }) : super.base();
  final ExecutableContainer _container;

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
  Future<Process> start(
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

    final String path;
    if (_container.context.isAbsolute(executable)) {
      path = executable;
    } else if (!executable.contains(_container.context.separator)) {
      path = executable;
    } else {
      path = _container.context.relative(executable, from: workingDirectory);
    }

    final run = _container._executables[path];
    if (run == null) {
      throw ProcessException(
        executable: executable,
        arguments: arguments,
        workingDirectory: workingDirectory,
        message: 'Executable not found in container at $path.',
      );
    }

    final start = StartProcess._(
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      runMode: runMode,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    );
    return run(start);
  }

  @override
  Stream<void> watch(ProcessSignal signal) {
    return _container.onWatch(signal);
  }
}
