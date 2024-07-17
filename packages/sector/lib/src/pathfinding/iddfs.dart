part of '../pathfinding.dart';

/// Pathfinding algorithm that explores the graph in iterative deepening depth.
///
/// See <https://en.wikipedia.org/wiki/Iterative_deepening_depth-first_search>
/// or [IterativeDepthFirstSearch].
///
/// {@category Pathfinding}
const iterativeDepthFirstSearch = IterativeDepthFirstSearch<Object?>();

/// Pathfinding algorithm that explores the graph in iterative deepening depth.
///
/// Iterative deepening depth-first search ([IDDFS][]) is a state space search
/// strategy in which a depth-limited search is run repeatedly with increasing
/// depth limits until the goal is found. It combines the benefits of
/// depth-first search and breadth-first search.
///
/// A default singleton instance of this class is [iterativeDepthFirstSearch].
///
/// [IDDFS]: https://en.wikipedia.org/wiki/Iterative_deepening_depth-first_search
///
/// {@category Pathfinding}
final class IterativeDepthFirstSearch<E> with Pathfinder<E> {
  /// Creates a new iterative deepening depth-first search algorithm.
  const IterativeDepthFirstSearch();

  @override
  Path<T> findPathExclusive<T extends E>(
    WalkableBase<T> graph,
    T start,
    Goal<T> goal, {
    Tracer<T>? tracer,
  }) {
    final path = [start];
    var maxDepth = 1;
    while (true) {
      final result = _depthStep(
        path,
        graph.asUnweighted(),
        goal,
        tracer,
        depth: maxDepth,
        check: false,
      );
      switch (result) {
        case _Iddfs.foundOptimum:
          return Path(path);
        case _Iddfs.impossible:
          return Path.notFound;
        case _Iddfs.noneAtThisDepth:
          maxDepth += 1;
      }
    }
  }

  static _Iddfs _depthStep<T>(
    List<T> path,
    Walkable<T> graph,
    Goal<T> goal,
    Tracer<T>? tracer, {
    required int depth,
    bool check = true,
  }) {
    if (depth == 0) {
      return _Iddfs.noneAtThisDepth;
    }
    final current = path.last;
    tracer?.onVisit(current);
    if (check && goal.success(current)) {
      return _Iddfs.foundOptimum;
    }
    var bestResult = _Iddfs.impossible;
    for (final next in graph.successors(current)) {
      if (path.lastIndexOf(next) >= 0) {
        // Edge-case: The goal is a successor of itself.
        if (goal.success(next)) {
          path.add(next);
          return _Iddfs.foundOptimum;
        }
        tracer?.onSkip(next);
        continue;
      }
      path.add(next);
      final result = _depthStep(
        path,
        graph,
        goal,
        tracer,
        depth: depth - 1,
      );
      if (result == _Iddfs.foundOptimum) {
        return _Iddfs.foundOptimum;
      }
      if (result == _Iddfs.noneAtThisDepth) {
        bestResult = _Iddfs.noneAtThisDepth;
      }
      path.removeLast();
    }
    return bestResult;
  }
}

enum _Iddfs {
  foundOptimum,
  impossible,
  noneAtThisDepth,
}
