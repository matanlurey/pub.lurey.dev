part of '../value.dart';

/// A value representing a [String] value to be encoded in UTF-8.
final class StringValue with _ScalarValue<String> {
  /// Creates a string value.
  const StringValue(this.value);

  /// The value of this [StringValue].
  @override
  final String value;
}
