part of '../lodim.dart';

/// An immutable 2D fixed-point vector.
///
/// This class could be used to represent a position in a 2D space, or a size.
///
/// ## Equality
///
/// Two points are considered equal if their [x] and [y] values are equal.
///
/// ## Example
///
/// Creating a position:
///
/// ```dart
/// final pos = Pos(10, 20);
/// ```
///
/// Using pattern matching to extract the x and y values in one statement:
///
/// ```dart
/// final Pos(:x, :y) = pos;
/// ```
@immutable
final class Pos {
  /// Creates a new position with the given x and y offsets.
  @pragma('vm:prefer-inline')
  const Pos(this.x, this.y);

  /// Returns a comparator that sorts positions by distance from the origin.
  ///
  /// The default formula is [euclideanSquared], which produces a value useful
  /// for distances that will be _compared_, but not used as an actual distance;
  /// see also [manhattan] and [chebyshev], or implement your own [Distance].
  ///
  /// ## Example
  ///
  /// To use euclidean distance:
  ///
  /// ```dart
  /// final positions = [Pos(10, 15), Pos(4, 8), Pos(12, 9)];
  /// positions.sort(Pos.byMagnitude());
  /// print(positions); // => [Pos(4, 8), Pos(10, 15), Pos(12, 9)]
  /// ```
  ///
  /// To provide another distance formula:
  ///
  /// ```dart
  /// final positions = [Pos(10, 15), Pos(4, 8), Pos(12, 9)];
  /// positions.sort(Pos.byMagnitude(manhattan));
  /// print(positions); // => [Pos(4, 8), Pos(12, 9), Pos(10, 15)]
  /// ```
  static Comparator<Pos> byMagnitude([Distance formula = euclideanSquared]) {
    return (a, b) => formula(a, Pos.zero).compareTo(formula(b, Pos.zero));
  }

  /// A comparator that sorts positions by row-major order.
  ///
  /// The y-axis is the primary sort key, and the x-axis is the secondary.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final positions = [Pos(10, 15), Pos(4, 8), Pos(12, 9)];
  /// positions.sort(Pos.byRowMajor);
  /// print(positions); // => [Pos(4, 8), Pos(12, 9), Pos(10, 15)]
  /// ```
  static const Comparator<Pos> byRowMajor = _byRowMajor;
  static int _byRowMajor(Pos a, Pos b) {
    return a.y == b.y ? a.x.compareTo(b.x) : a.y.compareTo(b.y);
  }

  /// A comparator that sorts positions by column-major order.
  ///
  /// The x-axis is the primary sort key, and the y-axis is the secondary.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final positions = [Pos(10, 15), Pos(4, 8), Pos(12, 9)];
  /// positions.sort(Pos.byColumnMajor);
  /// print(positions); // => [Pos(4, 8), Pos(10, 15), Pos(12, 9)]
  /// ```
  static const Comparator<Pos> byColumnMajor = _byColumnMajor;
  static int _byColumnMajor(Pos a, Pos b) {
    return a.x == b.x ? a.y.compareTo(b.y) : a.x.compareTo(b.x);
  }

  /// A position with x and y offsets set to zero, often used as the  _origin_.
  static const zero = Pos(0, 0);

  /// The x, or horizontal offset of this position.
  final int x;

  /// The y, or vertical offset of this position.
  final int y;

  /// Returns the distance between `this` and [other].
  ///
  /// The default formula is [euclideanSquared], which produces a value useful
  /// for distances that will be _compared_, but not used as an actual distance.
  /// See also [manhattan] and [chebyshev], or implement your own [Distance].
  ///
  /// To sort positions by using distance from the origin, see [byMagnitude].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a.distanceTo(b, using: euclideanSquared)); // => 500
  /// ```
  @pragma('vm:prefer-inline')
  int distanceTo(Pos other, {Distance using = euclideanSquared}) {
    return using(this, other);
  }

  /// Returns an iterable of positions that draws a line from `this` to [other].
  ///
  /// The default line algorithm is [bresenham], which is a fast and efficient
  /// algorithm for drawing lines between two points in a 2D space. You can also
  /// provide your own [Line].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(0, 0);
  /// final b = Pos(2, 2);
  /// print(a.lineTo(b)); // => [Pos(0, 0), Pos(1, 1), Pos(2, 2)]
  /// ```
  Iterable<Pos> lineTo(
    Pos other, {
    Line using = bresenham,
    bool exclusive = false,
  }) {
    return using(this, other, exclusive: exclusive);
  }

  /// Returns the middle positions between `this` and [other].
  ///
  /// If the two positions have an exact middle, it will return a single
  /// position. If the two positions are not aligned, it will return two
  /// positions that are the closest to the middle.
  ///
  /// ## Example
  ///
  /// Exact middle:
  ///
  /// ```dart
  /// final a = Pos(0, 0);
  /// final b = Pos(4, 4);
  /// print(a.middleOf(b)); // => [Pos(2, 2)]
  /// ```
  ///
  /// Closest middle:
  ///
  /// ```dart
  /// final a = Pos(0, 0);
  /// final b = Pos(3, 3);
  /// print(a.midpoints(b)); // => [Pos(1, 1), Pos(2, 2)]
  /// ```
  List<Pos> midpoints(Pos other) {
    final delta = other - this;

    // Is there an exact midpoint?
    if (delta.x.isEven && delta.y.isEven) {
      return [Pos(x + delta.x ~/ 2, y + delta.y ~/ 2)];
    }

    // Calculate two closest midpoints for odd cases
    final midX = x + delta.x ~/ 2;
    final midY = y + delta.y ~/ 2;
    return [
      Pos(midX, midY),
      Pos(midX + (delta.x.isOdd ? 1 : 0), midY + (delta.y.isOdd ? 1 : 0)),
    ];
  }

  /// Returns this position rotated by 45 degrees [steps] times clockwise.
  ///
  /// The default is to rotate 45 degrees once, but you can rotate multiple
  /// times by providing a different number of [steps], or counter-clockwise by
  /// providing a negative number of steps.
  ///
  /// A 45° rotation is a fixed-point rotation, i.e. it does not use floating
  /// point numbers or `π`, and is derived entirely from integer offsets.
  ///
  /// See [rotate90] for 90° rotations.
  ///
  /// ## Visualizing the rotations
  ///
  /// Imagine the following original position, perhaps at `(3, 2)`:
  ///
  /// ```txt
  /// y
  /// ^
  /// |
  /// |    *
  /// |
  /// O-----> x
  /// ```
  ///
  /// A 45° Clockwise `rotate45()` would move the position to `(5, 0)`:
  ///
  /// ```txt
  /// O-------*> x
  /// ```
  ///
  /// A 135° Clockwise `rotate45(3)` would move the position to `(-5, 0)`:
  /// ```txt
  /// x <*-------O
  /// ```
  ///
  /// A 225° Clockwise `rotate45(5)` would move the position to `(-1, -5)`:
  /// ```txt
  /// x <--o
  ///      |
  ///      |
  ///      |
  ///      |
  ///      |
  ///    * v
  ///      y
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// print(a.rotate45()); // => Pos(20, 10)
  /// print(a.rotate45(2)); // => Pos(10, -20)
  /// print(a.rotate45(-1)); // => Pos(-20, -10)
  /// ```
  Pos rotate45([int steps = 1]) {
    return switch (steps % 8) {
      0 => this,
      1 => Pos(x - y, x + y),
      2 => Pos(-y, x),
      3 => Pos(-x - y, -x + y),
      4 => Pos(-x, -y),
      5 => Pos(y - x, -x - y),
      6 => Pos(y, -x),
      _ => Pos(x + y, y - x),
    };
  }

  /// Returns this position rotated by 90 degrees [steps] times clockwise.
  ///
  /// The default is to rotate 90 degrees once, but you can rotate multiple
  /// times by providing a different number of [steps], or counter-clockwise by
  /// providing a negative number of steps.
  ///
  /// A 90° rotation is a fixed-point rotation, i.e. it does not use floating
  /// point numbers or `π`, and is derived entirely from integer offsets.
  ///
  /// See [rotate45] for 45° rotations.
  ///
  /// ## Visualizing the rotations
  ///
  /// Imagine the following original position, perhaps at `(3, 2)`:
  ///
  /// ```txt
  /// y
  /// ^
  /// |
  /// |    *
  /// |
  /// O-----> x
  /// ```
  ///
  /// A 90° Clockwise `rotate90()` would move the position to `(2, -3)`:
  ///
  /// ```txt
  /// O-----> x
  /// |
  /// |
  /// |  *
  /// v
  /// y
  /// ```
  ///
  /// A 180° Clockwise `rotate90(2)` would move the position to `(-3, -2)`:
  ///
  /// ```txt
  /// x <-----O
  ///         |
  ///    *    |
  ///         |
  ///         v
  ///         y
  /// ```
  ///
  /// And finally, a 270° Clockwise `rotate90(-1)` is `(-2, 3)`:
  ///
  /// ```txt
  ///         y
  ///         ^
  ///      *  |
  ///         |
  ///         |
  /// x <-----O
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// print(a.rotate90()); // => Pos(20, -10)
  /// print(a.rotate90(2)); // => Pos(-10, -20)
  /// print(a.rotate90(-1)); // => Pos(-20, 10)
  /// ```
  Pos rotate90([int steps = 1]) {
    return switch (steps % 4) {
      0 => this,
      1 => Pos(-y, x),
      2 => Pos(-x, -y),
      _ => Pos(y, -x),
    };
  }

  /// Returns this position rotated by 180 degrees.
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(-a.x, -a.y);
  /// ```
  ///
  /// See also [operator-] for the same effect.
  Pos rotate180() => -this;

  /// Returns a new position with the offsets of `this` scaled by [other].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(a.x * other.x, a.y * other.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(2, 3);
  /// print(a.scale(b)); // => Pos(20, 60)
  /// ```
  Pos scale(Pos other) => Pos(x * other.x, y * other.y);

  /// Returns a new position with the absolute value of `this` position.
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(-10, -20);
  /// final b = Pos(a.x.abs(), a.y.abs());
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(-10, -20);
  /// print(a.abs()); // => Pos(10, 20)
  /// ```
  Pos abs() => Pos(x.abs(), y.abs());

  /// Returns a new position with offsets of `this` to the power of [exponent].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(math.pow(a.x, exponent) as int, math.pow(a.y, exponent) as int);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// print(a.pow(2)); // => Pos(100, 400)
  /// ```
  Pos pow(int exponent) {
    return Pos(math.pow(x, exponent) as int, math.pow(y, exponent) as int);
  }

  @override
  bool operator ==(Object other) {
    return other is Pos && x == other.x && y == other.y;
  }

  /// Returns a new position with `this` position negated.
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(-a.x, -a.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// print(-a); // => Pos(-10, -20)
  /// ```
  Pos operator -() => Pos(-x, -y);

  /// Returns a new position with [other]'s offsets added to `this`.
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// final c = Pos(a.x + b.x, a.y + b.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a + b); // => Pos(40, 60)
  /// ```
  Pos operator +(Pos other) => Pos(x + other.x, y + other.y);

  /// Returns a new position with [other]'s offsets subtracted from `this`.
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// final c = Pos(a.x - b.x, a.y - b.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a - b); // => Pos(-20, -20)
  /// ```
  Pos operator -(Pos other) => Pos(x - other.x, y - other.y);

  /// Returns a new position with `this` position multiplied by [scalar].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(a.x * scalar, a.y * scalar);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// print(a * 2); // => Pos(20, 40)
  /// ```
  Pos operator *(int scalar) => Pos(x * scalar, y * scalar);

  /// Returns a new position with `this` position logical-ORed with [other].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// final c = Pos(a.x | b.x, a.y | b.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a | b); // => Pos(30, 60)
  Pos operator |(Pos other) => Pos(x | other.x, y | other.y);

  /// Returns a new position with `this` position logical-ANDed with [other].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// final c = Pos(a.x & b.x, a.y & b.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a & b); // => Pos(10, 0)
  Pos operator &(Pos other) => Pos(x & other.x, y & other.y);

  /// Returns a new position with `this` position logical-XORed with [other].
  ///
  /// This is equivalent to:
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// final c = Pos(a.x ^ b.x, a.y ^ b.y);
  /// ```
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Pos(10, 20);
  /// final b = Pos(30, 40);
  /// print(a ^ b); // => Pos(20, 60)
  /// ```
  Pos operator ^(Pos other) => Pos(x ^ other.x, y ^ other.y);

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Pos($x, $y)';
}
