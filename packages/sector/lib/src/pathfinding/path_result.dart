part of '../pathfinding.dart';

/// A representation of a path in a graph.
///
/// Each subsequent node in [nodes] is a neighbor of the previous node.
///
/// The first node in [nodes] is the start node, and the last node is the goal.
///
/// ## Equality
///
/// Two paths are considered equal if they have the same nodes in the same
/// order.
///
/// {@category Pathfinding}
@immutable
final class Path<T> {
  /// Creates a path from a list of nodes.
  ///
  /// The list of nodes should be in the order they were visited, from the
  /// start node to the goal node, inclusive. Ownership of the list should be
  /// considered transferred to the path and no longer modified.
  const Path(this.nodes);

  /// A path that is considered _not found_.
  static const notFound = Path<Never>([]);

  /// The nodes in the path.
  final List<T> nodes;

  /// Returns `true` if this path was considered _found_, i.e. non-empty.
  bool get isFound => nodes.isNotEmpty;

  /// Returns `true` if this path was considered _not found_, i.e. empty.
  bool get isNotFound => nodes.isEmpty;

  /// Whether the path is considered a cycle.
  ///
  /// A cycle is a found path that starts and ends at the same node.
  bool get cycle => isFound && start == goal;

  /// The start node of the path.
  ///
  /// The path must be [isFound] for this to be valid.
  T get start => nodes.first;

  /// The goal node of the path.
  ///
  /// The path must be [isFound] for this to be valid.
  T get goal => nodes.last;

  /// Returns `true` if `this` is a valid path in the graph.
  ///
  /// A path is considered valid if it [isFound] and:
  /// - Each node in the path is a direct successor of the previous node, _or_
  /// - The path is a single node that is a direct successor of itself _or_
  /// - The path is a single node that is a root node.
  ///
  /// If the path is [notFound], this method returns `false`.
  ///
  /// > [!NOTE]
  /// > Checking for a root node (i.e. from a single-node path) is a potentially
  /// > expensive operation, as it could require checking every node in the
  /// > graph. Either avoid using this method with single-node paths, or ensure
  /// > that the graph implementation is optimized for this operation (e.g. has
  /// > constant-time lookup for roots, such as [AdjacencyListGraph] or
  /// > [GridWalkable] on a default [Grid] implementation).
  bool isIn(WalkableBase<T> graph) {
    if (isNotFound) {
      return false;
    }

    // Edge-case: A path to yourself.
    if (nodes.length == 1) {
      // Self-loop:
      if (graph.successors(start).contains(start)) {
        return true;
      }

      // If not, it's still possible it's a path to itself without a loop.
      // This is a potentially expensive operation, though if you're asking if
      // a node is a path to itself returning 'false' doesn't make any sense.
      return graph.roots.contains(start);
    }

    for (var i = 0; i < nodes.length - 1; i++) {
      if (!graph.successors(nodes[i]).contains(nodes[i + 1])) {
        return false;
      }
    }
    return true;
  }

  /// Returns whether the path is valid and has a total cost of [cost].
  ///
  /// The result is a tuple of a boolean and a double, where the boolean is
  /// `true` if the path is valid and the cost is equal to [cost], and `false`
  /// otherwise. The double is the _actual_ total cost of the path, or
  /// [double.infinity] if the path is not valid.
  ///
  /// A path is considered valid if it [isFound] and:
  /// - Each node in the path is a direct successor of the previous node, _or_
  /// - The path is a single node that is a direct successor of itself _or_
  /// - The path is a single node that is a root node.
  ///
  /// _and_ the total cost of the path is equal to [cost].
  ///
  /// If the path is [notFound], this method returns `false`.
  ///
  /// > [!NOTE]
  /// > Checking for a root node (i.e. from a single-node path) is a potentially
  /// > expensive operation, as it could require checking every node in the
  /// > graph. Either avoid using this method with single-node paths, or ensure
  /// > that the graph implementation is optimized for this operation (e.g. has
  /// > constant-time lookup for roots, such as [AdjacencyListGraph] or
  /// > [GridWalkable] on a default [Grid] implementation).
  (bool, double) isInWithCost(WeightedWalkable<T> graph, double cost) {
    if (isNotFound) {
      return (false, double.infinity);
    }

    // Edge-case: A path to yourself.
    if (nodes.length == 1) {
      // Self-loop:
      if (graph.successors(start).any((e) => e.$1 == start)) {
        return (cost == 0.0, 0.0);
      }

      // If not, it's still possible it's a path to itself without a loop.
      // This is a potentially expensive operation, though if you're asking if
      // a node is a path to itself returning 'false' doesn't make any sense.
      return (graph.roots.contains(start) && cost == 0.0, 0.0);
    }

    var totalCost = 0.0;
    for (var i = 0; i < nodes.length - 1; i++) {
      final node = nodes[i];
      final next = nodes[i + 1];
      final moveCost = graph
          .successors(node)
          .firstWhere((e) => e.$1 == next)
          .$2;
      if (moveCost == double.infinity) {
        return (false, double.infinity);
      }
      totalCost += moveCost;
    }

    return (totalCost == cost, totalCost);
  }

  @override
  int get hashCode => Object.hashAll(nodes);

  @override
  bool operator ==(Object other) {
    if (other is! Path<T> || nodes.length != other.nodes.length) return false;
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i] != other.nodes[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    if (isNotFound) return 'Path.notFound';
    return 'Path($nodes)';
  }
}
