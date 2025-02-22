#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:path/path.dart' as p;

void main() async {
  await _compile(p.join('third_party', 'xoshiro128plus'));
  await _compile(p.join('third_party', 'xoshiro128plusplus'));
}

Future<void> _compile(String path) async {
  io.stderr.writeln('Compiling $path');

  final cmakeResult = await io.Process.start('cmake', [
    path,
  ], mode: io.ProcessStartMode.inheritStdio);

  final exitCode = await cmakeResult.exitCode;
  if (exitCode != 0) {
    io.exitCode = 1;
    io.stderr.writeln('Failed to generate makefiles for $path');
    return;
  }

  final makeResult = await io.Process.start(
    'make',
    const [],
    mode: io.ProcessStartMode.inheritStdio,
    workingDirectory: path,
  );

  final makeExitCode = await makeResult.exitCode;
  if (makeExitCode != 0) {
    io.exitCode = 1;
    io.stderr.writeln('Failed to compile $path');
    return;
  }
}
