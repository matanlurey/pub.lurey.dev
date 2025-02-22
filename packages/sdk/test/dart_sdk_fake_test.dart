import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  late io.Directory tmpDir;

  setUp(() async {
    tmpDir = await io.Directory.systemTemp.createTemp('sdk_test');
  });

  tearDown(() async {
    await tmpDir.delete(recursive: true);
  });

  test('version', () async {
    final file = io.File(p.join(tmpDir.path, 'version'));
    await file.writeAsString('2.14.0');

    final sdk = DartSdk.fromPath(tmpDir.path);
    await check(
      sdk.version,
    ).completes((e) => e.equals(SemanticVersion.from(2, 14, 0)));
  });

  test('revision', () async {
    final file = io.File(p.join(tmpDir.path, 'revision'));
    await file.writeAsString('abc123');

    final sdk = DartSdk.fromPath(tmpDir.path);
    await check(sdk.revision).completes((e) => e.equals('abc123'));
  });

  test('sdkPath', () {
    final sdk = DartSdk.fromPath(tmpDir.path);
    check(sdk.sdkPath).equals(tmpDir.path);
  });

  test('dart --version', () async {
    final container = ExecutableContainer();
    container.setExecutable(p.join(tmpDir.path, 'bin', 'dart'), (start) {
      return Process.complete(
        stdout: [
          'Dart SDK version: 3.5.1 (stable) (Tue Aug 13 21:02:17 2024 +0000) on "macos_arm64"',
        ],
      );
    });

    final sdk = DartSdk.fromPath(tmpDir.path);
    await check(
      sdk.dart.version(host: container.createProcessHost()),
    ).completes(
      (e) => e.equals(
        SdkVersion(
          channel: Channel.stable,
          version: SemanticVersion.from(3, 5, 1),
          releasedOn: DateTime(2024, 8, 13, 21, 2, 17),
          operatingSystem: OperatingSystem.macos,
          architecture: Architecture.arm64,
        ),
      ),
    );
  });
}
