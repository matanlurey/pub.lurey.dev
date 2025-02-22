part of '../graph.dart';

/// A function that visits [nodes] in a graph structure starting from [start].
///
/// Every algorithm that provides generalizable graph traversals can implement
/// this interface to provide a consistent API for visiting and finding
/// reachable nodes in a graph-like structure (e.g., a graph, tree, or grid,
/// or any [WalkableBase] implementation).
///
/// The exact order, and whether nodes are visited more than once, is
/// algorithm-specific.
///
/// ## Tracing
///
/// {@template sector.Tracer:argument}
/// May provide a [tracer] to capture finer-detail events during the
/// traversal.
///
/// If omitted, no tracing is performed.
/// {@endtemplate}
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
/// print(reachable); // (1, 2, 3)
/// ```
///
/// {@category Graphs}
typedef Crawler<E> =
    Iterable<T> Function<T extends E>(
      WalkableBase<T> nodes, {
      required T start,
      Tracer<T>? tracer,
    });
