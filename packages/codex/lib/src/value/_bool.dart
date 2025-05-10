part of '../value.dart';

/// A value representing a [bool] value.
final class BoolValue with _ScalarValue<bool> {
  /// Creates a boolean value.
  // ignore: avoid_positional_boolean_parameters
  const BoolValue(this.value);

  @override
  final bool value;
}
