part of '../graph.dart';

/// Returns a topological sort of the directed edges provided, if one exists.
///
/// The [roots] are the starting nodes of the graph, and [successors] is a
/// function that returns the nodes that are directly accessible from a given
/// node.
///
/// If the graph contains a cycle, a [CycleException] is thrown.
///
/// ## Example
///
/// We will sort integers from 1 to 9, each integer having its two immediate
/// greater numbers as successors, starting with two roots, `5` and `1`:
///
/// ```dart
/// Iterable<int> successors(int vertex) {
///   return switch (vertex) {
///     final n when n <= 7 => [n + 1, n + 2],
///     8 => [9],
///     _ => [],
///   };
/// }
///
/// final sorted = topologicalSort([5, 1], successors);
/// print(sorted); // [1, 2, 3, 4, 5, 6, 7, 8, 9]
/// ```
///
/// {@category Graphs}
List<T> topologicalSort<T>(
  Iterable<T> roots, {
  required Iterable<T> Function(T) successors,
}) {
  // TODO: Add Tracer.
  final stack = [...roots];
  if (stack.isEmpty) {
    return const [];
  }

  final result = ListQueue<T>();
  final marked = HashSet<T>();
  final visited = HashSet<T>();
  do {
    final node = stack.removeLast();
    if (marked.contains(node)) {
      continue;
    }
    if (visited.remove(node)) {
      marked.add(node);
      result.addFirst(node);
    } else {
      visited.add(node);
      stack.add(node);
      for (final next in successors(node)) {
        if (visited.contains(next)) {
          throw CycleException<T>(next);
        }
        stack.add(next);
      }
    }
  } while (stack.isNotEmpty);
  return result.toList();
}
