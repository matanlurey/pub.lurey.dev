part of '../value.dart';

/// A sequence of bytes often used to represent binary data.
final class BytesValue with _NestedValue {
  /// Wraps a buffer of bytes.
  const BytesValue(this.value);

  /// Sequence of bytes.
  @override
  final Uint8List value;

  @override
  bool operator ==(Object other) {
    if (other is! BytesValue) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return value.deepEquals(other.value);
  }

  @override
  int get hashCode => Object.hashAll(value);

  @override
  Object? toJson() {
    return base64Encode(value);
  }
}
