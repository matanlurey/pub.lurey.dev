import '_prelude.dart';

void main() {
  group('distanceSquared', () {
    test('calculates the squared euclidean distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceSquared(a, b)).equals(25);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceSquared(a, b)).equals(distanceSquared(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(distanceSquared(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceSquared(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceSquared(a, b)).not((a) => a.equals(0));
      check(distanceSquared(a, a)).equals(0);
    });
  });

  group('distanceApproximate', () {
    test('calculates the approximate euclidean distance between 2 points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceApproximate(a, b)).equals(5);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceApproximate(a, b)).equals(distanceApproximate(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(distanceApproximate(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceApproximate(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceApproximate(a, b)).not((a) => a.equals(0));
      check(distanceApproximate(a, a)).equals(0);
    });
  });

  group('distanceManhattan', () {
    test('calculates the distanceManhattan distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceManhattan(a, b)).equals(7);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceManhattan(a, b)).equals(distanceManhattan(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(distanceManhattan(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceManhattan(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceManhattan(a, b)).not((a) => a.equals(0));
      check(distanceManhattan(a, a)).equals(0);
    });
  });

  group('distanceDiagonal', () {
    test('calculates the distanceDiagonal distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceDiagonal(a, b)).equals(4);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceDiagonal(a, b)).equals(distanceDiagonal(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(distanceDiagonal(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceDiagonal(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceDiagonal(a, b)).not((a) => a.equals(0));
      check(distanceDiagonal(a, a)).equals(0);
    });
  });

  group('distanceChebyshev', () {
    test('calculates the distanceChebyshev distance between two points', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceChebyshev(a, b)).equals(4);
    });

    test('is commutative', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceChebyshev(a, b)).equals(distanceChebyshev(b, a));
    });

    test('is reflexive', () {
      final a = Pos(1, 2);
      check(distanceChebyshev(a, a)).equals(0);
    });

    test('is positive', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceChebyshev(a, b)).isGreaterOrEqual(0);
    });

    test('is zero if and only if the points are the same', () {
      final a = Pos(1, 2);
      final b = Pos(4, 6);
      check(distanceChebyshev(a, b)).not((a) => a.equals(0));
      check(distanceChebyshev(a, a)).equals(0);
    });
  });
}
