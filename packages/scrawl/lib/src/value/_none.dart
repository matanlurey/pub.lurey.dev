part of '../value.dart';

/// A value representing the absence of a value, or `null`.
final class NoneValue with ScalarValue<Null> {
  /// Creates the absence of a value.
  @literal
  const NoneValue();

  @override
  Null get value => null;

  @override
  String toString() => '<None>';
}
