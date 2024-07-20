#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/chore.dart';
import 'package:chore/chores/dartdoc.dart';
import 'package:chore/chores/generic.dart';
import 'package:path/path.dart' as p;

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
      'preview',
      abbr: 'p',
      help: 'Preview the generated documentation.',
      defaultsTo: !isCI,
    );
  final results = parser.parse(args);
  if (results.flag('help')) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await run((context) async {
    final path = await generateDartdoc(outDir: p.join('doc', 'api'));
    if (results.flag('preview')) {
      await serve(path: path, open: true);
    }
  });
}
