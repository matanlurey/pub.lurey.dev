@internal
library;

import 'package:chore/src/internal/yaml_wrapper.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// A package internal representation of a `pubspec.yaml` file.
///
/// <https://pub.dev/packages/pubspec_parse> is a better alternative for most.
@immutable
final class Pubspec extends YamlWrapper {
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

  const Pubspec._(super.root);

  /// Name of the package.
  String get name => loadString('name') ?? isRequired('name');

  /// Version of the package.
  ///
  /// If omitted, the default is `null`.
  String? get version => loadString('version');

  /// If publishing is enabled.
  bool get isPublishable => root['publish_to'] != 'none';

  /// Description of the package.
  ///
  /// If omitted, the default is `null`.
  String? get description => loadString('description');

  /// Short description of the package.
  ///
  /// If omitted, the default is `null`.
  String? get shortDescription => loadString('short_description');

  /// Packages in the workspace.
  ///
  /// If this is not a workspace, the default is `null`.
  List<String>? get workspace => loadStringList('workspace');
}
