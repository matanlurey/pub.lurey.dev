part of '../pathfinding.dart';

/// Pathfinding algorithm that chooses the locally optimal path at each step.
///
/// See <https://en.wikipedia.org/wiki/Best-first_search> or
/// [GreedyBestFirstSearch].
///
/// {@category Pathfinding}
const greedyBestFirstSearch = GreedyBestFirstSearch<Object?>();

/// Pathfinding algorithm that chooses the locally optimal path at each step.
///
/// Greedy best-first search is an informed search algorithm that uses a
/// [Heuristic] to estimate the cost to reach the goal from a given node. It
/// always chooses the node that is closest to the goal, but does not guarantee
/// that the path is the shortest.
///
/// Greedy best-first search is not guaranteed to find the shortest path, but
/// it is faster than A* and Dijkstra's algorithm, as it does not consider the
/// actual cost of reaching the goal from the current node.
///
/// A default singleton instance of this class is [greedyBestFirstSearch].
///
/// {@category Pathfinding}
final class GreedyBestFirstSearch<E> with HeuristicPathfinder<E> {
  /// Creates a new Greedy Best-First Search algorithm.
  const GreedyBestFirstSearch();

  @override
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal,
    Heuristic<T> heuristic, {
    Tracer<T>? tracer,
  }) {
    final initialNode = start;
    final path = <T>[];
    final visited = HashSet<T>();
    var totalCost = 0.0;

    while (true) {
      // Edge-case: Don't revisit the initial node unless it's the goal.
      if (path.length == 1 && !goal.success(initialNode)) {
        visited.add(initialNode);
      }
      final neighbors = [
        for (final next in graph.successors(start))
          if (next.$2 < double.infinity)
            (
              next.$1,
              next.$2,
              heuristic.estimateTotalCost(next.$1),
            ),
      ];
      if (neighbors.isEmpty) {
        break;
      }

      // Find the neighbor with the lowest estimated cost.
      neighbors.sort((a, b) => a.$3.compareTo(b.$3));

      double? nextWeight;
      for (final (next, weight, heuristic) in neighbors) {
        if (!visited.add(next)) {
          tracer?.onSkip(next);
          continue;
        }

        path.add(start);
        tracer?.onVisit(start);

        start = next;
        nextWeight = weight;
        tracer?.pushScalar(TraceKey.heuristic, heuristic);
        break;
      }

      if (nextWeight == null) {
        break;
      }
      totalCost += nextWeight;
      if (goal.success(start)) {
        path.add(start);
        return (Path(path), totalCost);
      }
    }

    return (Path.notFound, double.infinity);
  }
}
