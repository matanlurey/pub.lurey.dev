import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;
import 'package:sdk/sdk.dart';

/// A command that collects and reports code coverage.
final class Coverage extends BaseCommand {
  /// Creates a new coverage command.
  Coverage(super.context, super.environment);

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

    for (final package in await context.resolvedPackages) {
      await _runForPackage(dartBin, package);
    }
  }

  Future<void> _runForPackage(Dart dart, Package package) async {
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
        io.stderr.writeln('✅ Collected coverage.');
      }
    }

    // ensure coverage/lcov.info exists
    final lcov = io.File(p.join(package.path, 'coverage', 'lcov.info'));
    if (!lcov.existsSync()) {
      io.exitCode = 1;
      io.stderr.writeln('❌ No coverage data found at ${lcov.path}.');
      return;
    } else {
      io.stderr.writeln('✅ Found coverage data at ${lcov.path}.');
    }
  }
}
