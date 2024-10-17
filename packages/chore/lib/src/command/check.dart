import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:proc/proc.dart';

/// A command that checks the repository for issues.
final class Check extends BaseCommand {
  /// Creates a new check command.
  Check(super.context, super.environment);

  @override
  String get name => 'check';

  @override
  String get description => 'Check the repository for issues.';

  @override
  Future<void> run() async {
    for (final package in await context.resolvedPackages) {
      await _runForPackage(package);
    }
  }

  Future<void> _runForPackage(Package package) async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    // Run dartfmt.
    io.stderr.writeln('Checking formatting of ${package.name}...');
    {
      final process = await environment.processHost.start(
        dartBin.binPath,
        ['format', '--set-exit-if-changed', package.path],
        runMode: ProcessRunMode.inheritStdio,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln('❌ Found formatting issues.');
      } else {
        io.stderr.writeln('✅ No formatting issues found.');
      }
      io.stderr.writeln();
    }

    // Run dartanalyzer.
    io.stderr.writeln('Running static analysis of ${package.name}...');
    {
      final process = await environment.processHost.start(
        dartBin.binPath,
        ['analyze', package.path],
        runMode: ProcessRunMode.inheritStdio,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln('❌ Found analysis issues.');
      } else {
        io.stderr.writeln('✅ No analysis issues found.');
      }
      io.stderr.writeln();
    }
  }
}
