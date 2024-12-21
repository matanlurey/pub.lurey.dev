part of '../lodim.dart';

/// An arc of a circle equal to one-eigth of its circumference.
///
/// The octants are arranged as follows, with the origin `(0, 0)` at the center
/// of the diagram, where the x-axis and y-axis intersect; each quadrant is
/// further divided into two octants, resulting in a total of eight setions, and
/// numbered counter-clockwise from the top-right corner (`1`):
///
/// ```txt
///       ^ y-axis
///  \  3 | 2  /
///    \  |  /
///   4  \|/  1
/// -------------+ x-axis
///   5  /|\  8
///    /  |  \
///  /  6 | 7  \
/// ```
///
/// See also <https://en.wikipedia.org/wiki/Circular_sector>.
///
/// ## Usage
///
/// This class is provided as a utility for converting points between octants,
/// which is useful when designing algorithms that operate on a 2D coordinate
/// system, such as pathfinding or line-of-sight calculations. For example,
/// it's common to convert a point from it's current octant to the first octant
/// to simplify calculations, and then convert it back to the original octant
/// when the result is needed.
///
/// ## Examples
///
/// ```dart
/// final octant = Octant.from(Pos(0, 0), Pos(2, 2));
/// print(octant); // Octant.first
/// ```
enum Octant {
  /// The first octant, from `0°` to `45°`.
  first,

  /// The second octant, from `45°` to `90°`.
  second,

  /// The third octant, from `90°` to `135°`.
  third,

  /// The fourth octant, from `135°` to `180°`.
  fourth,

  /// The fifth octant, from `180°` to `225°`.
  fifth,

  /// The sixth octant, from `225°` to `270°`.
  sixth,

  /// The seventh octant, from `270°` to `315°`.
  seventh,

  /// The eighth octant, from `315°` to `360°`.
  eighth;

  /// Determines the octant of the angle formed by a line from [start] to [end].
  factory Octant.from(Pos start, Pos end) {
    var delta = end - start;
    var octant = 0;

    // Rotate by 180 degeres.
    if (delta.y < 0) {
      delta = delta.rotate180();
      octant += 4;
    }

    // Rotate clockwise by 90 degrees.
    if (delta.x < 0) {
      delta = delta.rotate90();
      octant += 2;
    }

    // No need to rotate.
    if (delta.x < delta.y) {
      octant += 1;
    }

    return Octant.values[octant];
  }

  /// Converts the provided [position] to the octant's equivalent.
  ///
  /// Given a point `(x, y)` in the first octant, this method will return the
  /// equivalent point in the octant. For example, the point `(2, 3)` in the
  /// first octant is `(3, 2)` in the second octant.
  ///
  /// This method is the inverse of [toOctant1].
  Pos toOctant1(Pos position) {
    final Pos(:x, :y) = position;
    return switch (this) {
      Octant.first => Pos(x, y),
      Octant.second => Pos(y, x),
      Octant.third => Pos(y, -x),
      Octant.fourth => Pos(-x, y),
      Octant.fifth => Pos(-x, -y),
      Octant.sixth => Pos(-y, -x),
      Octant.seventh => Pos(-y, x),
      Octant.eighth => Pos(x, -y),
    };
  }

  /// Converts the provided [position] from the octant's equivalent.
  ///
  /// Given a point `(x, y)` in the octant, this method will return the
  /// equivalent point in the first octant. For example, the point `(3, 2)` in
  /// the second octant is `(2, 3)` in the first octant.
  ///
  /// This method is the inverse of [toOctant1].
  Pos fromOctant1(Pos position) {
    final Pos(:x, :y) = position;
    return switch (this) {
      Octant.first => Pos(x, y),
      Octant.second => Pos(y, x),
      Octant.third => Pos(-y, x),
      Octant.fourth => Pos(-x, y),
      Octant.fifth => Pos(-x, -y),
      Octant.sixth => Pos(-y, -x),
      Octant.seventh => Pos(y, -x),
      Octant.eighth => Pos(x, -y),
    };
  }
}
