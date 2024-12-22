part of '../graph.dart';

/// Partitions nodes reachable in a [graph] into strongly connected components.
///
/// A strongly connected component is a subset of a graph where every node is
/// reachable from every other node in the subset. The function returns a list
/// of strongly connected component sets, containing at last one component (the
/// ones containing [from], if provided, otherwise _all_ root nodes).
///
/// ## Example
///
/// ```dart
/// final graph = Graph<int>();
///
/// graph.addEdge(Edge(1, 2));
/// graph.addEdge(Edge(2, 3));
/// graph.addEdge(Edge(3, 2));
///
/// final components = stronglyConnected(graph, start: 1);
/// print(components); // [[2, 3], [1]]
/// ```
///
/// {@category Graphs}
List<List<T>> stronglyConnected<T>(
  WalkableBase<T> graph, {
  Iterable<T>? from,
  Tracer<T>? tracer,
}) {
  final context = _StronglyConnectedContext<T>(graph.asUnweighted(), tracer);
  from ??= graph.roots;
  for (final root in from) {
    context.preorders[root] = null;
  }
  for (final root in from) {
    context.recurse(root);
  }
  return context.scc;
}

final class _StronglyConnectedContext<T> {
  _StronglyConnectedContext(this.walkable, this.tracer);

  final Walkable<T> walkable;
  final Tracer<T>? tracer;

  final preorders = HashMap<T, int?>();
  final p = <T>[];
  final s = <T>[];
  final scc = <List<T>>[];
  final scca = HashSet<T>(); // cSpell:ignore scca

  var c = 0;

  void recurse(T v) {
    tracer?.onVisit(v);
    preorders[v] = c;
    c += 1;
    s.add(v);
    p.add(v);
    for (final w in walkable.successors(v)) {
      if (!scca.contains(w)) {
        if (preorders[w] case final int pw) {
          while (preorders[p.last]! > pw) {
            p.removeLast();
          }
        } else {
          recurse(w);
        }
      } else {
        tracer?.onSkip(w);
      }
    }
    if (p.last == v) {
      p.removeLast();
      final component = <T>[];
      while (s.isNotEmpty) {
        final node = s.removeLast();
        component.add(node);
        scca.add(node);
        preorders.remove(node);
        if (node == v) {
          break;
        }
      }
      scc.add(component);
    }
  }
}
