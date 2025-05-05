part of '../value.dart';

/// A wrapper for `null` values.
final class NoneValue implements Value {
  /// Wraps `null` in a [Value].
  @literal
  const NoneValue();

  @override
  Value? get value => null;

  @override
  NoneValue clone() => this;

  @override
  ValueKind get kind => ValueKind.none;

  @override
  String toString() {
    return '$value';
  }
}
