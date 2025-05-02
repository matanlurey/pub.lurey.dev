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
  });
}
