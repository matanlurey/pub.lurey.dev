part of '../value.dart';

/// A wrapper for raw bytes data represented as a [ByteData].
final class BytesValue implements Value {
  /// Wraps a fixed-length buffer.
  ///
  /// Equivalent to:
  /// ```dart
  /// final bytes = data.buffer.asByteData();
  /// return BytesValue(bytes);
  /// ```
  factory BytesValue.viewBytes(TypedDataList<void> data) {
    final bytes = data.buffer.asByteData();
    return BytesValue(bytes);
  }

  /// Wraps a [ByteData] value.
  const BytesValue(this.value);

  @override
  final ByteData value;

  @override
  BytesValue clone() {
    final clonedBytes = Uint8List.fromList(value.buffer.asUint8List());
    return BytesValue(clonedBytes.buffer.asByteData());
  }

  @override
  ValueKind get kind => ValueKind.bytes;

  @override
  String toString() => base64Encode(value.buffer.asUint8List());
}
