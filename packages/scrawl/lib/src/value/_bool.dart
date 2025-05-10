part of '../value.dart';

/// A value representing a [bool] value.
final class BoolValue with ScalarValue<bool> {
  /// Creates a boolean value.
  // ignore: avoid_positional_boolean_parameters
  const BoolValue(this.value);

  @override
  final bool value;

  @override
  String toString() => value.toString();
}
