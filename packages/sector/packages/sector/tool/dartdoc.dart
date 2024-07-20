#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/chores/dartdoc.dart';
import 'package:chore/chores/generic.dart';

/// Generates dartdoc for the project.
void main(List<String> args) async {
  final isCI = io.Platform.environment['CI'] == 'true';
  final parser = ArgParser(allowTrailingOptions: false)
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints this help message.',
      negatable: false,
    )
    ..addFlag(
      'generate',
      abbr: 'g',
      help: 'Generate the documentation.',
      defaultsTo: true,
    )
    ..addFlag(
      'preview',
      abbr: 'p',
      help: 'Serve the documentation to preview.',
      defaultsTo: !isCI,
    )
    ..addFlag(
      'browse',
      abbr: 'b',
      help: 'Open the generated documentation in the browser.',
    )
    ..addOption(
      'port',
      abbr: 'P',
      help: 'Port to serve the documentation on. Defaults to a random port.',
    )
    ..addOption(
      'out',
      abbr: 'o',
      help: 'Output directory for the generated documentation.',
      defaultsTo: 'doc/api',
    );
  final results = parser.parse(args);

  if (results.flag('help')) {
    io.stderr.writeln(parser.usage);
    return;
  }

  final docPath = results.option('out')!;
  if (results.flag('generate')) {
    await generateDartdoc(outDir: docPath);
  }

  if (results.flag('preview')) {
    final (url, done) = await serve(
      path: docPath,
      open: results.flag('browse'),
      port: int.tryParse(results['port'] as String? ?? '8080')!,
    );
    io.stdout.writeln('Serving documentation at $url');
    await done;
  }
}
