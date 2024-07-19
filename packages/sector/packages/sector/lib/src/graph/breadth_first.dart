part of '../graph.dart';

/// Visits nodes in a [graph] structure, shallowest nodes first, from [start].
///
/// Breadth-first traversal is an algorithm for traversing or searching tree
/// or graph data structures. It starts at the tree root (or some arbitrary node
/// of a graph, i.e., the [start] node), and explores all of the neighbor nodes
/// at the _present depth_ prior to moving on to the nodes at the _next depth
/// level_.
///
/// A breath-first traversal is typically used for:
///
/// - Analyze the levels of connectedness between nodes;
/// - Visit all reachable nodes in a connected component;
/// - Early termination of search when the goal is close to the start node.
///
/// Breadth-first traversals typically have higher memory overhead than other
/// algorithms (`O(b^d)`, where `b` is the branching factor and `d` is the depth
/// of the shallowest goal); consider using [depthFirst] for memory-constrained
/// environments.
///
/// ## Example
///
/// ```dart
/// final graph = Graph<int>();
///
/// graph.addEdge(Edge(1, 2));
/// graph.addEdge(Edge(2, 3));
///
/// final reachable = breadthFirst(graph, start: 1);
/// print(reachable); // (1, 2, 3)
/// ```
///
/// {@category Graphs}
Iterable<T> breadthFirst<T>(
  WalkableBase<T> graph, {
  required T start,
  Tracer<T>? tracer,
}) {
  return _BfsReachable(graph.asUnweighted(), tracer, start);
}

final class _BfsReachable<E> extends Iterable<E> {
  const _BfsReachable(this._walkable, this._tracer, this._start);

  final Walkable<E> _walkable;
  final Tracer<E>? _tracer;
  final E _start;

  @override
  Iterator<E> get iterator => _BfsIterator(_walkable, _tracer, _start);
}

final class _BfsIterator<E> implements Iterator<E> {
  _BfsIterator(this._walkable, this._tracer, E start) {
    _visited.add(start);
  }

  final Walkable<E> _walkable;
  final Tracer<E>? _tracer;

  final _visited = IndexSet<E>();
  var _i = -1;

  @override
  late E current;

  @override
  bool moveNext() {
    if (_visited.length - 1 < ++_i) {
      return false;
    }
    final node = _visited[_i];
    current = node;
    _tracer?.onVisit(node);
    for (final next in _walkable.successors(node)) {
      if (!_visited.add(next)) {
        _tracer?.onSkip(next);
      }
    }
    return true;
  }
}
