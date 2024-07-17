part of '../graph.dart';

/// A collection of values, or "nodes", that can be traversed incrementally.
///
/// The nodes of the walkable collection are accessed by calling the
/// [successors] method with a source vertex as an argument, which returns an
/// [Iterable] of vertices that are accessible from the source node.
///
/// The [Walkable] declaration provides a default implementation, which can
/// be extended or mixed-in to implement the [Walkable] interface. It
/// implements every member other than [successors] and [roots]. An
/// implementation of [Walkable] should provide a more efficient
/// implementation of members of `Walkable` when it can do so.
///
/// ## Directed and Undirected Graphs
///
/// A [Walkable] by definition describes a _directed_ graph, where the edges
/// between nodes have a direction. For an _undirected_ graph, where the edges
/// are bidirectional, they should be represented as two directed edges in
/// either direction.
///
/// See [Walkable.undirected] as an example implementation of an undirected
/// graph.
///
/// ## Adapting to a [WeightedWalkable]
///
/// A [Walkable] can be adapted to a [WeightedWalkable] by calling the
/// [asWeighted] method with a function that determines the weight of an edge
/// between two nodes. This allows for a [Walkable] to be used in algorithms
/// that require a [WeightedWalkable]:
///
/// ```dart
/// final unweighted = Walkable.generate(
///   successors: (node) => switch (node) {
///     'a' => ['b'],
///     _ => const [],
///   },
///   roots: () => ['a'],
/// );
/// final weighted = unweighted.asWeighted((source, target) => 1);
/// print(weighted.successors('a')); // [('b', 1)]
/// ```
///
/// ## Example
///
/// Here is a sample implementation of a graph using pattern matching:
///
/// ```dart
/// final class AbcGraph with Walkable<String> {
///   @override
///   Iterable<String> successors(String node) {
///     return switch (node) {
///       'a' => ['b', 'c'],
///       'b' => ['c'],
///       'c' => ['d'],
///       _ => const [],
///     };
///   }
///
///   @override
///   Iterable<String> get roots => ['a', 'b', 'c'];
/// }
///
/// void main() {
///   final graph = AbcGraph();
///   print(graph.successors('a')); // ['b', 'c']
///   print(graph.roots); // ['a', 'b', 'c']
/// }
/// ```
///
/// {@category Graphs}
abstract mixin class Walkable<E> implements WalkableBase<E> {
  /// Creates an empty walkable.
  ///
  /// The empty walkable has no nodes and no edges.
  const factory Walkable.empty() = _EmptyWalkable<E>;

  /// Creates a walkable from a map of source nodes to target nodes.
  ///
  /// The resulting walkable is lazy, and is generally inefficient for
  /// operations outside of iterating [edges]. This is a convenience method for
  /// creating a walkable from a collection of edges, i.e. in a test case.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = Walkable.from({
  ///   'a': ['b'],
  ///   'b': ['c'],
  ///   'c': ['d'],
  /// });
  /// print(walkable.edges); // {a -> b, b -> c, c -> d}
  /// ```
  const factory Walkable.from(
    Map<E, Iterable<E>> edges,
  ) = _EdgesWalkable<E>;

  /// Creates a walkable which generates successors dynamically.
  ///
  /// The [successors] function is called whenever a node is accessed, and the
  /// [roots] function is called whenever the roots are accessed. This allows
  /// for lazy generation of nodes and edges.
  ///
  /// > [!NOTE]
  /// > Pay special attention to [Walkable.successors] and [Walkable.roots]
  /// > respectively, as they are called each time the property is accessed,
  /// > and have specific constraints on their return values (e.g. both must
  /// > not return the same node more than once).
  const factory Walkable.generate({
    required Iterable<E> Function(E node) successors,
    required Iterable<E> Function() roots,
  }) = _GeneratedWalkable<E>;

  /// Creates a walkable with a linear topology.
  ///
  /// Each node in the linear walkable is connected to the next node in the
  /// sequence.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = Walkable.linear(['a', 'b', 'c']);
  ///
  /// print(walkable.successors('a')); // ['b']
  /// print(walkable.successors('b')); // ['c']
  /// print(walkable.successors('c')); // []
  /// ```
  factory Walkable.linear(Set<E> nodes) = _LinearWalkable<E>;

  /// Creates a walkable with a circular topology.
  ///
  /// Each node in the circular walkable is connected to the next node in the
  /// sequence, and the last node is connected to the first node.
  ///
  /// At least one node must be provided.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = Walkable.circular(['a', 'b', 'c']);
  ///
  /// print(walkable.successors('a')); // ['b']
  /// print(walkable.successors('b')); // ['c']
  /// print(walkable.successors('c')); // ['a']
  /// ```
  factory Walkable.circular(Set<E> nodes) {
    final list = List.of(nodes);
    if (list.isEmpty) {
      throw ArgumentError.value(nodes, 'nodes', 'Must not be empty');
    }
    list.add(list.first);
    return _LinearWalkable._(list);
  }

  /// Creates a walkable with a star topology.
  ///
  /// Each node in the star is connected to every other node in the star.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = Walkable.star(['a', 'b', 'c']);
  ///
  /// print(walkable.successors('a')); // ['b', 'c']
  /// print(walkable.successors('b')); // ['a', 'c']
  /// print(walkable.successors('c')); // ['a', 'b']
  /// ```
  factory Walkable.star(Set<E> points) = _StarWalkable<E>;

  /// Creates a walkable with an undirected graph topology.
  ///
  /// Each edge in the undirected walkable is bidirectional, i.e. if `a` is
  /// a successor of `b`, then `b` is a successor of `a`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = Walkable.undirected([
  ///   ('a', 'b'),
  ///   ('b', 'c'),
  /// ]);
  /// print(walkable.successors('a')); // ['b']
  /// print(walkable.successors('b')); // ['a', 'c']
  /// print(walkable.successors('c')); // ['b']
  /// ```
  factory Walkable.undirected(Set<(E, E)> edges) = _UndirectedWalkable<E>;

  @override
  Iterable<E> successors(E node);

  @override
  Iterable<E> get roots;

  @override
  bool get isEmpty => roots.isEmpty;

  @override
  bool get isNotEmpty => roots.isNotEmpty;

  @override
  bool containsEdge(Edge<E> edge) {
    return successors(edge.source).contains(edge.target);
  }

  @override
  bool containsRoot(E node) => roots.contains(node);

  /// Each edge in the collection.
  Iterable<Edge<E>> get edges {
    return roots.expand((vertex) {
      return successors(vertex).map((target) => Edge(vertex, target));
    });
  }

  @override
  Walkable<E> asUnweighted() => this;

  /// Returns a view of this walkable as a _weighted_ walkable.
  ///
  /// The [weight] function is used to determine the weight of an edge between
  /// two nodes, and is invoked with the source and target nodes of the edge
  /// each time the edge is accessed.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final unweighted = Walkable.generate(
  ///   successors: (node) => switch (node) {
  ///     'a' => ['b'],
  ///     _ => const [],
  ///   },
  ///   roots: () => ['a'],
  /// );
  ///
  /// final weighted = unweighted.asWeighted((source, target) => 1);
  /// print(weighted.successors('a')); // [('a', 1)]
  /// ```
  WeightedWalkable<E> asWeighted(
    double Function(E source, E target) weight,
  ) {
    return _AsWeightedWalkable(this, weight);
  }

  /// Converts a [Walkable] to a string like [toString].
  ///
  /// Allows using other delimiters than `{` and `}`.
  static String walkableToString(
    Walkable<Object?> walkable, {
    String start = '{',
    String end = '}',
  }) {
    final buffer = StringBuffer(start);
    if (walkable.isEmpty) {
      buffer.write(end);
      return buffer.toString();
    }
    buffer.writeln();
    for (final source in walkable.roots) {
      buffer.write('  $source -> ');
      buffer.writeAll(walkable.successors(source), ', ');
      buffer.writeln();
    }
    buffer.write(end);
    return buffer.toString();
  }

  /// Returns a string representation of (some of) the nodes of `this`.
  ///
  /// Nodes are represented by their own [Object.toString] results.
  @override
  String toString() => walkableToString(this);
}

/// A graph edge connecting two nodes.
///
/// In [UndirectedGraph]s, the edge is an unordered pair of nodes.
///
/// {@category Graphs}
@immutable
final class Edge<E> {
  /// Creates an edge from [source] to [target].
  const Edge(this.source, this.target);

  /// The source node of the edge.
  final E source;

  /// The target node of the edge.
  final E target;

  @override
  bool operator ==(Object other) {
    return other is Edge<E> && source == other.source && target == other.target;
  }

  @override
  int get hashCode => Object.hash(source, target);

  /// The edge with the source and target nodes reversed.
  ///
  /// Not guaranteed to be valid in all graph types.
  Edge<E> get reversed => Edge(target, source);

  @override
  String toString() => '$source -> $target';
}

final class _EmptyWalkable<E> with Walkable<E> {
  const _EmptyWalkable();

  @override
  Iterable<E> successors(E node) => const [];

  @override
  Iterable<E> get roots => const [];
}

final class _EdgesWalkable<E> with Walkable<E> {
  const _EdgesWalkable(this._edges);
  final Map<E, Iterable<E>> _edges;

  @override
  Iterable<E> successors(E node) {
    return _edges[node] ?? const [];
  }

  @override
  Iterable<E> get roots => _edges.keys;
}

final class _GeneratedWalkable<E> with Walkable<E> {
  const _GeneratedWalkable({
    required Iterable<E> Function(E node) successors,
    required Iterable<E> Function() roots,
  })  : _successors = successors,
        _roots = roots;

  final Iterable<E> Function(E node) _successors;
  final Iterable<E> Function() _roots;

  @override
  Iterable<E> successors(E node) => _successors(node);

  @override
  Iterable<E> get roots => _roots();
}

final class _AsWeightedWalkable<V> with WeightedWalkable<V> {
  const _AsWeightedWalkable(this._walkable, this._weight);
  final Walkable<V> _walkable;
  final double Function(V source, V target) _weight;

  @override
  Iterable<(V, double)> successors(V node) {
    return _walkable.successors(node).map((target) {
      return (target, _weight(node, target));
    });
  }

  @override
  Iterable<V> get roots => _walkable.roots;
}

final class _LinearWalkable<E> with Walkable<E> {
  _LinearWalkable(Iterable<E> nodes) : this._(List.of(nodes));
  _LinearWalkable._(this._nodes);
  final List<E> _nodes;

  @override
  Iterable<E> successors(E node) {
    final index = _nodes.indexOf(node);
    if (index == -1) {
      return const [];
    }
    return index + 1 < _nodes.length ? [_nodes[index + 1]] : const [];
  }

  @override
  Iterable<E> get roots {
    if (_nodes.isEmpty) {
      return const [];
    }
    if (_nodes.length == 1) {
      return _nodes;
    }
    return _nodes.take(_nodes.length - 1);
  }
}

final class _StarWalkable<E> with Walkable<E> {
  _StarWalkable(Iterable<E> points) : _points = List.of(points);
  final List<E> _points;

  @override
  Iterable<E> successors(E node) {
    return _points.where((point) => point != node);
  }

  @override
  Iterable<E> get roots => _points;
}

final class _UndirectedWalkable<E> with Walkable<E> {
  _UndirectedWalkable(Iterable<(E, E)> edges) : _edges = {} {
    for (final (source, target) in edges) {
      _edges.putIfAbsent(source, () => {}).add(target);
      _edges.putIfAbsent(target, () => {}).add(source);
    }
  }
  final Map<E, Set<E>> _edges;

  @override
  Iterable<E> successors(E node) => _edges[node] ?? const [];

  @override
  Iterable<E> get roots => _edges.keys;
}
