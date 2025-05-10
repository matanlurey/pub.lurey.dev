import 'dart:convert';
import 'dart:typed_data';

import 'package:armory/armory.dart';
import 'package:meta/meta.dart';

part 'value/_bool.dart';
part 'value/_bytes.dart';
part 'value/_double.dart';
part 'value/_int.dart';
part 'value/_list.dart';
part 'value/_map.dart';
part 'value/_none.dart';
part 'value/_string.dart';

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

  /// Describes an optional value.
  const factory ValueTag.optional(ValueTag ifPresent) = _OptionalValueTag;

  /// Creates a tag representing a value that may be one of the given types.
  const factory ValueTag.union(Set<ValueTag> possibleTypes) = UnionValueTag;

  /// Returns a union of the given value tag(s) and [other].
  @useResult
  UnionValueTag or(ValueTag other);

  /// Returns a union of the given value tag(s) and [other].
  ///
  /// An alias for [or].
  @useResult
  UnionValueTag operator |(ValueTag other);
}

mixin _ValueTagOr implements ValueTag {
  /// Returns a union of the given value tag(s) and [other].
  ///
  /// An alias for [or].
  @nonVirtual
  @override
  UnionValueTag operator |(ValueTag other) => or(other);
}

enum _ValueTag with _ValueTagOr {
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
  UnionValueTag or(ValueTag other) {
    if (other is UnionValueTag) {
      return UnionValueTag({this, ...other.possibleTypes});
    }
    return UnionValueTag({this, other});
  }

  @override
  Type get runtimeType => ValueTag;

  @override
  String toString() {
    return 'ValueTag.$name';
  }
}

/// Represents either a value of type [ifPresent] or implicitly [NoneValue].
final class _OptionalValueTag with _ValueTagOr implements UnionValueTag {
  /// Creates a tag representing a value that may or may not be present.
  const _OptionalValueTag(this.ifPresent);

  /// The value type that is present.
  final ValueTag ifPresent;

  @override
  Set<ValueTag> get possibleTypes => {ifPresent, ValueTag.none};

  @override
  UnionValueTag or(ValueTag other) {
    if (other is UnionValueTag) {
      return UnionValueTag({ifPresent, ValueTag.none, ...other.possibleTypes});
    }
    return UnionValueTag({ifPresent, ValueTag.none, other});
  }

  @override
  bool operator ==(Object other) {
    if (other is UnionValueTag && other.possibleTypes.length == 2) {
      // Check if the other tag is a union of this tag and NoneValue.
      return other.possibleTypes.containsAll([ifPresent, ValueTag.none]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAllUnordered([_ValueTag.none, ifPresent]);

  @override
  Type get runtimeType => UnionValueTag;

  @override
  String toString() {
    return 'ValueTag.optional($ifPresent)';
  }
}

/// Represents multiple possible value types.
final class UnionValueTag with _ValueTagOr {
  /// Creates a tag representing a value that may be one of the given types.
  const UnionValueTag(this.possibleTypes);

  /// The possible value types.
  final Set<ValueTag> possibleTypes;

  @override
  UnionValueTag or(ValueTag other) {
    if (other is UnionValueTag) {
      return UnionValueTag({...possibleTypes, ...other.possibleTypes});
    }
    return UnionValueTag({...possibleTypes, other});
  }

  @override
  bool operator ==(Object other) {
    if (other is UnionValueTag) {
      return possibleTypes.deepEquals(other.possibleTypes);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAllUnordered(possibleTypes);

  @override
  String toString() {
    return 'ValueTag.union($possibleTypes)';
  }
}

/// A wrapper representing all low-level wire-compatible types.
///
/// Values are the building blocks of encoding and decoding, used to represent
/// the intermediate state of data as it is being processed - either being
/// encoded to an external format or decoded from one - and is used as as typed
/// representation of data (instead of something like `Object? which needs to be
/// cast to a specific type).
///
/// Value implements [Object.hashCode] and [Object.==], including for nested
/// values.
///
/// ## Safety
///
/// To keep overhead low, the value should be _treated_ as immutable, but the
/// underlying data will not prevent mutation. For example, a `ListValue` will
/// not prevent the list from being modified, but the value will not be
/// responsible for that.
///
/// This is a trade-off between performance and safety.
@immutable
sealed class Value {
  /// Wraps a boolean value.
  // ignore: avoid_positional_boolean_parameters
  const factory Value.bool(bool value) = BoolValue;

  /// Wraps a buffer of bytes.
  const factory Value.bytes(Uint8List bytes) = BytesValue;

  /// Wraps a double value.
  const factory Value.double(double value) = DoubleValue;

  /// Wraps an integer value.
  const factory Value.int(int value) = IntValue;

  /// Wraps a list of values.
  const factory Value.list(List<Value> values) = ListValue;

  /// Wraps a map of values.
  const factory Value.map(Map<String, Value> values) = MapValue;

  /// Returns a value representing no value.
  const factory Value.none() = NoneValue;

  /// Wraps a string value.
  const factory Value.string(String value) = StringValue;

  /// Returns a JSON representation of this value.
  ///
  /// The returned result should not be modified, as it may be a shared view
  /// of the underlying data.
  Object? toJson();
}

/// A value representing a single indivisible value rather than a nested value.
base mixin _ScalarValue<T> implements Value {
  /// The value of this scalar.
  T get value;

  @override
  @nonVirtual
  bool operator ==(Object other) {
    return other is _ScalarValue && value == other.value;
  }

  @override
  @nonVirtual
  int get hashCode => value.hashCode;

  @override
  @nonVirtual
  Object? toJson() {
    return value;
  }

  @override
  @nonVirtual
  String toString() => jsonEncode(toJson());
}

/// A value representing a nested value rather than a single indivisible value.
base mixin _NestedValue implements Value {
  /// The value of this nested value.
  Object? get value;

  @override
  @nonVirtual
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
