part of '../pathfinding.dart';

/// Counts the total number of paths from [start] to a [goal] in a [walkable].
///
/// There must be no loops in the graph, or a [CycleException] may be thrown.
///
/// ## Example
///
/// On a 8x8 chess board, find total paths from the top-left to bottom-right:
///
/// ```dart
/// final graph = Grid.filled(8, 8, empty: 0, fill: 1);
///
/// final paths = countPaths(
///   graph.asUnweighted(),
///   start: graph.topLeft,
///   goal: Goal.node(graph.bottomRight),
/// );
///
/// print(paths); // 3432
/// ```
///
/// {@category Pathfinding}
int countPaths<T>(
  WalkableBase<T> walkable, {
  required T start,
  required Goal<T> goal,
  Tracer<T>? tracer,
}) {
  return _cachedCountPaths(
    walkable.asUnweighted(),
    start: start,
    goal: goal,
    tracer: tracer,
    cache: HashMap<T, int>(),
  );
}

int _cachedCountPaths<T>(
  Walkable<T> walkable, {
  required T start,
  required Goal<T> goal,
  required Tracer<T>? tracer,
  required HashMap<T, int> cache,
}) {
  if (cache[start] case final int cached) {
    if (cached == 0) {
      throw CycleException<T>(start);
    }
    return cached;
  }

  tracer?.onVisit(start);
  final int count;
  if (goal.success(start)) {
    count = 1;
  } else {
    final paths = walkable.successors(start).map((next) {
      cache[start] = 0;
      return _cachedCountPaths(
        walkable,
        start: next,
        goal: goal,
        tracer: tracer,
        cache: cache,
      );
    });
    count = paths.fold(0, (sum, path) => sum + path);
  }

  cache[start] = count;
  return count;
}
