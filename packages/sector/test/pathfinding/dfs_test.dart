import '../prelude.dart';
import '../src/test_data.dart';

void main() {
  test('should find a direct path', () {
    final graph = directPath([1, 2, 3]);

    final path = depthFirstSearch.findPath<int>(
      graph,
      1,
      Goal.node(3),
      tracer: TestTracer(),
    );
    check(path).nodesEquals([1, 2, 3]);
  });

  test('should fail to find the shorter path, getting stuck in branch', () {
    final graph = multiplePaths(
      start: 'a',
      fast: ['a', 'b', 'c'],
      slow: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'],
      end: 'l',
    );

    final path = depthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('l'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l']);
  });

  test('should find a path in a tree-like structure', () {
    final graph = treeLikeStructure(
      root: 'president',
      children: ['vice-president', 'secretary', 'treasurer'],
      grandchildren: ['assistant', 'manager', 'accountant', 'analyst'],
    );

    final path = depthFirstSearch.findPath(
      graph,
      'president',
      Goal.node('analyst'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['president', 'vice-president', 'analyst']);
  });

  test('should find a path in a cyclic graph', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = depthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a']);
  });

  test('should find a path where the start is the goal', () {
    final graph = startIsGoal('a');

    final path = depthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a']);
  });

  test('should not find a path when exclusive search is used', () {
    final graph = startIsGoal('a');

    final path = depthFirstSearch.findPathExclusive(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });

  test('should find a cycle back to the start when exclusive is used', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = depthFirstSearch.findPathExclusive(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a', 'b', 'c', 'd', 'a']);
  });

  test('should not find an unreachable goal', () {
    final graph = unreachableGoal('a', 'b');

    final path = depthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('b'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });

  test('should skip a node', () {
    // It's actually tough to reproduce this scenario in a test, as the graph
    // needs to return successors in a different order than the order they were
    // added. It is unlikely to happen in practice, but it's not against the
    // contract of the algorithm.
    final graph = Graph<String>();

    // Normally in a 3-way star graph, i.e.:
    //   a
    //  / \
    // b<->c
    //
    // "successors" returns the nodes in the order they were added or,
    // a: [b, c]
    // b: [a, c]
    // c: [a, b]
    //
    // But what if a grid returns them in a different (mixed) order?
    // a: [c, b]
    // b: [b, a]
    // c: [a, b]
    //
    // We would want to ensure we skip the node.
    graph.addEdge(Edge('c', 'b'));
    graph.addEdge(Edge('b', 'a'));
    graph.addEdge(Edge('a', 'b'));

    final tracer = TestTracer<String>();
    final path = depthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('c'),
      tracer: tracer,
    );

    // Gets stuck.
    check(path).notFound();

    // We should have skipped nodes in the trace events.
    check(tracer.events).deepEquals([
      TraceEvent.onVisit('a'),
      TraceEvent.onVisit('b'),
      TraceEvent.onSkip('a'),
    ]);
  });
}
