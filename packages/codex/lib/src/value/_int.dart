part of '../value.dart';

/// A value representing an integer value.
final class IntValue with _ScalarValue<int> {
  /// Creates an integer value.
  const IntValue(this.value);

  @override
  final int value;

  @override
  IntValue clone() => this;
}
