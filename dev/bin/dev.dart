#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';

void main(List<String> args) async {
  // Find the root directory of the repository.
  final root = await findRootDir(package: 'pub.lurey.dev');
  if (root == null) {
    io.stderr.writeln('No repository found.');
    io.exitCode = 1;
    return;
  }

  final workspace = await Workspace.resolve(root);
  final available = workspace.packages.where((p) => p != 'dev').toSet();

  await Runner(
    name: 'dev',
    Context(rootDir: root, allPossiblePackages: available),
    systemEnvironment,
    commands: [
      Check.new,
      Coverage.new,
      Dartdoc.new,
      Generate.new,
      Publish.new,
      Setup.new,
      Test.new,
    ],
  ).run(args);
}
