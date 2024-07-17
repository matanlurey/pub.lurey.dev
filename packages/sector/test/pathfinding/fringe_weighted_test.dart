import '../prelude.dart';
import '../test_data.dart';

/// Due to an effective heuristic, falls back to Dijkstra's algorithm.
void main() {
  test('should find the shortest path in a weighted graph', () {
    final fixture = weightedGraph();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should fail to find a path where the goal is unreachable', () {
    final fixture = weightedUnreachable();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).notFound();
  });

  test('should find a path through a graph with many cycles', () {
    final fixture = weightedCyclic();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should find a path in a graph with multiple shortest paths', () {
    final fixture = weightedMultipleShortestPaths();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should find a path in a graph with zero-weight edges', () {
    final fixture = weightedZeroWeightEdges();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should not cross an impassable edge', () {
    final fixture = weightedImpassableNode();

    final result = fringeAstar.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      Heuristic<String>.zero(),
      tracer: TestTracer<String>(),
    );

    check(result).notFound();
  });
}
