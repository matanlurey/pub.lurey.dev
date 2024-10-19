import 'dart:io' as io;

import 'package:chore/src/internal/dart_test_config.dart';
import 'package:chore/src/internal/pubspec.dart';
import 'package:chore/src/test_deps.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:quirk/quirk.dart';

/// Represents a package within a repository.
///
/// Packages can either be a [Workspace] or just a regular package.
@immutable
sealed class Package {
  /// Resolves a package from the given [path].
  static Future<Package> resolve(String path) async {
    final pubspecPath = p.join(path, 'pubspec.yaml');
    final pubspecFile = io.File(pubspecPath);
    final contents = await pubspecFile.readAsString();
    final pubspec = Pubspec.parseFrom(
      contents,
      sourceUrl: Uri.parse(pubspecPath),
    );

    if (pubspec.workspace case final packages?) {
      return Workspace(
        path: path,
        name: pubspec.name,
        isPublishable: pubspec.isPublishable,
        description: pubspec.description,
        shortDescription: pubspec.shortDescription,
        packages: packages.toSetRejectDuplicates(),
      );
    }

    // Check if dart_test.yaml exists.
    final dartTestPath = p.join(path, 'dart_test.yaml');
    final testDeps = <TestDependency>{};
    var supportsCoverage = false;
    try {
      final dartTest = DartTest.parseFrom(
        await io.File(dartTestPath).readAsString(),
        sourceUrl: Uri.parse(dartTestPath),
      );
      // If a platform is set, 'vm' must also exist to report coverage.
      if (dartTest.presets?.contains('coverage') ?? false) {
        supportsCoverage = true;
      }
      // Check if chrome is required.
      if (dartTest.platforms?.contains('chrome') ?? false) {
        testDeps.add(TestDependency.chrome);
      }
    } on io.FileSystemException {
      // Ignore.
    }

    return Package(
      path: path,
      name: pubspec.name,
      isPublishable: pubspec.isPublishable,
      description: pubspec.description,
      shortDescription: pubspec.shortDescription,
      testDependencies: testDeps,
      supportsCoverage: supportsCoverage,
    );
  }

  /// Describes a package.
  factory Package({
    required String path,
    required String name,
    required bool isPublishable,
    required bool supportsCoverage,
    String? description,
    String? shortDescription,
    Set<TestDependency> testDependencies,
  }) = _Package;

  Package._({
    required this.path,
    required this.name,
    required this.isPublishable,
    required this.supportsCoverage,
    this.description,
    this.shortDescription,
    Set<TestDependency> testDependencies = const {},
  }) : testDependencies = Set.unmodifiable(testDependencies);

  /// Path of the package.
  final String path;

  /// Name of the package.
  final String name;

  /// Description of the package.
  ///
  /// If omitted, the package is considered to have no description.
  final String? description;

  /// Short description of the package.
  ///
  /// If omitted, the package is considered to have no short description.
  final String? shortDescription;

  /// Whether the package is publishable.
  final bool isPublishable;

  /// Dependencies required for testing.
  final Set<TestDependency> testDependencies;

  /// Whether coverage is supported.
  final bool supportsCoverage;

  @override
  bool operator ==(Object other) {
    return other is Package &&
        name == other.name &&
        description == other.description &&
        shortDescription == other.shortDescription &&
        isPublishable == other.isPublishable &&
        testDependencies.containsOnlyUnordered(other.testDependencies) &&
        supportsCoverage == other.supportsCoverage;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      description,
      shortDescription,
      isPublishable,
      Object.hashAllUnordered(testDependencies),
      supportsCoverage,
    );
  }

  @override
  @mustBeOverridden
  String toString();
}

final class _Package extends Package {
  _Package({
    required super.path,
    required super.name,
    required super.isPublishable,
    required super.supportsCoverage,
    super.description,
    super.shortDescription,
    super.testDependencies,
  }) : super._();

  @override
  String toString() {
    return 'Package <$name: $path>';
  }
}

/// Represents a package that is a workspace.
final class Workspace extends _Package {
  /// Resolves a workspace from the given [path].
  static Future<Workspace> resolve(String path) async {
    final package = await Package.resolve(path);
    if (package is! Workspace) {
      throw ArgumentError('Expected a workspace, got $package');
    }
    return package;
  }

  /// Describes a workspace package.
  Workspace({
    required super.path,
    required super.name,
    required super.isPublishable,
    Set<String> packages = const {},
    super.description,
    super.shortDescription,
  })  : packages = Set.unmodifiable(packages),
        super(supportsCoverage: false);

  /// Paths of packages that are part of the workspace.
  ///
  /// The paths are relative to [path].
  final Set<String> packages;

  @override
  bool operator ==(Object other) {
    if (other is! Workspace || super != other) {
      return false;
    }
    return packages.containsOnly(other.packages);
  }

  @override
  int get hashCode {
    return Object.hash(super.hashCode, Object.hashAllUnordered(packages));
  }

  @override
  String toString() {
    return 'Workspace <$name: $path>';
  }
}
