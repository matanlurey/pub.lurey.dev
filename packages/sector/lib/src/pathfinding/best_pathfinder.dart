part of '../pathfinding.dart';

/// Visits a [WeightedWalkable]'s nodes, finding a best path to a goal node.
///
/// Every algorithm that provides generalizable weighted path finding
/// capabilities can implement this interface to provide a consistent API for
/// finding paths between nodes in a weighted graph-like structure (e.g., a
/// graph, tree, or grid, or any [WeightedWalkable] implementation), or mix-in
/// (`with BestPathfinder`) to derive some default implementations by
/// implementing only [findBestPathExclusive].
///
/// ## Adapting an Unweighted Graph
///
/// It is possible to use a [BestPathfinder] with an _unweighted_ graph by
/// deriving a weight from an edge:
///
/// ```dart
/// // 1.0 -> 3.0 -> 10.0
/// final unweighted = Walkable.linear([1.0, 3.0, 10.0]);
///
/// // The weight is the difference between the nodes.
/// final weighted = unweighted.asWeighted((a, b) => (b - a).abs());
/// ```
///
/// {@category Pathfinding}
mixin BestPathfinder<E> implements PathfinderBase<E> {
  /// Returns an optimal path (and it's total cost) in [graph] from [start] to a
  /// node that satisfies [goal].
  ///
  /// If the initial node satisfies the goal, the path will contain only the
  /// start node, and the cost will be zero. If the path is not found, the total
  /// cost will be [double.infinity].
  ///
  /// {@macro sector.Pathfinder.findPath:return}
  ///
  /// ## Impassable Nodes
  ///
  /// {@template sector.Pathinder.findBestpath:impassable}
  /// There are two ways to represent impassable nodes in a graph:
  ///
  /// - Omit the node from the graph entirely, i.e. no edge leads to it;
  /// - Calculate the weight of the edge to the node as [double.infinity].
  /// {@endtemplate}
  ///
  /// ## Tracing
  ///
  /// {@macro sector.Tracer:argument}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final graph = WeightedWalkable.from({
  ///   'a': [('b', 1.0), ('c', 2.0)],
  ///   'b': [('c', 3.0)],
  ///   'c': [('d', 4.0)],
  /// });
  ///
  /// final (path, cost) = dijkstra.findBestPath(graph, 'a', Goal.node('d'));
  /// print(path); // Path(['a', 'c', 'd'])
  /// print(cost); // 6.0
  /// ```
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  (Path<T> path, double cost) findBestPath<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    if (goal.success(start)) {
      return (Path([start]), 0.0);
    }
    return findBestPathExclusive(graph, start, goal, tracer: tracer);
  }

  /// Returns an optimal path (and it's total cost) in [graph] from [start] to a
  /// node that satisfies [goal].
  ///
  /// Unlike [findBestPath], this method does not check if the goal is
  /// _initially_ satisfied by the start node, although it may be satisfied by
  /// the start node if it is an eventual successor of itself (i.e. a cycle in
  /// the graph).
  ///
  /// If the path is not found, the total cost will be [double.infinity].
  ///
  /// {@macro sector.Pathfinder.findPath:return}
  ///
  /// ## Impassable Nodes
  ///
  /// {@macro sector.Pathinder.findBestpath:impassable}
  ///
  /// ## Tracing
  ///
  /// {@macro sector.Tracer:argument}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final graph = WeightedWalkable.from({
  ///   'a': [('b', 1.0), ('c', 2.0)],
  ///   'b': [('c', 3.0)],
  ///   'c': [('a', 4.0)],
  /// });
  ///
  /// final (immediate, _) = bestFirst.findBestPath(graph, 'a', Goal.node('a'));
  /// print(immediate); // Path(['a'])
  ///
  /// final (cycle, _) = bestFirst.findBestPathExclusive(graph, 'a', Goal.node('a'));
  /// print(cycle); // Path(['a', 'c', 'a'])
  /// ```
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  });
}
