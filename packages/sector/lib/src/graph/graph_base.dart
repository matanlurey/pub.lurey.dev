part of '../graph.dart';

/// A base interface for graphs.
///
/// Most algorithms in this library are implemented in terms of graphs, which
/// are collections of nodes and edges, but there are two types of graphs:
///
/// - [Graph], which represents edges _without_ weights.
/// - [WeightedGraph], which represents edges _with_ weights.
///
/// This interface provides a common base class for both types of graphs,
/// allowing algorithms to be implemented in terms of [GraphBase] rather than
/// [Graph] or [WeightedGraph] specifically if they support both types.
///
/// ## Example
///
/// ```dart
/// // An algorithm that accepts only unweighted graphs.
/// void acceptsOnlyUnweighted(Graph<String> graph) {}
///
/// // An algorithm that accepts only weighted graphs.
/// void acceptsOnlyWeighted(WeightedGraph<String, int> graph) {}
///
/// // An algorithm that accepts both unweighted and weighted graphs.
/// void acceptsBoth(GraphBase<String> graph) {
///   acceptsOnlyUnweighted(graph.asUnweighted());
/// }
/// ```
///
/// {@category Graphs}
abstract interface class GraphBase<E> implements WalkableBase<E> {
  /// Removes an [edge] from the graph.
  ///
  /// If the edge was removed, the graph must:
  /// - Remove the edge from the graph so that [containsEdge] returns `false`;
  /// - Remove `target` as a successor of `source` in [successors];
  /// - If `source` has no more successors, return `false` for [containsRoot];
  ///
  /// In addition, the graph _may_, depending on the implementation:
  /// - Remove `source` and `target` from the graph if they have no more edges;
  /// - Remove the inverse edge, i.e. for undirected graphs.
  void removeEdge(Edge<E> edge);
}
