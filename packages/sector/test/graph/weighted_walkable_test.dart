import '../prelude.dart';

void main() {
  group('empty weighted walkable', () {
    final empty = WeightedWalkable<void>.empty();

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
  group('edges walkable', () {
    final edges = WeightedWalkable.from({
      1: [(2, 3)],
      2: [(3, 6)],
    });

    test('should not be empty', () {
      check(edges).isNotEmpty();
      check(edges).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(
        edges.edges,
      ).unorderedEquals([WeightedEdge(1, 2, 3), WeightedEdge(2, 3, 6)]);
    });

    test('should have successors', () {
      check(edges.successors(1)).unorderedEquals([(2, 3)]);
      check(edges.successors(2)).unorderedEquals([(3, 6)]);
      check(edges.successors(3)).isEmpty();
    });

    test('should have roots', () {
      check(edges.roots).unorderedEquals([1, 2]);
      check(edges).containsRoot(1);
      check(edges).containsRoot(2);
      check(edges).not((p) => p.containsRoot(3));
    });

    test('should contain edge', () {
      check(edges).containsEdge(Edge(1, 2));
      check(edges).containsEdge(Edge(2, 3));
    });
  });

  group('generated walkable', () {
    final generated = WeightedWalkable.generate(
      successors:
          (node) => switch (node) {
            1 => [(2, 3)],
            2 => [(3, 6)],
            _ => const [],
          },
      roots: () => [1, 2],
    );

    test('should not be empty', () {
      check(generated).isNotEmpty();
      check(generated).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(
        generated.edges,
      ).unorderedEquals([WeightedEdge(1, 2, 3), WeightedEdge(2, 3, 6)]);
    });

    test('should have successors', () {
      check(generated.successors(1)).unorderedEquals([(2, 3)]);
      check(generated.successors(2)).unorderedEquals([(3, 6)]);
      check(generated.successors(3)).isEmpty();
    });

    test('should have roots', () {
      check(generated.roots).unorderedEquals([1, 2]);
      check(generated).containsRoot(1);
      check(generated).containsRoot(2);
      check(generated).not((p) => p.containsRoot(3));
    });

    test('should contain edge', () {
      check(generated).containsEdge(Edge(1, 2));
      check(generated).containsEdge(Edge(2, 3));
    });
  });

  group('as unweighted walkable', () {
    final graph =
        WeightedWalkable.generate(
          successors:
              (node) => switch (node) {
                1 => [(2, 3)],
                2 => [(3, 6)],
                _ => const [],
              },
          roots: () => [1, 2],
        ).asUnweighted();

    test('should not be empty', () {
      check(graph).isNotEmpty();
      check(graph).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(graph.edges).unorderedEquals([Edge(1, 2), Edge(2, 3)]);
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
  });

  group('weighted edge', () {
    test('==', () {
      check(WeightedEdge(1, 2, 3)).equals(WeightedEdge(1, 2, 3));
      check(WeightedEdge(1, 2, 3)).not((p) => p.equals(WeightedEdge(1, 2, 6)));
    });

    test('hashCode', () {
      check(
        WeightedEdge(1, 2, 3).hashCode,
      ).equals(WeightedEdge(1, 2, 3).hashCode);
      check(
        WeightedEdge(1, 2, 3).hashCode,
      ).not((p) => p.equals(WeightedEdge(1, 2, 6).hashCode));
    });

    test('toString', () {
      check(WeightedEdge(1, 2, 3).toString()).equals('1 -> 2 <3.0>');
    });

    test('reversed', () {
      check(WeightedEdge(1, 2, 3).reversed).equals(WeightedEdge(2, 1, 3));
    });
  });
}
