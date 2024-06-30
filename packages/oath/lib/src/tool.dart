import 'dart:async';
import 'dart:io' as io;

import 'package:async/async.dart';

/// Runs the given [tool] function and returns its result.
FutureOr<T> runTool<T>(
  FutureOr<T> Function(Toolbox) tool, {
  Toolbox? withTools,
}) async {
  final completer = Completer<T>();
  final toolbox = withTools ?? Toolbox();
  late final StreamSubscription<void> onTerm;
  unawaited(
    runZonedGuarded(
      () async {
        onTerm = toolbox.terminate.listen((_) {
          toolExit();
        });
        final result = await tool(toolbox);
        completer.complete(result);
      },
      (error, stackTrace) {
        if (error is _ToolExit) {
          completer.complete();
        } else {
          completer.completeError(error, stackTrace);
        }
      },
    ),
  );
  try {
    return await completer.future;
  } finally {
    await toolbox.cleanup();
    await onTerm.cancel();
  }
}

/// Exits the current tool with an [error].
///
/// If no [error] is provided, the tool exits gracefully.
// ignore: only_throw_errors
Never toolExit([Object error = const _ToolExit()]) => throw error;

class _ToolExit implements Exception {
  const _ToolExit();
}

/// A collection of utility functions provided to each [runTool] invocation.
final class Toolbox {
  /// Creates a new [Toolbox] instance.
  factory Toolbox({
    StringSink? stdout,
    StringSink? stderr,
    Stream<void>? sigint,
    Stream<void>? sigterm,
  }) {
    // Merge both signals into a single stream.
    final terminate = StreamGroup.merge<void>([
      sigint ?? io.ProcessSignal.sigint.watch(),
      sigterm ?? io.ProcessSignal.sigterm.watch(),
    ]);

    return Toolbox._(
      stdout: stdout ?? io.stdout,
      stderr: stderr ?? io.stderr,
      terminate: terminate,
    );
  }

  Toolbox._({
    required this.stdout,
    required this.stderr,
    required this.terminate,
  });

  /// The standard output sink.
  final StringSink stdout;

  /// The standard error sink.
  final StringSink stderr;

  /// A stream that emits when the tool should terminate, i.e. external signals.
  final Stream<void> terminate;

  final _cleanupTasks = <TaskId, FutureOr<void> Function()>{};
  var _isComplete = false;
  var _cleanupTaskId = 0;

  /// Registers a cleanup task that will be executed when the tool finishes.
  ///
  /// The cleanup tasks are executed in the reverse order they were registered.
  void addCleanupTask(FutureOr<void> Function() task) {
    if (_isComplete) {
      throw StateError('Cannot add tasks after the tool has completed.');
    }
    final taskId = TaskId._(_cleanupTaskId++);
    _cleanupTasks[taskId] = task;
  }

  /// Removes a cleanup task with the given [taskId].
  ///
  /// Returns `true` if the task was removed, `false` otherwise.
  bool removeCleanupTask(TaskId taskId) {
    if (_isComplete) {
      throw StateError('Cannot remove tasks after the tool has completed.');
    }
    return _cleanupTasks.remove(taskId) != null;
  }

  /// Runs all cleanup tasks in the reverse order they were registered.
  Future<void> cleanup() async {
    if (_isComplete) {
      throw StateError('Cannot cleanup after the tool has completed.');
    }
    _isComplete = true;
    final tasks = _cleanupTasks.values.toList();
    _cleanupTasks.clear();
    for (final task in tasks) {
      await task();
    }
  }

  final _tempDirs = <String, io.Directory>{};

  /// Returns a temporary directory with the given [prefix].
  ///
  /// If a prefix matches a previously created directory, the same directory is
  /// returned. Otherwise, a new temporary directory is created. If no [prefix]
  /// is provided, a random one is generated.
  Future<io.Directory> getTempDir([String prefix = '']) async {
    if (prefix.isEmpty) {
      final result = await io.Directory.systemTemp.createTemp();
      addCleanupTask(() async => result.delete(recursive: true));
      return result;
    }
    var previous = _tempDirs[prefix];
    if (previous == null) {
      previous = await io.Directory.systemTemp.createTemp(prefix);
      addCleanupTask(() async => previous!.delete(recursive: true));
      _tempDirs[prefix] = previous;
    }
    return previous;
  }

  /// Returns a future that never completes.
  ///
  /// Useful as the last line of a tool to keep it running indefinitely.
  Future<void> forever() {
    return Completer<void>().future;
  }
}

/// An opaque object that represents a cleanup task handle.
extension type TaskId._(int _) {}
