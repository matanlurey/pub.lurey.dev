part of '../value.dart';

/// A wrapper for an [int] value.
final class IntValue implements Value {
  /// Wraps an [int] value.
  const IntValue(this.value);

  @override
  final int value;

  @override
  IntValue clone() => IntValue(value);

  @override
  ValueKind get kind => ValueKind.integer;
}
