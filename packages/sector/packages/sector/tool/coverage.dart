#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/chores/coverage.dart';
import 'package:chore/chores/generic.dart';
import 'package:path/path.dart' as p;

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
    )
    ..addFlag(
      'browse',
      abbr: 'b',
      help: 'Open the generated documentation in the browser.',
    );
  final results = parser.parse(args);

  if (results.flag('help')) {
    io.stderr.writeln(parser.usage);
    return;
  }

  final lcovPath = 'coverage';
  await generateLcov(outDir: lcovPath);

  if (results.option('report') == 'html') {
    final htmlPath = p.join(lcovPath, 'html');
    await generateHtml(outDir: htmlPath);

    if (results.flag('browse')) {
      final (url, done) = await serve(path: htmlPath, open: true);
      io.stdout.writeln('Serving coverage report at $url');
      await done;
    }
  }
}
