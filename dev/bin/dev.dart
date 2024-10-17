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

  // Find the workspace.
  final workspace = await Workspace.resolve(root);
  await Runner(
    Context(
      rootDir: root,
      packages: workspace.packages.where((p) {
        return !const {'dev'}.contains(p);
      }).toSet(),
    ),
  ).run(args);
}
