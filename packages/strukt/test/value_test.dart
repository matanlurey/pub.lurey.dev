import 'dart:convert';
import 'dart:typed_data';

import 'package:strukt/strukt.dart';

import 'prelude.dart';

void main() {
  group('BoolValue', () {
    test('value', () {
      final wrapper = Value.bool(true);
      check(wrapper).has((w) => w.value, 'value').equals(true);
    });

    test('clone', () {
      final wrapper = Value.bool(true);
      check(wrapper).has((w) => w.clone(), 'clone()').identicalTo(wrapper);
    });

    test('kind', () {
      final wrapper = Value.bool(true);
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.bool);
    });

    test('toString', () {
      final wrapper = Value.bool(true);
      check(wrapper).has((w) => w.toString(), 'toString()').equals('true');
    });
  });

  group('DoubleValue', () {
    test('value', () {
      final wrapper = Value.double(1.0);
      check(wrapper).has((w) => w.value, 'value').equals(1.0);
    });

    test('clone', () {
      final wrapper = Value.double(1.0);
      check(wrapper).has((w) => w.clone(), 'clone()').identicalTo(wrapper);
    });

    test('kind', () {
      final wrapper = Value.double(1.0);
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.double);
    });

    test('toString', () {
      final wrapper = Value.double(1.0);
      check(wrapper).has((w) => w.toString(), 'toString()').equals('1.0');
    });
  });

  group('IntValue', () {
    test('value', () {
      final wrapper = Value.int(1);
      check(wrapper).has((w) => w.value, 'value').equals(1);
    });

    test('clone', () {
      final wrapper = Value.int(1);
      check(wrapper).has((w) => w.clone(), 'clone()').identicalTo(wrapper);
    });

    test('kind', () {
      final wrapper = Value.int(1);
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.int);
    });

    test('toString', () {
      final wrapper = Value.int(1);
      check(wrapper).has((w) => w.toString(), 'toString()').equals('1');
    });
  });

  group('StringValue', () {
    test('value', () {
      final wrapper = Value.string('test');
      check(wrapper).has((w) => w.value, 'value').equals('test');
    });

    test('clone', () {
      final wrapper = Value.string('test');
      check(wrapper).has((w) => w.clone(), 'clone()').identicalTo(wrapper);
    });

    test('kind', () {
      final wrapper = Value.string('test');
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.string);
    });

    test('toString', () {
      final wrapper = Value.string('test');
      check(wrapper).has((w) => w.toString(), 'toString()').equals('test');
    });
  });

  group('BytesValue', () {
    test('value', () {
      final wrapper = BytesValue.viewBytes(Uint8List.fromList([1, 2, 3]));
      check(wrapper)
          .has(
            (w) => w.value.buffer.asUint8List(),
            'value.buffer.asUint8List()',
          )
          .deepEquals([1, 2, 3]);
    });

    test('clone (deep copy)', () {
      final wrapper = BytesValue.viewBytes(Uint8List.fromList([1, 2, 3]));
      check(wrapper).has((w) => w.clone(), 'clone()')
        ..not((a) => a.identicalTo(wrapper))
        ..has(
          (a) => a.value.buffer.asUint8List(),
          'clone().value.buffer.asUint8List()',
        ).deepEquals([1, 2, 3]);
    });

    test('kind', () {
      final wrapper = BytesValue.viewBytes(Uint8List.fromList([1, 2, 3]));
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.bytes);
    });

    test('toString', () {
      final wrapper = BytesValue.viewBytes(Uint8List.fromList([1, 2, 3]));
      check(wrapper)
          .has((w) => w.toString(), 'toString()')
          .equals(base64Encode(Uint8List.fromList([1, 2, 3])));
    });
  });

  group('ListValue', () {
    test('value', () {
      final wrapper = Value.list([Value.int(1), Value.string('test')]);
      check(wrapper).has((w) => w.value as List<Value>, 'value')
        ..first.has((v) => v.value, 'value[0]').equals(1)
        ..last.has((v) => v.value, 'value[1]').equals('test');
    });

    test('clone (deep copy)', () {
      final wrapper = Value.list([Value.int(1), Value.string('test')]);
      check(wrapper)
          .has((w) => w.clone(), 'clone()')
          .has((a) => a.value as List<Value>, 'clone().value')
        ..first.has((v) => v.value, 'clone().value[0]').equals(1)
        ..last.has((v) => v.value, 'clone().value[1]').equals('test')
        ..not((a) => a.identicalTo(wrapper.value as List<Value>));
    });

    test('kind', () {
      final wrapper = Value.list([Value.int(1), Value.string('test')]);
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.list);
    });

    test('toString', () {
      final wrapper = Value.list([Value.int(1), Value.string('test')]);
      check(wrapper).has((w) => w.toString(), 'toString()').equals('[1, test]');
    });
  });

  group('MapValue', () {
    test('value', () {
      final wrapper = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(wrapper).has((w) => w.value as Map<String, Value>, 'value')
        ..has((v) => v['key1']?.value, 'value[key1]').equals(1)
        ..has((v) => v['key2']?.value, 'value[key2]').equals('test');
    });

    test('clone (deep copy)', () {
      final wrapper = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(wrapper)
          .has((w) => w.clone(), 'clone()')
          .has((a) => a.value as Map<String, Value>, 'clone().value')
        ..has((v) => v['key1']?.value, 'clone().value[key1]').equals(1)
        ..has((v) => v['key2']?.value, 'clone().value[key2]').equals('test')
        ..not((a) => a.identicalTo(wrapper.value as Map<String, Value>));
    });

    test('kind', () {
      final wrapper = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.map);
    });

    test('toString', () {
      final wrapper = Value.map({
        'key1': Value.int(1),
        'key2': Value.string('test'),
      });
      check(
        wrapper,
      ).has((w) => w.toString(), 'toString()').equals('{key1: 1, key2: test}');
    });
  });

  group('NoneValue', () {
    test('value', () {
      final wrapper = Value.none();
      check(wrapper).has((w) => w.value, 'value').isNull();
    });

    test('clone', () {
      final wrapper = Value.none();
      check(wrapper).has((w) => w.clone(), 'clone()').identicalTo(wrapper);
    });

    test('kind', () {
      final wrapper = Value.none();
      check(wrapper).has((w) => w.kind, 'kind').equals(ValueKind.none);
    });

    test('toString', () {
      final wrapper = Value.none();
      check(wrapper).has((w) => w.toString(), 'toString()').equals('null');
    });
  });

  group('Value.equals', () {
    test('null == null', () {
      check(Value.equals(Value.none(), Value.none())).isTrue();
    });

    test('null != non-null', () {
      check(Value.equals(Value.none(), Value.int(1))).isFalse();
    });

    test('non-null != null', () {
      check(Value.equals(Value.int(1), Value.none())).isFalse();
    });

    test('bytes != non-bytes', () {
      check(
        Value.equals(
          BytesValue.viewBytes(Uint8List.fromList([1, 2, 3])),
          Value.int(1),
        ),
      ).isFalse();
    });

    test('bytes != bytes of different length', () {
      check(
        Value.equals(
          BytesValue.viewBytes(Uint8List.fromList([1, 2, 3])),
          BytesValue.viewBytes(Uint8List.fromList([1, 2])),
        ),
      ).isFalse();
    });

    test('bytes == bytes of same length', () {
      check(
        Value.equals(
          BytesValue.viewBytes(Uint8List.fromList([1, 2, 3])),
          BytesValue.viewBytes(Uint8List.fromList([1, 2, 3])),
        ),
      ).isTrue();
    });

    test('list != non-list', () {
      check(Value.equals(Value.list([Value.int(1)]), Value.int(1))).isFalse();
    });

    test('list != list of different length', () {
      check(
        Value.equals(
          Value.list([Value.int(1)]),
          Value.list([Value.int(1), Value.int(2)]),
        ),
      ).isFalse();
    });

    test('list == list of same length', () {
      check(
        Value.equals(Value.list([Value.int(1)]), Value.list([Value.int(1)])),
      ).isTrue();
    });

    test('map != non-map', () {
      check(
        Value.equals(Value.map({'key': Value.int(1)}), Value.int(1)),
      ).isFalse();
    });

    test('map != map of different length', () {
      check(
        Value.equals(
          Value.map({'key': Value.int(1)}),
          Value.map({'key': Value.int(1), 'key2': Value.int(2)}),
        ),
      ).isFalse();
    });

    test('map == map of same length', () {
      check(
        Value.equals(
          Value.map({'key': Value.int(1)}),
          Value.map({'key': Value.int(1)}),
        ),
      ).isTrue();
    });

    test('map == map of same length with different order', () {
      check(
        Value.equals(
          Value.map({'key': Value.int(1), 'key2': Value.int(2)}),
          Value.map({'key2': Value.int(2), 'key': Value.int(1)}),
        ),
      ).isTrue();
    });

    test('primitive == primitive', () {
      check(Value.equals(Value.int(1), Value.int(1))).isTrue();
    });
  });

  group('Value.hash', () {
    test('null', () {
      check(Value.hash(Value.none())).equals(null.hashCode);
    });

    test('bool', () {
      check(Value.hash(Value.bool(true))).equals(true.hashCode);
    });

    test('int', () {
      check(Value.hash(Value.int(1))).equals(1.hashCode);
    });

    test('double', () {
      check(Value.hash(Value.double(1.0))).equals(1.0.hashCode);
    });

    test('string', () {
      check(Value.hash(Value.string('test'))).equals('test'.hashCode);
    });

    test('bytes', () {
      check(
        Value.hash(BytesValue.viewBytes(Uint8List.fromList([1, 2, 3]))),
      ).equals(Object.hashAll([1, 2, 3]));
    });

    test('list', () {
      check(
        Value.hash(Value.list([Value.int(1), Value.string('test')])),
      ).equals(
        Object.hashAll([
          Value.hash(Value.int(1)),
          Value.hash(Value.string('test')),
        ]),
      );
    });

    test('map', () {
      check(
        Value.hash(
          Value.map({'key1': Value.int(1), 'key2': Value.string('test')}),
        ),
      ).equals(
        Object.hashAll([
          'key1',
          Value.hash(Value.int(1)),
          'key2',
          Value.hash(Value.string('test')),
        ]),
      );
    });

    test('optional', () {
      check(Value.hash(Value.none())).equals(null.hashCode);
    });
  });
}
