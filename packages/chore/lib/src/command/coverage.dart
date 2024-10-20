import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:sdk/sdk.dart';

/// A command that collects and reports code coverage.
final class Coverage extends BaseCommand {
  /// Creates a new coverage command.
  Coverage(super.context, super.environment) {
    argParser.addOption(
      'format',
      abbr: 'f',
      allowed: _Format.values.map((e) => e.name),
      allowedHelp: {
        for (final format in _Format.values) format.name: format.description,
      },
      defaultsTo: environment.isCI ? _Format.lcov.name : _Format.html.name,
      help: 'The format to output coverage data in.',
    );
    argParser.addFlag(
      'no-preview',
      help: 'Do not preview the HTML coverage report.',
      defaultsTo: environment.isCI,
    );
    argParser.addOption(
      'preview',
      abbr: 'p',
      help: ''
          'The port to preview the HTML coverage report on. '
          'Only a single package can be previewed at a time.',
      defaultsTo: '8080',
    );
  }

  @override
  String get name => 'coverage';

  @override
  String get description => 'Collects and reports code coverage.';

  @override
  Future<void> run() async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    final packages = await context.resolve(globalResults!);
    final genHtml = argResults!.option('format') == _Format.html.name;
    final int? preview;
    if (genHtml && !argResults!.flag('no-preview')) {
      if (packages.length == 1) {
        preview = int.tryParse(argResults!.option('preview')!);
      } else {
        io.exitCode = 1;
        io.stderr.writeln(
          '❌ Only a single package can be previewed at a time.',
        );
        return;
      }
    } else {
      preview = null;
    }

    // dart pub global activate coverage
    final process = await environment.processHost.start(
      dartBin.binPath,
      ['pub', 'global', 'activate', 'coverage'],
    );
    if ((await process.exitCode).isFailure) {
      io.exitCode = 1;
      io.stderr.writeln(await process.stderrText.join('\n'));
      io.stderr.writeln('❌ Failed to activate coverage.');
      return;
    } else {
      io.stderr.writeln('✅ Activated coverage.');
    }

    for (final package in packages) {
      await _runForPackage(
        dartBin,
        package,
        genHtml: genHtml,
        port: preview,
      );
    }
  }

  Future<void> _runForPackage(
    Dart dart,
    Package package, {
    required bool genHtml,
    required int? port,
  }) async {
    if (!package.supportsCoverage) {
      io.exitCode = 1;
      io.stderr.writeln('❌ ${package.name} does not support coverage.');
      return;
    }

    // dart pub global run coverage:format_coverage -i coverage
    io.stderr.writeln('Collecting coverage for ${package.name}...');
    {
      final process = await environment.processHost.start(
        dart.binPath,
        [
          'pub',
          'global',
          'run',
          'coverage:test_with_coverage',
          '--',
          '-P',
          'coverage',
        ],
        workingDirectory: package.path,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln(await process.stderrText.join('\n'));
        io.stderr.writeln('❌ Failed to collect coverage.');
        return;
      } else {
        final lcov = io.File(p.join(package.path, 'coverage', 'lcov.info'));
        if (!lcov.existsSync()) {
          io.exitCode = 1;
          io.stderr.writeln('❌ No coverage data found at ${lcov.path}.');
          return;
        } else {
          io.stderr.writeln('✅ Collected coverage.');
        }
      }
    }

    // Generate HTML coverage report if requested.
    if (!genHtml) {
      return;
    }

    // genhtml coverage/lcov.info -o coverage/html
    io.stderr.writeln('Generating HTML coverage report for ${package.name}...');
    {
      final process = await environment.processHost.start(
        'genhtml',
        [
          p.join(package.path, 'coverage', 'lcov.info'),
          '-o',
          p.join(package.path, 'coverage', 'html'),
        ],
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln(await process.stderrText.join('\n'));
        io.stderr.writeln('❌ Failed to generate HTML coverage report.');
        return;
      } else {
        io.stderr.writeln('✅ Generated HTML coverage report');
      }
    }

    // preview if requested
    if (port == null) {
      return;
    }

    final (close, url) = await preview(
      directory: p.join(package.path, 'coverage', 'html'),
      port: port,
    );
    io.stdout.writeln('📚 Previewing coverage report at $url');

    // Wait for the user to stop the server.
    await environment.processHost.watch(ProcessSignal.sigint).first;
    await close();
  }
}

/// The format to output coverage data in.
enum _Format {
  lcov(
    'Output coverage data in LCOV format.',
  ),
  html(
    'Output coverage data in both LCOV and HTML formats.\n\n'
    'Requires the `genhtml` tool to be installed:\n'
    'https://github.com/linux-test-project/lcov',
  );

  const _Format(this.description);
  final String description;
}
