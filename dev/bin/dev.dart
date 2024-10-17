#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:dev/src/runner.dart';
import 'package:dev/src/utils/find_root_dir.dart';

void main(List<String> args) async {
  // Find the root directory of the repository.
  final root = findRootDir();

  // Load workspace packages.
  final package = await Package.resolve(root);
  if (package is! Workspace) {
    io.stderr.writeln('No workspace found at $root.');
    io.exitCode = 1;
    return;
  }

  await Runner(packages: package.packages).run(args);
}
