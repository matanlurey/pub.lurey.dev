part of '../graph.dart';

/// An _unweighted_ graph suitable for sparse graphs.
///
/// The adjacency list representation of a graph is a collection of lists, one
/// for each node in the graph. Each list contains the nodes that are adjacent
/// to the node that the list represents, and is associated with the node with
/// a hash table.
///
/// _Implicitly_ adds and removes nodes as edges are added and removed,
/// respectively. A node is considered to be in the graph if it is present in
/// the adjacency list of another node _or_ if it has one or more edges
/// originating from it:
///
/// ```dart
/// final graph = AdjacencyListGraph<String>();
///
/// graph.addEdge(Edge('a', 'b'));
/// graph.addEdge(Edge('b', 'c'));
/// print(graph.roots); // ['a']
/// print(graph.isEmpty); // false
///
/// graph.removeEdge(Edge('a', 'b'));
/// print(graph.roots); // []
/// print(graph.isEmpty); // true
/// ```
///
/// ## Performance
///
/// The adjacency list representation is ideal for sparse graphs, where the
/// number of edges is much smaller than the number of nodes, or small overall;
/// in this case, the adjacency list representation can be more memory efficient
/// than other representations.
///
/// Operation      | Time Complexity
/// -------------- | ---------------
/// `containsEdge` | O(1)
/// `containsRoot` | O(n)
/// `addEdge`      | O(1)
/// `removeEdge`   | O(m)[^1]
/// `edges`        | O(n + m)
///
/// [^1]: Where `m` is the number of edges in the source node.
///
/// {@category Graphs}
abstract final class AdjacencyListGraph<E> with Walkable<E>, Graph<E> {
  /// Creates an empty adjacency list graph.
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory AdjacencyListGraph({bool directed = true}) {
    return directed
        ? _AdjacencyListGraph<E>()
        : _UndirectedAdjacencyListGraph<E>();
  }

  /// Creates an adjacency list graph from a [walkable].
  ///
  /// Each edge in the walkable is added to the graph, similar to calling:
  /// ```dart
  /// final graph = AdjacencyListGraph<E>();
  /// graph.addEdges(walkable.edges);
  /// ```
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory AdjacencyListGraph.from(
    WalkableBase<E> walkable, {
    bool directed = true,
  }) {
    return AdjacencyListGraph.fromEdges(
      walkable.asUnweighted().edges,
      directed: directed,
    );
  }

  /// Creates an adjacency list graph from [edges].
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory AdjacencyListGraph.fromEdges(
    Iterable<Edge<E>> edges, {
    bool directed = true,
  }) {
    final graph = AdjacencyListGraph<E>(directed: directed);
    graph.addEdges(edges);
    return graph;
  }

  const AdjacencyListGraph._();
}

final class _AdjacencyListGraph<E> extends AdjacencyListGraph<E> {
  _AdjacencyListGraph() : super._();
  final _edges = IndexMap<E, List<E>>();

  @override
  bool addEdge(Edge<E> edge) {
    final targets = _edges[edge.source] ??= [];
    for (final node in targets) {
      if (node == edge.target) return false;
    }
    targets.add(edge.target);
    return true;
  }

  @override
  bool containsEdge(Edge<E> edge) {
    final targets = _edges[edge.source];
    if (targets == null) return false;
    return targets.contains(edge.target);
  }

  @override
  Iterable<Edge<E>> get edges {
    return _edges.entries.expand((entry) {
      final source = entry.key;
      return entry.value.map((target) => Edge(source, target));
    });
  }

  @override
  void clear() {
    _edges.clear();
  }

  @override
  bool removeEdge(Edge<E> edge) {
    final targets = _edges[edge.source];
    if (targets == null) return false;
    if (targets.remove(edge.target)) {
      if (targets.isEmpty) {
        _edges.remove(edge.source);
      }
      return true;
    }
    return false;
  }

  @override
  bool containsRoot(E node) => _edges.containsKey(node);

  @override
  Iterable<E> get roots => _edges.keys;

  @override
  Iterable<E> successors(E node) => _edges[node] ?? const [];
}

final class _UndirectedAdjacencyListGraph<E> = _AdjacencyListGraph<E>
    with UndirectedGraph;
