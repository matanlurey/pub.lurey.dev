// Intentionally uses a builder-style API.
// ignore_for_file: avoid_returning_this

import 'package:codex/src/value.dart';
import 'package:meta/meta.dart';

/// A field descriptor for a message.
@immutable
final class FieldDescriptor {
  /// Creates a field descriptor.
  const FieldDescriptor(this.index, this.tag, {this.name});

  /// Index of the field.
  final int index;

  /// Name of the field.
  final String? name;

  /// Type of the field.
  final ValueTag tag;

  @override
  bool operator ==(Object other) {
    if (other is! FieldDescriptor) {
      return false;
    }
    return index == other.index && tag == other.tag && name == other.name;
  }

  @override
  int get hashCode => Object.hash(index, tag, name);

  @override
  String toString() {
    if (name case final name?) {
      return 'FieldDescriptor($index, $tag, name: $name)';
    } else {
      return 'FieldDescriptor($index, $tag)';
    }
  }
}

/// Incrementally defines a [Schema], a type-safe encodable format.
final class SchemaBuilder {
  /// Creates a new [SchemaBuilder].
  factory SchemaBuilder() => SchemaBuilder._([]);

  const SchemaBuilder._(this._fields);

  /// All of the fields in the message, in the order of their indices.
  Iterable<FieldDescriptor> get fields => _fields;
  final List<FieldDescriptor> _fields;

  /// Returns a built message.
  Schema build() {
    return Schema._([..._fields]);
  }

  /// Adds a field to the message.
  ///
  /// The field index is automatically assigned as the next available index.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final message = DynamicMessageBuilder();
  /// message.addField('field', ValueTag.string);
  /// ```
  SchemaBuilder addField(ValueTag tag, {String? fieldName}) {
    final index = _fields.length;
    final field = FieldDescriptor(index, tag, name: fieldName);
    _fields.add(field);
    return this;
  }

  /// Adds a reserved field or fields to the message, starting at [index].
  ///
  /// May optionally specify [count] to reserve multiple fields in a range.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final message = DynamicMessageBuilder();
  ///
  /// // Reserve a single field at index 2.
  /// message.reserve(2);
  ///
  /// // Reserve a range of fields from index 3 to 5.
  /// message.reserve(3, 3);
  /// ```
  SchemaBuilder reserve(int index, [int count = 1]) {
    // Check that the count is valid.
    if (count < 1) {
      throw ArgumentError.value(count, 'count', 'Must be greater than 0');
    }

    // If index = length, we can just add a reserved field.
    if (index == _fields.length) {
      final field = FieldDescriptor(index, ValueTag.none);
      _fields.add(field);
      return this;
    }

    // Check that the index is valid.1
    RangeError.checkValidIndex(index, _fields, 'index');

    // While the index is an existing field, replace it with a reserved field.
    // Decrement the count.
    // After the loop, if count > 0, add reserved fields.
    while (count > 0) {
      setField(index, ValueTag.none);
      count--;
      index++;
    }

    return this;
  }

  /// Sets the field at [index] to the given [value].
  ///
  /// If the [index] is not already present, it will be added, adding reserved
  /// fields as necessary.
  ///
  /// The [fieldName] may be used for debugging purposes, but is not required.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final message = DynamicMessageBuilder();
  /// message.seField(0, ValueTag.string);
  /// message.seField(1, ValueTag.int, fieldName: 'myField');
  /// ```
  SchemaBuilder setField(int index, ValueTag value, {String? fieldName}) {
    // Check that the index is valid.
    RangeError.checkNotNegative(index, 'index');

    // If the field is already present, set it.
    if (index < _fields.length) {
      final field = _fields[index];
      _fields[index] = FieldDescriptor(field.index, value, name: fieldName);
      return this;
    }

    // If the field is not present, add reserved fields as necessary.
    while (_fields.length < index) {
      final field = FieldDescriptor(_fields.length, ValueTag.none);
      _fields.add(field);
    }

    // Add the field.
    final field = FieldDescriptor(index, value, name: fieldName);
    _fields.add(field);
    return this;
  }
}

/// A type-safe encodable format that can be defined at runtime.
@immutable
final class Schema {
  const Schema._(this._fields);

  /// Returns a builder for a new schema.
  static SchemaBuilder builder() {
    return SchemaBuilder();
  }

  /// All of the fields in the message, in the order of their indices.
  Iterable<FieldDescriptor> get fields => _fields;
  final List<FieldDescriptor> _fields;

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
  FieldDescriptor fieldAt(int index) {
    return _fields[index];
  }

  /// Returns the field at the given [index].
  ///
  /// An alias for [fieldAt].
  FieldDescriptor operator [](int index) {
    return fieldAt(index);
  }

  /// Returns the field with the given [name].
  ///
  /// If the field is not found, returns `null`.
  FieldDescriptor? fieldNamed(String name) {
    for (final field in _fields) {
      if (field.name == name) {
        return field;
      }
    }
    return null;
  }
}
