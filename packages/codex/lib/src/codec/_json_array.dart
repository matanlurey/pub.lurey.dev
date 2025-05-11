part of '../codec.dart';

/// A lightweight JSON message codec that encodes and decodes as a JSON array.
final class JsonArrayCodec with MessageCodec<List<Object?>> {
  /// Creates a [JsonArrayCodec] instance.
  const JsonArrayCodec();

  @override
  MessageEncoder<List<Object?>> get encoder => const JsonArrayEncoder();

  @override
  MessageDecoder<List<Object?>> get decoder => const JsonArrayDecoder();
}

/// A lightweight JSON message encoder that encodes as a JSON array.
final class JsonArrayEncoder with MessageEncoder<List<Object?>> {
  /// Creates a [JsonArrayEncoder] instance.
  const JsonArrayEncoder();

  @override
  List<Object?> encode(Message message, Schema schema) {
    return [
      for (final field in schema.fields) message.getField(field).toJson(),
    ];
  }
}

/// A lightweight JSON message decoder that decodes from a JSON array.
final class JsonArrayDecoder with MessageDecoder<List<Object?>> {
  /// Creates a [JsonArrayDecoder] instance.
  const JsonArrayDecoder();

  @override
  Message decode(List<Object?> source, Schema schema) {
    final list = [
      for (final (i, field) in schema.fields.indexed)
        switch (field.tag) {
          FieldTag.bool => Value.bool(source[i] as bool),
          FieldTag.bytes => Value.bytes(base64Decode(source[i] as String)),
          FieldTag.double => Value.double(source[i] as double),
          FieldTag.int => Value.int(source[i] as int),
          FieldTag.string => Value.string(source[i] as String),
          _ => throw UnimplementedError(),
        },
    ];
    return Message(ListValue(list));
  }
}
