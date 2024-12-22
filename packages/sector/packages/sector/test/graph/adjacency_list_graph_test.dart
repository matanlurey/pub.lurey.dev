import '../prelude.dart';

void main() {
  group('empty graph', () {
    final empty = Graph<void>();

    test('should be empty', () {
      check(empty).isEmpty();
      check(empty).not((p) => p.isNotEmpty());
    });

    test('should have no edges', () {
      check(empty.edges).isEmpty();
    });

    test('should have no successors', () {
      check(empty.successors(null)).isEmpty();
    });

    test('should have no roots', () {
      check(empty.roots).isEmpty();
    });
  });

  group('graph from a traversable base', () {
    final graph = Graph.from(
      Walkable.linear({1, 2, 3}),
    );

    test('should not be empty', () {
      check(graph).isNotEmpty();
      check(graph).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(graph.edges).unorderedEquals([
        Edge(1, 2),
        Edge(2, 3),
      ]);
    });

    test('should have successors', () {
      check(graph.successors(1)).unorderedEquals([2]);
      check(graph.successors(2)).unorderedEquals([3]);
      check(graph.successors(3)).isEmpty();
    });

    test('should have roots', () {
      check(graph.roots).unorderedEquals([1, 2]);
      check(graph).containsRoot(1);
      check(graph).containsRoot(2);
      check(graph).not((p) => p.containsRoot(3));
    });
  });

  group('graph from edges', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
      Edge(2, 3),
    ]);

    test('should not be empty', () {
      check(graph).isNotEmpty();
      check(graph).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(graph.edges).unorderedEquals([
        Edge(1, 2),
        Edge(2, 3),
      ]);
    });

    test('should have successors', () {
      check(graph.successors(1)).unorderedEquals([2]);
      check(graph.successors(2)).unorderedEquals([3]);
      check(graph.successors(3)).isEmpty();
    });

    test('should have roots', () {
      check(graph.roots).unorderedEquals([1, 2]);
      check(graph).containsRoot(1);
      check(graph).containsRoot(2);
      check(graph).not((p) => p.containsRoot(3));
    });

    test('should contain edge', () {
      check(graph).containsEdge(Edge(1, 2));
      check(graph).containsEdge(Edge(2, 3));
    });

    test('should not contain edge', () {
      check(graph).not((p) => p.containsEdge(Edge(1, 3)));
    });
  });

  test('addEdge should add an edge', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
    ]);

    check(graph.addEdge(Edge(2, 3))).isTrue();
    check(graph.edges).unorderedEquals([
      Edge(1, 2),
      Edge(2, 3),
    ]);
  });

  test('addEdge should not add an existing edge', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
    ]);

    check(graph.addEdge(Edge(1, 2))).isFalse();
    check(graph.edges).unorderedEquals([
      Edge(1, 2),
    ]);
  });

  test('removeEdge should remove an edge', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
      Edge(2, 3),
    ]);

    check(graph.removeEdge(Edge(2, 3))).isTrue();
    check(graph.edges).unorderedEquals([
      Edge(1, 2),
    ]);
  });

  test('removeEdge should not remove a non-existing edge', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
    ]);

    check(graph.removeEdge(Edge(2, 3))).isFalse();
    check(graph.edges).unorderedEquals([
      Edge(1, 2),
    ]);
  });

  test('clear should remove all nodes and edges', () {
    final graph = Graph.fromEdges([
      Edge(1, 2),
      Edge(2, 3),
    ]);

    graph.clear();
    check(graph).isEmpty();
  });

  group('directed: false', () {
    test('should create an empty graph', () {
      final graph = Graph<void>(directed: false);
      check(graph).isEmpty();
    });

    test('should contain an edge in one direction', () {
      final graph = Graph.fromEdges(
        [Edge(1, 2)],
        directed: false,
      );

      check(graph).containsEdge(Edge(1, 2));
      check(graph).containsEdge(Edge(2, 1));
    });

    test('should add an edge in both directions', () {
      final graph = Graph.fromEdges(
        [Edge(1, 2)],
        directed: false,
      );

      check(graph.edges).unorderedEquals([
        Edge(1, 2),
        Edge(2, 1),
      ]);
    });

    test('should remove an edge in both directions', () {
      final graph = Graph.fromEdges(
        [Edge(1, 2)],
        directed: false,
      );

      check(graph.removeEdge(Edge(1, 2))).isTrue();
      check(graph).isEmpty();
    });
  });
}
