import '../prelude.dart';

void main() {
  test('Heuristic calls the given function', () {
    final heuristic = Heuristic((int node) => node * 2);

    check(heuristic.estimateTotalCost(1)).equals(2);
    check(heuristic.estimateTotalCost(2)).equals(4);
  });

  test('Heuristic.zero returns 0 for all nodes', () {
    final heuristic = Heuristic<int>.zero();

    check(heuristic.estimateTotalCost(1)).equals(0);
    check(heuristic.estimateTotalCost(2)).equals(0);
  });

  test('Heuristic.always returns the same value for all nodes', () {
    final heuristic = Heuristic<int>.always(2);

    check(heuristic.estimateTotalCost(1)).equals(2);
    check(heuristic.estimateTotalCost(2)).equals(2);
  });

  test('Heuristic.any returns the minimum of the heuristics', () {
    final heuristic = Heuristic.any([
      Heuristic((int node) => node * 2),
      Heuristic((int node) => node * 3),
    ]);

    check(heuristic.estimateTotalCost(1)).equals(2);
    check(heuristic.estimateTotalCost(2)).equals(4);
  });

  test('Heuristic.any with any empty list returns 0', () {
    final heuristic = Heuristic.any([]);

    check(heuristic.estimateTotalCost(1)).equals(0);
    check(heuristic.estimateTotalCost(2)).equals(0);
  });

  test('Heuristic.every returns the maximum of the heuristics', () {
    final heuristic = Heuristic.every([
      Heuristic((int node) => node * 2),
      Heuristic((int node) => node * 3),
    ]);

    check(heuristic.estimateTotalCost(1)).equals(3);
    check(heuristic.estimateTotalCost(2)).equals(6);
  });

  test('Heuristic.every with any empty list returns double.maxFinite', () {
    final heuristic = Heuristic.every([]);

    check(heuristic.estimateTotalCost(1)).equals(double.maxFinite);
    check(heuristic.estimateTotalCost(2)).equals(double.maxFinite);
  });

  test('operator* scales the cost of the heuristic', () {
    final heuristic = Heuristic((int node) => node * 2) * 2;

    check(heuristic.estimateTotalCost(1)).equals(4);
    check(heuristic.estimateTotalCost(2)).equals(8);
  });

  test('GridHeuristic.euclidean uses the Euclidean distance', () {
    final heuristic = GridHeuristic.euclidean(Pos(9, 9));

    check(heuristic.estimateTotalCost(Pos(0, 0))).isCloseTo(
      12.727922061357855,
      0.0001,
    );
    check(heuristic.estimateTotalCost(Pos(9, 9))).equals(0);
  });

  test('GridHeuristic.manhattan uses the Manhattan distance', () {
    final heuristic = GridHeuristic.manhattan(Pos(9, 9));

    check(heuristic.estimateTotalCost(Pos(0, 0))).equals(18);
    check(heuristic.estimateTotalCost(Pos(9, 9))).equals(0);
  });

  test('GridHeuristic.diagonal uses the Diagonal distance', () {
    final heuristic = GridHeuristic.diagonal(Pos(9, 9));

    check(heuristic.estimateTotalCost(Pos(0, 0))).equals(9);
    check(heuristic.estimateTotalCost(Pos(9, 9))).equals(0);
  });

  test('GridHeuristic.chebyshev uses the Chebyshev distance', () {
    final heuristic = GridHeuristic.chebyshev(Pos(9, 9));

    check(heuristic.estimateTotalCost(Pos(0, 0))).equals(9);
    check(heuristic.estimateTotalCost(Pos(9, 9))).equals(0);
  });
}
