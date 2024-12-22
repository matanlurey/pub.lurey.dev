part of '../pathfinding.dart';

/// Represents a _goal_ in a pathfinding algorithm.
///
/// {@template sector.Goal:description}
/// A goal is a condition that, when met, signals the end of a pathfinding
/// algorithm. For example, a goal could be a specific node in a graph, or a
/// condition that a node must meet to be considered a goal, such as a certain
/// value or property.
/// {@endtemplate}
///
/// {@category Pathfinding}
abstract interface class Goal<T> {
  /// Creates a goal with an arbitrary condition that a node must meet.
  ///
  /// The first node that matches [success] test is considered the goal.
  const factory Goal.test(bool Function(T node) success) = _TestGoal<T>;

  /// Creates a goal that matches a specific node.
  ///
  /// The first node that matches [Object.==] of [node] is considered the goal.
  const factory Goal.node(T node) = _NodeGoal<T>;

  /// Creates a goal that never matches any node.
  ///
  /// The entire graph will be traversed never finding a goal.
  const factory Goal.never() = _NeverGoal<T>;

  /// Creates a goal that always matches any node.
  ///
  /// The first node that is visited will be considered the goal.
  const factory Goal.always() = _AlwaysGoal<T>;

  /// Creates a goal that matches any of the goals in [goals].
  ///
  /// If the list is empty, the goal will always match any node.
  const factory Goal.any(List<Goal<T>> goals) = _AnyGoal<T>;

  /// Creates a goal that matches all of the goals in [goals].
  ///
  /// If the list is empty, the goal will never match any node.
  const factory Goal.every(List<Goal<T>> goals) = _EveryGoal<T>;

  /// Returns `true` if [node] is a goal, `false` otherwise.
  bool success(T node);
}

final class _TestGoal<T> implements Goal<T> {
  const _TestGoal(this._isGoal);
  final bool Function(T) _isGoal;

  @override
  bool success(T node) => _isGoal(node);
}

final class _NodeGoal<T> implements Goal<T> {
  const _NodeGoal(this.node);
  final T node;

  @override
  bool success(T other) => node == other;
}

final class _NeverGoal<T> implements Goal<T> {
  const _NeverGoal();

  @override
  bool success(T node) => false;
}

final class _AlwaysGoal<T> implements Goal<T> {
  const _AlwaysGoal();

  @override
  bool success(T node) => true;
}

final class _AnyGoal<T> implements Goal<T> {
  const _AnyGoal(this._goals);
  final List<Goal<T>> _goals;

  @override
  bool success(T node) {
    return _goals.any((goal) => goal.success(node));
  }
}

final class _EveryGoal<T> implements Goal<T> {
  const _EveryGoal(this._goals);
  final List<Goal<T>> _goals;

  @override
  bool success(T node) {
    return _goals.every((goal) => goal.success(node));
  }
}
