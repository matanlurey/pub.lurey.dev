import '_prelude.dart';

void main() {
  group('sqrtApproximate', () {
    test('approximateSqrt(9) => 3', () {
      check(sqrtApproximate(9)).equals(3);
    });

    test('approximateSqrt(16) => 4', () {
      check(sqrtApproximate(16)).equals(4);
    });

    test('approximateSqrt(24) => 4', () {
      check(sqrtApproximate(24)).equals(4);
    });

    test('approximateSqrt(101) => 10', () {
      check(sqrtApproximate(101)).equals(10);
    });
  });
}
