#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

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
      help: 'Generates the documentation.',
      defaultsTo: true,
    )
    ..addOption(
      'preview',
      abbr: 'p',
      help: 'Opens the generated documentation in a browser.',
      allowed: ['none', 'listen', 'listen-open-browser'],
      defaultsTo: isCI ? 'none' : 'listen-open-browser',
    );
  final results = parser.parse(args);

  if (results['help'] as bool) {
    io.stderr.writeln(parser.usage);
    return;
  }

  final preview = results['preview'] as String;
  final generate = results['generate'] as bool;

  if (generate) {
    final dartdoc = await io.Process.start('dart', ['doc']);

    dartdoc.stdout.listen(io.stdout.add);
    dartdoc.stderr.listen(io.stderr.add);

    final exitCode = await dartdoc.exitCode;
    if (exitCode != 0) {
      throw Exception('Failed to generate documentation: $exitCode');
    }
  }

  if (preview != 'none') {
    final handler = createStaticHandler('doc/api');
    final server = await shelf_io.serve(handler, 'localhost', 8080);

    io.stdout.writeln(
      'Serving documentation on http://localhost:8080/index.html',
    );
    io.stdout.writeln('Press Ctrl+C to exit.');

    if (preview == 'listen-open-browser') {
      final process = await io.Process.start(
        'open',
        ['http://localhost:8080/index.html'],
      );

      process.stdout.listen(io.stdout.add);
      process.stderr.listen(io.stderr.add);

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw Exception('Failed to open browser: $exitCode');
      }
    }

    await io.ProcessSignal.sigint.watch().first;
    await server.close(force: true);
  }
}
