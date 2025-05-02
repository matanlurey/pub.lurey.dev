part of '../value.dart';

/// A wrapper for raw bytes data represented as a [Uint8List].
final class BytesValue implements Value {
  /// Wraps a [Uint8List] value.
  const BytesValue(this.value);

  @override
  final Uint8List value;

  @override
  BytesValue clone() => BytesValue(Uint8List.fromList(value));

  @override
  ValueKind get kind => ValueKind.bytes;

  @override
  String toString() => base64Encode(value);
}
