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

    test('clone', () {
      final value = Value.bool(true);
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.double(3.14);
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.int(42);
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.string('Hello, world!');
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.none();
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.bytes(Uint8List.fromList([1, 2, 3]));
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.list([Value.int(1), Value.string('test')]);
      check(value.clone()).equals(value);
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

    test('clone', () {
      final value = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(value.clone()).equals(value);
    });
  });

  group('ValueTag', () {
    test('bool', () {
      check(ValueTag.bool.name).equals('bool');
    });

    test('bytes', () {
      check(ValueTag.bytes.name).equals('bytes');
    });

    test('double', () {
      check(ValueTag.double.name).equals('double');
    });

    test('int', () {
      check(ValueTag.int.name).equals('int');
    });

    test('list', () {
      check(ValueTag.list.name).equals('list');
    });

    test('map', () {
      check(ValueTag.map.name).equals('map');
    });

    test('none', () {
      check(ValueTag.none.name).equals('none');
    });

    test('string', () {
      check(ValueTag.string.name).equals('string');
    });

    test('runtimeType', () {
      check(ValueTag.bool.runtimeType).equals(ValueTag);
      check(ValueTag.bytes.runtimeType).equals(ValueTag);
      check(ValueTag.double.runtimeType).equals(ValueTag);
      check(ValueTag.int.runtimeType).equals(ValueTag);
      check(ValueTag.list.runtimeType).equals(ValueTag);
      check(ValueTag.map.runtimeType).equals(ValueTag);
      check(ValueTag.none.runtimeType).equals(ValueTag);
      check(ValueTag.string.runtimeType).equals(ValueTag);
    });

    test('toString', () {
      check(ValueTag.bool.toString()).equals('ValueTag.bool');
      check(ValueTag.bytes.toString()).equals('ValueTag.bytes');
      check(ValueTag.double.toString()).equals('ValueTag.double');
      check(ValueTag.int.toString()).equals('ValueTag.int');
      check(ValueTag.list.toString()).equals('ValueTag.list');
      check(ValueTag.map.toString()).equals('ValueTag.map');
      check(ValueTag.none.toString()).equals('ValueTag.none');
      check(ValueTag.string.toString()).equals('ValueTag.string');
    });
  });
}
