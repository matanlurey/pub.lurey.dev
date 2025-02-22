part of '../pathfinding.dart';

/// Pathfinding algorithm that search the shallowest nodes in a graph first.
///
/// See <https://en.wikipedia.org/wiki/Breadth-first_search> or
/// [BreadthFirstSearch].
///
/// {@category Pathfinding}
const breadthFirstSearch = BreadthFirstSearch<Object?>();

/// Pathfinding algorithm that search the shallowest nodes in a graph first.
///
/// Breadth-first search (BFS) is an algorithm for traversing or searching tree
/// or graph data structures. It starts at the tree root (or some arbitrary node
/// of a graph), and explores all of the neighbor nodes at the present depth
/// prior to moving on to the nodes at the next depth level.
///
/// Breadth-first search's main use case compared to other unweighted algorithms
/// is that it never gets "trapped" exploring a suboptimal path, as it will
/// always find the shortest path first. However, it has a higher memory
/// overhead than other algorithms (`O(b^d)` where `b` is the branching factor
/// and `d` is the depth of the solution) compared to [DepthFirstSearch].
///
/// A default singleton instance of this class is [breadthFirstSearch].
///
/// {@category Pathfinding}
final class BreadthFirstSearch<E> with Pathfinder<E> {
  /// Creates a new breadth-first search algorithm.
  const BreadthFirstSearch();

  @override
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  Path<T> findPathExclusive<T extends E>(
    WalkableBase<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    // The frontier is a queue of nodes to visit, starting with the start node.
    final search = graph.asUnweighted();
    final parents = IndexMap<T, int>()..[start] = -1;

    // Which node we are currently visiting.
    var i = 0;

    do {
      final node = parents.entryAt(i);
      tracer?.onVisit(node.key);
      for (final successor in search.successors(node.key)) {
        if (goal.success(successor)) {
          final path = _reversePath(parents, (p) => p, i);
          path.add(successor);
          return Path(path);
        }
        final next = parents.entryOf(successor);
        if (next.isAbsent) {
          next.setOrUpdate(i);
        }
      }
      i += 1;
    } while (i < parents.length);

    return Path.notFound;
  }
}
