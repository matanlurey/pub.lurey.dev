import 'package:quirk/quirk.dart';

import '_prelude.dart';

void main() {
  test('assertions are enabled', () {
    check(assertionsEnabled).isTrue();
  });

  group('checkPositive', () {
    test('returns the value if positive', () {
      check(checkPositive(1)).equals(1);
    });

    test('throws an error if negative', () {
      check(() => checkPositive(-1)).throws<RangeError>();
    });

    test('throws an error if zero', () {
      check(() => checkPositive(0)).throws<RangeError>();
    });

    test('throws an error with default name', () {
      check(
        () => checkPositive(-1),
      ).throws<RangeError>().has((e) => e.name, 'name').equals('value');
    });

    test('throws an error with default message', () {
      check(() => checkPositive(-1))
          .throws<RangeError>()
          .has((e) => e.message, 'message')
          .equals('must be positive');
    });

    test('throws an error with custom name', () {
      check(
        () => checkPositive(-1, 'foo'),
      ).throws<RangeError>().has((e) => e.name, 'name').equals('foo');
    });

    test('throws an error with custom message', () {
      check(
        () => checkPositive(-1, 'foo', 'bar'),
      ).throws<RangeError>().has((e) => e.message, 'message').equals('bar');
    });
  });

  test('assertPositive', () {
    check(assertPositive(1)).equals(1);
    check(() => assertPositive(0)).throws<RangeError>();
    check(() => assertPositive(-1)).throws<RangeError>();
  });

  group('checkNonNegative', () {
    test('returns the value if non-negative', () {
      check(checkNonNegative(1)).equals(1);
    });

    test('throws an error if negative', () {
      check(() => checkNonNegative(-1)).throws<RangeError>();
    });

    test('throws an error with default name', () {
      check(
        () => checkNonNegative(-1),
      ).throws<RangeError>().has((e) => e.name, 'name').equals('index');
    });

    test('throws an error with default message', () {
      check(() => checkNonNegative(-1))
          .throws<RangeError>()
          .has((e) => e.message, 'message')
          .equals('must be non-negative');
    });

    test('throws an error with custom name', () {
      check(
        () => checkNonNegative(-1, 'foo'),
      ).throws<RangeError>().has((e) => e.name, 'name').equals('foo');
    });

    test('throws an error with custom message', () {
      check(
        () => checkNonNegative(-1, 'foo', 'bar'),
      ).throws<RangeError>().has((e) => e.message, 'message').equals('bar');
    });
  });

  test('assertNonNegative', () {
    check(assertNonNegative(1)).equals(1);
    check(assertNonNegative(0)).equals(0);
    check(() => assertNonNegative(-1)).throws<RangeError>();
  });

  group('checkNotEmpty', () {
    test('returns the iterable if not empty', () {
      final iterable = [1, 2, 3];
      check(checkNotEmpty(iterable)).deepEquals(iterable);
    });

    test('throws an error if empty', () {
      check(() => checkNotEmpty(<int>[])).throws<ArgumentError>();
    });

    test('throws an error with default name', () {
      check(
        () => checkNotEmpty(<int>[]),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('iterable');
    });

    test('throws an error with default message', () {
      check(() => checkNotEmpty(<int>[]))
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .equals('must not be empty');
    });

    test('throws an error with custom name', () {
      check(
        () => checkNotEmpty(<int>[], 'foo'),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('foo');
    });

    test('throws an error with custom message', () {
      check(
        () => checkNotEmpty(<int>[], 'foo', 'bar'),
      ).throws<ArgumentError>().has((e) => e.message, 'message').equals('bar');
    });
  });

  test('assertNotEmpty', () {
    final iterable = [1, 2, 3];
    check(assertNotEmpty(iterable)).deepEquals(iterable);
    check(() => assertNotEmpty(<int>[])).throws<ArgumentError>();
  });

  group('checkStringNotEmpty', () {
    test('returns the string if not empty', () {
      final string = 'hello';
      check(checkStringNotEmpty(string)).equals(string);
    });

    test('throws an error if empty', () {
      check(() => checkStringNotEmpty('')).throws<ArgumentError>();
    });

    test('throws an error with default name', () {
      check(
        () => checkStringNotEmpty(''),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('string');
    });

    test('throws an error with default message', () {
      check(() => checkStringNotEmpty(''))
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .equals('must not be empty');
    });

    test('throws an error with custom name', () {
      check(
        () => checkStringNotEmpty('', 'foo'),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('foo');
    });

    test('throws an error with custom message', () {
      check(
        () => checkStringNotEmpty('', 'foo', 'bar'),
      ).throws<ArgumentError>().has((e) => e.message, 'message').equals('bar');
    });
  });

  test('assertStringNotEmpty', () {
    final string = 'hello';
    check(assertStringNotEmpty(string)).equals(string);
    check(() => assertStringNotEmpty('')).throws<ArgumentError>();
  });

  group('checkStringNotBlank', () {
    test('returns the string if not blank', () {
      final string = 'hello';
      check(checkStringNotBlank(string)).equals(string);
    });

    test('throws an error if blank', () {
      check(() => checkStringNotBlank('')).throws<ArgumentError>();
      check(() => checkStringNotBlank('   ')).throws<ArgumentError>();
    });

    test('throws an error with default name', () {
      check(
        () => checkStringNotBlank(''),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('string');
    });

    test('throws an error with default message', () {
      check(() => checkStringNotBlank(''))
          .throws<ArgumentError>()
          .has((e) => e.message, 'message')
          .equals('must not be empty or whitespace');
    });

    test('throws an error with custom name', () {
      check(
        () => checkStringNotBlank('', 'foo'),
      ).throws<ArgumentError>().has((e) => e.name, 'name').equals('foo');
    });

    test('throws an error with custom message', () {
      check(
        () => checkStringNotBlank('', 'foo', 'bar'),
      ).throws<ArgumentError>().has((e) => e.message, 'message').equals('bar');
    });
  });

  test('assertStringNotBlank', () {
    final string = 'hello';
    check(assertStringNotBlank(string)).equals(string);
    check(() => assertStringNotBlank('')).throws<ArgumentError>();
    check(() => assertStringNotBlank('   ')).throws<ArgumentError>();
  });
}
