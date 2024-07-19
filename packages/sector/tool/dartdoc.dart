#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:oath/tools/dartdoc.dart';
import 'package:path/path.dart' as p;

/// Generates dartdoc for the project.
void main(List<String> args) async {
  final isCI = io.Platform.environment['CI'] == 'true';
  final parser = ArgParser()
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
      defaultsTo: p.join('doc', 'api'),
    );
  final results = parser.parse(args);

  if (results['help'] as bool) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await runDartdoc(
    preview: results.flag('preview'),
    generate: results.flag('generate'),
    browse: results.flag('browse'),
    port: int.parse(results.option('port') ?? '0'),
    outDir: results.option('out'),
  );
}
