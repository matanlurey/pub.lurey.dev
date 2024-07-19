import '../prelude.dart';

void main() {
  test('should sort integers from 1 to 9', () {
    Iterable<int> successors(int vertex) {
      return switch (vertex) {
        final n when n <= 7 => [n + 1, n + 2],
        8 => [9],
        _ => [],
      };
    }

    final sorted = topologicalSort([5, 1], successors: successors);
    check(sorted).deepEquals([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test('should throw on a cycle with a node in the cycle', () {
    Iterable<int> successors(int vertex) {
      return switch (vertex) {
        1 => [2],
        2 => [3],
        3 => [1],
        _ => [],
      };
    }

    check(
      () => topologicalSort([1], successors: successors),
    )
        .throws<CycleException<int>>()
        .has((e) => e.involved, 'involved')
        .equals(1);
  });
}
