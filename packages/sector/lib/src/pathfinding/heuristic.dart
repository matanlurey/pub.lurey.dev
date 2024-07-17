part of '../pathfinding.dart';

/// A heuristic estimates the minimum total cost of reaching a [Goal].
///
/// Heuristics guide the search in "find best path" algorithms, such as A*,
/// by providing an estimate of the cost to reach the goal from a given node,
/// and picking the node with the lowest estimated cost to explore next.
///
/// {@category Pathfinding}
abstract mixin class Heuristic<T> {
  /// Creates a heuristic from an [estimateTotalCost] function.
  const factory Heuristic(double Function(T) estimateTotalCost) = _Heuristic<T>;

  /// Returns a heuristic that always returns [value].
  const factory Heuristic.always(double value) = _AlwaysHeuristic<T>;

  /// Returns a heuristic that always returns `0.0`.
  ///
  /// This is a valid heuristic guaranteed to find the optimal path, but may
  /// be significantly slower than other heuristics, as it becomes equivalent
  /// to Dijkstra's algorithm (expanding all nodes as the heuristic does not
  /// guide the search).
  const factory Heuristic.zero() = _ZeroHeuristic<T>;

  /// Returns a heuristic that uses the minimum of multiple possible goals.
  ///
  /// This is useful when there are multiple goals and the heuristic should
  /// estimate the cost to reach the closest one; the minimum cost is used,
  /// i.e. the most optimistic estimate of the cost of any goal.
  ///
  /// If an empty collection is used, the result is always `0.0`.
  const factory Heuristic.any(List<Heuristic<T>> heuristics) = _AnyHeuristic<T>;

  /// Returns a heuristic that uses the maximum of multiple possible goals.
  ///
  /// This is useful when there are multiple goals and the heuristic should
  /// estimate the cost to reach the farthest one; the maximum cost is used,
  /// i.e. the most pessimistic estimate of the cost of any goal.
  ///
  /// If an empty collection is used, the result is always [double.maxFinite].
  const factory Heuristic.every(
    List<Heuristic<T>> heuristics,
  ) = _EveryHeuristic<T>;

  /// Estimates the minimum total cost of reaching the goal from [node].
  ///
  /// Given `h(n)`, the heuristic, and `g(n)`, the (unknown) actual cost:
  ///
  /// | Heuristic             | Optimality Guarantee | Performance        |
  /// |-----------------------|----------------------|--------------------|
  /// | `h(n) == 0`           | Yes [^1]             | Potentially slower |
  /// | `h(n) <= g(n)`        | Yes                  | Varies (slower with lower h(n)) |
  /// | `h(n) == g(n)`        | Yes                  | Fastest possible   |
  /// | `h(n) > g(n)`         | No                   | Faster             |
  /// | `h(n) > g(n)`, always | No [^2]              | Very fast          |
  ///
  /// [^1]: A* becomes Dijsktra's algorithm.
  ///
  /// [^2]: A* becomes Greedy Best-First Search.
  double estimateTotalCost(T node);

  /// Returns a heuristic that scales the cost of another heuristic by [ratio].
  ///
  /// {@macro sector.GridHeuristic:ratio}
  Heuristic<T> scaleBy(double ratio) => _ScaledHeuristic(this, ratio);

  /// Returns a heuristic that scales the cost of another heuristic by [ratio].
  ///
  /// {@macro sector.GridHeuristic:ratio}
  Heuristic<T> operator *(double ratio) => scaleBy(ratio);
}

final class _Heuristic<T> with Heuristic<T> {
  const _Heuristic(this._estimateTotalCost);
  final double Function(T) _estimateTotalCost;

  @override
  double estimateTotalCost(T node) => _estimateTotalCost(node);
}

final class _ScaledHeuristic<T> with Heuristic<T> {
  const _ScaledHeuristic(this._heuristic, this._ratio);
  final Heuristic<T> _heuristic;
  final double _ratio;

  @override
  double estimateTotalCost(T node) {
    return _heuristic.estimateTotalCost(node) * _ratio;
  }
}

final class _ZeroHeuristic<T> with Heuristic<T> {
  const _ZeroHeuristic();

  @override
  double estimateTotalCost(T node) => 0;
}

final class _AlwaysHeuristic<T> with Heuristic<T> {
  const _AlwaysHeuristic(this._value);
  final double _value;

  @override
  double estimateTotalCost(T node) => _value;
}

/// A heuristic that estimates the minimum total cost of reaching a [Pos] goal.
///
/// This is a common heuristic used in grid-based pathfinding algorithms.
///
/// {@category Pathfinding}
abstract final class GridHeuristic with Heuristic<Pos> {
  /// Uses `euclidean` (`√` of [euclideanSquared]) distance to estimate the
  /// total cost.
  ///
  /// {@macro sector.GridHeuristic:ratio}
  const factory GridHeuristic.euclidean(
    Pos goal, {
    double ratio,
  }) = _EucledianHeuristic;

  /// Uses [manhattan] distance to estimate the total cost.
  ///
  /// {@template sector.GridHeuristic:ratio}
  /// The [ratio] parameter can be used to scale the heuristic, making it more
  /// or less aggressive, where the default value is `1.0`; a higher value makes
  /// the heuristic tend to overestimate the cost, which makes algorithms like
  /// A* run faster, while a lower value makes it tend to underestimate the cost
  /// which makes the algorithm run slower but may find a more optimal path.
  /// {@endtemplate}
  const factory GridHeuristic.manhattan(
    Pos goal, {
    double ratio,
  }) = _ManhattanHeuristic;

  /// Uses [diagonal] distance to estimate the total cost.
  ///
  /// {@macro sector.GridHeuristic:ratio}
  const factory GridHeuristic.diagonal(
    Pos goal, {
    double ratio,
  }) = _DiagonalHeuristic;

  /// Uses [chebyshev] distance to estimate the total cost.
  ///
  /// {@macro sector.GridHeuristic:ratio}
  const factory GridHeuristic.chebyshev(
    Pos goal, {
    double ratio,
  }) = _ChebyshevHeuristic;

  const GridHeuristic(this._goal, {this.ratio = 1});

  /// The goal to reach.
  final Pos _goal;

  /// The ratio the heuristic is scaling by.
  final double ratio;

  @override
  double estimateTotalCost(Pos node);
}

final class _EucledianHeuristic extends GridHeuristic {
  const _EucledianHeuristic(super._goal, {super.ratio});

  @override
  double estimateTotalCost(Pos node) {
    return math.sqrt(euclideanSquared(node, _goal)) * ratio;
  }
}

final class _ManhattanHeuristic extends GridHeuristic {
  const _ManhattanHeuristic(super._goal, {super.ratio});

  @override
  double estimateTotalCost(Pos node) => manhattan(node, _goal) * ratio;
}

final class _DiagonalHeuristic extends GridHeuristic {
  const _DiagonalHeuristic(super._goal, {super.ratio});

  @override
  double estimateTotalCost(Pos node) => diagonal(node, _goal) * ratio;
}

final class _ChebyshevHeuristic extends GridHeuristic {
  const _ChebyshevHeuristic(super._goal, {super.ratio});

  @override
  double estimateTotalCost(Pos node) => chebyshev(node, _goal) * ratio;
}

final class _AnyHeuristic<T> with Heuristic<T> {
  const _AnyHeuristic(this._heuristics);
  final List<Heuristic<T>> _heuristics;

  @override
  double estimateTotalCost(T node) {
    if (_heuristics.isEmpty) {
      return 0;
    }
    var min = _heuristics.first.estimateTotalCost(node);
    for (var i = 1; i < _heuristics.length; i++) {
      final cost = _heuristics[i].estimateTotalCost(node);
      if (cost < min) {
        min = cost;
      }
    }
    return min;
  }
}

final class _EveryHeuristic<T> with Heuristic<T> {
  const _EveryHeuristic(this._heuristics);
  final List<Heuristic<T>> _heuristics;

  @override
  double estimateTotalCost(T node) {
    if (_heuristics.isEmpty) {
      return double.maxFinite;
    }
    var max = _heuristics.first.estimateTotalCost(node);
    for (var i = 1; i < _heuristics.length; i++) {
      final cost = _heuristics[i].estimateTotalCost(node);
      if (cost > max) {
        max = cost;
      }
    }
    return max;
  }
}
