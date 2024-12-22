part of '../graph.dart';

/// A base interface for walkable collections.
///
/// Most algorithms in this library are implemented in terms of walkable
/// collections, which are collections of values that can be traversed
/// incrementally, but there are two types of walkable collections:
///
/// - [Walkable], which represents nodes _without_ weights.
/// - [WeightedWalkable], which represents nodes _with_ weights.
///
/// This interface provides a common base class for both types of walkable
/// collections, allowing algorithms to be implemented in terms of
/// [WalkableBase] rather than [Walkable] or [WeightedWalkable]
/// specifically if they support both types.
///
/// ## Example
///
/// ```dart
/// // An algorithm that accepts only unweighted walkables.
/// void acceptsOnlyUnweighted(Walkable<String> graph) {}
///
/// // An algorithm that accepts only weighted walkables.
/// void acceptsOnlyWeighted(WeightedWalkable<String, int> graph) {}
///
/// // An algorithm that accepts both unweighted and weighted walkables.
/// void acceptsBoth(WalkableBase<String> graph) {
///   acceptsOnlyUnweighted(graph.asUnweighted());
/// }
/// ```
///
/// {@category Graphs}
abstract interface class WalkableBase<E> {
  /// Each node that is exposed as a root node of the walkable collection.
  ///
  /// A root node is implementation defined, but is typically a node that has
  /// one or more successors, but not necessarily. For example, a graph may
  /// have multiple root nodes, or choose to expose every node in the graph as
  /// a root node, while a tree may have only one root node.
  ///
  /// A collection that has no root nodes is considered empty.
  Iterable<E> get roots;

  /// Returns each distinct node that is a direct successor of the given [node].
  ///
  /// The order of the nodes in the returned iterable is not guaranteed to be
  /// consistent between calls to this method, and the returned iterable may
  /// contain any number of nodes, including zero if [node] has no successors.
  Iterable<void> successors(E node);

  /// Returns `true` if the walkable collection has no nodes.
  ///
  /// This is equivalent to checking if [roots] is empty.
  bool get isEmpty;

  /// Returns `true` if the walkable collection has one or more nodes.
  ///
  /// This is equivalent to checking if [roots] is not empty.
  bool get isNotEmpty;

  /// Returns whether the collection contains an [edge] connecting two nodes.
  bool containsEdge(Edge<E> edge);

  /// Returns whether the collection contains a root node.
  bool containsRoot(E node);

  /// Returns a view of this walkable as an unweighted walkable.
  ///
  /// The view is a [Walkable] where the edges have no associated data,
  /// which can be useful when the edge data is not needed, i.e. for algorithms
  /// that do not require or expect edge data.
  ///
  /// If this walkable is already unweighted, it returns itself.
  Walkable<E> asUnweighted();
}
