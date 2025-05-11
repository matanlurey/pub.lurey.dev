part of '../schema.dart';

/// A tag representing the kind of a field.
@immutable
sealed class FieldTag {
  /// Creates a field tag representing a value.
  const factory FieldTag.value(ValueTag tag) = ValueFieldTag;

  /// Creates a field tag representing an optional field.
  const factory FieldTag.optional(FieldTag ifPresent) = OptionalFieldTag;

  /// Creates a field tag representing a union of fields.
  const factory FieldTag.union(Set<FieldTag> possibleTypes) = UnionFieldTag;

  /// Creates a field tag representing a nested message schema.
  const factory FieldTag.message(Schema schema) = MessageFieldTag;

  /// Describes a field that is a [BoolValue].
  static const FieldTag bool = ValueFieldTag(ValueTag.bool);

  /// Describes a field that is a [BytesValue].
  static const FieldTag bytes = ValueFieldTag(ValueTag.bytes);

  /// Describes a field that is a [DoubleValue].
  static const FieldTag double = ValueFieldTag(ValueTag.double);

  /// Describes a field that is a [IntValue].
  static const FieldTag int = ValueFieldTag(ValueTag.int);

  // FIXME: This should be FieldTag.list(FieldTag).
  // We need to know what the type of the list is.

  /// Describes a field that is a [ListValue].
  static const FieldTag list = ValueFieldTag(ValueTag.list);

  // FIXME: This should be FieldTag.map(FieldTag).
  // We need to know what the type of the map is.

  /// Describes a field that is a [MapValue].
  static const FieldTag map = ValueFieldTag(ValueTag.map);

  /// Describes a field that is a [NoneValue].
  static const FieldTag none = ValueFieldTag(ValueTag.none);

  /// Describes a field that is a [StringValue].
  static const FieldTag string = ValueFieldTag(ValueTag.string);

  /// Possible concrete tags of this field.
  Set<FieldTag> get possibleTags;
  Set<FieldTag> get _possibleTags;

  /// Returns a new field tag representing a union of this field and [other].
  ///
  /// Equivalent to `FieldTag.union({...this.possibleTags, ...other.possibleTags})`.
  @useResult
  FieldTag or(FieldTag other);

  /// Returns a new field tag representing a union of this field and [other].
  ///
  /// An alias for [or].
  @useResult
  FieldTag operator |(FieldTag other);

  /// Returns a new field tag representing an optional field.
  ///
  /// Equivalent to `FieldTag.optional(this)`.
  @useResult
  FieldTag optional();
}

base mixin _FieldTag implements FieldTag {
  @override
  Set<FieldTag> get possibleTags => UnmodifiableSetView(_possibleTags);

  @override
  bool operator ==(Object other) {
    return other is FieldTag && _possibleTags.deepEquals(other._possibleTags);
  }

  @override
  int get hashCode => Object.hashAllUnordered(_possibleTags);

  @override
  @nonVirtual
  FieldTag or(FieldTag other) {
    return UnionFieldTag({..._possibleTags, ...other._possibleTags});
  }

  @override
  @nonVirtual
  FieldTag operator |(FieldTag other) {
    return or(other);
  }

  @override
  @nonVirtual
  FieldTag optional() {
    return OptionalFieldTag(this);
  }
}

/// A tag representing a field that is a [ValueTag].
final class ValueFieldTag with _FieldTag {
  /// Creates a field tag representing a value.
  const ValueFieldTag(this.tag);

  /// The value tag of this field.
  final ValueTag tag;

  @override
  bool operator ==(Object other) {
    if (other is ValueFieldTag) {
      return tag == other.tag;
    }
    if (other is FieldTag) {
      return _possibleTags.deepEquals(other._possibleTags);
    }
    return false;
  }

  @override
  int get hashCode => tag.hashCode;

  @override
  Set<FieldTag> get _possibleTags => {this};

  @override
  String toString() => 'FieldTag.${tag.name}';
}

/// A tag representing a field that is optional.
final class OptionalFieldTag with _FieldTag {
  /// Creates a field tag representing an optional field.
  const OptionalFieldTag(this.ifPresent);

  /// The field tag of this field if present.
  final FieldTag ifPresent;

  @override
  Set<FieldTag> get _possibleTags => {FieldTag.none, ifPresent};

  @override
  String toString() => 'FieldTag.optional($ifPresent)';
}

/// A tag representing a field that is a union of fields.
final class UnionFieldTag with _FieldTag {
  /// Creates a field tag representing a union of fields.
  const UnionFieldTag(this._possibleTags);

  /// The possible field tags of this field.
  @override
  final Set<FieldTag> _possibleTags;

  @override
  String toString() => 'FieldTag.union($_possibleTags)';
}

/// A tag representing a field that is a nested message schema.
final class MessageFieldTag with _FieldTag {
  /// Creates a field tag representing a nested message schema.
  const MessageFieldTag(this.schema);

  /// The schema of this field.
  final Schema schema;

  @override
  bool operator ==(Object other) {
    if (other is MessageFieldTag) {
      return schema == other.schema;
    }
    if (other is FieldTag) {
      return _possibleTags.deepEquals(other._possibleTags);
    }
    return false;
  }

  @override
  int get hashCode => schema.hashCode;

  @override
  Set<FieldTag> get _possibleTags => {this};

  @override
  String toString() => 'FieldTag.message($schema)';
}
