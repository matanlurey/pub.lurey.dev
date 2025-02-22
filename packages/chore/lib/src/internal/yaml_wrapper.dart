@internal
library;

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// A package internal representation of a YAML file.
@immutable
base class YamlWrapper {
  /// Creates a new YAML wrapper around the given [root] node.
  const YamlWrapper(this.root);

  /// Root node of the YAML document.
  @protected
  final YamlMap root;

  /// Loads a string from the YAML document.
  ///
  /// If the key is missing, returns `null`.
  ///
  /// If the value is not a string, throws a [FormatException].
  @protected
  String? loadString(String key) {
    final value = root[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw FormatException(
        'Expected a string, got ${value.runtimeType}',
        root.span.text,
      );
    }
    return value;
  }

  /// Loads a list of strings from the YAML document.
  ///
  /// If the key is missing, returns `null`.
  ///
  /// If the value is not a list, throws a [FormatException].
  @protected
  List<String>? loadStringList(String key) {
    final value = root[key];
    if (value == null) {
      return null;
    }
    if (value is! List) {
      throw FormatException(
        'Expected a list, got ${value.runtimeType}',
        root.span.text,
      );
    }
    if (value.any((e) => e is! String)) {
      throw FormatException('Expected a list of strings', root.span.text);
    }
    return List<String>.from(value);
  }

  /// Throws a standard [FormatException] for a missing required field.
  ///
  /// ## Example
  ///
  /// ```dart
  /// String get name => loadString('name') ?? isRequired('name');
  /// ```
  @protected
  Never isRequired(String name) {
    throw FormatException('Missing required field: $name', root.span.text);
  }
}
