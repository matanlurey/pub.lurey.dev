part of '../value.dart';

/// A wrapper for a [double] value.
final class DoubleValue implements Value {
  /// Wraps a [double] value.
  const DoubleValue(this.value);

  @override
  final double value;

  @override
  DoubleValue clone() => this;

  @override
  ValueKind get kind => ValueKind.double;

  @override
  String toString() {
    return '$value';
  }
}
