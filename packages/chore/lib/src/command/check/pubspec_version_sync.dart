import 'dart:io';

import 'package:chore/src/command/check.dart';
import 'package:chore/src/environment.dart';
import 'package:chore/src/package.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart' as yaml;

/// Ensures the `version: ...` field in `pubspec.yaml` matches `CHANGELOG.md`.
final class PubspecVersionSync extends Checker {
  /// Creates a new pubspec version sync checker.
  const PubspecVersionSync();

  @override
  String get name => 'pubspec-version-sync';

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

    // If publish_to: none, skip this check.
    final pubspecContents = await pubspecFile.readAsString();
    final pubspecDocument = yaml.loadYaml(pubspecContents);
    if (pubspecDocument case final yaml.YamlMap map
        when map['publish_to'] == 'none') {
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

    // If the changelog version is `[Unreleased]`, skip this check
    // (this is a common pattern for packages that are in development).
    if (match[1] == '[Unreleased]') {
      return false;
    }

    final changelogVersion = Version.parse(match[1]!);
    if (package.version == changelogVersion.toString()) {
      return false;
    }

    // If it's fixable, update the `version` field in `pubspec.yaml`.
    if (fix) {
      var contents = pubspecContents;
      contents = contents.replaceFirst(
        _pubspecVersion,
        'version: $changelogVersion',
      );
      await pubspecFile.writeAsString(contents);
      stderr.writeln('Updated pubspec.yaml version to $changelogVersion.');
      return false;
    }

    stderr.writeln(
      'Mismatch between pubspec.yaml (${package.version}) and '
      'CHANGELOG.md ($changelogVersion).',
    );
    return true;
  }

  static final _changelogVersion = RegExp(
    r'## ((\d+\.\d+\.\d+.*)\[Unreleased\])',
  );
  static final _pubspecVersion = RegExp(r'version: (\d+\.\d+\.\d+.*)');
}
