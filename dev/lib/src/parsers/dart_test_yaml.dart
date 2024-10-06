import 'package:yaml/yaml.dart';

/// Parses a Dart test configuration file.
///
/// ---
///
/// See <https://github.com/dart-lang/test/blob/master/pkgs/test/doc/configuration.md>.
final class DartTestYaml {
  /// Creates a new Dart test configuration parser for the given document.
  DartTestYaml.from(this._doc);
  final YamlDocument _doc;

  /// Platforms that tests should execute on.
  Iterable<String> get platforms {
    final platforms = (_doc.contents as YamlMap)['platforms'];
    if (platforms == null) {
      return const [];
    }
    if (platforms is! YamlList) {
      throw FormatException('Expected a list of platforms.', _doc.span);
    }
    final nodes = platforms.nodes;
    if (nodes.any((node) => node is! YamlScalar || node.value is! String)) {
      throw FormatException('Expected a list of strings.', _doc.span);
    }
    return nodes.map((node) => (node as YamlScalar).value as String);
  }
}
