part of '../value.dart';

/// A value representing a [double] value.
final class DoubleValue with ScalarValue<double> {
  /// Creates a double value.
  const DoubleValue(this.value);

  @override
  final double value;

  @override
  String toString() => value.toString();
}
