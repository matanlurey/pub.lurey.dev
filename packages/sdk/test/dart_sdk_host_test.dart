import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  final sdk = DartSdk.current;
  if (sdk == null) {
    fail('Could not determine the Dart SDK.');
  }

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
