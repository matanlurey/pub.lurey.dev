part of '../pathfinding.dart';

/// Pathfinding algorithm that explores the graph in depth first order.
///
/// See <https://en.wikipedia.org/wiki/Depth-first_search> or
/// [DepthFirstSearch].
///
/// {@category Pathfinding}
const depthFirstSearch = DepthFirstSearch<Object?>();

/// Pathfinding algorithm that explores the graph in depth first order.
///
/// Depth-first search (DFS) is an algorithm for traversing or searching tree or
/// graph data structures. The algorithm starts at the root node and explores as
/// far as possible along each branch before backtracking.
///
/// Depth-first search is often compared to breadth-first search (BFS). The
/// biggest difference between the two is that depth-first search can get
/// "trapped" exploring a suboptimal path, as it will always find the deepest
/// path first. However, it has a lower memory overhead than other algorithms
/// (`O(bd)` where `b` is the branching factor and `d` is the depth of the
/// solution) compared to [BreadthFirstSearch].
///
/// A default singleton instance of this class is [depthFirstSearch].
///
/// {@category Pathfinding}
final class DepthFirstSearch<E> with Pathfinder<E> {
  /// Creates a new depth-first search algorithm.
  const DepthFirstSearch();

  @override
  // Intentionally unsafe variance.
  // ignore: unsafe_variance
  Path<T> findPathExclusive<T extends E>(
    WalkableBase<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    final path = [start];
    if (_recurse(path, graph.asUnweighted(), goal, tracer, check: false)) {
      return Path(path);
    } else {
      return Path.notFound;
    }
  }

  static bool _recurse<T>(
    List<T> path,
    Walkable<T> graph,
    Goal<T> goal,
    Tracer<T>? tracer, {
    bool check = true,
  }) {
    final current = path.last;
    tracer?.onVisit(current);
    if (check && goal.success(current)) {
      return true;
    }
    for (final neighbor in graph.successors(current)) {
      if (path.lastIndexOf(neighbor) >= 0) {
        if (goal.success(neighbor)) {
          // Edge-case: The goal is a successor of itself.
          path.add(neighbor);
          return true;
        }
        tracer?.onSkip(neighbor);
        continue;
      }
      path.add(neighbor);
      if (_recurse(path, graph, goal, tracer)) {
        return true;
      }
      path.removeLast();
    }
    return false;
  }
}
