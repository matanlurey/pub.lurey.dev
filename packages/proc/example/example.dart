#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:proc/proc.dart';

void main() async {
  final host = ProcessHost();
  final dart = io.Platform.resolvedExecutable;

  io.stderr.writeln('Running dart --version');
  final process = await host.start(dart, ['--version']);
  await process.exitCode;

  io.stdout.writeln(await process.stdoutText.join());
}
