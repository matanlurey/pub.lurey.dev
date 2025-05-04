import 'dart:core';
import 'dart:core' as core show bool;

import 'package:meta/meta.dart';
import 'package:quirk/quirk.dart';
import 'package:strukt/src/value.dart';

part 'descriptor/_indexed.dart';
part 'descriptor/_keyed.dart';
part 'descriptor/_list.dart';
part 'descriptor/_map.dart';
part 'descriptor/_one_of.dart';
part 'descriptor/_optional.dart';

/// Describes the type a value can be in a struct.
///
/// This is used to describe the type of a value in a struct, and is used to
/// validate, encode, and decode values.
@immutable
sealed class Descriptor {
  /// A boolean value.
  static const Descriptor bool = _Descriptor.bool;

  /// A byte array.
  static const Descriptor bytes = _Descriptor.bytes;

  /// A double-precision floating-point number.
  static const Descriptor double = _Descriptor.double;

  /// An integer.
  static const Descriptor int = _Descriptor.int;

  /// A string value.
  static const Descriptor string = _Descriptor.string;

  /// Creates a [Descriptor] that is optional.
  const factory Descriptor.optional(
    Descriptor value, //
  ) = OptionalDescriptor;

  /// Creates a [Descriptor] that is a list of values.
  const factory Descriptor.list(
    Descriptor value, //
  ) = ListDescriptor;

  /// Creates a [Descriptor] that is a map of string keys to values.
  const factory Descriptor.map(
    Descriptor value, //
  ) = MapDescriptor;

  /// Creates a [Descriptor] that is a struct with specific keyed values.
  factory Descriptor.keyed(
    Map<String, Descriptor> value, //
  ) = KeyedDescriptor;

  /// Creates a [Descriptor] that is a struct of indexed values.
  factory Descriptor.indexed(
    List<Descriptor> values, //
  ) = IndexedDescriptor;

  /// Creates a [Descriptor] that is one of multiple values.
  factory Descriptor.oneOf(
    List<Descriptor> values, //
  ) = OneOfDescriptor;

  /// Returns whether the provided [value] is valid for this descriptor.
  core.bool matches(Value value);
}

mixin _MatchesOptional implements Descriptor {
  @override
  core.bool matches(Value value) {
    if (value case NoneValue(value: final inner) when inner != null) {
      value = inner;
    }
    return _matchesUnwrappedOptional(value);
  }

  core.bool _matchesUnwrappedOptional(Value value);
}

enum _Descriptor with _MatchesOptional implements Descriptor {
  bool,
  bytes,
  double,
  int,
  string;

  @override
  core.bool _matchesUnwrappedOptional(Value value) {
    return switch (this) {
      bytes => value is BytesValue,
      bool => value is BoolValue,
      double => value is DoubleValue,
      int => value is IntValue,
      string => value is StringValue,
    };
  }

  @override
  String toString() {
    return 'Descriptor.$name';
  }
}
