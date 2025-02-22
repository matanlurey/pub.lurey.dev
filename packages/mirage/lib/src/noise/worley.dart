import 'dart:math';

import 'package:mirage/mirage.dart';

/// A [worley noise][] generator.
///
/// [worley noise]: https://en.wikipedia.org/wiki/Worley_noise
///
/// Creates patterns based on distances to a set of randomly distributed points.
/// Results in a bumpy or "cellular" appearance, with sharp transitions between
/// regions. Useful for creating textures, terrain, or other patterns like
/// cracked surfaces, clouds with gaps, or speckled patterns, or cave-like
/// systems or dungeon layouts with roosm and corridors.
///
/// Can be computationally expensive, especially with many points or large
/// regions, and requires tuning parameters like the number of points to achieve
/// desired results.
final class Worley with Pattern2d {
  /// Euclidean distance function.
  static double euclidean(Vec2 x, Vec2 y) {
    final diff = x - y;
    final result = sqrt((diff.x * diff.x + diff.y * diff.y).abs());
    return result;
  }

  /// Creates a new worley noise generator that returns the value of the
  /// nearest point.
  ///
  /// If a [hasher] is not provided, [NoiseHasher.new] is used.
  ///
  /// The [distance] function can be used to calculate the distance between two
  /// points. The default is the Euclidean distance.
  ///
  /// The [frequency] can be used to scale the distance between points. The
  /// default is 1.0.
  ///
  /// ![Example](https://github.com/user-attachments/assets/61475af8-1b95-4123-978a-b287cf3213c3)
  factory Worley.value({
    NoiseHasher? hasher,
    double Function(Vec2 x, Vec2 y) distance = euclidean,
    double frequency = 1.0,
  }) {
    hasher ??= NoiseHasher();
    return Worley._(hasher, distance, frequency, _ReturnType.value);
  }

  /// Creates a new worley noise generator that returns the distance to the
  /// nearest point.
  ///
  /// If a [hasher] is not provided, [NoiseHasher.new] is used.
  ///
  /// The [distance] function can be used to calculate the distance between two
  /// points. The default is the Euclidean distance.
  ///
  /// The [frequency] can be used to scale the distance between points. The
  /// default is 1.0.
  ///
  /// ![Example](https://github.com/user-attachments/assets/234d1f60-238c-438c-8c27-407140309b6d)
  factory Worley.distance({
    NoiseHasher? hasher,
    double Function(Vec2 x, Vec2 y) distance = euclidean,
    double frequency = 1.0,
  }) {
    hasher ??= NoiseHasher();
    return Worley._(hasher, distance, frequency, _ReturnType.distance);
  }

  const Worley._(
    this._hasher,
    this._distance,
    this._frequency,
    this._returnType,
  );
  final NoiseHasher _hasher;
  final double Function(Vec2 x, Vec2 y) _distance;
  final double _frequency;
  final _ReturnType _returnType;

  @override
  double get2df(double x, double y) {
    return _worley2d(Vec2(x, y).scale(_frequency));
  }

  double _worley2d(Vec2 point) {
    final cell = point.floorToInt();
    final floor = Vec2.fromInts(cell.x, cell.y);
    final frac = point - floor;

    final near = IVec2(frac.x < 0.5 ? 0 : 1, frac.y < 0.5 ? 0 : 1) + cell;
    final far = IVec2(frac.x < 0.5 ? 1 : 0, frac.y < 0.5 ? 1 : 0) + cell;

    final seedIndex = _hasher.hash(near.toList());
    final seedPoint = _getPoint(seedIndex, near);

    var seedCell = near;
    var distance = _distance(point, seedPoint);

    final range = Vec2(
      pow(0.5 - frac.x, 2).toDouble(),
      pow(0.5 - frac.y, 2).toDouble(),
    );

    void testPoint(IVec2 testPoint) {
      final index = _hasher.hash(testPoint.toList());
      final test = _getPoint(index, testPoint);
      final testDistance = _distance(point, test);
      if (testDistance < distance) {
        distance = testDistance;
        seedCell = testPoint;
      }
    }

    if (range.x < distance) {
      testPoint(IVec2(far.x, near.y));
    }

    if (range.y < distance) {
      testPoint(IVec2(near.x, far.y));
    }

    if (range.x < distance && range.y < distance) {
      testPoint(IVec2(far.x, far.y));
    }

    final value = switch (_returnType) {
      _ReturnType.distance => distance,
      _ReturnType.value => _hasher.hash(seedCell.toList()) / 255.0,
    };

    return value * 2.0 - 1.0;
  }

  static Vec2 _getPoint(int index, IVec2 point) {
    return _getVec2(index) + point.toVec2();
  }

  static Vec2 _getVec2(int index) {
    final length = ((index & 0xF8) >> 3) * 0.5 / 31.0;
    final diag = length * sqrt1_2;
    return switch (index & 0x7) {
      0 => Vec2(diag, diag),
      1 => Vec2(diag, -diag),
      2 => Vec2(-diag, diag),
      3 => Vec2(-diag, -diag),
      4 => Vec2(length, 0.0),
      5 => Vec2(-length, 0.0),
      6 => Vec2(0.0, length),
      7 => Vec2(0.0, -length),
      _ => throw StateError('Unreachable'),
    };
  }
}

enum _ReturnType { distance, value }
