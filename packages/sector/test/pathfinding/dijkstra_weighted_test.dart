import '../prelude.dart';
import '../src/test_data.dart';

void main() {
  test('should find the shortest path in a weighted graph', () {
    final fixture = weightedGraph();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should fail to find a path where the goal is unreachable', () {
    final fixture = weightedUnreachable();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).notFound();
  });

  test('should find a path through a graph with many cycles', () {
    final fixture = weightedCyclic();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(expectRepeatedVisits: true),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should find a path in a graph with multiple shortest paths', () {
    final fixture = weightedMultipleShortestPaths();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should find a path in a graph with zero-weight edges', () {
    final fixture = weightedZeroWeightEdges();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).pathEquals(fixture.shortestPath.nodes, fixture.shortestCost);
  });

  test('should not cross an impassable edge', () {
    final fixture = weightedImpassableNode();

    final result = dijkstra.findBestPath(
      fixture.graph,
      fixture.start,
      Goal.node(fixture.goal),
      tracer: TestTracer<String>(),
    );

    check(result).notFound();
  });
}
