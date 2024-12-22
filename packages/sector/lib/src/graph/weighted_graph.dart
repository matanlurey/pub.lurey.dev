part of '../graph.dart';

/// A graph where edges have an associated weight, or "cost", a [double] value.
///
/// The weight of an edge is a value associated with the edge that can be used
/// to determine the cost of traversing the edge, or to determine the shortest
/// path between two nodes.
///
/// A graph can be either directed, i.e. an edge has a source and a target node,
/// or undirected, where there is no such distinction, but most algorithms and
/// operations are applicable to both types of graphs.
///
/// {@category Graphs}
abstract mixin class WeightedGraph<V> implements WeightedWalkable<V> {
  /// Adds an [edge] from `source` to `target` with a `weight` to the graph.
  ///
  /// Returns the previous weight of the edge, or `null` if the edge was not
  /// present.
  ///
  /// If the edge was added, the graph must:
  /// - Add the edge to the graph so that [containsEdge] returns `true`;
  /// - Yield `target` as a successor of `source` in [successors];
  /// - If `source` has no predecessors, return `true` for [containsRoot];
  ///
  /// In addition, the graph _may_, depending on the implementation:
  /// - Add `source` and `target` to the graph if they are not already present;
  /// - Consider the inverse also an edge, i.e. for undirected graphs.
  double? addEdge(WeightedGraph<V> edge);

  /// Adds multiple edges to the graph.
  ///
  /// Equivalent to calling [addEdge] for each edge in [edges], but some
  /// implementations may be able to optimize this operation.
  void addEdges(Iterable<WeightedEdge<V>> edges);

  /// Returns the value at [edge] or `null` if it does not exist.
  double? getEdge(Edge<V> edge);

  /// Removes an [edge] from `source` to `target` with a `weight` to the graph.
  ///
  /// Returns the weight of the edge, or `null` if the edge was not present.
  ///
  /// If the edge was removed, the graph must:
  /// - Remove the edge from the graph so that [containsEdge] returns `false`;
  /// - Remove `target` as a successor of `source` in [successors];
  /// - If `source` has no more successors, return `false` for [containsRoot];
  ///
  /// In addition, the graph _may_, depending on the implementation:
  /// - Remove `source` and `target` from the graph if they have no more edges;
  /// - Remove the inverse edge, i.e. for undirected graphs.
  double? removeEdge(Edge<V> edge);

  /// Clears the graph of all nodes and edges.
  ///
  /// After calling this method, the graph is empty.
  void clear();
}
