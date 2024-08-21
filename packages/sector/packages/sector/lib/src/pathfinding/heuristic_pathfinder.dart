part of '../pathfinding.dart';

/// Visits a [WeightedWalkable]'s nodes, finding a best path to a goal node.
///
/// Every algorithm that provides generalizable weighted path finding using
/// heuristics can implement this interface to provide a consistent API for
/// finding paths between nodes in a weighted graph-like structure (e.g., a
/// graph, tree, or grid, or any [WeightedWalkable] implementation), or mix-in
/// (`with HeuristicPathfinder`) to derive some default implementations by
/// implementing only [findBestPathExclusive].
///
/// ## Adapting to a [BestPathfinder]
///
/// [HeuristicPathfinder] is a specialization of [BestPathfinder] that uses a
/// heuristic to guide the search for the best path, but as a result does not
/// share the same type signature, as their are scenarios where it would be
/// impossible to _derive_ a heuristic, i.e. a non-target node:
///
/// ```dart
/// // How would you derive a heuristic for this without specific code?
/// final goal = Goal.test((node) => node == node.terrain == Tile.water);
/// ```
///
/// However, if you can guarantee that a heuristic can be derived, or have
/// fallbacks for when it cannot, you can use [HeuristicPathfinder] as a
/// [BestPathfinder]:
///
/// ```dart
/// // Adapt A* to a BestPathfinder.
/// //
/// // When a `Goal.node` is used, `toNode` is used to derive the heuristic,
/// // otherwise `orElse` is used. You should consider creating a sealed class
/// // for your set of heuristics so pattern matching can be used.
/// final adapted = astar.asBestPathfinder(
///   toNode: (target) => GridHeuristic.manhattan(target),
///   orElse: (start, goal) => Heuristic.zero(),
/// );
/// ```
///
/// {@category Pathfinding}
mixin HeuristicPathfinder<E> implements PathfinderBase<E> {
  /// Returns an optimal path (and it's total cost) in [graph] from [start] to a
  /// node that satisfies [goal].
  ///
  /// If the initial node satisfies the goal, the path will contain only the
  /// start node, and the cost will be zero. If the path is not found, the total
  /// cost will be [double.infinity].
  ///
  /// {@template sector.HeuristicPathfinder:findBestPath:heuristic}
  /// The [heuristic] is used to estimate the cost of reaching the goal from a
  /// given node. The heuristic should be admissible, i.e., it should never
  /// overestimate the cost of reaching the goal from the current node; see
  /// [Heuristic] for more information.
  /// {@endtemplate}
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
  ///   'c': [('d', 4.0)],
  /// });
  ///
  /// final (path, cost) = astar.findBestPath(graph, 'a', Goal.node('d'));
  /// print(path); // Path(['a', 'c', 'd'])
  /// print(cost); // 6.0
  /// ```
  (Path<T> path, double cost) findBestPath<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal,
    Heuristic<T> heuristic, {
    Tracer<T>? tracer,
  }) {
    if (goal.success(start)) {
      return (Path([start]), 0.0);
    }
    return findBestPathExclusive(
      graph,
      start,
      goal,
      heuristic,
      tracer: tracer,
    );
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
  /// final (path, cost) = astar.findBestPathExclusive(graph, 'a', Goal.node('d'));
  /// print(path); // Path(['a', 'c', 'd'])
  /// print(cost); // 6.0
  /// ```
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal,
    Heuristic<T> heuristic, {
    Tracer<T>? tracer,
  });

  /// Adapts this [HeuristicPathfinder] to a [BestPathfinder].
  ///
  /// When a [Goal.node] is used, [toNode] is used to derive the heuristic,
  /// otherwise [orElse] is used. You should consider creating a sealed class
  /// for your set of heuristics so pattern matching can be used.
  ///
  /// ## Example
  ///
  /// ```dart
  /// sealed class MyGoal implements Goal<MyNode> {
  ///   const MyGoal();
  /// }
  ///
  /// final adapted = astar.asBestPathfinder(
  ///   toNode: <T>(target) => toHeuristic(target),
  ///   orElse: <T>(start, goal) => switch (goal) {
  ///     TileTypeGoal t => doSomethingElse(t),
  ///     _ => Heuristic.zero(),
  ///   },
  /// );
  /// ```
  BestPathfinder<E> asBestPathfinder<G extends Goal<E>>({
    required Heuristic<T> Function<T extends E>(E) toNode,
    required Heuristic<T> Function<T extends E>(E, G) orElse,
  }) {
    return _AsBestPathfinder(this, toNode, orElse);
  }
}

final class _AsBestPathfinder<E, G extends Goal<E>> with BestPathfinder<E> {
  const _AsBestPathfinder(
    this._pathfinder,
    this._toNode,
    this._orElse,
  );

  final HeuristicPathfinder<E> _pathfinder;
  final Heuristic<T> Function<T extends E>(E) _toNode;
  final Heuristic<T> Function<T extends E>(E, G) _orElse;

  @override
  (Path<T>, double) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    final heuristic = switch (goal) {
      _NodeGoal<T>(:final node) => _toNode<T>(node),
      _ => _orElse<T>(start, goal as G),
    };
    return _pathfinder.findBestPathExclusive(
      graph,
      start,
      goal,
      heuristic,
      tracer: tracer,
    );
  }
}
