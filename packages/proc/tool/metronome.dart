#!/usr/bin/env dart

import 'dart:async';
import 'dart:io' as io;

/// Repeatedly print a number to stdout at a fixed interval.
///
/// ## Usage
///
/// ```sh
/// ./tool/metronome [milliseconds]
/// ```
void main(List<String> args) async {
  final Duration duration;
  switch (args) {
    case []:
      duration = const Duration(milliseconds: 100);
    case [final s]:
      final ms = int.tryParse(s);
      if (ms == null) {
        io.stderr.writeln('Usage: metronome [milliseconds]');
        io.exitCode = 1;
        return;
      }
      duration = Duration(milliseconds: ms);
    default:
      io.stderr.writeln('Usage: metronome [milliseconds]');
      io.exitCode = 1;
      return;
  }

  late final StreamSubscription<void> sigintSub;
  var running = true;
  sigintSub = io.ProcessSignal.sigint.watch().listen((signal) {
    running = false;
  });

  var ticks = 0;
  while (running) {
    await Future<void>.delayed(duration);
    io.stdout.writeln(++ticks);
  }
  await sigintSub.cancel();
}
