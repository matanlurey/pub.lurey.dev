/// _Fast pixel accurate_ fixed-point 2D geometry with minimum approximations.
///
/// ## Usage
///
/// Most of the library is built around [Pos], a fixed-point (integer-based) 2D
/// vector class. It's used to represent positions, directions, distances, and
/// offsets in a 2D space:
///
/// ```dart
/// // Creating a position at (4, 2).
/// final pos = Pos(4, 2);
///
/// // Adding two positions.
/// final other = Pos(1, 3);
/// print(pos + other); // => Pos(5, 5)
///
/// // Negating a position.
/// print(-pos); // => Pos(-4, -2)
///
/// // Calculating the distance between two positions.
/// final a = Pos(10, 20);
/// final b = Pos(30, 40);
/// print(a.distanceTo(b, using: euclideanSquared)); // => 500
///
/// // Rotating a position.
/// final rotated = pos.rotate90();
/// print(rotated); // => Pos(-2, 4)
/// ```
///
/// ### Directions
///
/// [Direction] is a specialization of [Pos] with a fixed set of 8 directions;
/// either [Direction.ordinal] (horizontal/vertical), [Direction.cardinal]
/// (diagonal), or [Direction.all] (all 8 directions), with useful constants:
///
/// ```dart
/// // Getting the direction to the right.
/// print(Direction.right); // => Pos(1, 0)
///
/// // Moving a rotation with a direction.
/// final pos = Pos(4, 2);
/// final direction = Direction.right;
/// print(pos + direction); // => Pos(5, 2)
///
/// // Or, multiple times.
/// print(pos + direction * 3); // => Pos(7, 2)
/// ```
///
/// ### Rectangles
///
/// [Rect] is a rectangle class, similar to [Pos], but with a width and height
/// (or bottom-right corner) instead of a single point; useful for representing
/// areas, sizes, and ranges, also in fixed-point (integer-based) 2D spaces:
///
/// ```dart
/// // Creating a rectangle at (4, 2) with a size of 3x2.
/// final rect = Rect.fromLTRB(4, 2, 7, 4);
/// print(rect.topLeft); // => Pos(4, 2)
/// print(rect.bottomRight); // => Pos(7, 4)
/// print(rect.width); // => 3
/// print(rect.height); // => 2
/// ```
///
/// Similarily, additional methods exist for common operations:
///
/// ```dart
/// // Checking if a position is inside a rectangle.
/// final pos = Pos(5, 3);
/// print(rect.contains(pos)); // => true
///
/// // Getting the intersection of two rectangles.
/// final other = Rect.fromLTRB(6, 3, 8, 5);
/// print(rect.intersect(other)); // => Rect.fromLTRB(6, 3, 7, 4)
///
/// // Iterating over all edges of a rectangle.
/// for (final edge in rect.edges) {
///   print(edge); // => Pos(x, y)
/// }
/// ```
library;

import 'dart:math' as math;

import 'package:lodim/src/path/line_bresenham.dart';
import 'package:meta/meta.dart';
import 'package:quirk/quirk.dart';

export 'package:lodim/src/path/line_bresenham.dart';
export 'package:lodim/src/path/line_vector.dart';
export 'package:quirk/quirk.dart'
    show assertNonNegative, assertPositive, checkNonNegative, checkPositive;

part 'src/check.dart';
part 'src/direction.dart';
part 'src/distance.dart';
part 'src/grid.dart';
part 'src/path.dart';
part 'src/math.dart';
part 'src/octant.dart';
part 'src/pos.dart';
part 'src/rect.dart';

/// Whether the runtime is JS (Dart2JS or DDC).
const _isJs = identical(1, 1.0);

/// A pragma hint requesting the compiler to inline the annotated function.
const _pragmaInline =
    _isJs //
        ? pragma('dart2js:prefer-inline')
        : pragma('vm:prefer-inline');

/// A pragma hint requesting the compiler to specialize the annotated function.
const _pragmaSpecialize =
    _isJs //
        ? pragma('dart2js:prefer-inline')
        : pragma('vm:always-consider-inlining');

/// A pragma hint requesting the compiler to omit array bounds checks.
const _pragmaOmitBoundsChecks =
    _isJs //
        ? pragma('dart2js:index-bounds:trust')
        : pragma('vm:unsafe:no-bounds-checks');
