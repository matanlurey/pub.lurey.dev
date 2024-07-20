import 'dart:async';
import 'dart:io' as io;

import 'package:async/async.dart';

/// A collection of utility functions to use within the context of a task.
abstract interface class Context {
  /// Creates a new context.
  factory Context({
    StringSink? stdout,
    StringSink? stderr,
    Iterable<Stream<void>>? terminate,
  }) {
    stdout ??= io.stdout;
    stderr ??= io.stderr;
    terminate ??= [
      io.ProcessSignal.sigint.watch(),
      io.ProcessSignal.sigterm.watch(),
    ];
    return _Context(
      output: stdout,
      error: stderr,
      terminate: StreamGroup.merge(terminate),
    );
  }

  /// The output stream.
  ///
  /// Output streams typically write non-diagnostic messages to the console,
  /// such as the requested task's output. For example, the `echo` task writes
  /// to the output stream:
  ///
  /// ```dart
  /// void echo(Context ctx, String message) {
  ///   ctx.output.writeln(message);
  /// }
  /// ```
  ///
  /// Status and error messages should be written to the [Context.error] stream.
  StringSink get output;

  /// The error stream.
  ///
  /// Error streams typically write diagnostic messages to the console, such as
  /// status messages and error messages. For example, the `cat` task might
  /// write an error message if the file does not exist:
  ///
  /// ```dart
  /// void cat(Context ctx, String path) {
  ///   if (!File.existsSync(path)) {
  ///     ctx.error.writeln('File not found: $path');
  ///     return;
  ///   }
  /// }
  /// ```
  ///
  /// Non-diagnostic messages should be written to the [Context.output] stream.
  StringSink get error;

  /// A stream that emits when the task _runner_ is terminated.
  Stream<void> get onDone;

  /// Registers a cleanup function to be run when the task completes.
  ///
  /// The cleanup function is run when the task completes, whether it completes
  /// successfully or with an error. Cleanup functions are run in reverse order
  /// of registration.
  void addCleanup(FutureOr<void> Function() fn);

  /// Runs all cleanup functions, and terminates the task if necessary.
  Future<void> cleanup();

  /// Uses the provide [hook] to do or generate something context-aware.
  T use<T>(T Function(Context ctx) hook);
}

final class _Context implements Context {
  _Context({
    required this.output,
    required this.error,
    required Stream<void> terminate,
  }) {
    _onTerm = terminate.listen((_) async => cleanup());
  }

  @override
  final StringSink output;

  @override
  final StringSink error;

  @override
  Stream<void> get onDone => _onDone.stream;
  final _onDone = StreamController<void>.broadcast();
  late final StreamSubscription<void> _onTerm;

  /// Functions to run when the task completes.
  final _cleanup = <FutureOr<void> Function()>[];

  @override
  void addCleanup(FutureOr<void> Function() fn) {
    if (_onDone.isClosed) {
      throw StateError('Task is already completed');
    }
    _cleanup.add(fn);
  }

  @override
  Future<void> cleanup() async {
    await _onTerm.cancel();
    await Future.wait(_cleanup.reversed.map((fn) async => await fn()));
    if (!_onDone.isClosed) {
      _onDone.add(null);
      await _onDone.close();
    }
  }

  @override
  T use<T>(T Function(Context ctx) hook) => hook(this);
}

/// Indicates that the task should exit immediately.
final class ToolExit implements Exception {}
