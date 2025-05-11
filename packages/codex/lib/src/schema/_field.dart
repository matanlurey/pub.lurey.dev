part of '../schema.dart';

/// A field descriptor for a message.
@immutable
final class Field {
  /// Creates a field descriptor.
  const Field(this.index, this.tag, {this.name});

  /// Index of the field.
  final int index;

  /// Name of the field.
  final String? name;

  /// Type of the field.
  final FieldTag tag;

  /// Whether the field is optional.
  bool get isOptional => tag._possibleTags.contains(FieldTag.none);

  @override
  bool operator ==(Object other) {
    if (other is! Field) {
      return false;
    }
    return index == other.index && tag == other.tag && name == other.name;
  }

  @override
  int get hashCode => Object.hash(index, tag, name);

  @override
  String toString() {
    if (name case final name?) {
      return 'Field($index, $tag, name: $name)';
    } else {
      return 'Field($index, $tag)';
    }
  }
}
