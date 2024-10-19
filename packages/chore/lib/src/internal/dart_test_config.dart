@internal
library;

import 'package:chore/src/internal/yaml_wrapper.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// <https://github.com/dart-lang/test/blob/master/pkgs/test/doc/configuration.md>.
final class DartTest extends YamlWrapper {
  /// Parses the Dart test configuration from the given YAML document
  /// [contents].
  factory DartTest.parseFrom(String contents, {Uri? sourceUrl}) {
    final doc = loadYamlDocument(contents, sourceUrl: sourceUrl);
    final map = doc.contents;
    if (map is! YamlMap) {
      throw FormatException(
        'Expected a map, got ${map.runtimeType}',
        doc.span.text,
      );
    }
    return DartTest._(map);
  }

  /// Creates a synthetic Dart test configuration from the given root node.
  @visibleForTesting
  factory DartTest.from(Map<String, Object?> root) {
    return DartTest._(YamlMap.wrap(root));
  }

  const DartTest._(super.root);

  /// Platforms that tests should execute on.
  ///
  /// If omitted, the default is `null`.
  List<String>? get platforms => loadStringList('platforms');

  /// Presets that exist in the configuration.
  ///
  /// If omitted, the default is `null`.
  Set<String>? get presets {
    final value = root['presets'];
    if (value == null) {
      return null;
    }
    if (value is! Map) {
      throw FormatException(
        'Expected a map, got ${value.runtimeType}',
        root.span.text,
      );
    }
    return value.keys.cast<String>().toSet();
  }
}
