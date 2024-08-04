import 'dart:math' as math;

import 'package:meta/meta.dart';

/// An interface for a generator of a 2-dimensional pattern.
///
/// Each type of pattern generator uses a specific method to calculate an output
/// value, or [double] value, for a given set of 2-dimensional input
/// coordinates (i.e. `(x, y)`), and this interface provides a common way to
/// implement and use generators.
///
/// The output value of a pattern is typically within the range of
/// `[-1.0, 1.0]`.
///
/// ## Implementing
///
/// To implement a new pattern generator, create a new class that implements or
/// mixes in this interface, and implement [get2df].
@Immutable('Recommended to be immutable for predictable behavior.')
abstract mixin class Pattern2d {
  /// Creates a new pattern that delegates to a function to calculate the output
  /// value.
  ///
  /// The [get] function should be pure and side-effect free.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Pattern2d.from((x, y) => x + y);
  /// print(pattern.get(1, 2)); // 3.0
  /// ```
  const factory Pattern2d.from(
    double Function(double x, double y) get,
  ) = _DelegatePattern2d;

  /// Returns the value of the pattern at the given fixed-point coordinates.
  ///
  /// The value returned is typically within the range of `[-1.0, 1.0]`, where:
  ///
  /// - `-1.0` represents the lowest value of the pattern;
  /// - `0.0` represents the middle value of the pattern;
  /// - `1.0` represents the highest value of the pattern.
  double get2d(int x, int y) => get2df(x.toDouble(), y.toDouble());

  /// Returns the value of the pattern at the given floating-point coordinates.
  ///
  /// The value returned is typically within the range of `[-1.0, 1.0]`, where:
  ///
  /// - `-1.0` represents the lowest value of the pattern;
  /// - `0.0` represents the middle value of the pattern;
  /// - `1.0` represents the highest value of the pattern.
  double get2df(double x, double y);

  /// Returns a new pattern that maps the output of this pattern using the given
  /// function.
  ///
  /// Prefer specialized methods for common mapping operations, such as:
  ///
  /// - [scale] for scaling the output by a factor;
  /// - [normalized] for normalizing the output to `[0.0, 1.0]`;
  /// - [inverted] for inverting the output;
  /// - [transposed] for transposing the output.
  ///
  /// The [map] function should be pure and side-effect free.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Constant(0.5);
  /// final mapped = pattern.map((value) => value * 2.0);
  /// print(mapped.get(0, 0)); // 1.0
  /// ```
  Pattern2d map(double Function(double) map) => _MappedPattern2d(this, map);

  /// Returns a new pattern that scales the output of this pattern by the given
  /// [factor].
  ///
  /// The output value at `(x, y)` is `get(x, y) * factor`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Constant(0.5);
  /// final scaled = pattern.scale(2.0);
  /// print(scaled.get(0, 0)); // 1.0
  /// ```
  Pattern2d scale(double factor) => _ScaledPattern2d(this, factor);

  /// Returns a new pattern that scales the output of this pattern by the given
  /// [factor].
  ///
  /// This is an alias for [scale].
  Pattern2d operator *(double factor) => scale(factor);

  /// Returns a new pattern that returns the absolute value of the output of
  /// this pattern.
  ///
  /// The output value at `(x, y)` is `get(x, y).abs()`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Constant(-0.5);
  /// final absolute = pattern.absolute;
  /// print(absolute.get(0, 0)); // 0.5
  ///
  Pattern2d get absolute => _AbsolutePattern2d(this);

  /// Returns a new pattern that normalizes the output of this pattern to the
  /// range of `[0.0, 1.0]`.
  ///
  /// A value of `-1.0` shoild be mapped to `0.0`, and a value of `1.0` should
  /// map to `1.0`.
  ///
  /// Implementations already in this range can return the same pattern.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Constant(-0.5);
  /// final normalized = pattern.normalized;
  /// print(normalized.get(0, 0)); // 0.25
  /// ```
  Pattern2d get normalized => _NormalizedPattern(this);

  /// Returns a new pattern that is the inverse of this pattern.
  ///
  /// The inverse of a pattern is the pattern where the output value at `(x, y)`
  /// is `-get(x, y)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Constant(0.5);
  /// final inverted = pattern.inverted;
  /// print(inverted.get(0, 0)); // -0.5
  Pattern2d get inverted => _InvertedPattern(this);

  /// Returns a new pattern that is the inverse of this pattern.
  ///
  /// This is an alias for [inverted].
  Pattern2d operator -() => inverted;

  /// Returns a new pattern that is the transpose of this pattern.
  ///
  /// The transpose of a pattern is the pattern where the output value at
  /// `(x, y)` is `get(y, x)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final pattern = Checkerboard(even: -1.0, odd: 1.0);
  /// print(pattern.get(0, 0)); // -1.0
  ///
  /// final transposed = pattern.transposed;
  /// print(transposed.get(0, 0)); // -1.0
  /// ```
  Pattern2d get transposed => _TransposedPattern2d(this);

  /// Returns a new pattern that adds the output of this pattern with the output
  /// of the given [pattern].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Constant(0.25);
  /// final b = Constant(0.75);
  /// final added = a.add(b);
  /// print(added.get(0, 0)); // 1.0
  /// ```
  Pattern2d add(Pattern2d pattern) => _AddPattern2d(this, pattern);

  /// Returns a new pattern that adds the output of this pattern with the output
  /// of the given [pattern].
  ///
  /// This is an alias for [add].
  Pattern2d operator +(Pattern2d pattern) => add(pattern);

  /// Returns a new pattern that subtracts the output of the given [pattern]
  /// from the output of this pattern.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Constant(0.25);
  /// final b = Constant(0.75);
  /// final subtracted = a.subtract(b);
  /// print(subtracted.get(0, 0)); // -0.5
  /// ```
  Pattern2d subtract(Pattern2d pattern) => _SubtractPattern2d(this, pattern);

  /// Returns a new pattern that subtracts the output of the given [pattern]
  /// from the output of this pattern.
  ///
  /// This is an alias for [subtract].
  Pattern2d operator -(Pattern2d pattern) => subtract(pattern);

  /// Returns a new pattern that returns the maximum value between the output of
  /// two patterns.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Constant(0.25);
  /// final b = Constant(0.75);
  /// final maxed = a.max(b);
  /// print(maxed.get(0, 0)); // 0.75
  /// ```
  Pattern2d max(Pattern2d pattern) => _MaxPattern2d(this, pattern);

  /// Returns a new pattern that returns the minimum value between the output of
  /// two patterns.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Constant(0.25);
  /// final b = Constant(0.75);
  /// final minned = a.min(b);
  /// print(minned.get(0, 0)); // 0.25
  /// ```
  Pattern2d min(Pattern2d pattern) => _MinPattern2d(this, pattern);
}

final class _DelegatePattern2d with Pattern2d {
  const _DelegatePattern2d(this._get);
  final double Function(double x, double y) _get;

  @override
  double get2df(double x, double y) => _get(x, y);
}

final class _MappedPattern2d with Pattern2d {
  const _MappedPattern2d(this._pattern, this._mapper);
  final Pattern2d _pattern;
  final double Function(double) _mapper;

  @override
  double get2df(double x, double y) => _mapper(_pattern.get2df(x, y));
}

final class _ScaledPattern2d with Pattern2d {
  const _ScaledPattern2d(this._pattern, this._scale);
  final Pattern2d _pattern;
  final double _scale;

  @override
  double get2df(double x, double y) => _pattern.get2df(x, y) * _scale;
}

final class _NormalizedPattern with Pattern2d {
  const _NormalizedPattern(this._pattern);
  final Pattern2d _pattern;

  @override
  double get2df(double x, double y) {
    final value = _pattern.get2df(x, y);
    return (value + 1.0) / 2.0;
  }
}

final class _InvertedPattern with Pattern2d {
  const _InvertedPattern(this._pattern);
  final Pattern2d _pattern;

  @override
  double get2df(double x, double y) => -_pattern.get2df(x, y);
}

final class _TransposedPattern2d with Pattern2d {
  const _TransposedPattern2d(this._pattern);
  final Pattern2d _pattern;

  @override
  double get2df(double x, double y) => _pattern.get2df(y, x);
}

final class _AbsolutePattern2d with Pattern2d {
  const _AbsolutePattern2d(this._pattern);
  final Pattern2d _pattern;

  @override
  double get2df(double x, double y) => _pattern.get2df(x, y).abs();
}

final class _AddPattern2d with Pattern2d {
  const _AddPattern2d(this._a, this._b);
  final Pattern2d _a;
  final Pattern2d _b;

  @override
  double get2df(double x, double y) => _a.get2df(x, y) + _b.get2df(x, y);
}

final class _SubtractPattern2d with Pattern2d {
  const _SubtractPattern2d(this._a, this._b);
  final Pattern2d _a;
  final Pattern2d _b;

  @override
  double get2df(double x, double y) => _a.get2df(x, y) - _b.get2df(x, y);
}

final class _MaxPattern2d with Pattern2d {
  const _MaxPattern2d(this._a, this._b);
  final Pattern2d _a;
  final Pattern2d _b;

  @override
  double get2df(double x, double y) {
    return math.max(_a.get2df(x, y), _b.get2df(x, y));
  }
}

final class _MinPattern2d with Pattern2d {
  const _MinPattern2d(this._a, this._b);
  final Pattern2d _a;
  final Pattern2d _b;

  @override
  double get2df(double x, double y) {
    return math.min(_a.get2df(x, y), _b.get2df(x, y));
  }
}
