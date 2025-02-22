import 'package:mirage/mirage.dart';

/// A pattern that outputs a constant value.
///
/// Regardless of the input coordinates, this pattern always returns the same
/// value.
///
/// While not very useful on its own, this pattern can be used as a source
/// pattern for other patterns.
///
/// ## Example
///
/// ```dart
/// final pattern = Constant(0.5);
/// print(pattern.get(0, 0)); // 0.5
/// print(pattern.get(1, 1)); // 0.5
/// print(pattern.get(2, 2)); // 0.5
/// ```
final class Constant with Pattern2d {
  /// Creates a new constant pattern with the given value.
  const Constant(this._value);
  final double _value;

  /// A constant pattern that always returns `-1.0`.
  static const negative = Constant(-1.0);

  /// A constant pattern that always returns `0.0`.
  static const zero = Constant(0.0);

  /// A constant pattern that always returns `1.0`.
  static const positive = Constant(1.0);

  @override
  double get2df(double x, double y) => _value;
}

/// A pattern that outputs a checkerboard pattern.
///
/// The checkerboard pattern alternates between two values based on the input
/// coordinates.
///
/// ![Example](https://github.com/user-attachments/assets/5d3dace2-b78d-4bc7-81c3-3eb3f0847b48)
///
/// ## Example
///
/// ```dart
/// final pattern = Checkerboard(even: -1.0, odd: 1.0);
/// print(pattern.get(0, 0)); // -1.0
/// print(pattern.get(1, 1)); // 1.0
/// print(pattern.get(2, 2)); // -1.0
/// ```
final class Checkerboard with Pattern2d {
  /// Creates a new checkerboard pattern with the given [even] and [odd] values.
  const Checkerboard({required double even, required double odd})
    : _even = even,
      _odd = odd;
  final double _even;
  final double _odd;

  /// A checkerboard pattern that is "off" for even coordinates and "on" for odd
  /// coordinates.
  ///
  /// This is typically the default checkerboard pattern:
  ///
  /// - `-1.0` for even coordinates;
  /// - `1.0` for odd coordinates.
  static const odd = Checkerboard(even: -1.0, odd: 1.0);

  /// A checkerboard pattern that is "off" for odd coordinates and "on" for even
  /// coordinates.
  ///
  /// This is the inverse of the default checkerboard pattern:
  ///
  /// - `1.0` for even coordinates;
  /// - `-1.0` for odd coordinates.
  static const even = Checkerboard(even: 1.0, odd: -1.0);

  @override
  double get2d(int x, int y) => (x + y).isEven ? _even : _odd;

  @override
  double get2df(double x, double y) => get2d(x.floor(), y.floor());
}
