/// Test graphs for testing the library.
library;

import 'package:sector/sector.dart';

/// Returns a graph with only one node.
WalkableBase<T> singleNode<T>(T a) => Walkable.linear({a});

/// Returns a graph with a single cycle.
///
/// e.g., `A -> B -> C -> A`.
WalkableBase<T> simpleCycle<T>(T a, T b, T c) {
  return Walkable.from({
    a: [b],
    b: [c],
    c: [a],
  });
}

/// Returns a graph with a linear structure of 4 nodes.
///
/// e.g., `A -> B -> C -> D`.
WalkableBase<T> linear4<T>(T a, T b, T c, T d) {
  return Walkable.from({
    a: [b],
    b: [c],
    c: [d],
    d: [],
  });
}

/// Returns a graph with two disconnected cycles of 2 nodes each.
///
/// e.g., `A -> B -> A` and `C -> D -> C`.
WalkableBase<T> disconnectedCycles<T>(T a, T b, T c, T d) {
  return Walkable.from({
    a: [b],
    b: [a],
    c: [d],
    d: [c],
  });
}

/// Returns a graph with a cycle within a larger cycle.
///
/// e.g., `A -> B -> C -> B -> D -> A`.
WalkableBase<T> nestedCycle<T>(T a, T b, T c, T d) {
  return Walkable.from({
    a: [b],
    b: [c, d],
    c: [b],
    d: [a],
  });
}

/// Returns a graph with multiple branches, some of which contain cycles.
///
/// e.g. `A -> B -> C -> A` and `A -> D -> E`.
WalkableBase<T> multipleBranches<T>(T a, T b, T c, T d, T e) {
  return Walkable.from({
    a: [b, d],
    b: [c],
    c: [a],
    d: [e],
    e: [],
  });
}

/// Returns an empty graph.
WalkableBase<T> empty<T>() => Walkable.empty();

/// Returns a graph with self loops.
///
/// e.g., `A -> A`, `B -> B`, `C -> C`.
WalkableBase<T> selfLoops<T>(T a, T b, T c) {
  return Walkable.from({
    a: [a],
    b: [b],
    c: [c],
  });
}

/// Returns a graph with multiple disconnected components.
///
/// e.g., `A -> B -> C` and `D -> E -> F`.
WalkableBase<T> disconnectedComponents<T>(T a, T b, T c, T d, T e, T f) {
  return Walkable.from({
    a: [b],
    b: [c],
    c: [],
    d: [e],
    e: [f],
    f: [],
  });
}

/// Returns a graph with a single path from the first node to the last.
WalkableBase<T> directPath<T>(List<T> nodes) {
  return Walkable.linear(Set.of(nodes));
}

/// Returns a graph with multiple paths from the start to the end.
///
/// There is a fast path (less nodes) and a slow path (more nodes).
WalkableBase<T> multiplePaths<T>({
  required T start,
  required List<T> fast,
  required List<T> slow,
  required T end,
}) {
  assert(
    fast.length < slow.length,
    'Fast path must be shorter than slow path.',
  );
  final graph = Graph<T>();

  // Slow path.
  for (var i = 0; i < slow.length - 1; i++) {
    graph.addEdge(Edge(slow[i], slow[i + 1]));
  }

  // Fast path.
  for (var i = 0; i < fast.length - 1; i++) {
    graph.addEdge(Edge(fast[i], fast[i + 1]));
  }

  // Connect paths.
  graph.addEdge(Edge(slow.last, end));
  graph.addEdge(Edge(fast.last, end));

  return graph;
}

/// Returns a graph resembling a tree, with hierarchical structures
WalkableBase<T> treeLikeStructure<T>({
  required T root,
  required List<T> children,
  required List<T> grandchildren,
}) {
  final graph = Graph<T>();

  // Root to children.
  for (final child in children) {
    graph.addEdge(Edge(root, child));
  }

  // Children to grandchildren.
  for (final child in children) {
    for (final grandchild in grandchildren) {
      graph.addEdge(Edge(child, grandchild));
    }
  }

  return graph;
}

/// Returns a graph containing cycles.
WalkableBase<T> cyclicGraph<T>(T a, T b, T c, T d) {
  return Walkable.circular({a, b, c, d});
}

/// Returns a graph where the start node is the goal node.
WalkableBase<T> startIsGoal<T>(T a) => Walkable.linear({a});

/// Returns a graph where the end node is unreachable.
WalkableBase<T> unreachableGoal<T>(T a, T b) {
  return Walkable.from({a: [], b: []});
}

/// A test fixture for weighted graphs.
final class WeightedGraphFixture {
  WeightedGraphFixture(
    this.graph, {
    required this.start,
    required this.goal,
    required this.shortestPath,
    required this.shortestCost,
  }) {
    if (shortestPath.isFound) {
      assert(
        shortestPath.start == start,
        '\n\nThe start node of the shortest path must be the same as the fixture start node.',
      );
      assert(
        shortestPath.goal == goal,
        '\n\nThe goal node of the shortest path must be the same as the fixture goal node.',
      );
      final (found, cost) = shortestPath.isInWithCost(graph, shortestCost);
      assert(
        found,
        '\n\nThe cost ($cost) of the shortest path (${shortestPath.nodes}) must be the same as the fixture shortest cost ($shortestCost).',
      );
    }
  }

  /// The graph to test.
  final WeightedWalkable<String> graph;

  /// The start node.
  final String start;

  /// The goal node.
  final String goal;

  /// The shortest path from the start to the goal.
  final Path<String> shortestPath;

  /// The cost of the shortest path.
  final double shortestCost;
}

/// Returns a simple weighted graph.
///
/// ```txt
///         (4)
///     A-------B
///     |      /|
///  (1)| (2)/  |(6)
///     |/      |
///     C-----D |
///     | (8) \ |
///  (3)| (5)  E
///     |     /
///     F ---
/// ```
WeightedGraphFixture weightedGraph() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', 4.0), ('C', 1.0)],
      'B': [('A', 4.0), ('C', 2.0), ('D', 6.0)],
      'C': [('A', 1.0), ('B', 2.0), ('D', 8.0), ('F', 3.0)],
      'D': [('B', 6.0), ('C', 8.0), ('E', 2.0)],
      'E': [('D', 2.0), ('F', 5.0)],
      'F': [('C', 3.0), ('E', 5.0)],
    }),
    start: 'A',
    goal: 'E',
    shortestPath: Path(['A', 'C', 'F', 'E']),
    shortestCost: 9,
  );
}

/// Returns a weighted graph where the goal is unreachable.
///
/// ```txt
///     A-------B
///     |     /|
///  (1)| (2)/ |(6)
///     |/   / |
///     C----D--|
///          \ |
///         (5)E
/// ```
WeightedGraphFixture weightedUnreachable() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', 1.0), ('C', 2.0)],
      'B': [('A', 1.0), ('C', 2.0), ('D', 6.0)],
      'C': [('A', 2.0), ('B', 2.0), ('D', 5.0)],
      'D': [('B', 6.0), ('C', 5.0), ('E', double.infinity)],
      'E': [('D', double.infinity)],
    }),
    start: 'A',
    goal: 'E',
    shortestPath: Path.notFound,
    shortestCost: 0,
  );
}

/// Returns a weighted graph with a cycle.
///     A-(4)---B
///     |      /|
///  (1)| (2) / |(6)
///     |/    / |
///     C(8)-D  |
///     |   /|  |
///  (3)| / |(1)|
///     |/  | |
///     F----E |
///          \|
///          (5)
WeightedGraphFixture weightedCyclic() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', 4.0), ('C', 1.0)],
      'B': [('A', 4.0), ('C', 2.0), ('D', 6.0)],
      'C': [('A', 1.0), ('B', 2.0), ('D', 8.0), ('F', 3.0)],
      'D': [('B', 6.0), ('C', 8.0), ('E', 1.0)],
      'E': [('D', 1.0), ('F', 5.0)],
      'F': [('C', 3.0), ('E', 5.0)],
    }),
    start: 'A',
    goal: 'E',
    shortestPath: Path(['A', 'C', 'F', 'E']),
    shortestCost: 9,
  );
}

/// Returns a weighted graph with multiple shortest paths.
///
/// ```txt
///      (4)    (4)
///     A-------B-------C
///     |                |
///  (1)|                |(1)
///     D-------E-------F
/// ```
WeightedGraphFixture weightedMultipleShortestPaths() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', 4.0), ('D', 1.0)],
      'B': [('A', 4.0), ('C', 4.0), ('E', 1.0)],
      'C': [('B', 4.0), ('F', 1.0)],
      'D': [('A', 1.0), ('E', 4.0)],
      'E': [('B', 1.0), ('D', 4.0), ('F', 1.0)],
      'F': [('C', 1.0), ('E', 1.0)],
    }),
    start: 'A',
    goal: 'F',
    shortestPath: Path(['A', 'D', 'E', 'F']),
    shortestCost: 6,
  );
}

/// Returns a weighted graph with zero-weight edges.
///
/// ```txt
///         (0)
///     A--------B
///     |       |
///  (1)|       |(6)
///     |       |
///     C-------D
///         (3)
/// ```
WeightedGraphFixture weightedZeroWeightEdges() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', 0.0), ('C', 1.0)],
      'B': [('A', 0.0), ('D', 6.0)],
      'C': [('A', 1.0), ('D', 3.0)],
      'D': [('B', 6.0), ('C', 3.0)],
    }),
    start: 'A',
    goal: 'D',
    shortestPath: Path(['A', 'C', 'D']),
    shortestCost: 4,
  );
}

/// Returns a weighted graph with an impassable node.
///
/// ```txt
/// A -> (∞) -> B
/// ```
WeightedGraphFixture weightedImpassableNode() {
  return WeightedGraphFixture(
    WeightedWalkable.from({
      'A': [('B', double.infinity)],
      'B': [],
    }),
    start: 'A',
    goal: 'B',
    shortestPath: Path.notFound,
    shortestCost: double.infinity,
  );
}
