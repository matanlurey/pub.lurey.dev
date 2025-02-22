import 'package:proc/proc.dart';

import '_prelude.dart';

void main() {
  group('Process.complete', () {
    test('default with no output', () async {
      final process = Process.complete();
      await check(
        process.exitCode,
      ).completes((s) => s.equals(ExitCode.success));
    });

    test('with stdout', () async {
      final process = Process.complete(stdout: ['Hello, World!']);
      await check(
        process.exitCode,
      ).completes((s) => s.equals(ExitCode.success));
      await check(
        process.stdoutText,
      ).withQueue.emits((e) => e.equals('Hello, World!'));
    });

    test('with stderr', () async {
      final process = Process.complete(stderr: ['Hello, World!']);
      await check(
        process.exitCode,
      ).completes((s) => s.equals(ExitCode.success));
      await check(
        process.stderrText,
      ).withQueue.emits((e) => e.equals('Hello, World!'));
    });

    test('as failure', () async {
      final process = Process.complete(exitCode: ExitCode.failure);
      await check(
        process.exitCode,
      ).completes((s) => s.equals(ExitCode.failure));
    });
  });
}
