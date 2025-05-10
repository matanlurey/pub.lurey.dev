import 'package:codex/codex.dart';

import 'prelude.dart';

void main() {
  group('FieldDescriptor', () {
    test('operator == and hashCode', () {
      final field1 = FieldDescriptor(0, ValueTag.int);
      final field2 = FieldDescriptor(0, ValueTag.int);
      final field3 = FieldDescriptor(1, ValueTag.string);

      check(field1).equals(field2);
      check(field1).not((f) => f.equals(field3));
      check(field1.hashCode).equals(field2.hashCode);
      check(field1.hashCode).not((f) => f.equals(field3.hashCode));
      check(field1.toString()).equals('FieldDescriptor(0, ValueTag.int)');
    });

    test('with a name', () {
      final field = FieldDescriptor(0, ValueTag.int, name: 'myField');
      check(field.name).equals('myField');
      check(
        field.toString(),
      ).equals('FieldDescriptor(0, ValueTag.int, name: myField)');
    });
  });

  group('SchemaBuilder', () {
    test('add a field', () {
      final builder = SchemaBuilder();
      builder.addField(ValueTag.int);

      check(builder.fields).deepEquals([FieldDescriptor(0, ValueTag.int)]);
    });

    test('add a field with name', () {
      final builder = SchemaBuilder();
      builder.addField(ValueTag.int, fieldName: 'myField');

      check(
        builder.fields,
      ).deepEquals([FieldDescriptor(0, ValueTag.int, name: 'myField')]);
    });

    group('reserve', () {
      test('invalid index', () {
        final builder = SchemaBuilder();
        expect(() => builder.reserve(-1), throwsA(isA<RangeError>()));
      });

      test('invalid count', () {
        final builder = SchemaBuilder();
        expect(() => builder.reserve(0, 0), throwsA(isA<ArgumentError>()));
      });

      test('reserve a single field at the end', () {
        final builder = SchemaBuilder();
        builder.reserve(0);

        check(builder.fields).deepEquals([FieldDescriptor(0, ValueTag.none)]);
      });

      test('replace an existing field with a reserved field', () {
        final builder = SchemaBuilder();
        builder.addField(ValueTag.int);
        builder.reserve(0);

        check(builder.fields).deepEquals([FieldDescriptor(0, ValueTag.none)]);
      });

      test('range of reserved fields', () {
        final builder = SchemaBuilder();
        builder.addField(ValueTag.int);
        builder.reserve(0, 3);

        check(builder.fields).deepEquals([
          FieldDescriptor(0, ValueTag.none),
          FieldDescriptor(1, ValueTag.none),
          FieldDescriptor(2, ValueTag.none),
        ]);
      });

      test('setField existing', () {
        final builder = SchemaBuilder();
        builder.addField(ValueTag.int);
        builder.setField(0, ValueTag.string);

        check(builder.fields).deepEquals([FieldDescriptor(0, ValueTag.string)]);
      });

      test('setField that implicitly reserves', () {
        final builder = SchemaBuilder();
        builder.addField(ValueTag.int);
        builder.setField(2, ValueTag.string);

        check(builder.fields).deepEquals([
          FieldDescriptor(0, ValueTag.int),
          FieldDescriptor(1, ValueTag.none),
          FieldDescriptor(2, ValueTag.string),
        ]);
      });
    });
  });

  group('Schema', () {
    test('update', () {
      final schema = SchemaBuilder().build();
      final updated = schema.update((b) => b.addField(ValueTag.string));
      check(updated.fields).deepEquals([FieldDescriptor(0, ValueTag.string)]);
    });

    test('toBuilder', () {
      final schema = SchemaBuilder().build();
      final builder = schema.toBuilder();
      check(builder.fields).isEmpty();
    });

    test('fieldAt', () {
      final schema =
          Schema.builder()
              .addField(ValueTag.int)
              .addField(ValueTag.string)
              .build();
      final field = schema.fieldAt(1);
      check(field).equals(FieldDescriptor(1, ValueTag.string));
    });

    test('operator []', () {
      final schema =
          Schema.builder()
              .addField(ValueTag.int)
              .addField(ValueTag.string)
              .build();
      final field = schema[1];
      check(field).equals(FieldDescriptor(1, ValueTag.string));
    });

    test('fieldNamed', () {
      final schema =
          Schema.builder().addField(ValueTag.int, fieldName: 'myField').build();
      final field = schema.fieldNamed('myField');
      check(field).equals(FieldDescriptor(0, ValueTag.int, name: 'myField'));
    });

    test('fieldNamed, missing', () {
      final schema = Schema.builder().build();
      final field = schema.fieldNamed('missingField');
      check(field).isNull();
    });
  });
}
