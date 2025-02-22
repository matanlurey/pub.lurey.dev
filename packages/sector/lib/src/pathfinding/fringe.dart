// cSpell:ignore flimit fmin

part of '../pathfinding.dart';

/// Pathfinding algorithm that finds an optimal shortest path using a heuristic.
///
/// See <https://en.wikipedia.org/wiki/Fringe_search> or [FringeAstar].
///
/// {@category Pathfinding}
const fringeAstar = FringeAstar<Object?>();

/// Pathfinding algorithm that finds an optimal shortest path using a heuristic.
///
/// Fringe, or a variant of A*, is an informed search algorithm sits in between
/// `IDA*` and [Astar]; it uses a [Heuristic] to estimate the cost to reach the
/// goal from a given node and repeats states in the _fringe_, or _frontier_, of
/// the search space.
///
/// Fringe is considered faster than [Astar] for [Grid]-based pathfinding.
///
/// A default singleton instance of this class is [fringeAstar].
///
/// {@category Pathfinding}
final class FringeAstar<E> with HeuristicPathfinder<E> {
  /// Creates a new Fringe algorithm.
  const FringeAstar();

  @override
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  (Path<T> path, double cost) findBestPathExclusive<T extends E>(
    WeightedWalkable<T> graph,
    T start,
    Goal<T> goal,
    Heuristic<T> heuristic, {
    Tracer<T>? tracer,
  }) {
    final parents = IndexMap<T, (int, double)>()..[start] = (0, 0.0);

    var now = Queue<int>()..add(0);
    var later = Queue<int>();
    var flimit = heuristic.estimateTotalCost(start);
    var check = false;

    while (now.isNotEmpty) {
      var fmin = double.maxFinite;
      while (now.isNotEmpty) {
        final index = now.removeFirst();
        final entry = parents.entryAt(index);
        final node = entry.key;
        final (_, g) = entry.value;
        final f = g + heuristic.estimateTotalCost(node);
        if (f > flimit) {
          fmin = math.min(fmin, f);
          later.addLast(index);
          continue;
        }

        tracer?.onVisit(node);
        if (check && goal.success(node) && node != start) {
          final path = _reversePath(parents, (p) => p.$1, index);
          return (Path(path), g);
        }
        check = true;

        for (final (next, weight) in graph.successors(node)) {
          final gSuccessor = g + weight;
          if (gSuccessor >= double.infinity) {
            continue;
          }
          final int iSuccessor;
          switch (parents.entryOf(next)) {
            case final AbsentMapEntry<T, (int, double)> e:
              iSuccessor = e.index;
              e.setOrUpdate((index, gSuccessor));
            case final PresentMapEntry<T, (int, double)> e:
              final (_, gNext) = e.value;
              if (gSuccessor < gNext) {
                iSuccessor = e.index;
                e.setOrUpdate((index, gSuccessor));
              } else {
                // Edge-case: It's a loop back to the same node.
                if (e.key == start && goal.success(start)) {
                  // We can't use the primary routine, so let's build a path
                  // to the previous ("node") and then add the start node to the
                  // path.
                  final path = _reversePath(parents, (p) => p.$1, index);
                  return (Path(path..add(start)), gSuccessor);
                }
                continue;
              }
          }
          if (!later.remove(iSuccessor)) {
            now.addLast(iSuccessor);
          }
          now.addLast(index);
        }
      }

      // Swap now & later.
      final temp = now;
      now = later;
      later = temp;
      flimit = fmin;
    }

    return (Path.notFound, double.infinity);
  }
}
