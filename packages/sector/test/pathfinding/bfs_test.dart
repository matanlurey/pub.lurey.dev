import '../prelude.dart';
import '../src/test_data.dart';

void main() {
  test('should find a direct path', () {
    final graph = directPath([1, 2, 3]);

    final path = breadthFirstSearch.findPath(
      graph,
      1,
      Goal.node(3),
      tracer: TestTracer<int>(),
    );
    check(path).nodesEquals([1, 2, 3]);
  });

  test('should find the faster path', () {
    final graph = multiplePaths(
      start: 'a',
      fast: ['a', 'b', 'c'],
      slow: ['a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'],
      end: 'l',
    );

    final path = breadthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('l'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a', 'b', 'c', 'l']);
  });

  test('should find a path in a tree-like structure', () {
    final graph = treeLikeStructure(
      root: 'president',
      children: ['vice-president', 'secretary', 'treasurer'],
      grandchildren: ['assistant', 'manager', 'accountant', 'analyst'],
    );

    final path = breadthFirstSearch.findPath(
      graph,
      'president',
      Goal.node('analyst'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['president', 'vice-president', 'analyst']);
  });

  test('should find a path in a cyclic graph', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = breadthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a']);
  });

  test('should find a path where the start is the goal', () {
    final graph = startIsGoal('a');

    final path = breadthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a']);
  });

  test('should not find a path when exclusive search is used', () {
    final graph = startIsGoal('a');

    final path = breadthFirstSearch.findPathExclusive(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });

  test('should find a cycle back to the start when exclusive is used', () {
    final graph = cyclicGraph('a', 'b', 'c', 'd');

    final path = breadthFirstSearch.findPathExclusive(
      graph,
      'a',
      Goal.node('a'),
      tracer: TestTracer<String>(),
    );
    check(path).nodesEquals(['a', 'b', 'c', 'd', 'a']);
  });

  test('should not find an unreachable goal', () {
    final graph = unreachableGoal('a', 'b');

    final path = breadthFirstSearch.findPath(
      graph,
      'a',
      Goal.node('b'),
      tracer: TestTracer<String>(),
    );
    check(path).notFound();
  });
}
