import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:proc/proc.dart';

/// A command that invokes `pub get` for a package.
final class Setup extends BaseCommand {
  /// Creates a new setup command.
  Setup(super.context, super.environment);

  @override
  String get name => 'setup';

  @override
  String get description => 'Runs `pub get` for a package.';

  @override
  Future<void> run() async {
    for (final package in await context.resolve(globalResults!)) {
      await _runForPackage(package);
      for (final nestedPackage in package.nestedPackages) {
        await _runForPackage(nestedPackage);
      }
    }
  }

  Future<void> _runForPackage(Package package) async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    // Run dart pub get.
    io.stderr.writeln('Running `pub get` for ${package.name}...');
    {
      final process = await environment.processHost.start(
        package.isFlutterPackage ? 'flutter' : dartBin.binPath,
        ['pub', 'get'],
        runMode: ProcessRunMode.inheritStdio,
        workingDirectory: package.path,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln('❌ `pub get` failed.');
      } else {
        io.stderr.writeln('✅ `pub get` succeeded.');
      }
      io.stderr.writeln();
    }
  }
}
