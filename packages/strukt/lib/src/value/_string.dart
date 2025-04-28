part of '../value.dart';

/// A wrapper for a [String] value.
final class StringValue implements Value {
  /// Wraps a [String] value.
  const StringValue(this.value);

  @override
  final String value;

  @override
  StringValue clone() => StringValue(value);

  @override
  ValueKind get kind => ValueKind.string;
}
