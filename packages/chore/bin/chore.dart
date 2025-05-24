#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:lore/lore.dart';

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
    Context(
      rootDir: root,
      logLevel: args.any((arg) => arg == '--verbose' || arg == '-v')
          ? Level.debug
          : Level.status,
      allPossiblePackages: available,
    ),
    systemEnvironment,
  ).run(args);
}
