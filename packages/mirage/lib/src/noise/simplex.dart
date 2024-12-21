import 'dart:math';

import 'package:mirage/mirage.dart';

/// A [simplex noise][] generator.
///
/// [simplex noise]: https://en.wikipedia.org/wiki/Simplex_noise
///
/// Typically an improvement over [Perlin] noise, offering similar smoothness
/// and organic patterns but with better performance and fewer directional
/// artifacts; often considered the best general-purpose noise algorithm.
///
/// ![Example](https://github.com/user-attachments/assets/5168bc86-9915-4664-ae8d-3752e2bd3651)
final class Simplex with Pattern2d {
  /// Creates a new simplex noise generator.
  ///
  /// If a [hasher] is not provided, [NoiseHasher.new] is used.
  factory Simplex([NoiseHasher? hasher]) {
    hasher ??= NoiseHasher();
    return Simplex._(hasher);
  }

  const Simplex._(this._hasher);
  final NoiseHasher _hasher;

  @override
  double get2df(double x, double y) {
    final (noise, _) = _simplex2d(Vec2(x, y));
    return noise;
  }

  (double, Vec2) _simplex2d(Vec2 point) {
    final skew = point.sum() * _skewFactor2;
    final skewed = point.translate(skew);
    final cell = skewed.floorToInt();
    final floor = Vec2.fromInts(cell.x, cell.y);

    final unskew = floor.sum() * _unskewFactor2;
    final unskewed = floor.translate(-unskew);
    final offset1 = point - unskewed;

    // For the 2D case, the simplex shape is an equilateral triangle.
    // Determine which simplex we are in.
    final order = offset1.x > offset1.y ? Vec2.v10 : Vec2.v01;
    final offset2 = (offset1 - order).translate(_unskewFactor2);
    final offset3 = offset1.translate(-1.0).translate(2.0 * _unskewFactor2);

    // Calculate gradient indexes for each corner
    final gi0 = _hasher.hash(cell.toList());
    final gi1 = _hasher.hash((cell + order.reinterpret()).toList());
    final gi2 = _hasher.hash(cell.translate(1).toList());

    // Calculate the contribution from the three corners
    final corner0 = _Surflet.from(offset1, gradientIndex: gi0);
    final corner1 = _Surflet.from(offset2, gradientIndex: gi1);
    final corner2 = _Surflet.from(offset3, gradientIndex: gi2);
    final noise = corner0.value + corner1.value + corner2.value;

    // A straight, unoptimised calculation would be like:
    //   dnoise_dx = -8.0 * t20 * t0 * x0 * ( gx0 * x0 + gy0 * y0 ) + t40 * gx0;
    //   dnoise_dy = -8.0 * t20 * t0 * y0 * ( gx0 * x0 + gy0 * y0 ) + t40 * gy0;
    //   dnoise_dx += -8.0 * t21 * t1 * x1 * ( gx1 * x1 + gy1 * y1 ) + t41 * gx1;
    //   dnoise_dy += -8.0 * t21 * t1 * y1 * ( gx1 * x1 + gy1 * y1 ) + t41 * gy1;
    //   dnoise_dx += -8.0 * t22 * t2 * x2 * ( gx2 * x2 + gy2 * y2 ) + t42 * gx2;
    //   dnoise_dy += -8.0 * t22 * t2 * y2 * ( gx2 * x2 + gy2 * y2 ) + t42 * gy2;
    var dnoise = offset1.translate(
      corner0.t2 * corner0.t * corner0.gradient.dot(offset1),
    );
    dnoise += offset2.translate(
      corner1.t2 * corner1.t * corner1.gradient.dot(offset2),
    );
    dnoise += offset3.translate(
      corner2.t2 * corner2.t * corner2.gradient.dot(offset3),
    );
    dnoise = dnoise.scale(-8.0);
    dnoise += corner0.gradient.scale(corner0.t4) +
        corner1.gradient.scale(corner1.t4) +
        corner2.gradient.scale(corner2.t4);

    return (noise, dnoise);
  }

  /// ```txt
  ///     sqrt(n + 1) - 1
  /// F = ---------------
  ///            n
  /// ```
  ///
  /// The result of `n = 2`.
  static final _skewFactor2 = (sqrt(3) - 1) / 2;

  /// ```txt
  ///     1 - 1 / sqrt(n + 1)
  /// G = -------------------
  ///             n
  /// ```
  ///
  /// The result of `n = 2`.
  static final _unskewFactor2 = (1 - 1 / sqrt(3)) / 2;
}

final class _Surflet {
  factory _Surflet.from(
    Vec2 point, {
    required int gradientIndex,
  }) {
    final t = 1.0 - (point.length2 * 2.0);
    if (t > 0.0) {
      final gradient = gradient2d(gradientIndex);
      final t2 = t * t;
      final t4 = t2 * t2;
      return _Surflet._(
        value: (2.0 * t2 + t4) * point.dot(gradient),
        t: t,
        t2: t2,
        t4: t4,
        gradient: gradient,
      );
    }
    return const _Surflet._(
      value: 0.0,
      t: 0.0,
      t2: 0.0,
      t4: 0.0,
      gradient: Vec2.zero,
    );
  }

  const _Surflet._({
    required this.value,
    required this.t,
    required this.t2,
    required this.t4,
    required this.gradient,
  });

  final double value;
  final double t;
  final double t2;
  final double t4;
  final Vec2 gradient;
}
