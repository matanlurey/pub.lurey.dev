import '../prelude.dart';

void main() {
  group('empty walkable', () {
    final empty = Walkable<void>.empty();

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
    final edges = Walkable.linear({1, 2, 3});

    test('should not be empty', () {
      check(edges).isNotEmpty();
      check(edges).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(edges.edges).unorderedEquals([Edge(1, 2), Edge(2, 3)]);

      check(edges.roots).unorderedEquals([1, 2]);
    });

    test('should have successors', () {
      check(edges.successors(1)).unorderedEquals([2]);
      check(edges.successors(2)).unorderedEquals([3]);
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
    final generated = Walkable.generate(
      roots: () => [1, 2],
      successors: (node) => [node + 1],
    );

    test('should not be empty', () {
      check(generated).isNotEmpty();
      check(generated).not((p) => p.isEmpty());
    });

    test('should have edges', () {
      check(generated.edges).unorderedEquals([Edge(1, 2), Edge(2, 3)]);
    });

    test('should have successors', () {
      check(generated.successors(1)).unorderedEquals([2]);
      check(generated.successors(2)).unorderedEquals([3]);
    });

    test('should have roots', () {
      check(generated.roots).unorderedEquals([1, 2]);
    });
  });

  group('as weighted walkable', () {
    final walkable = Walkable.linear({1.0, 3.0, 10.0});

    final weighted = walkable.asWeighted(
      (source, target) => (source - target).abs(),
    );

    test('should have edges', () {
      check(weighted.edges).unorderedEquals([
        WeightedEdge(1.0, 3.0, 2.0),
        WeightedEdge(3.0, 10.0, 7.0),
      ]);
    });

    test('should have successors', () {
      check(weighted.successors(1.0)).unorderedEquals([(3.0, 2.0)]);
      check(weighted.successors(3.0)).unorderedEquals([(10.0, 7.0)]);
    });
  });

  test('Walkable.linear with a single node', () {
    final walkable = Walkable.linear({1});

    check(walkable.roots).unorderedEquals([1]);
  });

  test('asUnweighted() should return the same instance', () {
    final walkable = Walkable.linear({1, 2, 3});

    check(walkable.asUnweighted()).identicalTo(walkable);
  });

  group('edge', () {
    test('==', () {
      check(Edge(1, 2)).equals(Edge(1, 2));
      check(Edge(1, 2)).not((p) => p.equals(Edge(2, 1)));
    });

    test('hashCode', () {
      check(Edge(1, 2).hashCode).equals(Edge(1, 2).hashCode);
      check(Edge(1, 2).hashCode).not((p) => p.equals(Edge(2, 1).hashCode));
    });

    test('toString', () {
      check(Edge(1, 2).toString()).equals('1 -> 2');
    });

    test('reversed', () {
      check(Edge(1, 2).reversed).equals(Edge(2, 1));
    });
  });

  test('Walkable.from has every key as a root', () {
    final walkable = Walkable.from({
      1: [2],
      2: [3],
    });
    check(walkable.roots).unorderedEquals([1, 2]);
  });

  test('Walkable.star has every element as a root', () {
    final walkable = Walkable.star({1, 2, 3});
    check(walkable.roots).unorderedEquals([1, 2, 3]);
    check(walkable.successors(1)).unorderedEquals([2, 3]);
    check(walkable.successors(2)).unorderedEquals([1, 3]);
    check(walkable.successors(3)).unorderedEquals([1, 2]);
  });

  test('Walkable.circular must have at least one element', () {
    check(() => Walkable.circular({})).throws<ArgumentError>();
  });

  test('Walkable.undirected should form undirected edges', () {
    final walkable = Walkable.undirected({(1, 2), (2, 3)});
    check(
      walkable.edges,
    ).unorderedEquals([Edge(1, 2), Edge(2, 1), Edge(2, 3), Edge(3, 2)]);
    check(walkable.roots).unorderedEquals([1, 2, 3]);
    check(walkable.successors(1)).unorderedEquals([2]);
    check(walkable.successors(2)).unorderedEquals([1, 3]);
    check(walkable.successors(3)).unorderedEquals([2]);
  });
}
