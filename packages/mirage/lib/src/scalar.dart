import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:mirage/mirage.dart';

/// A fixed-size association of a 2D point to a value.
///
/// This type can be used to efficiently store the results of a noise function,
/// but is not intended to be used as a general-purpose 2D array.
///
/// ## Example
///
/// To create from a function:
///
/// ```dart
/// final map = ScalarField.generate(256, 256, (x, y) {
///   return noise2d(x / 256, y / 256);
/// });
/// ```
///
/// Or from a pattern:
///
/// ```dart
/// final map = ScalarField.fromPattern(256, 256, Checkerboard.even.get2d);
/// ```
final class ScalarField {
  /// Generates a new noise map with the given dimensions and initial contents.
  ///
  /// The [generator] function is called for each cell in the map, and the
  /// result is stored in the map.
  factory ScalarField.generate(
    int width,
    int height,
    double Function(int x, int y) generator,
  ) {
    final map = ScalarField(width, height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        map.setUnchecked(x, y, generator(x, y));
      }
    }
    return map;
  }

  /// Generates a new noise map with the given dimensions and initial contents.
  ///
  /// The [value] is used to fill the entire map.
  factory ScalarField.filled(int width, int height, double value) {
    final map = ScalarField(width, height);
    map._values.fillRange(0, map._values.length, value);
    return map;
  }

  /// Generates a new noise map from [other].
  ///
  /// The new map will have the same dimensions and values as [other].
  factory ScalarField.from(ScalarField other) {
    final map = ScalarField(other.width, other.height);
    map._values.setAll(0, other._values);
    return map;
  }

  /// Creates a new noise map with the given dimensions.
  ///
  /// Both [width] and [height] must be non-negative.
  ScalarField(this.width, this.height) : _values = Float64List(width * height);
  final Float64List _values;

  /// Width of the map.
  final int width;

  /// Height of the map.
  final int height;

  /// Returns a clone of this map with the same dimensions and values.
  ScalarField clone() => ScalarField.from(this);

  /// An unmodifiable view of the values in the map in row-major order.
  ///
  /// This list is a view of the internal data, and changes to the map will be
  /// reflected in the list.
  late final List<double> values = _values.asUnmodifiableView();

  /// Returns the value at the given coordinates.
  ///
  /// [x] and [y] must be within the bounds of the map.
  double get(int x, int y) {
    RangeError.checkValueInInterval(x, 0, width - 1, 'x');
    RangeError.checkValueInInterval(y, 0, height - 1, 'y');
    return getUnchecked(x, y);
  }

  /// Returns the value at the given coordinates.
  ///
  /// If [x] or [y] are out of bounds, the behavior is undefined.
  double getUnchecked(int x, int y) => _values[y * width + x];

  /// Sets the value at the given coordinates.
  ///
  /// [x] and [y] must be within the bounds of the map.
  void set(int x, int y, double value) {
    RangeError.checkValueInInterval(x, 0, width - 1, 'x');
    RangeError.checkValueInInterval(y, 0, height - 1, 'y');
    setUnchecked(x, y, value);
  }

  /// Sets the value at the given coordinates.
  ///
  /// If [x] or [y] are out of bounds, the behavior is undefined.
  void setUnchecked(int x, int y, double value) {
    _values[y * width + x] = value;
  }

  /// Writes the bytes of the map to the given [buffer] at the given [offset].
  ///
  /// The [buffer] must be large enough to hold the entire map.
  void writeBytes(ByteData buffer, [int offset = 0]) {
    for (var i = 0; i < _values.length; i++) {
      buffer.setFloat64(offset + i * 8, _values[i]);
    }
  }

  /// Returns a comparison of [other] compared to this map.
  ///
  /// This method is intended to be used in testing or debugging.
  ScalarFieldComparison compare(ScalarField other) {
    if (width != other.width || height != other.height) {
      throw ArgumentError('Maps must have the same dimensions');
    }
    final delta = Float64List(width * height);
    for (var i = 0; i < _values.length; i++) {
      delta[i] = _values[i] - other._values[i];
    }
    return ScalarFieldComparison.none(width, height).._delta.setAll(0, delta);
  }
}

/// A comparison of two noise maps.
@immutable
final class ScalarFieldComparison {
  /// Creates a comparison that is considered no difference, or exactly equal.
  ScalarFieldComparison.none(
    this.width,
    this.height,
  ) : _delta = Float64List(width * height);

  /// Width of the maps being compared.
  final int width;

  /// Height of the maps being compared.
  final int height;

  /// Differences between the two maps.
  ///
  /// Each value is the difference between the corresponding values in the two
  /// maps, in row-major order. If the values are equal, each difference will
  /// be exactly `0.0`.
  ///
  /// This list is unmodifiable.
  late final Float64List delta = _delta.asUnmodifiableView();
  final Float64List _delta;

  /// Returns `true` if the maps are considered equal within the given
  /// [tolerance].
  bool isCloseTo({required double tolerance}) {
    for (var i = 0; i < _delta.length; i++) {
      if (_delta[i].abs() > tolerance) {
        return false;
      }
    }
    return true;
  }
}

/// Creates a [ScalarField] that represents a flat plane of [width] by [height].
///
/// Useful for creating simple terrain or textures where the underlying
/// surface is flat.
///
/// Plane maps aer sthe simplest and most intuitive way to apply noise to a
/// 2D grid, and can represent the heightmap of a terrain, where each noise
/// value cooresponds to the elevation of a point on the map, or to define the
/// layout of a dungeon, where different noise values represent different types
/// of tiles (e.g. walls, floors, doors, etc), or any other procedural content.
///
/// ## Configuration
///
/// May optionally provide [xBounds] and [yBounds] to specify the range of
/// coordinates that the plane should cover. By default, the plane will cover
/// the range `(-1.0, 1.0)` in both dimensions.
///
/// If [seamless] is `true`, the plane will be seamless, meaning that the
/// edges of the plane will wrap around to the opposite side. This is useful
/// for creating tileable textures or terrain.
///
/// ## Example
///
/// ```dart
/// final map = buildFlatPlane(256, 256, (x, y) {
///   return noise2d(x / 256, y / 256);
/// });
/// ```
///
/// Or to use a [Pattern2d]:
///
/// ```dart
/// final map = buildFlatPlane(256, 256, Checkerboard.even.get2d);
/// ```
ScalarField buildFlatPlane(
  int width,
  int height,
  double Function(double x, double y) generator, {
  (double, double) xBounds = (-1.0, 1.0),
  (double, double) yBounds = (-1.0, 1.0),
  bool seamless = false,
}) {
  // Create a new empty map.
  final result = ScalarField(width, height);

  // Determine the X and Y extent.
  final xExtent = xBounds.$2 - xBounds.$1;
  final yExtent = yBounds.$2 - yBounds.$1;

  /// Determine the X and Y step size.
  final xStep = xExtent / width;
  final yStep = yExtent / height;

  for (var y = 0; y < height; y++) {
    final currentY = yBounds.$1 + y * yStep;
    for (var x = 0; x < width; x++) {
      final currentX = xBounds.$1 + x * xStep;

      final double value;
      if (seamless) {
        final swValue = generator(currentX, currentY);
        final seValue = generator(currentX + xExtent, currentY);
        final nwValue = generator(currentX, currentY + yExtent);
        final neValue = generator(currentX + xExtent, currentY + yExtent);

        final xBlend = 1.0 - (currentX - xBounds.$1) / xExtent;
        final yBlend = 1.0 - (currentY - yBounds.$1) / yExtent;

        final y0 = linearInterpolate(swValue, seValue, xBlend);
        final y1 = linearInterpolate(nwValue, neValue, xBlend);

        value = linearInterpolate(y0, y1, yBlend);
      } else {
        value = generator(currentX, currentY);
      }

      assert(
        value.isFinite,
        'Value generated at ($x, $y) ($value) is not finite',
      );
      result.setUnchecked(x, y, value);
    }
  }

  return result;
}
