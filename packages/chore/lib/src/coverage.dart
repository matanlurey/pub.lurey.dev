import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// A command to generate a coverage report.
final class Coverage extends Command<void> {
  final Chore _chore;
  Coverage(this._chore) {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The output directory for the coverage report',
        defaultsTo: 'coverage',
      )
      ..addOption(
        'format',
        abbr: 'f',
        help: 'The format of the coverage report',
        allowed: ['lcov', 'html'],
        defaultsTo: _chore.isCI ? 'lcov' : 'html',
      )
      ..addOption(
        'port',
        abbr: 'p',
        help: 'Set to a port number to preview the HTML report',
        defaultsTo: _chore.isCI ? null : '8080',
      );
  }

  @override
  String get name => 'coverage';

  @override
  String get description => 'Generates a coverage report';

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final outputDir = p.join(
      _chore.workingDirectory,
      argResults.option('output'),
    );

    // Generate LCOV.
    io.stderr.writeln('Generating LCOV in $outputDir...');
    final testWithCoverage = await io.Process.run('dart', [
      'run',
      'coverage:test_with_coverage',
      '--out=$outputDir',
      if (argResults.rest.isNotEmpty) ...['--', ...argResults.rest],
    ]);
    if (testWithCoverage.exitCode != 0) {
      _chore.stderr.writeln(testWithCoverage.stderr);
      io.exitCode = 1;
      return;
    }

    // Early exit if the format is LCOV.
    if (argResults.option('format') != 'html') {
      return;
    }

    // Generate HTML.
    io.stderr.writeln('Generating HTML...');
    final generateHtml = await io.Process.run('genhtml', [
      p.join(outputDir, 'lcov.info'),
      '-o',
      p.join(outputDir, 'html'),
    ]);
    if (generateHtml.exitCode != 0) {
      _chore.stderr.writeln(generateHtml.stderr);
      io.exitCode = 1;
      return;
    }

    // Preview the HTML report.
    final handler = createStaticHandler(
      p.join(outputDir, 'html'),
      defaultDocument: 'index.html',
    );
    final port = int.parse(argResults.option('port')!);
    final server = await shelf_io.serve(handler, 'localhost', port);
    _chore.stdout.writeln(
      'Serving coverage report on '
      'http://${server.address.host}:${server.port}',
    );

    // Wait for the command runner to terminate.
    await _chore.onTerminate.first;
    await server.close(force: true);
  }
}
