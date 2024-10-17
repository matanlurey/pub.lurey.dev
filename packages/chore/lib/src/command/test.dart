import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:proc/proc.dart';

/// A command that runs tests.
final class Test extends BaseCommand {
  /// Creates a new check command.
  Test(super.context, super.environment);

  @override
  String get name => 'test';

  @override
  String get description => 'Runs tests.';

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

    // Run dart test.
    io.stderr.writeln('Running tests for ${package.name}...');
    {
      final process = await environment.processHost.start(
        dartBin.binPath,
        ['test', package.path],
        runMode: ProcessRunMode.inheritStdio,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln('❌ Tests failed.');
      } else {
        io.stderr.writeln('✅ Tests passed.');
      }
      io.stderr.writeln();
    }
  }
}
