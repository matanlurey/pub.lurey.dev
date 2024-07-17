import '../prelude.dart';
import '../test_data.dart';

/// Tests dijkstra's algorithm with an effectively unweighted graph.
void main() {
  test('should find a direct path', () {
    final graph = directPath([1, 2, 3]);

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      1,
      Goal.node(3),
      tracer: TestTracer<int>(),
    );
    check(path).pathEquals([1, 2, 3]);
  });

  test('should find the faster path', () {
    final graph = multiplePaths(
      start: 'a',
      fast: ['a', 'b', 'c'],
      slow: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'],
      end: 'l',
    );

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      'a',
      Goal.node('l'),
      tracer: TestTracer<String>(),
    );
    check(path).pathEquals(['a', 'b', 'c', 'l']);
  });

  test('should find a path in a tree-like structure', () {
    final graph = treeLikeStructure(
      root: 'president',
      children: ['vice-president', 'secretary', 'treasurer'],
      grandchildren: ['assistant', 'manager', 'accountant', 'analyst'],
    );

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      'president',
      Goal.node('analyst'),
      tracer: TestTracer<String>(),
    );
    check(path).pathEquals([
      'president',
      'vice-president',
      'analyst',
    ]);
  });

  test('should find a path in a cyclic graph', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).pathEquals(['a']);
  });

  test('should find a path where the start is the goal', () {
    final graph = startIsGoal('a');

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).pathEquals(['a']);
  });

  test('should not find a path when exclusive search is used', () {
    final graph = startIsGoal('a');

    final path = dijkstra.findBestPathExclusive(
      graph.asWeightedForced(),
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });

  test('should find a cycle back to the start when exclusive is used', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = dijkstra.findBestPathExclusive(
      graph.asWeightedForced(),
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).pathEquals(['a', 'b', 'c', 'd', 'a']);
  });

  test('should not find an unreachable goal', () {
    final graph = unreachableGoal('a', 'b');

    final path = dijkstra.findBestPath(
      graph.asWeightedForced(),
      'a',
      Goal.node('b'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });
}
