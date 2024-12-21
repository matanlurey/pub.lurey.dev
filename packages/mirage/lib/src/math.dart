import 'dart:math';
import 'dart:typed_data';

/// Quintic easing function.
///
/// [t] is the alpha value, ranging from 0.0 to 1.0.
///
/// {@category Math}
double quinticEase(double t) {
  return t * t * t * (t * (t * 6 - 15) + 10);
}

/// Linear interpolation between two values.
double linearInterpolate(double a, double b, double t) {
  return b * t + a * (1.0 - t);
}

/// Cubic interpolation between two values bound between two other values.
///
/// - [a] is the value _before_ the first value.
/// - [b] is the first value.
/// - [c] is the second value.
/// - [d] is the value _after_ the second value.
/// - [t] is the alpha value, ranging from 0.0 to 1.0.
///
/// If [t] is `0.0`, the result is [b]. If [t] is `1.0`, the result is [c].
double cubicInterpolate(double a, double b, double c, double d, double t) {
  final p = (d - c) - (a - b);
  final q = (a - b) - p;
  final r = c - a;
  final s = b;
  return p * t * t * t + q * t * t + r * t + s;
}

/// Returns the 2-dimensuonal gradient vector at [index], between 0 and 7.
///
/// Any index out of bounds is wrapped around using `index % 8`.
Vec2 gradient2d(int index) {
  const diag = sqrt1_2;
  return switch (index % 8) {
    0 => const (1.0, 0.0),
    1 => const (-1.0, 0.0),
    2 => const (0.0, 1.0),
    3 => const (0.0, -1.0),
    4 => const (diag, diag),
    5 => const (-diag, diag),
    6 => const (diag, -diag),
    7 => const (-diag, -diag),
    _ => throw StateError('Unreachable'),
  } as Vec2;
}

final _reinterpretBuffer = ByteData(8);

/// Reinterprets a 32-bit integer as a double.
double reinterpretAsDouble(int bits) {
  _reinterpretBuffer.setUint32(0, bits);
  return _reinterpretBuffer.getFloat64(0);
}

/// Reinterprets a double as a 32-bit integer.
int reinterpretAsInt(double value) {
  _reinterpretBuffer.setFloat64(0, value);
  return _reinterpretBuffer.getUint32(0);
}

/// A two-dimensional floating-point vector.
///
/// Prefer [`pacakge:vector_math`](https://pub.dev/packages/vector_math) over
/// this extension for serious applications; this is a minimalistic alternative
/// that only provides the most basic functionality needed for this library,
/// such as noise generation.
///
/// Any tuple of two doubles can be cast to a `Vec2` using `as Vec2`:
/// ```dart
/// final vec = (1.0, 2.0) as Vec2;
/// ```
///
/// To convert back to a tuple, use the `x` and `y` getters, or [xy]:
/// ```dart
/// final (x, y) = vec.xy;
/// ```
///
/// {@category Math}
extension type const Vec2._((double, double) _) {
  /// The zero vector.
  static const zero = v00;

  /// The unit vector in no direction.
  static const v00 = (0.0, 0.0) as Vec2;

  /// The unit vector in the x-direction.
  static const v01 = (0.0, 1.0) as Vec2;

  /// The unit vector in the y-direction.
  static const v10 = (1.0, 0.0) as Vec2;

  /// The unit vector in the x and y-directions.
  static const v11 = (1.0, 1.0) as Vec2;

  /// Creates a new 2D vector.
  ///
  /// The components must be finite.
  factory Vec2(double x, double y) {
    assert(x.isFinite && y.isFinite, 'Vector components must be finite');
    return (x, y) as Vec2;
  }

  /// Creates a new 2D vector from two integers.
  factory Vec2.fromInts(int x, int y) => Vec2(x.toDouble(), y.toDouble());

  /// The x-coordinate of the vector.
  double get x => _.$1;

  /// The y-coordinate of the vector.
  double get y => _.$2;

  /// The vector as a tuple of two doubles.
  (double x, double y) get xy => _;

  /// Squared magnitude of the vector.
  double get length2 => dot(this);

  /// Dot product of this vector and [other].
  double dot(Vec2 other) => x * other.x + y * other.y;

  /// Adds this vector and [other].
  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);

  /// Subtracts [other] from this vector.
  Vec2 operator -(Vec2 other) => Vec2(x - other.x, y - other.y);

  /// Translates the vector by [by] for both components.
  Vec2 translate(double by) => Vec2(x + by, y + by);

  /// Scales the vector by [by] for both components.
  Vec2 scale(double by) => Vec2(x * by, y * by);

  /// Returns the vector floored but kept as a double.
  Vec2 floor() => Vec2(x.floorToDouble(), y.floorToDouble());

  /// Returns the vector floored to two integers.
  IVec2 floorToInt() => (x.floor(), y.floor()) as IVec2;

  /// Returns the sum of the vector components.
  double sum() => x + y;

  /// Returns a new vector with components mapped by [f].
  Vec2 map(double Function(double) f) => Vec2(f(x), f(y));

  /// Reinterprets the vector as a 2D integer vector.
  IVec2 reinterpret() {
    return IVec2(reinterpretAsInt(x), reinterpretAsInt(y));
  }
}

/// A two-dimensional fixed-point vector.
///
/// Prefer [`pacakge:vector_math`](https://pub.dev/packages/vector_math) over
/// this extension for serious applications; this is a minimalistic alternative
/// that only provides the most basic functionality needed for this library,
/// such as noise generation.
///
/// Any tuple of two integers can be cast to a `IVec2` using `as IVec2`:
/// ```dart
/// final vec = (1, 2) as IVec2;
/// ```
///
/// To convert back to a tuple, use the `x` and `y` getters, or [xy]:
/// ```dart
/// final (x, y) = vec.xy;
/// ```
extension type const IVec2._((int, int) _) {
  /// The zero vector.
  static const zero = v00;

  /// The unit vector in no direction.
  static const v00 = (0, 0) as IVec2;

  /// The unit vector in the x-direction.
  static const v01 = (0, 1) as IVec2;

  /// The unit vector in the y-direction.
  static const v10 = (1, 0) as IVec2;

  /// The unit vector in the x and y-directions.
  static const v11 = (1, 1) as IVec2;

  /// Creates a new 2D vector.
  factory IVec2(int x, int y) => (x, y) as IVec2;

  /// The x-coordinate of the vector.
  int get x => _.$1;

  /// The y-coordinate of the vector.
  int get y => _.$2;

  /// The vector as a tuple of two integers.
  (int x, int y) get xy => _;

  /// Squared magnitude of the vector.
  int get length2 => x * x + y * y;

  /// Adds this vector and [other].
  IVec2 operator +(IVec2 other) => IVec2(x + other.x, y + other.y);

  /// Subtracts [other] from this vector.
  IVec2 operator -(IVec2 other) => IVec2(x - other.x, y - other.y);

  /// Translates the vector by [by] for both components.
  IVec2 translate(int by) => IVec2(x + by, y + by);

  /// Returns a list of the vector components.
  List<int> toList() => [x, y];

  /// Returns as a 2D floating-point vector.
  Vec2 toVec2() => Vec2(x.toDouble(), y.toDouble());
}
