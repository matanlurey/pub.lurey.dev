part of '../pathfinding.dart';

/// Visits a [Walkable]'s node, finding one or more paths to a goal node.
///
/// Every algorithm that provides generalizable path finding capabilities can
/// implement this interface to provide a consistent API for finding paths
/// between nodes in a graph-like structure (e.g., a graph, tree, or grid, or
/// any [Walkable] implementation), or mix-in (`with Pathfinder`) to derive some
/// default implementations by implementing only [findPathExclusive].
///
/// {@category Pathfinding}
mixin Pathfinder<E> implements PathfinderBase<E> {
  /// Returns a path in [graph] from [start] to a node that satisfies [goal].
  ///
  /// {@template sector.Pathfinder.findPath:return}
  /// If no path can be found, [Path.notFound] is returned.
  ///
  /// A node will never be included in the path more than once, as determined
  /// by [Object.==] on the node, unless the source node is also a successor of
  /// itself, in which case it will be included twice (once at the beginning
  /// and once at the end), otherwise it will only be included at the start.
  /// {@endtemplate}
  ///
  /// ## Tracing
  ///
  /// {@macro sector.Tracer:argument}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final graph = Walkable.linear([1, 2, 3]);
  ///
  /// final path = depthFirst.findPath(graph, 1, Goal.node(3));
  /// print(path); // Path([1, 2, 3])
  /// ```
  Path<T> findPath<T extends E>(
    WalkableBase<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    if (goal.success(start)) {
      return Path([start]);
    }
    return findPathExclusive(graph, start, goal, tracer: tracer);
  }

  /// Returns a path in [graph] from [start] to a node that satisfies [goal].
  ///
  /// Unlike [findPath], this method does not check if the goal is _initially_
  /// satisfied by the start node, although it may be satisfied by the start
  /// node if it is an eventual successor of itself (i.e. a cycle in the graph).
  ///
  /// {@macro sector.Pathfinder.findPath:return}
  ///
  /// ## Tracing
  ///
  /// {@macro sector.Tracer:argument}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final graph = Graph<int>();
  /// graph.addEdge(1, 2);
  /// graph.addEdge(2, 1);
  ///
  /// final immediate = depthFirst.findPath(graph, 1, Goal.node(1));
  /// print(immediate); // Path([1])
  ///
  /// final cycle = depthFirst.findPathExclusive(graph, 1, Goal.node(1));
  /// print(cycle); // Path([1, 2, 1])
  /// ```
  Path<T> findPathExclusive<T extends E>(
    WalkableBase<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  });
}
