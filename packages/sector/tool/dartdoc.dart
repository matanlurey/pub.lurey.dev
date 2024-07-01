#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:oath/tools/dartdoc.dart';

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
      'preview',
      abbr: 'p',
      help: 'Serve the documentation to preview.',
      defaultsTo: !isCI,
    );
  final results = parser.parse(args);

  if (results['help'] as bool) {
    io.stderr.writeln(parser.usage);
    return;
  }

  await runDartdoc(
    mode: results.flag('preview') ? DartdocMode.preview : DartdocMode.generate,
  );
}
