#!/usr/bin/env dart

import 'dart:io' as io;
import 'package:sdk/sdk.dart';

/// Print information about the current Dart SDK.
///
/// Try running this both with the Dart VM, and as an AOT compiled binary:
/// ```sh
/// dart example/dart_sdk.dart
/// dart compile exe example/dart_sdk.dart -o example/dart_sdk && ./example/dart_sdk || rm example/dart_sdk
/// ```
void main() async {
  final sdk = DartSdk.current;
  if (sdk == null) {
    io.stderr.writeln('Could not determine the Dart SDK.');
    io.exitCode = 1;
    return;
  }

  io.stdout.writeln('Resolved SDK: ${sdk.sdkPath}');
  io.stdout.writeln('Version:      ${(await sdk.version).name}');
  io.stdout.write('Revision:     ${await sdk.revision}');
}
