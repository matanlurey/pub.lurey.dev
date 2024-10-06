import 'dart:io' as io;

import 'package:path/path.dart' as p;

/// Finds the mono repository root directory.
///
/// The [start] directory is used as the starting point for the search.
///
/// As a heuristic, the search will stop at the first directory that contains a
/// `pubspec.yaml` file that contains the string `workspace:`.
String findRootDir([String? start]) {
  start ??= p.current;
  var dir = io.Directory(start);
  while (!p.equals(dir.path, p.rootPrefix(dir.path))) {
    final pubspec = io.File(p.join(dir.path, 'pubspec.yaml'));
    if (pubspec.existsSync() &&
        pubspec.readAsStringSync().contains('workspace:')) {
      return dir.path;
    }
    dir = dir.parent;
  }
  throw StateError('Could not find mono repository root directory.');
}
