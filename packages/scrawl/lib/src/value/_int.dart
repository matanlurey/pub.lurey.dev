part of '../value.dart';

/// A value representing an integer value.
final class IntValue with ScalarValue<int> {
  /// Creates an integer value.
  const IntValue(this.value);

  @override
  final int value;

  @override
  String toString() => value.toString();
}
