import '../prelude.dart';
import '../src/test_data.dart';

void main() {
  final adapted = greedyBestFirstSearch.asBestPathfinder(
    toNode: <T>(target) => Heuristic.zero(),
    orElse: <T>(start, goal) => Heuristic.zero(),
  );

  test('should find a path in a weighted graph, not the shortest', () {
    final fixture = weightedGraph();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(['A', 'B', 'C', 'D', 'E'], 16);
  });

  test('should fail to find a path where the goal is unreachable', () {
    final fixture = weightedUnreachable();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).notFound();
  });

  test('should find a path through a graph with many cycles', () {
    final fixture = weightedCyclic();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(['A', 'B', 'C', 'D', 'E'], 15);
  });

  test('should find a path in a graph with multiple shortest paths', () {
    final fixture = weightedMultipleShortestPaths();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(['A', 'B', 'C', 'F'], 9);
  });

  test('should find a path in a graph with zero-weight edges', () {
    final fixture = weightedZeroWeightEdges();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(['A', 'B', 'D'], 6);
  });

  test('should not cross an impassable edge', () {
    final fixture = weightedImpassableNode();

    final result = adapted.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).notFound();
  });
}
