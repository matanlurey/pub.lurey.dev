#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';

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
      allowed: ['lcov-only', 'html', 'html-open-browser'],
      defaultsTo: isCI ? 'lcov-only' : 'html-open-browser',
    );
  final results = parser.parse(args);

  if (results['help'] as bool) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await _testWithCoverage();

  // If we're reporting html or html-open-browser, generate the HTML report.
  if (results['report'] != 'lcov-only') {
    await _generateHtmlReport();

    // Open the browser if requested.
    if (results['report'] == 'html-open-browser') {
      final process = await io.Process.start(
        'open',
        ['coverage/html/index.html'],
      );

      process.stdout.listen(io.stdout.add);
      process.stderr.listen(io.stderr.add);

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw Exception('Failed to open browser: $exitCode');
      }
    }
  }
}

/// Runs `dart run coverage:test_with_coverage -- -P coverage`.
Future<void> _testWithCoverage() async {
  final process = await io.Process.start(
    'dart',
    [
      'run',
      'coverage:test_with_coverage',
      '--',
      '-P',
      'coverage',
    ],
  );

  process.stdout.listen(io.stdout.add);
  process.stderr.listen(io.stderr.add);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Failed to run test_with_coverage: $exitCode');
  }
}

/// Runs `genhtml coverage/lcov.info -o coverage/html`.
Future<void> _generateHtmlReport() async {
  final process = await io.Process.start(
    'genhtml',
    [
      'coverage/lcov.info',
      '-o',
      'coverage/html',
    ],
  );

  process.stdout.listen(io.stdout.add);
  process.stderr.listen(io.stderr.add);

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Failed to generate HTML report: $exitCode');
  }
}
