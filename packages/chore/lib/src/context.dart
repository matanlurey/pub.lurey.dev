import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/src/internal/pubspec.dart';
import 'package:chore/src/package.dart';
import 'package:lore/lore.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:quirk/quirk.dart';

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
  /// Registers arguments for the context.
  static void registerArgs(
    ArgParser parser, {
    required Iterable<String> packages,
  }) {
    parser.addMultiOption(
      'packages',
      abbr: 'p',
      help: 'Configuration to use for the command.',
      allowed: packages,
    );
  }

  /// Resolves a context based on the given [results] and [rootDir].
  static Future<Context> resolve(
    ArgResults results,
    String rootDir, {
    required Set<String> availablePackages,
  }) async {
    var packages = results.multiOption('packages').toSet();
    if (packages.isEmpty) {
      packages = availablePackages;
    }
    return Context(rootDir: rootDir, packages: packages);
  }

  /// Creates a new context.
  Context({
    required this.rootDir,
    this.logLevel = Level.status,
    Set<String> packages = const {},
  }) : packages = Set.unmodifiable(packages);

  /// The root directory of the repository.
  final String rootDir;

  /// What log level to use.
  final Level logLevel;

  /// Packages, relative to [rootDir], to run commands for.
  final Set<String> packages;

  /// [packages] resolved to [Package] instances based on [rootDir].
  late final resolvedPackages = Future.wait(packages.map(Package.resolve));

  @override
  bool operator ==(Object other) {
    if (other is! Context) {
      return false;
    }
    return rootDir == other.rootDir &&
        logLevel == other.logLevel &&
        packages.containsOnly(other.packages);
  }

  @override
  int get hashCode {
    return Object.hash(
      rootDir,
      logLevel,
      Object.hashAllUnordered(packages),
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
