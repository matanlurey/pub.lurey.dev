import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

part 'value/_bool.dart';
part 'value/_bytes.dart';
part 'value/_double.dart';
part 'value/_equality.dart';
part 'value/_int.dart';
part 'value/_list.dart';
part 'value/_map.dart';
part 'value/_none.dart';
part 'value/_string.dart';

/// The base type for values that are supported by the Acorn database model.
///
/// _Similar_ to types supported by JavaScript's [structured cloning][].
///
/// Implementations are guaranteed to support all types, but translation from
/// a storage format may be required.
///
/// [structured cloning]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm
@immutable
sealed class Value {
  /// Returns whether two [Value]s are equal.
  ///
  /// Will recursively check the equality of all nested values, and expect the
  /// same types, in the same order.
  ///
  /// An [NoneValue] is unwrapped and compared to its value, if it is not
  /// `null`.
  static bool equals(Value a, Value b) => _deepEqualsNullable(a, b);

  /// Returns the deep hash code of a [Value].
  ///
  /// This is a recursive hash code that will include all nested values.
  static int hash(Value value) => _deepHashCode(value);

  /// Creates a [Value] from a [bool].
  // ignore: avoid_positional_boolean_parameters
  const factory Value.bool(bool value) = BoolValue;

  /// Creates a [Value] from a [double].
  const factory Value.double(double value) = DoubleValue;

  /// Creates a [Value] from an [int].
  const factory Value.int(int value) = IntValue;

  /// Creates a [Value] from a [String].
  const factory Value.string(String value) = StringValue;

  /// Creates a [Value] from a [Uint8List].
  const factory Value.bytes(ByteData value) = BytesValue;

  /// Creates a [Value] from a [List].
  const factory Value.list(List<Value> value) = ListValue;

  /// Creates a [Value] from a [Map].
  const factory Value.map(Map<String, Value> value) = MapValue;

  /// Creates a [Value] that is `null`.
  const factory Value.none() = NoneValue;

  /// Creates a clone of this value.
  ///
  /// For an immutable value, may return `this`.
  Value clone();

  /// What kind of value this is.
  ValueKind get kind;

  /// Underlying value.
  ///
  /// If the value is mutable, it is the caller's responsibility to ensure that
  /// modifying the value is safe.
  Object? get value;
}

/// Describes a kind of [Value].
enum ValueKind {
  /// A boolean value.
  bool,

  /// A byte array.
  bytes,

  /// A double-precision floating-point number.
  double,

  /// An integer.
  int,

  /// A list of values.
  list,

  /// A map of values.
  map,

  /// An absent (null) value.
  none,

  /// A string value.
  string,
}
