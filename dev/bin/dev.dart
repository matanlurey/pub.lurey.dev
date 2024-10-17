#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:dev/src/runner.dart';

void main(List<String> args) async {
  // Find the root directory of the repository.
  final root = await findRootDir(package: 'pub.lurey.dev');
  if (root == null) {
    io.stderr.writeln('No repository found.');
    io.exitCode = 1;
    return;
  }
  await Runner(Context(rootDir: root)).run(args);
}
