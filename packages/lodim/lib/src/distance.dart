part of '../lodim.dart';

/// A function that returns an integer distance between two positions.
typedef Distance = int Function(Pos a, Pos b);

/// Calculates the squared [Euclidean][] distance between two positions.
///
/// The squared Euclidean distance is the square of the straight-line distance
/// between two points in a 2D space, or `(x₂ - x₁)² + (y₂ - y₁)²`. This is
/// useful for comparing distances without needing to calculate the square root,
/// i.e. when doing a comparison between distances but not using the actual
/// distance value.
///
/// [Euclidean]: https://en.wikipedia.org/wiki/Euclidean_distance
///
/// ## Example
///
/// ```dart
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, euclideanSquared)); // => 500
/// ```
@pragma('vm:prefer-inline')
int euclideanSquared(Pos a, Pos b) {
  final delta = a - b;
  return delta.x * delta.x + delta.y * delta.y;
}

/// Calculates the [Manhattan][] distance between two positions.
///
/// The Manhattan distance is the sum of the absolute differences of the
/// horizontal and vertical offsets between two points in a 2D space, or
/// `|x₂ - x₁|`. This is useful for calculating distances in a grid-based
/// system, where diagonal movement is _not_ allowed.
///
/// [Manhattan]: https://en.wikipedia.org/wiki/Taxicab_geometry
///
/// ## Example
///
/// ```dart
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, manhattan)); // => 40
/// ```
@pragma('vm:prefer-inline')
int manhattan(Pos a, Pos b) {
  final delta = (a - b).abs();
  return delta.x + delta.y;
}

/// Calculates the [Chebyshev][] distance between two positions.
///
/// The Chebyshev distance is the maximum of the absolute differences of the
/// horizontal and vertical offsets between two points in a 2D space, or
/// `max(|x₂ - x₁|, |y₂ - y₁|)`. This is useful for calculating distances in
/// a grid-based system, where diagonal movement _is_ allowed.
///
/// [Chebyshev]: https://en.wikipedia.org/wiki/Chebyshev_distance
///
/// ## Example
///
/// ```dart
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, chebyshev)); // => 20
/// ```
@pragma('vm:prefer-inline')
int chebyshev(Pos a, Pos b) {
  final delta = (a - b).abs();
  return math.max(delta.x, delta.y);
}
