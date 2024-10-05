import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:proc/src/impl/_null.dart'
    if (dart.library.io) 'package:proc/src/impl/_io.dart' as impl;
import 'package:proc/src/process.dart';
import 'package:proc/src/process_run_mode.dart';
import 'package:proc/src/process_signal.dart';

/// Runs processes and listens for signals on the host platform.
///
/// This class is an abstract base class that delegates to the host platform,
/// or to a custom implementation.
///
/// To create a default process runner, use [ProcessHost.new].
///
/// To create a custom process runner, extend this class and override the
/// methods as needed.
///
/// ## Example
///
/// ```dart
/// final host = ProcessHost();
/// final process = await host.start('echo', ['Hello, World!']);
/// ```
abstract base class ProcessHost {
  /// Whether process execution is supported on the host platform.
  ///
  /// If `false`, [ProcessHost.new] cannot be used.
  static bool get isSupported => impl.ProcessHost.isSupported;

  /// Creates a new process runner that delegates to the host platform.
  ///
  /// Process execution must be [isSupported] by the host platform.
  factory ProcessHost({
    Encoding stdoutEncoding,
    Encoding stderrEncoding,
    String? workingDirectory,
    ProcessRunMode runMode,
    Map<String, String> environment,
    bool includeParentEnvironment,
    bool runInShell,
  }) = impl.ProcessHost;

  /// Initializes a new instance of the [ProcessHost] class.
  ProcessHost.base({
    required this.stdoutEncoding,
    required this.stderrEncoding,
    required this.workingDirectory,
    this.runMode = ProcessRunMode.normal,
    Map<String, String> environment = const {},
    this.includeParentEnvironment = true,
    this.runInShell = false,
  }) : environment = _copyFrozen(environment);

  static Map<K, V> _copyFrozen<K, V>(Map<K, V> map) {
    return map.isEmpty ? const {} : Map.unmodifiable(map);
  }

  /// Creates a copy of this process runner with the specified properties.
  ///
  /// Each property can be overridden by passing a new value.
  ProcessHost copyWith({
    String? workingDirectory,
    Map<String, String>? environment,
    ProcessRunMode? runMode,
    bool? includeParentEnvironment,
    bool? runInShell,
    Encoding? stdoutEncoding,
    Encoding? stderrEncoding,
  });

  /// Working directory to use by default for processes.
  @nonVirtual
  final String workingDirectory;

  /// Additional environment variables to set for processes.
  ///
  /// This map is unmodifiable.
  @nonVirtual
  final Map<String, String> environment;

  /// How to run the process.
  @nonVirtual
  final ProcessRunMode runMode;

  /// Whether to include the parent environment when running processes.
  @nonVirtual
  final bool includeParentEnvironment;

  /// Whether to spawn a process in a shell.
  @nonVirtual
  final bool runInShell;

  /// Encoding to use for `stdout` if not specified.
  @nonVirtual
  final Encoding stdoutEncoding;

  /// Encoding to use for `stderr` if not specified.
  @nonVirtual
  final Encoding stderrEncoding;

  /// Runs a process with the specified arguments.
  ///
  /// Configurations not specified use the default values from this instance.
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
  });

  /// Returns a stream that fires when the current process receives [signal].
  Stream<void> watch(ProcessSignal signal);
}
