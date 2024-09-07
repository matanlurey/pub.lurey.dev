import '_prelude.dart';

void main() {
  test('checkPositive throws an error if the value is negative', () {
    check(() => checkPositive(-1)).throws<RangeError>();
  });

  test('checkPositive throws an error if the value is zero', () {
    check(() => checkPositive(0)).throws<RangeError>();
  });

  test('checkPositive returns the value if it is positive', () {
    check(checkPositive(1)).equals(1);
  });

  test('checkNonNegative throws an error if the value is negative', () {
    check(() => checkNonNegative(-1)).throws<RangeError>();
  });

  test('checkNonNegative returns the value if it is zero', () {
    check(checkNonNegative(0)).equals(0);
  });

  test('checkNonNegative returns the value if it is positive', () {
    check(checkNonNegative(1)).equals(1);
  });

  test('assertNonNegative throws an error if the value is negative', () {
    check(() => assertNonNegative(-1)).throws<Error>();
  });
}
