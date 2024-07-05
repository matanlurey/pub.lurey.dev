#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:oath/tools/coverage.dart';

/// Generates a coverage report for the project.
void main(List<String> args) async {
  final isCI = io.Platform.environment['CI'] == 'true';
  final parser = ArgParser()
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

  if (results['help'] as bool) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await runCoverage(
    mode: results.option('report') == 'lcov'
        ? CoverageMode.generate
        : CoverageMode.preview,
  );
}
