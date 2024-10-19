#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';

void main(List<String> args) async {
  // Find the root directory of the repository.
  final root = await findRootDir();
  if (root == null) {
    io.stderr.writeln('No repository found.');
    io.exitCode = 1;
    return;
  }

  // Resolve the pubspec.yaml file.
  final pubspec = await Package.resolve(root);
  final available = pubspec is Workspace ? pubspec.packages : {'.'};

  await Runner(
    Context(rootDir: root),
    systemEnvironment,
    availablePackages: available,
  ).run(args);
}
