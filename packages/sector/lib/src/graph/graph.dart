part of '../graph.dart';

/// A collection of nodes and edges where edges connect exactly two nodes.
///
/// Associated data for each node, [E], is stored in the graph, and edges are
/// represented as a pair of nodes, and have no associated data unless the graph
/// is a [WeightedGraph].
///
/// A graph can be either directed, i.e. an edge has a source and a target node,
/// or undirected, where there is no such distinction, but most algorithms and
/// operations are applicable to both types of graphs.
///
/// {@category Graphs}
abstract base mixin class Graph<E> implements GraphBase<E>, Walkable<E> {
  /// Creates an empty [AdjacencyListGraph].
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory Graph({bool directed = true}) {
    return directed
        ? _AdjacencyListGraph<E>()
        : _UndirectedAdjacencyListGraph<E>();
  }

  /// Creates a [AdjacencyListGraph] graph from a [walkable].
  ///
  /// Each edge in the walkable is added to the graph, similar to calling:
  /// ```dart
  /// final graph = Graph<E>();
  /// graph.addEdges(walkable.edges);
  /// ```
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory Graph.from(WalkableBase<E> walkable, {bool directed}) =
      AdjacencyListGraph<E>.from;

  /// Creates a [AdjacencyListGraph] graph from [edges].
  ///
  /// If [directed] is `true`, which is the default, the graph is directed, i.e.
  /// an edge has an explicit source and a target node. If [directed] is
  /// `false`, the graph is undirected, and the inverse of an edge is also an
  /// edge.
  factory Graph.fromEdges(Iterable<Edge<E>> edges, {bool directed}) =
      AdjacencyListGraph<E>.fromEdges;

  /// Adds an [edge] from to the graph.
  ///
  /// Returns `true` if the edge was added, `false` if it was already present.
  ///
  /// If the edge was added, the graph must:
  /// - Add the edge to the graph so that [containsEdge] returns `true`;
  /// - Yield `target` as a successor of `source` in [successors];
  /// - If `source` has no predecessors, return `true` for [containsRoot];
  ///
  /// In addition, the graph _may_, depending on the implementation:
  /// - Add `source` and `target` to the graph if they are not already present;
  /// - Consider the inverse also an edge, i.e. for undirected graphs.
  bool addEdge(Edge<E> edge);

  /// Adds multiple edges to the graph.
  ///
  /// Equivalent to calling [addEdge] for each edge in [edges], but some
  /// implementations may be able to optimize this operation.
  void addEdges(Iterable<Edge<E>> edges) {
    for (final edge in edges) {
      addEdge(edge);
    }
  }

  @override
  bool removeEdge(Edge<E> edge);

  /// Clears the graph of all nodes and edges.
  ///
  /// After calling this method, the graph is empty.
  void clear();
}
