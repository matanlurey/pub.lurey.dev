import 'dart:math';

import 'package:mirage/mirage.dart';

/// A [perlin noise][] generator.
///
/// [perlin noise]: https://en.wikipedia.org/wiki/Perlin_noise
///
/// A classic noise algorithm known for its organic, "cloudy" appearance.
/// Produces smooth, continuous noise patterns with a natural feel; moderately
/// expensive to compute compared to [Simplex] or [Value] noise.
///
/// Ideal for natural-looking terrain genreation, cloud formations, or other
/// fluid simulations. Can exhibit slight directional artifacts due to the
/// underlying grid structure, and is considered slower than [Simplex] for
/// similar quality output.
///
/// ![Example](https://github.com/user-attachments/assets/23214d88-4143-44e5-97bb-40c40d02e529)
final class Perlin with Pattern2d {
  /// Creates a new perlin noise generator.
  ///
  /// If a [hasher] is not provided, [NoiseHasher.new] is used.
  factory Perlin([NoiseHasher? hasher]) {
    hasher ??= NoiseHasher();
    return Perlin._(hasher);
  }

  const Perlin._(this._hasher);
  final NoiseHasher _hasher;

  @override
  double get2df(double x, double y) => _perlin2d(Vec2(x, y));

  double _perlin2d(Vec2 point) {
    final corner = point.floorToInt();
    final distance = point - corner.toVec2();

    double gradient(Vec2 offset) {
      final point = distance - offset;
      final ioffset = offset.floorToInt();
      return switch (_hasher.hash((corner + ioffset).toList()) & 0x3) {
        0 => point.x + point.y, //  ( 1, 1)
        1 => -point.x + point.y, // (-1, 1)
        2 => point.x - point.y, //  ( 1,-1)
        3 => -point.x - point.y, // (-1,-1)
        _ => throw StateError('Unreachable'),
      };
    }

    final g00 = gradient(Vec2.v00);
    final g10 = gradient(Vec2.v10);
    final g01 = gradient(Vec2.v01);
    final g11 = gradient(Vec2.v11);

    final curve = distance.map(quinticEase);
    final result = linearInterpolate(
      linearInterpolate(g00, g10, curve.x),
      linearInterpolate(g01, g11, curve.x),
      curve.y,
    );

    // At this point, we should be really damn close to the (-1, 1) range, but
    // some float errors could have accumulated, so let's just clamp the results
    // to (-1, 1) to cut off any outliers and return it.
    return (result * _scaleFactor).clamp(-1.0, 1.0);
  }

  /// Unscaled range of linearly interpolated perlin noise should be
  /// `(-sqrt(N)/2, sqrt(N)/2)` where `N` is the number of dimensions. Need to
  /// invert this value and multiply the unscaled result by the value to get a
  /// scaled range of `(-1, 1)`.
  ///
  /// `1/(sqrt(N)/2)`, `N = 1` -> `2/sqrt(1)`.
  static const _scaleFactor = 2.0 / sqrt2;
}
