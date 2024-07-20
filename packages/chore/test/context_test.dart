@TestOn('vm')
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:checks/checks.dart';
import 'package:chore/chore.dart';
import 'package:test/test.dart' show TestOn, test;

void main() {
  test('should run and execute cleanups', () async {
    late io.Directory tempDir;

    await run((context) async {
      tempDir = await context.use(getTempDir());
      check(tempDir.existsSync()).isTrue();
    });

    check(tempDir.existsSync()).isFalse();
  });

  test('should terminate', () async {
    final sigint = StreamController<int>();
    final context = Context(terminate: [sigint.stream]);

    Timer.run(() {
      sigint.add(0);
    });

    await run(
      (context) async => context.use(waitUntilTerminated()),
      context: context,
    );
  });
}
