part of '../graph.dart';

/// Visits nodes in a [graph] structure, deepest nodes first, from [start].
///
/// Depth-first traversal is an algorithm for traversing or searching tree
/// or graph data structures. It starts at the tree root (or some arbitrary node
/// of a graph, i.e., the [start] node), and explores as far as possible along
/// each branch before backtracking.
///
/// A depth-first traversal is typically used for:
///
/// - Wander deep into the graph before exploring closer nodes;
/// - In cases where deep branches or cycles are less likely to be found;
///
/// Depth-first traversals typically have lower memory overhead than other
/// algorithms (`O(d)`, where `d` is the depth of the deepest node); consider
/// using [breadthFirst] when a shallower traversal is needed.
///
/// ## Example
///
/// ```dart
/// final graph = Graph<int>();
///
/// graph.addEdge(Edge(1, 2));
/// graph.addEdge(Edge(2, 3));
///
/// final reachable = depthFirst(graph, start: 1);
/// print(reachable); // (1, 3, 2)
/// ```
///
/// {@category Graphs}
Iterable<T> depthFirst<T>(
  WalkableBase<T> graph, {
  required T start,
  Tracer<T>? tracer,
}) {
  return _DfsReachable(graph.asUnweighted(), tracer, start);
}

final class _DfsReachable<E> extends Iterable<E> {
  const _DfsReachable(this._walkable, this._tracer, this._start);

  final Walkable<E> _walkable;
  final Tracer<E>? _tracer;
  final E _start;

  @override
  Iterator<E> get iterator => _DfsIterator(_walkable, _tracer, _start);
}

final class _DfsIterator<E> implements Iterator<E> {
  _DfsIterator(this._walkable, this._tracer, E start) {
    _toSee.add(start);
  }

  final Walkable<E> _walkable;
  final Tracer<E>? _tracer;

  final _toSee = <E>[];
  final _visited = HashSet<E>();

  @override
  late E current;

  @override
  bool moveNext() {
    if (_toSee.isEmpty) {
      return false;
    }
    final next = _toSee.removeLast();
    if (!_visited.add(next)) {
      _tracer?.onSkip(next);
      return moveNext();
    }

    _tracer?.onVisit(next);
    _toSee.addAll(_walkable.successors(next));
    current = next;
    return true;
  }
}
