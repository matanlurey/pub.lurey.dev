import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:chore/src/internal/pubspec.dart';
import 'package:chore/src/package.dart';
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
  /// Registers arguments for the context.
  static void registerArgs(
    ArgParser parser, {
    required Iterable<String> packages,
    bool verbose = false,
  }) {
    parser.addFlag(
      'no-packages',
      negatable: false,
      help: 'Whether to skip package-specific commands.',
    );
    parser.addMultiOption(
      'packages',
      abbr: 'p',
      help: 'Configuration to use for the command.',
      allowed: packages,
      defaultsTo: packages.length == 1 ? [packages.first] : packages,
      hide: !verbose && packages.length <= 1,
    );
    parser.addMultiOption(
      'match-package-regex',
      abbr: 'x',
      help: 'Regex that can match a package name. Cannot use with --packages.',
      defaultsTo: [],
      hide: !verbose && packages.length <= 1,
    );
  }

  /// Creates a new context.
  Context({
    required this.rootDir,
    required Iterable<String> allPossiblePackages,
    this.logLevel = Level.status,
  }) : allPossiblePackages = List.unmodifiable(allPossiblePackages);

  /// The root directory of the repository.
  final String rootDir;

  /// What log level to use.
  final Level logLevel;

  /// All possible packages in the repository.
  ///
  /// This list is unmodifiable.
  final List<String> allPossiblePackages;

  /// Resolves the context from the command-line arguments.
  Future<List<Package>> resolve(ArgResults topLevelArgs) async {
    if (topLevelArgs.flag('no-packages')) {
      return [];
    }

    // Check if --match-package-regex is used.
    final List<String> packages;
    if (topLevelArgs.multiOption('match-package-regex') case [
      ...final rx,
    ] when rx.isNotEmpty) {
      // Make sure that packages are not used.
      if (topLevelArgs.wasParsed('packages')) {
        throw StateError('Cannot use --match-package-regex with --packages.');
      }

      // Find packages that match at least one regex.
      final regexes = [...rx.map(RegExp.new)];
      packages = [
        for (final package in allPossiblePackages)
          if (regexes.any((regex) => regex.hasMatch(package))) package,
      ];
    } else {
      // Get the packages from the command line.
      packages = topLevelArgs.multiOption('packages');
    }

    return Future.wait(packages.map(Package.resolve));
  }

  @override
  bool operator ==(Object other) {
    if (other is! Context) {
      return false;
    }
    return rootDir == other.rootDir && logLevel == other.logLevel;
  }

  @override
  int get hashCode {
    return Object.hash(rootDir, logLevel);
  }

  @override
  String toString() {
    final buffer = StringBuffer('Context(')..writeln();
    buffer.writeln("  rootDir: '$rootDir',");
    buffer.writeln('  logLevel: $logLevel,');
    buffer.write(')');
    return buffer.toString();
  }
}
