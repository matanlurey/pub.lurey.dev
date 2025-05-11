// Intentionally uses a builder-style API.
// ignore_for_file: avoid_returning_this

import 'dart:collection';
import 'dart:convert';

import 'package:armory/armory.dart';
import 'package:codex/src/value.dart';
import 'package:meta/meta.dart';

part 'schema/_field.dart';
part 'schema/_tag.dart';
part 'schema/_builder.dart';

/// A type-safe encodable format that can be defined at runtime.
@immutable
final class Schema {
  const Schema._(this._fields);

  /// Returns a builder for a new schema.
  static SchemaBuilder builder() {
    return SchemaBuilder();
  }

  /// All of the fields in the message, in the order of their indices.
  Iterable<Field> get fields => _fields;
  final List<Field> _fields;

  /// Returns a new dynamic message with the contents changed by [update].
  ///
  /// ```dart
  /// final message = DynamicMessage();
  /// final updated = message.update((b) => b.add('field', ValueKind.string));
  /// ```
  @useResult
  Schema update(void Function(SchemaBuilder) update) {
    final builder = toBuilder();
    update(builder);
    return builder.build();
  }

  /// Creates a mutable copy of `this`.
  @useResult
  SchemaBuilder toBuilder() {
    return SchemaBuilder._([..._fields]);
  }

  /// Returns the field at the given [index].
  Field fieldAt(int index) {
    return _fields[index];
  }

  /// Returns the field at the given [index].
  ///
  /// An alias for [fieldAt].
  Field operator [](int index) {
    return fieldAt(index);
  }

  /// Returns the field with the given [name].
  ///
  /// If the field is not found, returns `null`.
  Field? fieldNamed(String name) {
    for (final field in _fields) {
      if (field.name == name) {
        return field;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is Schema && _fields.deepEquals(other._fields);
  }

  @override
  int get hashCode => Object.hashAll(_fields);

  @override
  String toString() {
    return 'Schema ${const JsonEncoder.withIndent('  ', _toEncodable).convert(_fields)}';
  }

  static Object? _toEncodable(Object? other) => '$other';
}
