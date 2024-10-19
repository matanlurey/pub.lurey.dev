#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
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

  final workspace = await Workspace.resolve(root);
  final available = workspace.packages.where((p) => p != 'dev').toSet();

  final earlyArgs = ArgParser();
  Context.registerArgs(earlyArgs, packages: available);

  // Find the first command.
  var end = args.length;
  for (var i = 0; i < args.length; i++) {
    if (const {
      'generate',
      'check',
      'coverage',
      'test',
    }.contains(args[i])) {
      end = i;
      break;
    }
  }
  final argResults = earlyArgs.parse(args.getRange(0, end));

  await Runner(
    await Context.resolve(
      argResults,
      root,
      availablePackages: available,
    ),
    systemEnvironment,
    availablePackages: available,
  ).run(args);
}
