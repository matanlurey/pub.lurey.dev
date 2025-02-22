part of '../graph.dart';

/// A collection of nodes and edges that can be traversed incrementally.
///
/// The nodes of the walkable collection are accessed by calling the
/// [successors] method with a source vertex as an argument, which returns an
/// [Iterable] of vertices and their respective weights that are accessible from
/// the source node.
///
/// The [WeightedWalkable] declaration provides a default implementation,
/// which can be extended or mixed-in to implement the [WeightedWalkable]
/// interface. It implements every member other than [successors] and [roots].
/// An implementation of [WeightedWalkable] should provide a more efficient
/// implementation of members of `WeightedWalkable` when it can do so.
///
/// ## Adapting
///
/// ## Example
///
/// Here is a sample implementation of a weighted graph using pattern matching:
///
/// ```dart
/// final class AbcGraph with WeightedWalkable<String> {
///   @override
///   Iterable<(String, int)> successors(String node) {
///     return switch (node) {
///       'a' => const [('b', 1), ('c', 2)],
///       'b' => const [('c', 3)],
///       'c' => const [('d', 4)],
///       _ => const [],
///     };
///   }
///
///   @override
///   Iterable<String> get roots => ['a', 'b', 'c'];
/// }
///
/// void main() {
///   final graph = AbcGraph();
///   print(graph.successors('a')); // [('b', 1), ('c', 2.0)]
///   print(graph.roots); // ['a', 'b', 'c']
/// }
/// ```
///
/// {@category Graphs}
abstract mixin class WeightedWalkable<E> implements WalkableBase<E> {
  /// Creates an empty weighted walkable.
  ///
  /// The empty walkable has no nodes and no edges.
  const factory WeightedWalkable.empty() = _EmptyWeightedWalkable<E>;

  /// Creates a walkable from a map of source nodes to target nodes and weights.
  ///
  /// The resulting walkable is lazy, and is generally inefficient for
  /// operations outside of iterating [edges]. This is a convenience method for
  /// creating a walkable from a collection of edges, i.e. in a test case.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final walkable = WeightedWalkable.fromEdges({
  ///   'a': [('b', 1)],
  ///   'b': [('c', 2)],
  ///   'c': [('d', 3)],
  /// });
  /// print(walkable.edges); // {a -> b (1.0), b -> c (2.0), c -> d (3.0)}
  /// ```
  const factory WeightedWalkable.from(Map<E, Iterable<(E, double)>> edges) =
      _EdgesWeightedWalkable<E, double>;

  /// Creates a weighted walkable which generates successors dynamically.
  ///
  /// The [successors] function is called whenever a node is accessed, and the
  /// [roots] function is called whenever the roots are accessed. This allows
  /// for lazy generation of nodes and edges.
  const factory WeightedWalkable.generate({
    required Iterable<(E, double)> Function(E node) successors,
    required Iterable<E> Function() roots,
  }) = _GeneratedWeightedWalkable<E>;

  @override
  Iterable<(E, double)> successors(E node);

  @override
  bool get isEmpty => roots.isEmpty;

  @override
  bool get isNotEmpty => roots.isNotEmpty;

  @override
  bool containsEdge(Edge<E> edge) {
    for (final (node, _) in successors(edge.source)) {
      if (node == edge.target) return true;
    }
    return false;
  }

  @override
  bool containsRoot(E node) => roots.contains(node);

  /// Each edge in the collection.
  Iterable<WeightedEdge<E>> get edges {
    return roots.expand((vertex) {
      return successors(vertex).map((pair) {
        return WeightedEdge(vertex, pair.$1, pair.$2);
      });
    });
  }

  @override
  Walkable<E> asUnweighted() => _AsUnweightedWalkable(this);

  /// Converts a [WeightedWalkable] to a string like [toString].
  ///
  /// Allows using other delimiters than `{` and `}`.
  static String weightedWalkableToString(
    WeightedWalkable<Object?> walkable, [
    String start = '{',
    String end = '}',
  ]) {
    final buffer = StringBuffer(start);
    if (walkable.isEmpty) {
      buffer.write(end);
      return buffer.toString();
    }
    buffer.writeln();
    for (final source in walkable.roots) {
      buffer.write('  $source -> ');
      buffer.writeAll(
        walkable.successors(source).map((pair) {
          return '${pair.$1} <${pair.$2}>';
        }),
        ', ',
      );
      buffer.writeln();
    }
    buffer.write(end);
    return buffer.toString();
  }

  /// Returns a string representation of (some of) the nodes of `this`.
  ///
  /// Nodes and edges are represented by their own [Object.toString] results.
  @override
  String toString() => weightedWalkableToString(this);
}

/// A weighted graph edge connecting two nodes.
///
/// In [UndirectedGraph]s, the edge is an unordered pair of nodes.
///
/// {@category Graphs}
@immutable
final class WeightedEdge<V> extends Edge<V> {
  /// Creates a new weighted edge from [source] to [target] with a [weight].
  const WeightedEdge(super.source, super.target, this.weight);

  /// The weight of the edge.
  final double weight;

  @override
  bool operator ==(Object other) {
    return other is WeightedEdge<V> &&
        source == other.source &&
        target == other.target &&
        weight == other.weight;
  }

  @override
  int get hashCode => Object.hash(source, target, weight);

  /// The edge with the source and target nodes reversed.
  ///
  /// Not guaranteed to be valid in all graph types.
  @override
  WeightedEdge<V> get reversed => WeightedEdge(target, source, weight);

  @override
  String toString() => '$source -> $target <$weight>';
}

final class _EmptyWeightedWalkable<V> with WeightedWalkable<V> {
  const _EmptyWeightedWalkable();

  @override
  Iterable<(V, double)> successors(V node) => const [];

  @override
  Iterable<V> get roots => const [];
}

final class _EdgesWeightedWalkable<V, E> with WeightedWalkable<V> {
  const _EdgesWeightedWalkable(this._edges);
  final Map<V, Iterable<(V, double)>> _edges;

  @override
  Iterable<(V, double)> successors(V node) {
    return _edges[node] ?? const [];
  }

  @override
  Iterable<V> get roots {
    return _edges.keys;
  }
}

final class _GeneratedWeightedWalkable<V> with WeightedWalkable<V> {
  const _GeneratedWeightedWalkable({
    required Iterable<(V, double)> Function(V node) successors,
    required Iterable<V> Function() roots,
  }) : _successors = successors,
       _roots = roots;

  // Only accessed in `this`.
  // ignore: unsafe_variance
  final Iterable<(V, double)> Function(V node) _successors;
  final Iterable<V> Function() _roots;

  @override
  Iterable<(V, double)> successors(V node) => _successors(node);

  @override
  Iterable<V> get roots => _roots();
}

final class _AsUnweightedWalkable<V> with Walkable<V> {
  const _AsUnweightedWalkable(this._walkable);
  final WeightedWalkable<V> _walkable;
  @override
  Iterable<V> successors(V node) {
    return _walkable
        .successors(node)
        .where((pair) => pair.$2 != double.infinity)
        .map((pair) => pair.$1);
  }

  @override
  Iterable<V> get roots => _walkable.roots;
}
