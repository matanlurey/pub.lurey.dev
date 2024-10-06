import 'dart:io' as io;

import 'package:path/path.dart' as p;

/// Generic interface for writing files relative to a predefined base directory.
interface class FileSink {
  /// Creates a new [FileSink] that writes files relative to a base directory.
  FileSink.fromBaseDir(this._baseDir);
  final String _baseDir;

  /// Writes the given string content as the file at the given relative path.
  Future<void> write(
    String relativePath,
    String content,
  ) async {
    final file = io.File(p.join(_baseDir, relativePath));
    await file.writeAsString(content);
  }

  static final _regionPattern = RegExp(r'#region\(([^)]+)\)');

  /// Write the given string content in region blocks in the given file.
  ///
  /// For each key-value pair in [regions], the key is the region name and the
  /// value is the content of the region. The content of the region is written
  /// between `#region(name)` and `#endregion(name)` comments, replacing any
  /// existing content in the region.
  Future<void> writeRegions(
    String relativePath,
    Map<String, String> regions,
  ) async {
    final file = io.File(p.join(_baseDir, relativePath));
    final lines = await file.readAsLines();
    final pending = regions.keys.toSet();

    // Iterate over the lines in the file and write the regions.
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Check if the line is the start of a region.
      final match = _regionPattern.firstMatch(line);
      if (match == null) {
        continue;
      }

      // Check if the region is in the list of regions to write.
      final regionName = match.group(1);
      if (!regions.containsKey(regionName)) {
        continue;
      }

      // Find the end of the region.
      var end = i + 1;
      final search = '#endregion($regionName)';
      while (end < lines.length && !lines[end].contains(search)) {
        end++;
      }

      // Clear the region and write the new content.
      lines.replaceRange(i + 1, end, regions[regionName]!.split('\n'));

      // Mark the region as written.
      pending.remove(regionName);
    }

    // If any regions were not written, throw.
    if (pending.isNotEmpty) {
      throw StateError('Regions not found: $pending');
    }

    // Write the modified lines back to the file.
    await file.writeAsString(lines.join('\n'));
  }
}
