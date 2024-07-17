import '../prelude.dart';
import '../test_data.dart';

void main() {
  test('whould find a single node', () {
    final graph = singleNode('a');
    final nodes = breadthFirst(graph, start: 'a').toList();

    check(nodes).deepEquals(['a']);
  });

  test('should find a single cycle in a directed grpah', () {
    final graph = simpleCycle('a', 'b', 'c');
    final nodes = breadthFirst(graph, start: 'a').toList();

    check(nodes).deepEquals(['a', 'b', 'c']);
  });

  test('should find four components in a linear structure of 4 nodes', () {
    final graph = linear4('a', 'b', 'c', 'd');
    final nodes = breadthFirst(graph, start: 'a').toList();

    check(nodes).deepEquals(['a', 'b', 'c', 'd']);
  });

  test('should find two disconnected cycles', () {
    final graph = disconnectedCycles('a', 'b', 'c', 'd');

    final aNodes = breadthFirst(graph, start: 'a').toList();
    check(aNodes).deepEquals(['a', 'b']);

    final dNodes = breadthFirst(graph, start: 'd').toList();
    check(dNodes).deepEquals(['d', 'c']);
  });

  test('should find nested cycles; a cycle within a larger cycle', () {
    final graph = nestedCycle('a', 'b', 'c', 'd');

    final nodes = breadthFirst(graph, start: 'a').toList();
    check(nodes).deepEquals(['a', 'b', 'c', 'd']);
  });

  test('should find cycles within a grpah with multiple branches', () {
    final graph = multipleBranches('a', 'b', 'c', 'd', 'e');

    final nodes = breadthFirst(graph, start: 'a').toList();
    check(nodes).deepEquals(['a', 'b', 'd', 'c', 'e']);
  });

  test('should find the start in a graph with no nodes', () {
    final graph = empty<String>();

    final nodes = breadthFirst(graph, start: 'a').toList();
    check(nodes).deepEquals(['a']);
  });

  test('should find a graph with self loops', () {
    final graph = selfLoops('a', 'b', 'c');

    final aNodes = breadthFirst(graph, start: 'a').toList();
    check(aNodes).deepEquals(['a']);

    final bNodes = breadthFirst(graph, start: 'b').toList();
    check(bNodes).deepEquals(['b']);

    final cNodes = breadthFirst(graph, start: 'c').toList();
    check(cNodes).deepEquals(['c']);
  });

  test('should find multiple disconnected components', () {
    final graph = disconnectedComponents('a', 'b', 'c', 'd', 'e', 'f');

    final aNodes = breadthFirst(graph, start: 'a').toList();
    check(aNodes).deepEquals(['a', 'b', 'c']);

    final dNodes = breadthFirst(graph, start: 'd').toList();
    check(dNodes).deepEquals(['d', 'e', 'f']);
  });
}
