import 'package:codex/codex.dart';

import 'prelude.dart';

void main() {
  test('Message', () {
    final name = Field(0, FieldTag.string, name: 'name');
    final message = Message(ListValue([StringValue('John Doe')]));
    check(message.getField(name)).equals(StringValue('John Doe'));
  });

  test('getMessage', () {
    final name = Field(0, FieldTag.string, name: 'name');
    final message = Message(
      ListValue([
        ListValue([StringValue('John Doe')]),
      ]),
    );
    check(message.getMessage(0).getField(name)).equals(StringValue('John Doe'));
  });

  test('update', () {
    final name = Field(0, FieldTag.string, name: 'name');
    final message = Message(ListValue([StringValue('John Doe')]));
    final updatedMessage = message.update(
      (b) => b.setField(name, StringValue('Jane Doe')),
    );
    check(updatedMessage.getField(name)).equals(StringValue('Jane Doe'));
  });

  test('setMessage', () {
    final name = Field(0, FieldTag.string, name: 'name');
    final message = Message(
      ListValue([
        ListValue([StringValue('John Doe')]),
      ]),
    );
    final updatedMessage = message.update(
      (b) => b.setMessage(
        0,
        message.update((b) => b.setField(name, StringValue('Jane Doe'))),
      ),
    );
    check(
      updatedMessage.getMessage(0).getField(name),
    ).equals(StringValue('Jane Doe'));
  });

  test('operator ==', () {
    final message = Message(ListValue([StringValue('John Doe')]));
    check(message).equals(Message(ListValue([StringValue('John Doe')])));
  });

  test('hashCode', () {
    final message = Message(ListValue([StringValue('John Doe')]));
    check(
      message.hashCode,
    ).equals(Message(ListValue([StringValue('John Doe')])).hashCode);
  });

  test('toString', () {
    final message = Message(ListValue([StringValue('John Doe')]));
    check(message.toString()).equals('Message [\n  "John Doe"\n]');
  });

  test('MessageBuilder.build', () {
    final name = Field(0, FieldTag.string, name: 'name');
    final message =
        MessageBuilder(1).setField(name, StringValue('John Doe')).build();
    check(message.getField(name)).equals(StringValue('John Doe'));
  });

  test('MessageBuilder.toString', () {
    final message = MessageBuilder(
      1,
    ).setField(Field(0, FieldTag.string), StringValue('John Doe'));
    check(message.toString()).equals('MessageBuilder [\n  "John Doe"\n]');
  });
}
