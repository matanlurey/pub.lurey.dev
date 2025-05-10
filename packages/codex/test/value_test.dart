import 'dart:convert';
import 'dart:typed_data';

import 'package:codex/codex.dart';

import 'prelude.dart';

void main() {
  group('BoolValue', () {
    test('value', () {
      final value = Value.bool(true);
      check(value).isA<BoolValue>().has((v) => v.value, 'value').isTrue();
    });

    test('operator ==', () {
      final value1 = Value.bool(true);
      final value2 = Value.bool(true);
      final value3 = Value.bool(false);

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.bool(true);
      final value2 = Value.bool(true);
      final value3 = Value.bool(false);

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.bool(true);
      check(value.toJson()).equals(true);
    });

    test('toString', () {
      final value = Value.bool(true);
      check(value.toString()).equals('true');
    });
  });

  group('DoubleValue', () {
    test('value', () {
      final value = Value.double(3.14);
      check(value).isA<DoubleValue>().has((v) => v.value, 'value').equals(3.14);
    });

    test('operator ==', () {
      final value1 = Value.double(3.14);
      final value2 = Value.double(3.14);
      final value3 = Value.double(2.71);

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.double(3.14);
      final value2 = Value.double(3.14);
      final value3 = Value.double(2.71);

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.double(3.14);
      check(value.toJson()).equals(3.14);
    });

    test('toString', () {
      final value = Value.double(3.14);
      check(value.toString()).equals('3.14');
    });
  });

  group('IntValue', () {
    test('value', () {
      final value = Value.int(42);
      check(value).isA<IntValue>().has((v) => v.value, 'value').equals(42);
    });

    test('operator ==', () {
      final value1 = Value.int(42);
      final value2 = Value.int(42);
      final value3 = Value.int(24);

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.int(42);
      final value2 = Value.int(42);
      final value3 = Value.int(24);

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.int(42);
      check(value.toJson()).equals(42);
    });

    test('toString', () {
      final value = Value.int(42);
      check(value.toString()).equals('42');
    });
  });

  group('StringValue', () {
    test('value', () {
      final value = Value.string('Hello, world!');
      check(
        value,
      ).isA<StringValue>().has((v) => v.value, 'value').equals('Hello, world!');
    });

    test('operator ==', () {
      final value1 = Value.string('Hello, world!');
      final value2 = Value.string('Hello, world!');
      final value3 = Value.string('Goodbye, world!');

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.string('Hello, world!');
      final value2 = Value.string('Hello, world!');
      final value3 = Value.string('Goodbye, world!');

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.string('Hello, world!');
      check(value.toJson()).equals('Hello, world!');
    });

    test('toString', () {
      final value = Value.string('Hello, world!');
      check(value.toString()).equals('"Hello, world!"');
    });
  });

  group('NoneValue', () {
    test('value', () {
      final value = Value.none();
      check(value).isA<NoneValue>();
    });

    test('operator ==', () {
      final value1 = Value.none();
      final value2 = Value.none();

      check(value1).equals(value2);
    });

    test('hashCode', () {
      final value1 = Value.none();
      final value2 = Value.none();

      check(value1.hashCode).equals(value2.hashCode);
    });

    test('toJson', () {
      final value = Value.none();
      check(value.toJson()).equals(null);
    });

    test('toString', () {
      final value = Value.none();
      check(value.toString()).equals('null');
    });
  });

  group('BytesValue', () {
    test('value', () {
      final value = Value.bytes(Uint8List.fromList([1, 2, 3]));
      check(value)
          .isA<BytesValue>()
          .has((v) => v.value, 'value')
          .deepEquals(Uint8List.fromList([1, 2, 3]));
    });

    test('operator ==', () {
      final value1 = Value.bytes(Uint8List.fromList([1, 2, 3]));
      final value2 = Value.bytes(Uint8List.fromList([1, 2, 3]));
      final value3 = Value.bytes(Uint8List.fromList([4, 5, 6]));

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.bytes(Uint8List.fromList([1, 2, 3]));
      final value2 = Value.bytes(Uint8List.fromList([1, 2, 3]));
      final value3 = Value.bytes(Uint8List.fromList([4, 5, 6]));

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.bytes(Uint8List.fromList([1, 2, 3]));
      check(value.toJson()).equals(base64Encode(Uint8List.fromList([1, 2, 3])));
    });

    test('toString', () {
      final value = Value.bytes(Uint8List.fromList([1, 2, 3]));
      check(value.toString()).equals('"AQID"');
    });
  });

  group('ListValue', () {
    test('value', () {
      final value = Value.list([Value.int(1), Value.string('test')]);
      check(value).isA<ListValue>().has((v) => v.value, 'value').deepEquals([
        Value.int(1),
        Value.string('test'),
      ]);
    });

    test('operator ==', () {
      final value1 = Value.list([Value.int(1), Value.string('test')]);
      final value2 = Value.list([Value.int(1), Value.string('test')]);
      final value3 = Value.list([Value.int(2), Value.string('test')]);

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.list([Value.int(1), Value.string('test')]);
      final value2 = Value.list([Value.int(1), Value.string('test')]);
      final value3 = Value.list([Value.int(2), Value.string('test')]);

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.list([Value.int(1), Value.string('test')]);
      check(value.toJson() as List).deepEquals([1, 'test']);
    });

    test('toString', () {
      final value = Value.list([Value.int(1), Value.string('test')]);
      check(value.toString()).equals(
        '[\n'
        '  1,\n'
        '  "test"\n'
        ']',
      );
    });
  });

  group('MapValue', () {
    test('value', () {
      final value = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(value).isA<MapValue>().has((v) => v.value, 'value').deepEquals({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
    });

    test('operator ==', () {
      final value1 = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      final value2 = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      final value3 = Value.map({
        'key1': Value.int(2),
        'key2': Value.string('test'),
      });

      check(value1).equals(value2);
      check(value1).not((v) => v.equals(value3));
    });

    test('hashCode', () {
      final value1 = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      final value2 = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      final value3 = Value.map({
        'key1': Value.int(2),
        'key2': Value.string('test'),
      });

      check(value1.hashCode).equals(value2.hashCode);
      check(value1.hashCode).not((v) => v.equals(value3.hashCode));
    });

    test('toJson', () {
      final value = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(value.toJson() as Map).deepEquals({'key1': 1, 'key2': 'test'});
    });

    test('toString', () {
      final value = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(value.toString()).equals(
        '{\n'
        '  "key1": 1,\n'
        '  "key2": "test"\n'
        '}',
      );
    });
  });

  group('ValueTag', () {
    test('ValueTag. | ValueTag.', () {
      final tag1 = ValueTag.bool | ValueTag.int;
      final tag2 = ValueTag.int | ValueTag.bool;

      check(tag1).equals(tag2);
      check(tag1.hashCode).equals(tag2.hashCode);
    });

    test('ValueTag. | ValueTag. | ValueTag.', () {
      final tag1 = ValueTag.bool | ValueTag.int | ValueTag.string;
      final tag2 = ValueTag.string | ValueTag.int | ValueTag.bool;

      check(tag1).equals(tag2);
      check(tag1.hashCode).equals(tag2.hashCode);
    });

    test('ValueTag.optional = ValueTag. | ValueTag.none', () {
      final tag1 = ValueTag.optional(ValueTag.int);
      final tag2 = ValueTag.int | ValueTag.none;

      check(tag1).equals(tag2);
      check(tag1.hashCode).equals(tag2.hashCode);
    });

    test('ValueTag. | ValueTag.union', () {
      final tag1 = ValueTag.int | ValueTag.union({ValueTag.string});
      final tag2 = ValueTag.union({ValueTag.string}) | ValueTag.int;

      check(tag1).equals(tag2);
      check(tag1.hashCode).equals(tag2.hashCode);
    });

    test('ValueTag.union |', () {
      final tag1 = ValueTag.union({ValueTag.int, ValueTag.string});
      final tag2 = ValueTag.union({ValueTag.string, ValueTag.int});

      check(tag1 | tag2).equals(tag2 | tag1);
      check(
        tag1.hashCode | tag2.hashCode,
      ).equals(tag2.hashCode | tag1.hashCode);
    });

    test('ValueTag.optional | ValueTag.union', () {
      final tag1 = ValueTag.optional(ValueTag.int);
      final tag2 = ValueTag.union({ValueTag.string}) | ValueTag.int;

      check(tag1 | tag2).equals(tag2 | tag1);
      check(
        tag1.hashCode | tag2.hashCode,
      ).equals(tag2.hashCode | tag1.hashCode);
    });

    test('ValueTag.optional | ValueTag.', () {
      final tag1 = ValueTag.optional(ValueTag.int);
      final tag2 = ValueTag.bool;

      check(tag1 | tag2).equals(tag2 | tag1);
      check(
        tag1.hashCode | tag2.hashCode,
      ).equals(tag2.hashCode | tag1.hashCode);
    });

    test('ValueTag.optional .runtimeType and .toString()', () {
      final tag = ValueTag.optional(ValueTag.int);
      check(tag.runtimeType).equals(UnionValueTag);
      check(tag.toString()).equals('ValueTag.optional(ValueTag.int)');
    });

    test('ValueTag.string .runtimeType and .toString()', () {
      final tag = ValueTag.string;
      check(tag.runtimeType).equals(ValueTag);
      check(tag.toString()).equals('ValueTag.string');
    });

    test('ValueTAg.union .runtimeType and .toString()', () {
      final tag = ValueTag.union({ValueTag.int, ValueTag.string});
      check(tag.runtimeType).equals(UnionValueTag);
      check(
        tag.toString(),
      ).equals('ValueTag.union({ValueTag.int, ValueTag.string})');
    });
  });
}
