part of '../value.dart';

/// A tag representing the kind of [Value].
@immutable
sealed class ValueTag {
  /// Describes a [BoolValue].
  static const ValueTag bool = _ValueTag.bool;

  /// Describes a [BytesValue].
  static const ValueTag bytes = _ValueTag.bytes;

  /// Describes a [DoubleValue].
  static const ValueTag double = _ValueTag.double;

  /// Describes a [IntValue].
  static const ValueTag int = _ValueTag.int;

  /// Describes a [ListValue].
  static const ValueTag list = _ValueTag.list;

  /// Describes a [MapValue].
  static const ValueTag map = _ValueTag.map;

  /// Describes a [NoneValue].
  static const ValueTag none = _ValueTag.none;

  /// Describes a [StringValue].
  static const ValueTag string = _ValueTag.string;

  /// Name of the tag.
  String get name;
}

enum _ValueTag implements ValueTag {
  bool,
  bytes,
  double,
  int,
  list,
  map,
  none,
  string;

  const _ValueTag();

  @override
  String get name => EnumName(this).name;

  @override
  Type get runtimeType => ValueTag;

  @override
  String toString() {
    return 'ValueTag.$name';
  }
}
