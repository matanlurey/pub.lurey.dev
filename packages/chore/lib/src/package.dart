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
        isFlutterPackage: pubspec.dependencies.contains('flutter'),
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

    // Check for other pubspec.yaml files in the package.
    final nestedPackages = <Package>{};
    await for (final entity in io.Directory(path).list(recursive: true)) {
      if (entity is io.Directory) {
        final nestedPubspecPath = p.join(entity.path, 'pubspec.yaml');
        if (await io.File(nestedPubspecPath).exists()) {
          nestedPackages.add(await resolve(entity.path));
        }
      }
    }

    return Package(
      path: path,
      name: pubspec.name,
      version: pubspec.version,
      isPublishable: pubspec.isPublishable,
      isFlutterPackage: pubspec.dependencies.contains('flutter'),
      description: pubspec.description,
      shortDescription: pubspec.shortDescription,
      testDependencies: testDeps,
      nestedPackages: nestedPackages,
      supportsCoverage: supportsCoverage,
    );
  }

  /// Describes a package.
  factory Package({
    required String path,
    required String name,
    required bool isPublishable,
    required bool isFlutterPackage,
    required bool supportsCoverage,
    String? version,
    String? description,
    String? shortDescription,
    Set<TestDependency> testDependencies,
    Set<Package> nestedPackages,
  }) = _Package;

  Package._({
    required this.path,
    required this.name,
    required this.isPublishable,
    required this.supportsCoverage,
    required this.isFlutterPackage,
    this.version,
    this.description,
    this.shortDescription,
    Set<TestDependency> testDependencies = const {},
    Set<Package> nestedPackages = const {},
  })  : testDependencies = Set.unmodifiable(testDependencies),
        nestedPackages = Set.unmodifiable(nestedPackages);

  /// Path of the package.
  final String path;

  /// Name of the package.
  final String name;

  /// Version of the package.
  ///
  /// If omitted, the package is considered to have no version.
  final String? version;

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

  /// Whether the package uses the Flutter SDK.
  final bool isFlutterPackage;

  /// Dependencies required for testing.
  final Set<TestDependency> testDependencies;

  /// Whether coverage is supported.
  final bool supportsCoverage;

  /// Nested packages, often examples or test fixtures.
  final Set<Package> nestedPackages;

  @override
  bool operator ==(Object other) {
    return other is Package &&
        name == other.name &&
        version == other.version &&
        description == other.description &&
        shortDescription == other.shortDescription &&
        isPublishable == other.isPublishable &&
        isFlutterPackage == other.isFlutterPackage &&
        testDependencies.containsOnlyUnordered(other.testDependencies) &&
        nestedPackages.containsOnlyUnordered(other.nestedPackages) &&
        supportsCoverage == other.supportsCoverage;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      version,
      description,
      shortDescription,
      isPublishable,
      isFlutterPackage,
      Object.hashAllUnordered(testDependencies),
      Object.hashAllUnordered(nestedPackages),
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
    required super.isFlutterPackage,
    super.version,
    super.description,
    super.shortDescription,
    super.testDependencies,
    super.nestedPackages,
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
    required super.isFlutterPackage,
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
