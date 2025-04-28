part of '../value.dart';

/// A wrapper for a [double] value.
final class DoubleValue implements Value {
  /// Wraps a [double] value.
  const DoubleValue(this.value);

  @override
  final double value;

  @override
  DoubleValue clone() => DoubleValue(value);

  @override
  ValueKind get kind => ValueKind.double;
}
