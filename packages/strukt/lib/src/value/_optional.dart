part of '../value.dart';

/// A wrapper for a value that can be either a [Value] or null.
final class OptionalValue implements Value {
  /// Wraps a [Value] or null.
  const OptionalValue(this.value);

  @override
  final Value? value;

  @override
  OptionalValue clone() => OptionalValue(value?.clone());

  @override
  ValueKind get kind => ValueKind.optional;
}
