import 'dart:io';

import 'package:chore/src/command/check.dart';
import 'package:chore/src/environment.dart';
import 'package:chore/src/package.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';

/// Ensures the `version: ...` field in `pubspec.yaml` matches `CHANGELOG.md`.
final class PubspecVersionSync extends Checker {
  /// Creates a new pubspec version sync checker.
  const PubspecVersionSync();

  @override
  String get name => 'Pubspec Version Sync';

  @override
  Future<bool> run(
    Package package,
    Environment environment, {
    bool fix = false,
  }) async {
    // Find the `pubspec.yaml` file.
    final pubspecFile = File(p.join(package.path, 'pubspec.yaml'));
    if (!await pubspecFile.exists()) {
      return false;
    }

    // Find the `CHANGELOG.md` file.
    final changelogFile = File(p.join(package.path, 'CHANGELOG.md'));
    if (!await changelogFile.exists()) {
      return false;
    }

    // Find the last version in the `CHANGELOG.md` file.
    // Match the first occurrence of a line that starts with `## ` followed by a version.
    final changelog = await changelogFile.readAsString();
    final match = _changelogVersion.firstMatch(changelog);
    if (match == null) {
      return false;
    }

    final changelogVersion = Version.parse(match[1]!);
    if (package.version == changelogVersion.toString()) {
      return false;
    }

    // If it's fixable, update the `version` field in `pubspec.yaml`.
    if (fix) {
      var contents = await pubspecFile.readAsString();
      contents = contents.replaceFirst(
        _pubspecVersion,
        'version: $changelogVersion',
      );
      await pubspecFile.writeAsString(contents);
      return false;
    }

    stderr.writeln(
      '❌ Found mismatch between pubspec.yaml (${package.version}) and '
      'CHANGELOG.md ($changelogVersion).',
    );
    return true;
  }

  static final _changelogVersion = RegExp(r'^## (\d+\.\d+\.\d+.*)$');
  static final _pubspecVersion = RegExp(r'^version: (\d+\.\d+\.\d+.*)$');
}
