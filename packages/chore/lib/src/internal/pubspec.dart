@internal
library;

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// A package internal representation of a pubspec file.
///
/// <https://pub.dev/packages/pubspec_parse> is a better alternative for most.
final class Pubspec {
  /// Parses the pubspec from the given YAML document [contents].
  factory Pubspec.parseFrom(String contents, {Uri? sourceUrl}) {
    final doc = loadYamlDocument(contents, sourceUrl: sourceUrl);
    final map = doc.contents;
    if (map is! YamlMap) {
      throw FormatException(
        'Expected a map, got ${map.runtimeType}',
        doc.span.text,
      );
    }
    return Pubspec._(map);
  }

  /// Creates a synthetic pubspec from the given root node.
  @visibleForTesting
  factory Pubspec.from(Map<String, Object?> root) {
    return Pubspec._(YamlMap.wrap(root));
  }

  const Pubspec._(this._root);
  final YamlMap _root;

  String? _loadString(String key) {
    final value = _root[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw FormatException(
        'Expected a string, got ${value.runtimeType}',
        _root.span.text,
      );
    }
    return value;
  }

  List<String>? _loadStringList(String key) {
    final value = _root[key];
    if (value == null) {
      return null;
    }
    if (value is! List) {
      throw FormatException(
        'Expected a list, got ${value.runtimeType}',
        _root.span.text,
      );
    }
    if (value.any((e) => e is! String)) {
      throw FormatException(
        'Expected a list of strings',
        _root.span.text,
      );
    }
    return List<String>.from(value);
  }

  Never _isRequired(String name) {
    throw FormatException(
      'Missing required field: $name',
      _root.span.text,
    );
  }

  /// Name of the package.
  String get name => _loadString('name') ?? _isRequired('name');

  /// If publishing is enabled.
  bool get isPublishable => _root['publish'] != 'none';

  /// Description of the package.
  ///
  /// If omitted, the default is `null`.
  String? get description => _loadString('description');

  /// Short description of the package.
  ///
  /// If omitted, the default is `null`.
  String? get shortDescription => _loadString('short_description');

  /// Packages in the workspace.
  ///
  /// If this is not a workspace, the default is `null`.
  List<String>? get workspace => _loadStringList('workspace');
}
