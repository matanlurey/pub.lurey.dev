part of '../value.dart';

/// A sequence of bytes often used to represent binary data.
final class BytesValue implements Value {
  /// Creates a buffer by copying an existing buffer of bytes.
  BytesValue.fromBytes(
    TypedData bytes, //
  ) : this.fromList(bytes.buffer.asUint8List());

  /// Creates a buffer by copying each element as a byte.
  ///
  /// Values are truncated to fit in the byte range.
  BytesValue.fromList(
    List<int> bytes, //
  ) : value = Uint8List.fromList(bytes).asUnmodifiableView();

  /// Sequence of bytes.
  ///
  /// This list is unmodifiable.
  final Uint8List value;

  @override
  bool operator ==(Object other) {
    if (other is! BytesValue || other.value.length != value.length) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    for (var i = 0; i < value.length; i++) {
      if (value[i] != other.value[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(value);

  @override
  String toString() {
    return '<Bytes (${value.length} bytes)>: ${base64Encode(value)}';
  }
}
