import 'package:codex/codex.dart';

import 'prelude.dart';

void main() {
  group('Field', () {
    test('operator == and hashCode', () {
      final field1 = Field(0, FieldTag.int);
      final field2 = Field(0, FieldTag.int);
      final field3 = Field(1, FieldTag.string);

      check(field1).equals(field2);
      check(field1).not((f) => f.equals(field3));
      check(field1.hashCode).equals(field2.hashCode);
      check(field1.hashCode).not((f) => f.equals(field3.hashCode));
      check(field1.toString()).equals('Field(0, FieldTag.int)');
    });

    test('with a name', () {
      final field = Field(0, FieldTag.int, name: 'myField');
      check(field.name).equals('myField');
      check(field.toString()).equals('Field(0, FieldTag.int, name: myField)');
    });

    test('isOptional', () {
      final field = Field(0, FieldTag.int.optional());
      check(field.isOptional).isTrue();
      check(
        field.toString(),
      ).equals('Field(0, FieldTag.optional(FieldTag.int))');
    });
  });

  group('SchemaBuilder', () {
    test('add a field', () {
      final builder = SchemaBuilder();
      builder.addField(FieldTag.int);

      check(builder.fields).deepEquals([Field(0, FieldTag.int)]);
    });

    test('add a field with name', () {
      final builder = SchemaBuilder();
      builder.addField(FieldTag.int, fieldName: 'myField');

      check(
        builder.fields,
      ).deepEquals([Field(0, FieldTag.int, name: 'myField')]);
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

        check(builder.fields).deepEquals([Field(0, FieldTag.none)]);
      });

      test('replace an existing field with a reserved field', () {
        final builder = SchemaBuilder();
        builder.addField(FieldTag.int);
        builder.reserve(0);

        check(builder.fields).deepEquals([Field(0, FieldTag.none)]);
      });

      test('range of reserved fields', () {
        final builder = SchemaBuilder();
        builder.addField(FieldTag.int);
        builder.reserve(0, 3);

        check(builder.fields).deepEquals([
          Field(0, FieldTag.none),
          Field(1, FieldTag.none),
          Field(2, FieldTag.none),
        ]);
      });

      test('setField existing', () {
        final builder = SchemaBuilder();
        builder.addField(FieldTag.int);
        builder.setField(0, FieldTag.string);

        check(builder.fields).deepEquals([Field(0, FieldTag.string)]);
      });

      test('setField that implicitly reserves', () {
        final builder = SchemaBuilder();
        builder.addField(FieldTag.int);
        builder.setField(2, FieldTag.string);

        check(builder.fields).deepEquals([
          Field(0, FieldTag.int),
          Field(1, FieldTag.none),
          Field(2, FieldTag.string),
        ]);
      });
    });
  });

  group('Schema', () {
    test('update', () {
      final schema = SchemaBuilder().build();
      final updated = schema.update((b) => b.addField(FieldTag.string));
      check(updated.fields).deepEquals([Field(0, FieldTag.string)]);
    });

    test('toBuilder', () {
      final schema = SchemaBuilder().build();
      final builder = schema.toBuilder();
      check(builder.fields).isEmpty();
    });

    test('fieldAt', () {
      final schema =
          Schema.builder()
              .addField(FieldTag.int)
              .addField(FieldTag.string)
              .build();
      final field = schema.fieldAt(1);
      check(field).equals(Field(1, FieldTag.string));
    });

    test('operator []', () {
      final schema =
          Schema.builder()
              .addField(FieldTag.int)
              .addField(FieldTag.string)
              .build();
      final field = schema[1];
      check(field).equals(Field(1, FieldTag.string));
    });

    test('fieldNamed', () {
      final schema =
          Schema.builder().addField(FieldTag.int, fieldName: 'myField').build();
      final field = schema.fieldNamed('myField');
      check(field).equals(Field(0, FieldTag.int, name: 'myField'));
    });

    test('fieldNamed, missing', () {
      final schema = Schema.builder().build();
      final field = schema.fieldNamed('missingField');
      check(field).isNull();
    });

    test('operator == and hashCode', () {
      final schema1 = Schema.builder().addField(FieldTag.int).build();
      final schema2 = Schema.builder().addField(FieldTag.int).build();
      final schema3 = Schema.builder().addField(FieldTag.string).build();

      check(schema1).equals(schema2);
      check(schema1).not((s) => s.equals(schema3));
      check(schema1.hashCode).equals(schema2.hashCode);
      check(schema1.hashCode).not((s) => s.equals(schema3.hashCode));
    });
  });

  group('FieldTag', () {
    test('FieldTag.bool', () {
      final tag = FieldTag.bool;
      check(tag).equals(FieldTag.bool);
      check(tag.possibleTags).deepEquals({FieldTag.bool});
    });

    test('FieldTag.bytes', () {
      final tag = FieldTag.bytes;
      check(tag).equals(FieldTag.bytes);
      check(tag.possibleTags).deepEquals({FieldTag.bytes});
    });

    test('FieldTag.double', () {
      final tag = FieldTag.double;
      check(tag).equals(FieldTag.double);
      check(tag.possibleTags).deepEquals({FieldTag.double});
    });

    test('FieldTag.int', () {
      final tag = FieldTag.int;
      check(tag).equals(FieldTag.int);
      check(tag.possibleTags).deepEquals({FieldTag.int});
    });

    test('FieldTag.list', () {
      final tag = FieldTag.list;
      check(tag).equals(FieldTag.list);
      check(tag.possibleTags).deepEquals({FieldTag.list});
    });

    test('FieldTag.map', () {
      final tag = FieldTag.map;
      check(tag).equals(FieldTag.map);
      check(tag.possibleTags).deepEquals({FieldTag.map});
    });

    test('FieldTag.none', () {
      final tag = FieldTag.none;
      check(tag).equals(FieldTag.none);
      check(tag.possibleTags).deepEquals({FieldTag.none});
    });

    test('FieldTag.string', () {
      final tag = FieldTag.string;
      check(tag).equals(FieldTag.string);
      check(tag.possibleTags).deepEquals({FieldTag.string});
    });

    test('FieldTag.value', () {
      final tag = FieldTag.value(ValueTag.int);
      check(tag).equals(FieldTag.value(ValueTag.int));
      check(tag.possibleTags).deepEquals({FieldTag.value(ValueTag.int)});
    });

    group('FieldTag.union', () {
      test('union of two tags', () {
        final tag1 = FieldTag.int;
        final tag2 = FieldTag.string;
        final unionTag = tag1 | tag2;
        check(unionTag).equals(FieldTag.union({FieldTag.int, FieldTag.string}));
      });

      test('union of three tags', () {
        final tag1 = FieldTag.int;
        final tag2 = FieldTag.string;
        final tag3 = FieldTag.bool;
        final unionTag = tag1 | tag2 | tag3;
        check(unionTag).equals(
          FieldTag.union({FieldTag.int, FieldTag.string, FieldTag.bool}),
        );
      });

      test('.hashCode', () {
        final tag1 = FieldTag.int;
        final tag2 = FieldTag.string;
        final unionTag1 = tag1 | tag2;
        final unionTag2 = tag2 | tag1;

        check(unionTag1.hashCode).equals(unionTag2.hashCode);
      });

      test('.toString()', () {
        final tag1 = FieldTag.int;
        final tag2 = FieldTag.string;
        final unionTag = tag1 | tag2;

        check(
          unionTag.toString(),
        ).equals('FieldTag.union({FieldTag.int, FieldTag.string})');
      });
    });

    test('.optional()', () {
      final tag = FieldTag.int.optional();
      check(tag).equals(FieldTag.optional(FieldTag.int));
    });

    test('.hashCode', () {
      final tag1 = FieldTag.int;
      final tag2 = FieldTag.int;
      final tag3 = FieldTag.string;

      check(tag1.hashCode).equals(tag2.hashCode);
      check(tag1.hashCode).not((t) => t.equals(tag3.hashCode));
    });

    test('.toString()', () {
      final tag = FieldTag.int;
      check(tag.toString()).equals('FieldTag.int');
    });

    test('operator== a single union tag', () {
      final tag1 = FieldTag.int;
      final tag2 = FieldTag.int;
      final unionTag = tag1 | tag2;

      check(unionTag).equals(FieldTag.union({FieldTag.int}));
      check(tag1).equals(FieldTag.union({FieldTag.int}));
    });

    group('FieldTag.message', () {
      test('message tag', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag = FieldTag.message(schema);
        check(tag).equals(FieldTag.message(schema));
      });

      test('message tag with different schema', () {
        final schema1 = Schema.builder().addField(FieldTag.int).build();
        final schema2 = Schema.builder().addField(FieldTag.string).build();
        final tag1 = FieldTag.message(schema1);
        final tag2 = FieldTag.message(schema2);

        check(tag1).not((t) => t.equals(tag2));
      });

      test('operator ==', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag1 = FieldTag.message(schema);
        final tag2 = FieldTag.message(schema);

        check(tag1).equals(tag2);
      });

      test('hashCode', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag1 = FieldTag.message(schema);
        final tag2 = FieldTag.message(schema);

        check(tag1.hashCode).equals(tag2.hashCode);
      });

      test('possibleTags', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag = FieldTag.message(schema);

        check(tag.possibleTags).deepEquals({tag});
      });

      test('toString', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag = FieldTag.message(schema);

        check(tag.toString()).equals('FieldTag.message($schema)');
      });

      test('== a union of just a message tag', () {
        final schema = Schema.builder().addField(FieldTag.int).build();
        final tag = FieldTag.message(schema);
        final unionTag = tag | tag;

        check(unionTag).equals(FieldTag.union({tag}));
        check(tag).equals(FieldTag.union({tag}));
      });
    });

    group('FieldTag.optional', () {
      test('toString', () {
        final tag = FieldTag.optional(FieldTag.int);
        check(tag.toString()).equals('FieldTag.optional(FieldTag.int)');
      });
    });
  });
}
