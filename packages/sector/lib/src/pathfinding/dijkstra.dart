part of '../pathfinding.dart';

/// Pathfinding algorithm that finds the best path in a weighted graph.
///
/// See <https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm> or
/// [Dijkstra].
///
/// {@category Pathfinding}
const dijkstra = Dijkstra<Object?>();

/// Pathfinding algorithm that finds the best path in a weighted graph.
///
/// Dijkstra's algorithm is an algorithm for finding the shortest paths between
/// nodes in a graph, which may represent, for example, road networks, networks
/// of pipes, or tiles on a grid. It starts at a source node and explores
/// branches of the graph along all possible paths as far as necessary,
/// backtracking when it fails to find the goal, _or_ the cost of the path
/// exceeds a previously found path with a lower cost.
///
/// Dijkstra's algorithm is a generalization of the [breadthFirstSearch]
/// algorithm. It is guaranteed to find the shortest path from the source node,
/// but it has a potentially high runtime complexity (`O((V + E) log V)` where
/// `V` is the number of vertices and `E` is the number of edges), as in the
/// worst case it may visit every edge in the graph.
///
/// A default singleton instance of this class is [dijkstra].
///
/// {@category Pathfinding}
final class Dijkstra<E> with BestPathfinder<E> {
  /// Creates a new Dijkstra's algorithm.
  const Dijkstra();

  @override
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    final toSee = FlatQueue()..add(0, 0.0);
    final parents = IndexMap<T, (int, double)>()..[start] = (0, 0.0);

    var check = false;
    int? targetReached;
    while (toSee.isNotEmpty) {
      final (index, cost) = toSee.removeFirst();
      final node = parents.entryAt(index).key;
      tracer?.onVisit(node);
      if (check && goal.success(node)) {
        targetReached = index;
        break;
      }
      check = true;

      for (final (next, moveCost) in graph.successors(node)) {
        if (moveCost >= double.infinity) {
          continue;
        }
        final newCost = cost + moveCost;
        final int indexForSuccessor;
        switch (parents.entryOf(next)) {
          case final AbsentMapEntry<T, (int, double)> e:
            indexForSuccessor = e.index;
            e.setOrUpdate((index, newCost));
          case final PresentMapEntry<T, (int, double)> e:
            if (newCost < e.value.$2) {
              indexForSuccessor = e.index;
              e.setOrUpdate((index, newCost));
            } else {
              // Edge-case: It's a loop back to the same node.
              if (e.key == start && goal.success(start)) {
                // We can't use the primary routine, so let's build a path
                // to the previous ("node") and then add the start node to the
                // path.
                final path = _reversePath(parents, (p) => p.$1, index);
                return (Path(path..add(start)), newCost);
              }
              tracer?.onSkip(next);
              continue;
            }
        }

        toSee.add(indexForSuccessor, newCost);
      }
    }

    var totalCost = double.infinity;
    if (targetReached != null) {
      totalCost = parents.entryAt(targetReached).value.$2;
      final path = _reversePath(parents, (p) => p.$1, targetReached);
      return (Path(path), totalCost);
    }

    return (Path.notFound, totalCost);
  }
}
