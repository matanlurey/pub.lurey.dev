import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:sdk/src/dart_bin.dart';
import 'package:sdk/src/semantic_version.dart';

/// A representation of the Dart SDK installed on the local machine.
interface class DartSdk {
  /// Creates a reference to the Dart SDK at the given path.
  ///
  /// It is assumed that the given path is the `libexec` directory of the Dart
  /// SDK, which includes folders such as `bin`, `include`, `lib`, `pkg`,
  /// `revision`, `sdk_packages.yaml`, and `version`, but does not verify that
  /// the path is valid.
  factory DartSdk.fromPath(String sdkPath) = DartSdk._;

  DartSdk._(this.sdkPath);

  /// The path to the root of the Dart SDK.
  final String sdkPath;

  /// Reference to the `dart` binary in the SDK.
  late final dart = Dart.fromPath(p.join(sdkPath, 'bin', 'dart'));

  /// Version information for the Dart SDK.
  Future<SemanticVersion> get version async {
    final contents = await io.File(p.join(sdkPath, 'version')).readAsString();
    return SemanticVersion.parse(contents.trim());
  }

  /// Revision information for the Dart SDK.
  Future<String> get revision async {
    return io.File(p.join(sdkPath, 'revision')).readAsString();
  }
}
