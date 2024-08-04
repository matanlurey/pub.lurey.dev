import 'package:mirage/mirage.dart';

/// A [value noise][] generator.
///
/// [value noise]: https://en.wikipedia.org/wiki/Value_noise
///
/// Generates random values at grid points and interpolates between them for
/// smoother results. Produces more organic-looking patterns compared to
/// [White] noise, but can still appear rather blocky; still rather fast to
/// compute.
///
/// Ideal for terrain generation, clouds, and other natural looking patterns,
/// but can exhibit visible grid artifacts due to linear interpolation, and is
/// considered less smooth than [Perlin] or [Simplex] noise.
///
/// ![Example](https://github.com/user-attachments/assets/6c93d6d0-67d1-4bb9-a8fc-6cc00b451a5c)
final class Value with Pattern2d {
  /// Creates a new value noise generator.
  ///
  /// If a [hasher] is not provided, a [NoiseHasher.new] is used.
  factory Value([NoiseHasher? hasher]) {
    hasher ??= NoiseHasher();
    return Value._(hasher);
  }

  const Value._(this._hasher);
  final NoiseHasher _hasher;

  @override
  double get2d(int x, int y) => _value2d(Vec2.fromInts(x, y));

  double _value2d(Vec2 point) {
    final corner = point.floor();
    final weight = corner.map(quinticEase);

    final f00 = _get2d(offset: Vec2.v00, corner: corner);
    final f10 = _get2d(offset: Vec2.v10, corner: corner);
    final f01 = _get2d(offset: Vec2.v01, corner: corner);
    final f11 = _get2d(offset: Vec2.v11, corner: corner);

    final result = linearInterpolate(
      linearInterpolate(f00, f10, weight.x),
      linearInterpolate(f01, f11, weight.x),
      weight.y,
    );

    return result * 2.0 - 1.0;
  }

  double _get2d({required Vec2 offset, required Vec2 corner}) {
    final position = (offset + corner).floorToInt();
    return _hasher.hash(position.toList()) / 255.0;
  }
}
