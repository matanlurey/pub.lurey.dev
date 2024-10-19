@TestOn('vm')
@Tags(['e2e'])
library;

import 'dart:io' as io;

import 'package:sdk/sdk.dart';

import '../_prelude.dart';
import '_sandbox.dart';

void main() {
  final dartBin = Dart.fromPath(io.Platform.resolvedExecutable);

  group('successful', () {
    late final io.Directory sandbox;

    setUpAll(() async {
      sandbox = await createPackage(
        'e2e_example_pkg',
        libContents: [
          '/// Adds two integers.',
          'int add(int a, int b) => a + b;',
          '',
        ].join('\n'),
        testContents: [
          "import 'package:e2e_example_pkg/e2e_example_pkg.dart';",
          "import 'package:test/test.dart';",
          '',
          'void main() {',
          "  test('adds two integers', () {",
          '    expect(add(1, 2), 3);',
          '  });',
          '}',
          '',
        ].join('\n'),
        supportCoverage: true,
      );
    });

    tearDownAll(() async {
      // await sandbox.delete(recursive: true);
    });

    test('check', () async {
      await runCommand(
        dartBin.binPath,
        ['run', 'chore', 'check'],
        workingDirectory: sandbox.path,
      );
    });

    test('test', () async {
      await runCommand(
        dartBin.binPath,
        ['run', 'chore', 'test'],
        workingDirectory: sandbox.path,
      );
    });

    test('coverage', () async {
      await runCommand(
        dartBin.binPath,
        ['run', 'chore', 'coverage'],
        workingDirectory: sandbox.path,
      );
    });
  });
}
