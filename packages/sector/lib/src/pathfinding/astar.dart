part of '../pathfinding.dart';

/// Pathfinding algorithm that finds an optimal shortest path using a heuristic.
///
/// See <https://en.wikipedia.org/wiki/A*_search_algorithm> or [Astar].
///
/// {@category Pathfinding}
const astar = Astar<Object?>();

/// Pathfinding algorithm that finds an optimal shortest path using a heuristic.
///
/// A* is an informed search algorithm that uses a [Heuristic] to estimate the
/// cost to reach the goal from a given node. It always chooses the node that
/// has the lowest total cost, which is the sum of the actual cost of reaching
/// the node from the start and the estimated cost to reach the goal from the
/// node.
///
/// A* is guaranteed to find the shortest path, but it is slower than greedy
/// best-first search, as it considers the actual cost of reaching the goal from
/// the current node.
///
/// A default singleton instance of this class is [astar].
///
/// {@category Pathfinding}
final class Astar<E> with HeuristicPathfinder<E> {
  /// Creates a new A* algorithm.
  const Astar();

  @override
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal,
    Heuristic<T> heuristic, {
    Tracer<T>? tracer,
  }) {
    final toSee = FlatQueue()..add(0, 0.0);
    final parents = IndexMap<T, (int, double)>()..[start] = (0, 0.0);

    var check = false;
    while (toSee.isNotEmpty) {
      final (minIndex, minCost) = toSee.removeFirst();
      final entry = parents.entryAt(minIndex);
      final node = entry.key;
      if (check && goal.success(node)) {
        tracer?.onVisit(node);
        final path = _reversePath(parents, (p) => p.$1, minIndex);
        return (Path(path), minCost);
      }
      check = true;

      final (_, c) = entry.value;
      if (c > minCost) {
        tracer?.onSkip(node);
        continue;
      }

      tracer?.onVisit(node);
      for (final (next, weight) in graph.successors(node)) {
        if (weight >= double.infinity) {
          continue;
        }

        final newCost = c + weight;
        final int indexForSuccessor;
        final double heuristicForSuccessor;
        switch (parents.entryOf(next)) {
          case final AbsentMapEntry<T, (int, double)> e:
            indexForSuccessor = e.index;
            heuristicForSuccessor = heuristic.estimateTotalCost(next);
            e.setOrUpdate((minIndex, newCost));
          case final PresentMapEntry<T, (int, double)> e:
            if (e.value.$2 > newCost) {
              indexForSuccessor = e.index;
              heuristicForSuccessor = heuristic.estimateTotalCost(next);
              e.setOrUpdate((minIndex, newCost));
            } else {
              // Edge-case: It's a loop back to the same node.
              if (e.key == start && goal.success(start)) {
                // We can't use the primary routine, so let's build a path
                // to the previous ("node") and then add the start node to the
                // path.
                final path = _reversePath(parents, (p) => p.$1, minIndex);
                return (Path(path..add(start)), newCost);
              }
              tracer?.onSkip(next);
              continue;
            }
        }

        toSee.add(indexForSuccessor, newCost + heuristicForSuccessor);
      }
    }

    return (Path.notFound, double.infinity);
  }
}
