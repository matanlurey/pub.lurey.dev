import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:chore/src/context.dart';

/// Returns a function that creates a temporary directory.
Future<io.Directory> Function(Context) getTempDir([String prefix = '']) {
  return (ctx) async {
    final directory = await io.Directory.systemTemp.createTemp(prefix);
    ctx.addCleanup(() => directory.delete(recursive: true));
    return directory;
  };
}

/// Returns a function that returns a future that never completes.
///
/// Useful as the last task in a sequence to keep something running.
Future<void> Function(Context) waitUntilTerminated() {
  return (_) => Completer<void>().future;
}

/// Starts a process with the given [executable] and [arguments].
Future<io.Process> Function(Context) startProcess(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  bool includeParentEnvironment = true,
  bool runInShell = false,
  io.ProcessStartMode mode = io.ProcessStartMode.inheritStdio,
}) {
  return (ctx) async {
    var inheritStdio = false;
    if (mode == io.ProcessStartMode.inheritStdio) {
      inheritStdio = true;
      mode = io.ProcessStartMode.normal;
    }
    final process = await io.Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode,
    );
    ctx.addCleanup(process.kill);
    if (inheritStdio) {
      process.stdout.transform(const Utf8Decoder()).listen(ctx.output.write);
      process.stderr.transform(const Utf8Decoder()).listen(ctx.error.write);
    }
    return process;
  };
}

/// Opens a web browser at the given [url].
Future<io.Process> Function(Context) openBrowser(Uri url) {
  return (ctx) async {
    final List<String> command;
    if (io.Platform.isMacOS) {
      command = ['open', url.toString()];
    } else if (io.Platform.isLinux) {
      command = ['xdg-open', url.toString()];
    } else if (io.Platform.isWindows) {
      command = ['cmd', '/c', 'start', url.toString()];
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${io.Platform.operatingSystem}',
      );
    }
    return startProcess(command.first, command.skip(1).toList())(ctx);
  };
}
