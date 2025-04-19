import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';

/// A command that generates dartdoc.
final class Dartdoc extends BaseCommand {
  /// Creates a new dartdoc command.
  Dartdoc(super.context, super.environment) {
    argParser.addOption(
      'port',
      abbr: 'p',
      help:
          ''
          'The port to preview the HTML coverage report on. '
          'Only a single package can be previewed at a time.',
      defaultsTo: '8080',
    );
    argParser.addFlag(
      'preview',
      help: 'Whether to preview the HTML coverage report.',
      defaultsTo: !environment.isCI,
    );
  }

  @override
  String get name => 'dartdoc';

  @override
  String get description => 'Generates dartdoc.';

  @override
  Future<void> run() async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    final packages = await context.resolve(globalResults!);
    final int? port;
    if (!argResults!.flag('preview')) {
      port = null;
    } else if (packages.length == 1) {
      port = int.tryParse(argResults!.option('port')!);
    } else if (packages.length > 1 && argResults!.flag('preview')) {
      io.exitCode = 1;
      io.stderr.writeln('❌ Only a single package can be previewed at a time.');
      return;
    } else {
      port = null;
    }

    for (final package in packages) {
      await _runForPackage(dartBin.binPath, package, port: port);
    }
  }

  Future<void> _runForPackage(
    String dartBin,
    Package package, {
    required int? port,
  }) async {
    Future<void> generate() async {
      final process = await environment.processHost.start(
        dartBin,
        ['doc'],
        workingDirectory: package.path,
        runMode: ProcessRunMode.inheritStdio,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln(await process.stderrText.join('\n'));
        io.stderr.writeln('❌ Failed to generate dartdoc.');
      } else {
        io.stderr.writeln('✅ Generated dartdoc.');
      }
    }

    if (port == null) {
      await generate();
      return;
    }

    final (close, url) = await preview(
      directory: p.join(package.path, 'doc', 'api'),
      port: port,
    );
    io.stdout.writeln('📚 Previewing dartdoc at $url');

    // Wait for the user to stop the server.
    await startInteractive(generate, environment: environment);
    await close();
  }
}
