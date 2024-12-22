import 'package:lodim/lodim.dart';

import '../prelude.dart';

void main() {
  test('should return 0 for an empty graph', () {
    final graph = Walkable<void>.empty();
    final paths = countPaths(
      graph,
      start: null,
      goal: Goal<void>.never(),
      tracer: TestTracer<void>(),
    );

    check(paths).equals(0);
  });

  test('should return 1 for a graph with a single node', () {
    final graph = Walkable.linear({1});
    final paths = countPaths(
      graph,
      start: 1,
      goal: Goal.node(1),
      tracer: TestTracer<int>(),
    );

    check(paths).equals(1);
  });

  test('should return 0 for a graph with a single node and no goal', () {
    final graph = Walkable.linear({1});
    final paths = countPaths(
      graph,
      start: 1,
      goal: Goal<int>.never(),
      tracer: TestTracer<int>(),
    );

    check(paths).equals(0);
  });

  test('should return 3432 for an 8x8 chess board', () {
    final graph = Grid.filled(8, 8, empty: 0, fill: 1);
    final paths = countPaths(
      graph.asUnweighted(
        directions: [
          Direction.right,
          Direction.down,
        ],
      ),
      start: graph.topLeft,
      goal: Goal.node(graph.bottomRight),
      tracer: TestTracer<Pos>(),
    );

    check(paths).equals(3432);
  });

  test('should throw a $CycleException for a graph with a cycle', () {
    final graph = Grid.filled(8, 8, empty: 0, fill: 1);

    check(
      () => countPaths(
        graph.asUnweighted(),
        start: graph.topRight,
        goal: Goal.test((e) => e == graph.bottomLeft),
        tracer: TestTracer<Pos>(),
      ),
    ).throws<CycleException<void>>();

    check(CycleException(5).toString()).contains('Cycle detected at node 5.');
  });
}
