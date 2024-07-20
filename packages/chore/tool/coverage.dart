#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/chore.dart';
import 'package:chore/chores/coverage.dart';
import 'package:chore/chores/generic.dart';
import 'package:path/path.dart' as p;

/// Generates a coverage report for the project.
void main(List<String> args) async {
  final isCI = io.Platform.environment['CI'] == 'true';
  final parser = ArgParser(allowTrailingOptions: false)
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints this help message.',
      negatable: false,
    )
    ..addOption(
      'report',
      abbr: 'r',
      help: 'What kind of report to generate.',
      allowed: ['lcov', 'html'],
      defaultsTo: isCI ? 'lcov' : 'html',
    );
  final results = parser.parse(args);
  if (results.flag('help')) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await run((context) async {
    final lcov = await generateLcov(outDir: 'coverage');
    if (results.option('report') == 'html') {
      final path = await generateHtml(
        lcovPath: lcov,
        outDir: p.join('coverage', 'html'),
      );
      await serve(path: path, open: true);
    }
  });
}
