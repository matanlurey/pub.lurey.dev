import 'dart:convert';

import 'package:codex/src/message.dart';
import 'package:codex/src/schema.dart';

part 'codec/_json_array.dart';

/// A codec for encoding and decoding messages.
abstract mixin class MessageCodec<T> {
  /// Encoder.
  MessageEncoder<T> get encoder;

  /// Decoder.
  MessageDecoder<T> get decoder;

  /// Returns as a codec for the given [schema].
  ///
  /// [Converter.convert] implicitly uses encode and decode methods.
  Codec<Message, T> asCodec(Schema schema) {
    return _MessageCodec(this, schema);
  }
}

final class _MessageCodec<T> extends Codec<Message, T> {
  _MessageCodec(this._codec, this._schema);
  final MessageCodec<T> _codec;
  final Schema _schema;

  @override
  late final decoder = _codec.decoder.asConverter(_schema);

  @override
  late final encoder = _codec.encoder.asConverter(_schema);
}

/// Encodes a [Message] into a target format [T].
abstract mixin class MessageEncoder<T> {
  /// Encodes a [Message] into a target format [T].
  T encode(Message message, Schema schema);

  /// Returns as a converter for the given [schema].
  ///
  /// [Converter.convert] implicitly uses the [encode] method.
  Converter<Message, T> asConverter(Schema schema) {
    return _MessageEncoderConverter(this, schema);
  }
}

final class _MessageEncoderConverter<T> extends Converter<Message, T> {
  const _MessageEncoderConverter(this._encoder, this._schema);
  final MessageEncoder<T> _encoder;
  final Schema _schema;

  @override
  T convert(Message input) {
    return _encoder.encode(input, _schema);
  }
}

/// Decodes a [Message] from a source format [T].
abstract mixin class MessageDecoder<T> {
  /// Decodes a [Message] from a source format [T].
  Message decode(T source, Schema schema);

  /// Returns as a converter for the given [schema].
  ///
  /// [Converter.convert] implicitly uses the [decode] method.
  Converter<T, Message> asConverter(Schema schema) {
    return _MessageDecoderConverter(this, schema);
  }
}

final class _MessageDecoderConverter<T> extends Converter<T, Message> {
  const _MessageDecoderConverter(this._decoder, this._schema);
  final MessageDecoder<T> _decoder;
  final Schema _schema;

  @override
  Message convert(T input) {
    return _decoder.decode(input, _schema);
  }
}
