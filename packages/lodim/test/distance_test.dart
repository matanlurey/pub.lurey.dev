import '_prelude.dart';

void main() {
  group('euclideanSquared', () {
    test('calculates the squared euclidean distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(euclideanSquared(a, b)).equals(25);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(euclideanSquared(a, b)).equals(euclideanSquared(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(euclideanSquared(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(euclideanSquared(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(euclideanSquared(a, b)).not((a) => a.equals(0));
      check(euclideanSquared(a, a)).equals(0);
    });
  });

  group('manhattan', () {
    test('calculates the manhattan distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(manhattan(a, b)).equals(7);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(manhattan(a, b)).equals(manhattan(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(manhattan(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(manhattan(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(manhattan(a, b)).not((a) => a.equals(0));
      check(manhattan(a, a)).equals(0);
    });
  });

  group('chebyshev', () {
    test('calculates the chebyshev distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(chebyshev(a, b)).equals(4);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(chebyshev(a, b)).equals(chebyshev(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(chebyshev(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(chebyshev(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(chebyshev(a, b)).not((a) => a.equals(0));
      check(chebyshev(a, a)).equals(0);
    });
  });
}
