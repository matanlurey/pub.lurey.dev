part of '../lodim.dart';

/// A function that returns an integer distance between two positions.
///
/// Each function, unless otherwise specified, should:
///
/// - Return a non-negative integer and `0` only if bothpositions are the same.
/// - Be commutative, i.e. `f(a, b) == f(b, a)`.
/// - Be reflexive, i.e. `f(a, a) == 0`.
typedef Distance = int Function(Pos a, Pos b);

/// Calculates the _squared_ [Euclidean][] distance between two positions.
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
const Distance distanceSquared = _euclideanSquared;

/// Calculates the _squared_ [Euclidean][] distance between two positions.
///
/// **Deprecated**: Use [distanceSquared] instead.
@Deprecated('Use `distanceSquared` instead.')
const Distance euclideanSquared = _euclideanSquared;

@_pragmaInline
int _euclideanSquared(Pos a, Pos b) {
  final delta = a - b;
  return delta.x * delta.x + delta.y * delta.y;
}

/// Calculates an _approximate_ [Euclidean][] distance between two positions.
///
/// Uses [sqrtApproximate] to calculate the square root of
/// [distanceApproximate].
///
/// [Euclidean]: https://en.wikipedia.org/wiki/Euclidean_distance
///
/// ## Example
///
/// ```dart
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, using: euclideanApproximate)); // => 22
/// ```
const Distance distanceApproximate = _euclideanApproximate;

/// Calculates an _approximate_ [Euclidean][] distance between two positions.
///
/// **Deprecated**: Use [distanceApproximate] instead.
@Deprecated('Use `distanceApproximate` instead.')
const Distance euclideanApproximate = _euclideanApproximate;

@_pragmaInline
int _euclideanApproximate(Pos a, Pos b) {
  return sqrtApproximate(distanceSquared(a, b));
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
const Distance distanceManhattan = _manhattan;

/// Calculates the [Manhattan][] distance between two positions.
///
/// **Deprecated**: Use [manhattan] instead.
@Deprecated('Use `manhattan` instead.')
const Distance manhattan = _manhattan;

@_pragmaInline
int _manhattan(Pos a, Pos b) {
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
const Distance distanceChebyshev = _chebyshev;

/// Calculates the [Chebyshev][] distance between two positions.
///
/// **Deprecated**: Use [chebyshev] instead.
@Deprecated('Use `chebyshev` instead.')
const Distance chebyshev = _chebyshev;

@_pragmaInline
int _chebyshev(Pos a, Pos b) {
  final delta = (a - b).abs();
  return math.max(delta.x, delta.y);
}

/// Calculates the diagonal (ordinal) distance between two positions.
///
/// Similar to [distanceManhattan], but _only_ allows diagonal movement, i.e.
/// the distance between two points is the sum of the horizontal and vertical
/// offsets, _minus_ the minimum of the two offsets, or
/// `|x₂ - x₁| + |y₂ - y₁| - min(|x₂ - x₁|, |y₂ - y₁|)`.
///
/// ## Example
///
/// ```dart
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, diagonal)); // => 20
/// ```
const Distance distanceDiagonal = _diagonal;

/// Calculates the diagonal (ordinal) distance between two positions.
///
/// **Deprecated**: Use [diagonal] instead.
@Deprecated('Use `diagonal` instead.')
const Distance diagonal = _diagonal;

@_pragmaInline
int _diagonal(Pos a, Pos b) {
  final delta = (a - b).abs();
  return delta.x + delta.y - math.min(delta.x, delta.y);
}
