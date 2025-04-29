part of '../value.dart';

/// A wrapper for a value that can be either a [Value] or null.
final class OptionalValue implements Value {
  /// Wraps a [Value] or null.
  const OptionalValue(this.value);

  @override
  final Value? value;

  @override
  OptionalValue clone() {
    if (value case final v?) {
      return OptionalValue(v.clone());
    }
    return this;
  }

  @override
  ValueKind get kind => ValueKind.optional;

  @override
  String toString() {
    return '$value';
  }
}
