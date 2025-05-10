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
part 'value/_record.dart';
part 'value/_string.dart';

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
  String toString() => jsonEncode(value);
}

/// A value representing a nested value rather than a single indivisible value.
base mixin _NestedValue implements Value {
  /// The value of this nested value.
  Object? get value;

  @override
  @nonVirtual
  String toString() => jsonEncode(value);
}
