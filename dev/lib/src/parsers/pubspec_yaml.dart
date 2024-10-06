import 'package:yaml/yaml.dart';

/// Parses a pubspec file.
///
/// ---
///
/// See <https://dart.dev/tools/pub/pubspec>.
final class PubspecYaml {
  /// Creates a new pubspec parser for the given document.
  PubspecYaml.from(this._doc);
  final YamlDocument _doc;

  /// If publishing is enabled.
  bool get isPublishable {
    final publish = (_doc.contents as YamlMap)['publish_to'];
    if (publish == null) {
      return true;
    }
    return publish != 'none';
  }

  /// Description of the package.
  String get description {
    final description = (_doc.contents as YamlMap)['description'];
    if (description == null) {
      return '';
    }
    if (description is! String) {
      throw FormatException(
        'Expected a string, got ${description.runtimeType}',
        _doc.span.text,
      );
    }
    return description;
  }
}
