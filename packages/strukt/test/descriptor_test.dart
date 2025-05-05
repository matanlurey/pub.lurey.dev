import 'dart:typed_data';

import 'package:strukt/strukt.dart';

import 'prelude.dart';

void main() {
  group('Descriptor.bool', () {
    test('is a constant', () {
      check(Descriptor.bool).identicalTo(Descriptor.bool);
    });

    test('has a toString', () {
      check(
        Descriptor.bool,
      ).has((d) => d.toString(), 'toString()').equals('Descriptor.bool');
    });

    test('matches a BoolValue', () {
      check(Descriptor.bool.matches(Value.bool(true))).isTrue();
      check(Descriptor.bool.matches(Value.bool(false))).isTrue();
    });
  });

  group('Descriptor.bytes', () {
    test('is a constant', () {
      check(Descriptor.bytes).identicalTo(Descriptor.bytes);
    });

    test('has a toString', () {
      check(
        Descriptor.bytes,
      ).has((d) => d.toString(), 'toString()').equals('Descriptor.bytes');
    });

    test('matches a BytesValue', () {
      check(Descriptor.bytes.matches(Value.bytes(ByteData(0)))).isTrue();
    });
  });

  group('Descriptor.double', () {
    test('is a constant', () {
      check(Descriptor.double).identicalTo(Descriptor.double);
    });

    test('has a toString', () {
      check(
        Descriptor.double,
      ).has((d) => d.toString(), 'toString()').equals('Descriptor.double');
    });

    test('matches a DoubleValue', () {
      check(Descriptor.double.matches(Value.double(0.0))).isTrue();
      check(Descriptor.double.matches(Value.double(1.0))).isTrue();
    });
  });

  group('Descriptor.int', () {
    test('is a constant', () {
      check(Descriptor.int).identicalTo(Descriptor.int);
    });

    test('has a toString', () {
      check(
        Descriptor.int,
      ).has((d) => d.toString(), 'toString()').equals('Descriptor.int');
    });

    test('matches an IntValue', () {
      check(Descriptor.int.matches(Value.int(0))).isTrue();
      check(Descriptor.int.matches(Value.int(1))).isTrue();
    });
  });

  group('Descriptor.string', () {
    test('is a constant', () {
      check(Descriptor.string).identicalTo(Descriptor.string);
    });

    test('has a toString', () {
      check(
        Descriptor.string,
      ).has((d) => d.toString(), 'toString()').equals('Descriptor.string');
    });

    test('matches a StringValue', () {
      check(Descriptor.string.matches(Value.string(''))).isTrue();
      check(Descriptor.string.matches(Value.string('hello'))).isTrue();
    });
  });

  group('Descriptor.optional', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.optional(Descriptor.string),
      ).equals(Descriptor.optional(Descriptor.string));

      check(Descriptor.optional(Descriptor.string))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.optional(Descriptor.string).hashCode);
    });

    test('has a toString', () {
      check(Descriptor.optional(Descriptor.string))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.optional(Descriptor.string)');
    });

    test('matches null', () {
      check(
        Descriptor.optional(Descriptor.string).matches(Value.none()),
      ).isTrue();
    });

    test('matches a matching value', () {
      check(
        Descriptor.optional(Descriptor.string).matches(Value.string('hello')),
      ).isTrue();
    });
  });

  group('Descriptor.list', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.list(Descriptor.string),
      ).equals(Descriptor.list(Descriptor.string));

      check(Descriptor.list(Descriptor.string))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.list(Descriptor.string).hashCode);
    });

    test('has a toString', () {
      check(Descriptor.list(Descriptor.string))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.list(Descriptor.string)');
    });

    test('matches a ListValue', () {
      check(
        Descriptor.list(
          Descriptor.string,
        ).matches(Value.list([Value.string('hello')])),
      ).isTrue();
    });
  });

  group('Descriptor.map', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.map(Descriptor.string),
      ).equals(Descriptor.map(Descriptor.string));

      check(Descriptor.map(Descriptor.string))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.map(Descriptor.string).hashCode);
    });

    test('has a toString', () {
      check(Descriptor.map(Descriptor.string))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.map(Descriptor.string)');
    });

    test('matches a MapValue', () {
      check(
        Descriptor.map(
          Descriptor.string,
        ).matches(Value.map({'hello': Value.string('world')})),
      ).isTrue();
    });
  });

  group('Descriptor.keyed', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.keyed({'name': Descriptor.string}),
      ).equals(Descriptor.keyed({'name': Descriptor.string}));

      check(Descriptor.keyed({'name': Descriptor.string}))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.keyed({'name': Descriptor.string}).hashCode);
    });

    test('has a toString', () {
      check(Descriptor.keyed({'name': Descriptor.string}))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.keyed({name: Descriptor.string})');
    });

    test('matches a MapValue', () {
      check(
        Descriptor.keyed({
          'name': Descriptor.string,
        }).matches(Value.map({'name': Value.string('hello')})),
      ).isTrue();
    });

    test('matches a MapValue where a key is present but null', () {
      check(
        Descriptor.keyed({
          'name': Descriptor.optional(Descriptor.string),
        }).matches(Value.map({'name': Value.none()})),
      ).isTrue();
    });

    test('matches a MapValue where a key is absent', () {
      check(
        Descriptor.keyed({
          'name': Descriptor.optional(Descriptor.string),
        }).matches(Value.map({})),
      ).isTrue();
    });
  });

  group('Descriptor.indexed', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.indexed([Descriptor.string]),
      ).equals(Descriptor.indexed([Descriptor.string]));

      check(Descriptor.indexed([Descriptor.string]))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.indexed([Descriptor.string]).hashCode);
    });

    test('has a toString', () {
      check(Descriptor.indexed([Descriptor.string]))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.indexed([Descriptor.string])');
    });

    test('matches a ListValue', () {
      check(
        Descriptor.indexed([
          Descriptor.string,
        ]).matches(Value.list([Value.string('hello')])),
      ).isTrue();
    });
  });

  group('Descriptor.oneOf', () {
    test('implements equality and hashCode', () {
      check(
        Descriptor.oneOf([Descriptor.string]),
      ).equals(Descriptor.oneOf([Descriptor.string]));

      check(Descriptor.oneOf([Descriptor.string]))
          .has((d) => d.hashCode, 'hashCode')
          .equals(Descriptor.oneOf([Descriptor.string]).hashCode);
    });

    test('must be non-empty', () {
      check(() => Descriptor.oneOf([])).throws<ArgumentError>();
    });

    test('has a toString', () {
      check(Descriptor.oneOf([Descriptor.string]))
          .has((d) => d.toString(), 'toString()')
          .equals('Descriptor.oneOf([Descriptor.string])');
    });

    test('matches one of the values', () {
      check(
        Descriptor.oneOf([
          Descriptor.string,
          Descriptor.int,
        ]).matches(Value.string('hello')),
      ).isTrue();

      check(
        Descriptor.oneOf([
          Descriptor.string,
          Descriptor.int,
        ]).matches(Value.int(1)),
      ).isTrue();
    });

    test('does not match a value that is not one of the values', () {
      check(
        Descriptor.oneOf([
          Descriptor.string,
          Descriptor.int,
        ]).matches(Value.bool(true)),
      ).isFalse();
    });
  });
}
