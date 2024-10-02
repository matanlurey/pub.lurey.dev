import 'dart:async';
import 'dart:convert';

import 'package:proc/src/exit_code.dart';
import 'package:proc/src/process.dart';
import 'package:proc/src/process_host.dart';
import 'package:proc/src/process_signal.dart';
import 'package:proc/src/process_sink.dart';

/// A controller with the [process] it controls.
///
/// This class can be used to create an instrumented [Process] instance, either
/// for implementing a custom [ProcessHost] (i.e. that does not delegate to
/// `dart:io`), or for testing.
final class ProcessController {
  /// Creates a controller that manages a running process.
  ProcessController({
    required this.processId,
    this.stdoutEncoding = utf8,
    this.stderrEncoding = utf8,
    this.stdinEncoding = utf8,
    this.lineTerminator = '\n',
    bool Function(ProcessSignal)? onKill,
    void Function(List<int>)? onInput,
  }) {
    onKill ??= (_) {
      if (isClosed) {
        return false;
      }
      complete(ExitCode.failure);
      return true;
    };

    // Field must be late and cannot use `this` in initializer.
    // ignore: prefer_initializing_formals
    this.onKill = onKill;
    this.onInput = onInput ?? (_) {};
  }

  /// Whether the controller is closed.
  bool get isClosed => _closed;
  var _closed = false;
  void _throwIfClosed() {
    if (_closed) {
      throw StateError('ProcessController is closed.');
    }
  }

  /// Called when [Process.kill] is called.
  late void Function(ProcessSignal) onKill;

  /// Called when [Process.stdin] receives data.
  late void Function(List<int>) onInput;

  /// Process ID.
  final int processId;

  /// Line terminator used for [addStdoutLine] and [addStderrLine].
  final String lineTerminator;

  /// Encoding used for [Process.stdoutText].
  final Encoding stdoutEncoding;
  late final _stdout = StreamController<List<int>>();

  /// Encoding used for [Process.stderrText].
  final Encoding stderrEncoding;
  late final _stderr = StreamController<List<int>>();

  /// The process that this controller is controlling.
  late final Process process = _Process(this);
  late final _exitCode = Completer<ExitCode>();

  /// Encoding used for [Process.stdin].
  final Encoding stdinEncoding;

  /// Appends bytes to [Process.stdout].
  void addStdoutBytes(List<int> bytes) {
    _throwIfClosed();
    _stdout.add(bytes);
  }

  /// Appends text to [Process.stdout].
  void addStdout(String text) {
    _throwIfClosed();
    _stdout.add(stdoutEncoding.encoder.convert(text));
  }

  /// Appends a line to [Process.stdout].
  void addStdoutLine([String line = '']) {
    addStdout('$line$lineTerminator');
  }

  /// Appends bytes to [Process.stderr].
  void addStderrBytes(List<int> bytes) {
    _throwIfClosed();
    _stderr.add(bytes);
  }

  /// Appends text to [Process.stderr].
  void addStderr(String text) {
    _throwIfClosed();
    _stderr.add(stderrEncoding.encoder.convert(text));
  }

  /// Appends a line to [Process.stderr].
  void addStderrLine([String line = '']) {
    addStderr('$line$lineTerminator');
  }

  /// Completes the process with the specified [exitCode].
  ///
  /// If [exitCode] is not specified, it defaults to [ExitCode.success].
  void complete([FutureOr<ExitCode> exitCode = ExitCode.success]) {
    _throwIfClosed();
    _closed = true;
    unawaited(_stdout.close());
    unawaited(_stderr.close());
    _exitCode.complete(exitCode);
  }
}

final class _Process implements Process {
  _Process(this._controller);
  final ProcessController _controller;

  @override
  late final stdin = _ProcessSink(_controller);

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    if (_controller.isClosed) {
      return false;
    }
    _controller.onKill(signal);
    return true;
  }

  @override
  int get processId => _controller.processId;

  @override
  Future<ExitCode> get exitCode => _controller._exitCode.future;

  @override
  Stream<List<int>> get stdout => _controller._stdout.stream;

  @override
  late final stdoutText = stdout.transform(_controller.stdoutEncoding.decoder);

  @override
  Stream<List<int>> get stderr => _controller._stderr.stream;

  @override
  late final stderrText = stderr.transform(_controller.stderrEncoding.decoder);
}

final class _ProcessSink with ProcessSink {
  _ProcessSink(this._controller);
  final ProcessController _controller;

  final _closed = Completer<void>();
  void _throwIfClosed() {
    if (_closed.isCompleted) {
      throw StateError('ProcessSink is closed.');
    }
    _controller._throwIfClosed();
  }

  @override
  late Encoding encoding = _controller.stdinEncoding;

  @override
  void add(List<int> event) {
    _throwIfClosed();
    _controller.onInput(event);
  }

  @override
  Future<void> close() {
    _throwIfClosed();
    _closed.complete();
    return _closed.future;
  }

  @override
  Future<void> get done => _closed.future;

  @override
  void writeln([Object? object = '']) {
    write('$object${_controller.lineTerminator}');
  }
}
