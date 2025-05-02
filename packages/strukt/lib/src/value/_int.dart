part of '../value.dart';

/// A wrapper for an [int] value.
final class IntValue implements Value {
  /// Wraps an [int] value.
  const IntValue(this.value);

  @override
  final int value;

  @override
  IntValue clone() => this;

  @override
  ValueKind get kind => ValueKind.int;

  @override
  String toString() {
    return '$value';
  }
}
