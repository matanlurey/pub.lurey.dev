// Intentional fluent API.
// ignore_for_file: avoid_returning_this

import 'dart:convert';

import 'package:codex/src/schema.dart';
import 'package:codex/src/value.dart';
import 'package:meta/meta.dart';

/// A message that is backed by a list.
@immutable
final class Message {
  /// Creates a message from a list of fields.
  const Message(this._fields);
  final ListValue _fields;

  /// Returns the value of the field at [index].
  Value operator [](int index) {
    return _fields.value[index];
  }

  /// Returns the value of the given [field].
  Value getField(Field field) => this[field.index];

  /// Returns the field at [index] as a message.
  Message getMessage(int index) {
    return Message(_fields.value[index] as ListValue);
  }

  /// Returns a new message with the fields updated.
  @useResult
  Message update(void Function(MessageBuilder) update) {
    final builder = toBuilder();
    update(builder);
    return Message(builder._fields);
  }

  /// Returns a builder for this message.
  @useResult
  MessageBuilder toBuilder() {
    return MessageBuilder._(_fields.clone());
  }

  @override
  bool operator ==(Object other) {
    return other is Message && _fields == other._fields;
  }

  @override
  int get hashCode => _fields.hashCode;

  @override
  String toString() {
    return 'Message ${const JsonEncoder.withIndent('  ').convert(_fields)}';
  }
}

/// A builder for a message.
final class MessageBuilder {
  /// Creates an empty message builder with the given [capacity].
  factory MessageBuilder(int capacity) {
    return MessageBuilder._(
      ListValue(List.filled(capacity, const NoneValue())),
    );
  }

  MessageBuilder._(this._fields);
  final ListValue _fields;

  /// Sets the value of the field at [index].
  void operator []=(int index, Value value) {
    _fields.value[index] = value;
  }

  /// Sets the value of the given [field].
  @useResult
  MessageBuilder setField(Field field, Value value) {
    this[field.index] = value;
    return this;
  }

  /// Sets the field at [index] to a message.
  @useResult
  MessageBuilder setMessage(int index, Message message) {
    _fields.value[index] = message._fields;
    return this;
  }

  /// Builds the message.
  Message build() {
    return Message(_fields.clone());
  }

  @override
  String toString() {
    return 'MessageBuilder ${const JsonEncoder.withIndent('  ').convert(_fields)}';
  }
}
