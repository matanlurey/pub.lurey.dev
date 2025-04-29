part of '../value.dart';

/// A wrapper for a [bool] value.
final class BoolValue implements Value {
  /// Wraps a [bool] value.
  // ignore: avoid_positional_boolean_parameters
  const BoolValue(this.value);

  @override
  final bool value;

  @override
  BoolValue clone() => this;

  @override
  ValueKind get kind => ValueKind.boolean;

  @override
  String toString() {
    return '$value';
  }
}
