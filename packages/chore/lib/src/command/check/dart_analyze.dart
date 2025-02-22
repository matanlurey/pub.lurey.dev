import 'package:chore/src/command/check.dart';
import 'package:chore/src/environment.dart';
import 'package:chore/src/package.dart';
import 'package:proc/proc.dart';

/// A checker that runs `dart analyze` on a package.
final class DartAnalyze extends Checker {
  /// Creates a new dart analyze checker.
  const DartAnalyze();

  @override
  String get name => 'Dart Analyze';

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
      ['analyze', '.'],
      runMode: ProcessRunMode.inheritStdio,
      workingDirectory: package.path,
    );

    return (await process.exitCode).isFailure;
  }
}
