import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('binPath', () {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    check(dartBin.binPath).equals(fakePath);
  });

  test('sdk', () {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    check(dartBin.sdk).has((a) => a.sdkPath, 'sdkPath').equals(p.join('path'));
  });

  test('format returns true when the process fails', () async {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    final container = ExecutableContainer();
    container.setExecutable(fakePath, (start) {
      return Process.complete(exitCode: ExitCode.failure);
    });

    await check(
      dartBin.format(['foo'], host: container.createProcessHost()),
    ).completes((e) => e.isTrue());
  });

  test('format returns false when the process succeeds', () async {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    final container = ExecutableContainer();
    container.setExecutable(fakePath, (start) {
      return Process.complete();
    });

    await check(
      dartBin.format(['foo'], host: container.createProcessHost()),
    ).completes((e) => e.isFalse());
  });

  test('formatCheck returns paths that need formatting', () async {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    final container = ExecutableContainer();
    container.setExecutable(fakePath, (start) {
      return Process.complete(
        exitCode: ExitCode.failure,
        stdout: [
          'Changed test/dart_bin_fake_test.dart',
          '{"path": "test/dart_bin_fake_test.dart"}',
        ],
      );
    });

    await check(
      dartBin.formatCheck(['foo'], host: container.createProcessHost()),
    ).withQueue.emits((e) => e.endsWith('test/dart_bin_fake_test.dart'));
  });

  test('formatCheck returns no paths when all files are formatted', () async {
    final fakePath = p.join('path', 'to', 'dart');
    final dartBin = Dart.fromPath(fakePath);

    final container = ExecutableContainer();
    container.setExecutable(fakePath, (start) {
      return Process.complete();
    });

    await check(
      dartBin.formatCheck(['foo'], host: container.createProcessHost()),
    ).withQueue.isDone();
  });
}
