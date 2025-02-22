import 'package:chore/src/command/check.dart';
import 'package:chore/src/environment.dart';
import 'package:chore/src/package.dart';
import 'package:proc/proc.dart';

/// A checker that runs `dart format` on a package.
final class DartFormat extends Checker {
  /// Creates a new dart format checker.
  const DartFormat();

  @override
  String get name => 'dart-format';

  @override
  Future<bool> run(
    Package package,
    Environment environment, {
    bool fix = false,
  }) async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    final process = await environment.processHost.start(
      dartBin.binPath,
      [
        'format',
        if (fix) ...[
          '--output=write',
        ] else ...[
          '--output=show',
          '--show=changed',
          '--set-exit-if-changed',
        ],
        '.',
      ],
      runMode: ProcessRunMode.inheritStdio,
      workingDirectory: package.path,
    );

    return (await process.exitCode).isFailure;
  }
}
