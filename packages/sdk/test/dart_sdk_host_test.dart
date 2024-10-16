@TestOn('vm')
library;

import 'dart:io' as io;
import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  final dart = Dart.fromPath(io.Platform.resolvedExecutable);
  if (!io.File(dart.binPath).existsSync()) {
    fail('Could not determine the Dart SDK.');
  }
  final sdk = dart.sdk;

  test('version', () async {
    await check(() => sdk.version).returnsNormally().completes();
  });

  test('revision', () async {
    await check(() => sdk.revision).returnsNormally().completes();
  });

  test('dart --version', () async {
    await check(sdk.dart.version).returnsNormally().completes();
  });
}
