import 'dart:typed_data';

import 'package:strukt/strukt.dart';

import 'prelude.dart';

void main() {
  group('MapValueBuilder', () {
    test('creates an empty map', () {
      final builder = MapValueBuilder();
      check(builder.build()).has((b) => b.value, 'value').deepEquals({});
    });

    test('creates a map from an existing map', () {
      final builder = MapValueBuilder.fromMap({
        'key1': Value.int(1),
        'key2': Value.string('value'),
      });
      final result = builder.build().value;
      check(result)['key1'].has((v) => v.value, "['key1']").equals(1);
      check(result)['key2'].has((v) => v.value, "['key2']").equals('value');
    });

    test('creates a map from an existing value', () {
      final initial = MapValue({
        'key1': Value.int(1),
        'key2': Value.string('value'),
      });
      final builder = MapValueBuilder.fromValue(initial);
      final result = builder.build().value;
      check(result)['key1'].has((v) => v.value, "['key1']").equals(1);
      check(result)['key2'].has((v) => v.value, "['key2']").equals('value');
    });

    test('clones the builder', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      final clone = builder.clone();
      check(
        clone.build().value,
      )['key1'].has((v) => v.value, "['key1']").equals(1);
      check(
        builder.build().value,
      )['key1'].has((v) => v.value, "['key1']").equals(1);
    });

    test('shows the entries', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      builder.addValue('key2', Value.string('value'));
      final entries = builder.entries.toList();
      check(entries).has((e) => e.length, 'length').equals(2);
      check(entries[0].key).equals('key1');
      check(entries[0].value.value).equals(1);
      check(entries[1].key).equals('key2');
      check(entries[1].value.value).equals('value');
    });

    test('length', () {
      final builder = MapValueBuilder();
      check(builder.length).equals(0);
      builder.addValue('key1', Value.int(1));
      check(builder.length).equals(1);
      builder.addValue('key2', Value.string('value'));
      check(builder.length).equals(2);
    });

    test('isEmpty', () {
      final builder = MapValueBuilder();
      check(builder.isEmpty).isTrue();
      builder.addValue('key1', Value.int(1));
      check(builder.isEmpty).isFalse();
    });

    test('isNotEmpty', () {
      final builder = MapValueBuilder();
      check(builder.isNotEmpty).isFalse();
      builder.addValue('key1', Value.int(1));
      check(builder.isNotEmpty).isTrue();
    });

    test('addValue', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value.value).equals(1);
    });

    test('addBool', () {
      final builder = MapValueBuilder();
      builder.addBool('key1', true);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value.value).equals(true);
    });

    test('addDouble', () {
      final builder = MapValueBuilder();
      builder.addDouble('key1', 1.0);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value.value).equals(1.0);
    });

    test('addInt', () {
      final builder = MapValueBuilder();
      builder.addInt('key1', 1);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value.value).equals(1);
    });

    test('addString', () {
      final builder = MapValueBuilder();
      builder.addString('key1', 'value');
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value.value).equals('value');
    });

    test('addBytes (copy = true)', () {
      final builder = MapValueBuilder();
      final bytes = ByteData(4);
      bytes.setUint8(0, 1);
      bytes.setUint8(1, 2);
      bytes.setUint8(2, 3);
      bytes.setUint8(3, 4);
      builder.addBytes('key1', bytes);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value)
          .isA<BytesValue>()
          .has((v) => v.value.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);

      bytes.setUint8(0, 5);
      check(builder.entries.first.value)
          .isA<BytesValue>()
          .has((v) => v.value.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);
    });

    test('addBytes (copy = false)', () {
      final builder = MapValueBuilder();
      final bytes = ByteData(4);
      bytes.setUint8(0, 1);
      bytes.setUint8(1, 2);
      bytes.setUint8(2, 3);
      bytes.setUint8(3, 4);
      builder.addBytes('key1', bytes, copy: false);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(builder.entries.first.value)
          .isA<BytesValue>()
          .has((v) => v.value.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);

      bytes.setUint8(0, 5);
      check(builder.entries.first.value)
          .isA<BytesValue>()
          .has((v) => v.value.buffer.asUint8List(), 'value')
          .deepEquals([5, 2, 3, 4]);
    });

    test('addList (copy = true)', () {
      final builder = MapValueBuilder();
      final list = [Value.int(1), Value.string('value')];
      builder.addList('key1', list);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(
        builder.entries.first.value,
      ).isA<ListValue>().has((v) => v.value, 'value').deepEquals(list);

      list[0] = Value.int(2);
      check(
        builder.entries.first.value.value as List<Value>,
      ).first.has((v) => v.value, 'value[0]').equals(1);
    });

    test('addList (copy = false)', () {
      final builder = MapValueBuilder();
      final list = [Value.int(1), Value.string('value')];
      builder.addList('key1', list, copy: false);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(
        builder.entries.first.value,
      ).isA<ListValue>().has((v) => v.value, 'value').deepEquals(list);

      list[0] = Value.int(2);
      check(
        builder.entries.first.value.value as List<Value>,
      ).first.has((v) => v.value, 'value[0]').equals(2);
    });

    test('addMap (copy = true)', () {
      final builder = MapValueBuilder();
      final map = {'key1': Value.int(1), 'key2': Value.string('value')};
      builder.addMap('key1', map);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(
        builder.entries.first.value,
      ).isA<MapValue>().has((v) => v.value, 'value').deepEquals(map);

      map['key1'] = Value.int(2);
      check(
        builder.entries.first.value.value as Map<String, Value>,
      )['key1'].has((v) => v.value, 'value[key1]').equals(1);
    });

    test('addMap (copy = false)', () {
      final builder = MapValueBuilder();
      final map = {'key1': Value.int(1), 'key2': Value.string('value')};
      builder.addMap('key1', map, copy: false);
      check(builder.length).equals(1);
      check(builder.entries.first.key).equals('key1');
      check(
        builder.entries.first.value,
      ).isA<MapValue>().has((v) => v.value, 'value').deepEquals(map);

      map['key1'] = Value.int(2);
      check(
        builder.entries.first.value.value as Map<String, Value>,
      )['key1'].has((v) => v.value, 'value[key1]').equals(2);
    });

    test('asMap', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      builder.addValue('key2', Value.string('value'));
      final map = builder.asMap();
      check(map).has((m) => m.length, 'length').equals(2);
      check(map['key1']).has((v) => v?.value, "['key1']").equals(1);
      check(map['key2']).has((v) => v?.value, "['key2']").equals('value');
    });

    test('clear', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      builder.addValue('key2', Value.string('value'));
      check(builder.length).equals(2);
      builder.clear();
      check(builder.length).equals(0);
    });

    test('take', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      builder.addValue('key2', Value.string('value'));
      check(builder.length).equals(2);
      final map = builder.take();
      check(map.value).has((m) => m.length, 'length').equals(2);
      check(map.value['key1']).has((v) => v?.value, "['key1']").equals(1);
      check(map.value['key2']).has((v) => v?.value, "['key2']").equals('value');
      check(builder.length).equals(0);
    });

    test('build', () {
      final builder = MapValueBuilder();
      builder.addValue('key1', Value.int(1));
      builder.addValue('key2', Value.string('value'));
      check(builder.length).equals(2);
      final map = builder.build();
      check(map.value).has((m) => m.length, 'length').equals(2);
      check(map.value['key1']).has((v) => v?.value, "['key1']").equals(1);
      check(map.value['key2']).has((v) => v?.value, "['key2']").equals('value');
    });
  });

  group('ListValueBuilder', () {
    test('creates an empty list', () {
      final builder = ListValueBuilder();
      check(builder.build()).has((b) => b.value, 'value').deepEquals([]);
    });

    test('creates a list from an existing list', () {
      final builder = ListValueBuilder.fromList([
        Value.int(1),
        Value.string('value'),
      ]);
      final result = builder.build().value;
      check(result).has((r) => r.length, 'length').equals(2);
      check(result[0]).has((v) => v.value, '[0]').equals(1);
      check(result[1]).has((v) => v.value, '[1]').equals('value');
    });

    test('creates a list from an existing value', () {
      final initial = ListValue([Value.int(1), Value.string('value')]);
      final builder = ListValueBuilder.fromValue(initial);
      final result = builder.build().value;
      check(result).has((r) => r.length, 'length').equals(2);
      check(result[0]).has((v) => v.value, '[0]').equals(1);
      check(result[1]).has((v) => v.value, '[1]').equals('value');
    });

    test('clones the builder', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      final clone = builder.clone();
      check(clone.build().value).has((v) => v.length, 'length').equals(1);
      check(builder.build().value).has((v) => v.length, 'length').equals(1);
    });

    test('shows the entries', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      builder.addValue(Value.string('value'));
      final entries = builder.entries.toList();
      check(entries).has((e) => e.length, 'length').equals(2);
      check(entries[0].value).equals(1);
      check(entries[1].value).equals('value');
    });

    test('length', () {
      final builder = ListValueBuilder();
      check(builder.length).equals(0);
      builder.addValue(Value.int(1));
      check(builder.length).equals(1);
      builder.addValue(Value.string('value'));
      check(builder.length).equals(2);
    });

    test('isEmpty', () {
      final builder = ListValueBuilder();
      check(builder.isEmpty).isTrue();
      builder.addValue(Value.int(1));
      check(builder.isEmpty).isFalse();
    });

    test('isNotEmpty', () {
      final builder = ListValueBuilder();
      check(builder.isNotEmpty).isFalse();
      builder.addValue(Value.int(1));
      check(builder.isNotEmpty).isTrue();
    });

    test('addValue', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      check(builder.length).equals(1);
      check(builder.entries.first.value).equals(1);
    });

    test('addBool', () {
      final builder = ListValueBuilder();
      builder.addBool(true);
      check(builder.length).equals(1);
      check(builder.entries.first.value).equals(true);
    });

    test('addDouble', () {
      final builder = ListValueBuilder();
      builder.addDouble(1.0);
      check(builder.length).equals(1);
      check(builder.entries.first.value).equals(1.0);
    });

    test('addInt', () {
      final builder = ListValueBuilder();
      builder.addInt(1);
      check(builder.length).equals(1);
      check(builder.entries.first.value).equals(1);
    });

    test('addString', () {
      final builder = ListValueBuilder();
      builder.addString('value');
      check(builder.length).equals(1);
      check(builder.entries.first.value).equals('value');
    });

    test('addBytes (copy = true)', () {
      final builder = ListValueBuilder();
      final bytes = ByteData(4);
      bytes.setUint8(0, 1);
      bytes.setUint8(1, 2);
      bytes.setUint8(2, 3);
      bytes.setUint8(3, 4);
      builder.addBytes(bytes);
      check(builder.length).equals(1);
      check(builder.entries.first.value)
          .isA<ByteData>()
          .has((v) => v.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);

      bytes.setUint8(0, 5);
      check(builder.entries.first.value)
          .isA<ByteData>()
          .has((v) => v.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);
    });

    test('addBytes (copy = false)', () {
      final builder = ListValueBuilder();
      final bytes = ByteData(4);
      bytes.setUint8(0, 1);
      bytes.setUint8(1, 2);
      bytes.setUint8(2, 3);
      bytes.setUint8(3, 4);
      builder.addBytes(bytes, copy: false);
      check(builder.length).equals(1);
      check(builder.entries.first.value)
          .isA<ByteData>()
          .has((v) => v.buffer.asUint8List(), 'value')
          .deepEquals([1, 2, 3, 4]);

      bytes.setUint8(0, 5);
      check(builder.entries.first.value)
          .isA<ByteData>()
          .has((v) => v.buffer.asUint8List(), 'value')
          .deepEquals([5, 2, 3, 4]);
    });

    test('addList (copy = true)', () {
      final builder = ListValueBuilder();
      final list = [Value.int(1), Value.string('value')];
      builder.addList(list);
      check(builder.length).equals(1);
      check(
        builder.entries.first.value,
      ).isA<List<Value>>().first.has((v) => v.value, 'value[0]').equals(1);

      list[0] = Value.int(2);
      check(
        builder.entries.first.value,
      ).isA<List<Value>>().first.has((v) => v.value, 'value[0]').equals(1);
    });

    test('addList (copy = false)', () {
      final builder = ListValueBuilder();
      final list = [Value.int(1), Value.string('value')];
      builder.addList(list, copy: false);
      check(builder.length).equals(1);
      check(
        builder.entries.first.value,
      ).isA<List<Value>>().first.has((v) => v.value, 'value[0]').equals(1);

      list[0] = Value.int(2);
      check(
        builder.entries.first.value,
      ).isA<List<Value>>().first.has((v) => v.value, 'value[0]').equals(2);
    });

    test('addMap (copy = true)', () {
      final builder = ListValueBuilder();
      final map = {'key1': Value.int(1), 'key2': Value.string('value')};
      builder.addMap(map);
      check(builder.length).equals(1);
      check(builder.entries.first.value)
          .isA<Map<String, Value>>()
          .has((v) => v['key1']?.value, 'value[key1],value')
          .equals(1);
    });

    test('addMap (copy = false)', () {
      final builder = ListValueBuilder();
      final map = {'key1': Value.int(1), 'key2': Value.string('value')};
      builder.addMap(map, copy: false);
      check(builder.length).equals(1);
      check(builder.entries.first.value)
          .isA<Map<String, Value>>()
          .has((v) => v['key1']?.value, 'value[key1],value')
          .equals(1);

      map['key1'] = Value.int(2);
      check(builder.entries.first.value)
          .isA<Map<String, Value>>()
          .has((v) => v['key1']?.value, 'value[key1],value')
          .equals(2);
    });

    test('asList', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      builder.addValue(Value.string('value'));
      final list = builder.asList();
      check(list).has((l) => l.length, 'length').equals(2);
      check(list[0]).has((v) => v.value, '[0]').equals(1);
      check(list[1]).has((v) => v.value, '[1]').equals('value');
    });

    test('clear', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      builder.addValue(Value.string('value'));
      check(builder.length).equals(2);
      builder.clear();
      check(builder.length).equals(0);
    });

    test('take', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      builder.addValue(Value.string('value'));
      check(builder.length).equals(2);
      final list = builder.take();
      check(list.value).has((l) => l.length, 'length').equals(2);
      check(list.value[0]).has((v) => v.value, '[0]').equals(1);
      check(list.value[1]).has((v) => v.value, '[1]').equals('value');
      check(builder.length).equals(0);
    });

    test('build', () {
      final builder = ListValueBuilder();
      builder.addValue(Value.int(1));
      builder.addValue(Value.string('value'));
      check(builder.length).equals(2);
      final list = builder.build();
      check(list.value).has((l) => l.length, 'length').equals(2);
      check(list.value[0]).has((v) => v.value, '[0]').equals(1);
      check(list.value[1]).has((v) => v.value, '[1]').equals('value');
    });
  });
}
