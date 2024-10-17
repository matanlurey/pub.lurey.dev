import 'dart:io' as io;

import 'package:chore/chore.dart';
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
    // dart pub global run coverage:format_coverage -i coverage
    io.stderr.writeln('Formatting coverage for ${package.name}...');
    {
      final process = await environment.processHost.start(
        dart.binPath,
        [
          'pub',
          'global',
          'run',
          'coverage:format_coverage',
          '--lcov',
          '--in=coverage',
          '--out=coverage/lcov.info',
        ],
        workingDirectory: package.path,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln(await process.stderrText.join('\n'));
        io.stderr.writeln('❌ Failed to format coverage.');
        return;
      } else {
        io.stderr.writeln('✅ Formatted coverage.');
      }
    }
  }
}