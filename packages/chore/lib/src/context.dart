import 'dart:io' as io;

import 'package:chore/src/internal/pubspec.dart';
import 'package:collection/collection.dart';
import 'package:lore/lore.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

/// Finds the root directory of a repository.
///
/// By default, finds the first directory that contains a `pubspec.yaml` file,
/// but [package] can be used to specify a different package name.
///
/// The [start] directory is used as the starting point for the search, and
/// defaults to the current working directory.
Future<String?> findRootDir({String? start, String? package}) async {
  start ??= p.current;
  var dir = io.Directory(start);
  while (!p.equals(dir.path, p.rootPrefix(dir.path))) {
    final pubspec = io.File(p.join(dir.path, 'pubspec.yaml'));
    try {
      final contents = await pubspec.readAsString();
      if (package != null) {
        final pubspec = Pubspec.parseFrom(contents);
        if (pubspec.name == package) {
          return dir.path;
        }
      } else {
        return dir.path;
      }
    } on io.FileSystemException {
      // ignore
    }
    dir = dir.parent;
  }
  return null;
}

/// Top-level context for executing a tool.
@immutable
final class Context {
  /// Creates a new context.
  Context({
    required this.rootDir,
    this.packages = const [],
    this.logLevel = Level.status,
  });

  /// The root directory of the repository.
  final String rootDir;

  /// Packages to consider when running commands.
  final List<String> packages;

  /// What log level to use.
  final Level logLevel;

  @override
  bool operator ==(Object other) {
    if (other is! Context) {
      return false;
    }

    const eq = UnorderedIterableEquality<Object?>();
    if (rootDir != other.rootDir) {
      return false;
    }
    if (!eq.equals(packages, other.packages)) {
      return false;
    }
    if (logLevel != other.logLevel) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      rootDir,
      Object.hashAllUnordered(packages),
      logLevel,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('Context(')..writeln();
    buffer.writeln("  rootDir: '$rootDir',");
    buffer.writeln('  logLevel: $logLevel,');
    buffer.writeln('  packages: $packages,');
    buffer.write(')');
    return buffer.toString();
  }
}
