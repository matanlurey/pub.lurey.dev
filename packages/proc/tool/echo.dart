#!/usr/bin/env dart

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

/// Repeatedly print lines from stdin to stdout or stderr.
///
/// ## Usage
///
/// ```sh
/// ./tool/echo [stdout|stderr]
/// ```
void main(List<String> args) async {
  final StringSink out;
  switch (args) {
    case [] || ['stdout']:
      out = io.stdout;
    case ['stderr']:
      out = io.stderr;
    default:
      io.stderr.writeln('Usage: echo [stdout|stderr]');
      io.exitCode = 1;
      return;
  }

  late final StreamSubscription<void> sigintSub;
  var running = true;
  sigintSub = io.ProcessSignal.sigint.watch().listen((signal) {
    running = false;
  });

  const splitter = LineSplitter();
  final lines = io.stdin.transform(utf8.decoder).transform(splitter);
  final linesSub = lines.listen(out.writeln);
  while (running) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  await linesSub.cancel();
  await sigintSub.cancel();
}
