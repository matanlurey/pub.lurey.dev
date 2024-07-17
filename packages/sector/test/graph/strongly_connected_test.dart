import '../prelude.dart';
import '../test_data.dart';

void main() {
  test('whould find a single node', () {
    final graph = singleNode('a');

    check(stronglyConnected(graph, from: ['a'])).deepEquals([
      ['a'],
    ]);
  });

  test('should find a single cycle in a directed grpah', () {
    final graph = simpleCycle('a', 'b', 'c');

    check(stronglyConnected(graph, from: ['a'])).deepEquals([
      ['c', 'b', 'a'],
    ]);
  });

  test('should find four components in a linear structure of 4 nodes', () {
    final graph = linear4('a', 'b', 'c', 'd');

    check(stronglyConnected(graph, from: ['a'])).deepEquals([
      ['d'],
      ['c'],
      ['b'],
      ['a'],
    ]);
  });

  test('should find two disconnected cycles', () {
    final graph = disconnectedCycles('a', 'b', 'c', 'd');

    check(stronglyConnected(graph)).deepEquals([
      ['b', 'a'],
      ['b'],
      ['d', 'c'],
      ['d'],
    ]);
  });

  test('should find nested cycles; a cycle within a larger cycle', () {
    final graph = nestedCycle('a', 'b', 'c', 'd');

    check(stronglyConnected(graph, from: ['a'])).deepEquals([
      ['d', 'c', 'b', 'a'],
    ]);
  });

  test('should find cycles within a grpah with multiple branches', () {
    final graph = multipleBranches('a', 'b', 'c', 'd', 'e');

    check(stronglyConnected(graph, from: ['a'])).deepEquals([
      ['e'],
      ['d'],
      ['c', 'b', 'a'],
    ]);
  });

  test('should find nothing in a graph with no nodes', () {
    final graph = empty<String>();

    check(stronglyConnected(graph, from: [])).deepEquals([]);
  });

  test('should find a graph with self loops', () {
    final graph = selfLoops('a', 'b', 'c');

    check(stronglyConnected(graph)).deepEquals([
      ['a'],
      ['b'],
      ['c'],
    ]);
  });

  test('should find multiple disconnected components', () {
    final graph = disconnectedComponents('a', 'b', 'c', 'd', 'e', 'f');

    check(stronglyConnected(graph, from: ['a', 'd'])).deepEquals([
      ['c'],
      ['b'],
      ['a'],
      ['f'],
      ['e'],
      ['d'],
    ]);
  });
}
