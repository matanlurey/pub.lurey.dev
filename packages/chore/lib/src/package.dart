import 'dart:io' as io;

import 'package:chore/src/internal/pubspec.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

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
        packages: packages,
      );
    }

    return Package(
      path: path,
      name: pubspec.name,
      isPublishable: pubspec.isPublishable,
      description: pubspec.description,
      shortDescription: pubspec.shortDescription,
    );
  }

  /// Describes a package.
  factory Package({
    required String path,
    required String name,
    required bool isPublishable,
    String? description,
    String? shortDescription,
  }) = _Package;

  const Package._({
    required this.path,
    required this.name,
    required this.isPublishable,
    this.description,
    this.shortDescription,
  });

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

  @override
  @mustCallSuper
  bool operator ==(Object other) {
    assert(other is Package, 'Child classes must override == operator.');
    other as Package;

    return name == other.name &&
        description == other.description &&
        shortDescription == other.shortDescription &&
        isPublishable == other.isPublishable;
  }

  @override
  @mustCallSuper
  int get hashCode {
    return Object.hash(
      name,
      description,
      shortDescription,
      isPublishable,
    );
  }

  @override
  @mustBeOverridden
  String toString();
}

final class _Package extends Package {
  const _Package({
    required super.path,
    required super.name,
    required super.isPublishable,
    super.description,
    super.shortDescription,
  }) : super._();

  @override
  String toString() {
    return 'Package <$name: $path>';
  }
}

/// Represents a package that is a workspace.
final class Workspace extends _Package {
  /// Describes a workspace package.
  Workspace({
    required super.path,
    required super.name,
    required super.isPublishable,
    Iterable<String> packages = const [],
    super.description,
    super.shortDescription,
  }) : packages = List.unmodifiable(packages);

  /// Paths of packages that are part of the workspace.
  ///
  /// The paths are relative to [path].
  final List<String> packages;

  @override
  String toString() {
    return 'Workspace <$name: $path>';
  }
}
