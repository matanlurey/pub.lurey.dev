part of '../graph.dart';

/// A mixin and marker interface that that adapts a [Graph] to be undirected.
///
/// This mixin ensures that for every edge added to the graph, the inverse edge
/// is also added, and that for every edge removed from the graph, the inverse
/// edge is also removed.
///
/// This mixin is only applicable to graphs that are not already undirected.
///
/// ## Example
///
/// ```dart
/// final class MyGraph implements Graph<E> { /* ... */ }
/// final class MyUndirectedGraph = MyGraph<E> with UndirectedGraph<E> {}
/// ```
///
/// {@category Graphs}
mixin UndirectedGraph<E> on Graph<E> implements GraphBase<E> {
  @override
  bool addEdge(Edge<E> edge) {
    final a = super.addEdge(edge);
    final b = super.addEdge(edge.reversed);
    assert(a == b, 'Inconsistent undirected edges');
    return a;
  }

  @override
  bool removeEdge(Edge<E> edge) {
    final a = super.removeEdge(edge);
    final b = super.removeEdge(edge.reversed);
    assert(a == b, 'Inconsistent undirected edges');
    return a;
  }

  @override
  bool containsEdge(Edge<E> edge) {
    final a = super.containsEdge(edge);
    assert(
      a == super.containsEdge(edge.reversed),
      'Inconsistent undirected edges',
    );
    return a;
  }
}
