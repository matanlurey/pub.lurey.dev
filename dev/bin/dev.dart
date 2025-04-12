#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:dev/src/commands/generate.dart';

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
    commands: (context, env) {
      return [Generate(context, env)];
    },
  ).run(args);
}
