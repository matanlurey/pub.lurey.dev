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
}
