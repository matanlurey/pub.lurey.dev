import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// A command to generate dart docs.
final class Dartdoc extends Command<void> {
  final Chore _chore;

  /// Creates a new dartdoc command.
  Dartdoc(this._chore) {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The output directory for the dart docs',
        defaultsTo: p.join('doc', 'api'),
      )
      ..addOption(
        'port',
        abbr: 'p',
        help: 'Set to a port number to preview the HTML report',
        defaultsTo: _chore.isCI ? null : '8080',
      );
  }

  @override
  String get name => 'dartdoc';

  @override
  String get description => 'Generates dart docs';

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final outputDir = p.join(
      _chore.workingDirectory,
      argResults.option('output'),
    );

    // Generate dart docs.
    io.stderr.writeln('Generating dart docs in $outputDir...');
    final dartdoc = await io.Process.run('dart', [
      'doc',
      '--output',
      outputDir,
      if (argResults.rest.isNotEmpty) ...['--', ...argResults.rest],
    ]);
    if (dartdoc.exitCode != 0) {
      _chore.stderr.writeln(dartdoc.stderr);
      io.exitCode = 1;
      return;
    }

    if (argResults.option('port') case final String port) {
      final handler = createStaticHandler(
        outputDir,
        defaultDocument: 'index.html',
      );
      final server = await shelf_io.serve(
        handler,
        'localhost',
        int.parse(port),
      );
      _chore.stdout.writeln(
        'Serving dart docs on http://localhost:${server.port}',
      );
      await _chore.onTerminate.first;
      await server.close(force: true);
    }
  }
}
