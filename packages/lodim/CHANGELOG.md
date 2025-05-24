<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.1.6+6

- Bumped Dart to `^3.8.0`.

## 0.1.6+5

- Update dependency ranges.

## 0.1.6+4

- Exposed some functions through `package:quirk`.

## 0.1.6+3

- Bumped Dart to `^3.7.0`.

## 0.1.6+2

- Merged into the `pub.luery.dev` monorepo.

## 0.1.6+1

Fixes a mistake where methods were not renamed correctly.

The last release was published for only minutes, so hopefully this is fine!

## 0.1.6

**Features**:

- Added additional functions for checking 1D and 2D collections:

  - `checkRectangular1D` & `assertRectangular1D`
  - `checkRectangular2D` & `assertRectangular2D`

## 0.1.5

**Features**:

- Added top-level functions to perform bulk-`Pos` based operations.

  While this library will not ship a grid implementation, it is no doubt useful
  in the context of `Pos` and `Rect` to be able to make bulk operations on
  grid-like objects using these functions. There are two implementations of
  each function - one that uses callback functions, and one that operates on
  linear memory in row-major order:

  Callback-based | Linear memory
  ---------------|--------------
  `getRect`      | `getRectLinear`
  `fillRect`     | `fillRectLinear`
  `fillRectFrom` | `fillRectFromLinear`
  `copyRect`     | `copyRectLinear`

- Added `checkPositive`, `assertPositive`, and `assertNonNegative` as top-level
  methods to assert that a value is positive (`>= 0`), or non-negative (`> 0`);
  these methods return the value if it passes the check or throws an exception
  otherwise:

  ```dart
  checkPositive(5); // 5
  assertPositive(5); // 5
  assertNonNegative(5); // 5
  ```

- Added `Pos.fromXY` as an inverse of `<Pos>.xy` to create a position from a
  tuple:

  ```dart
  Pos.fromXY(5, 5); // Pos(5, 5)
  ```

- Added `Pos.fromRowMajor` and `Pos.toRowMajor` to convert a position to and
  from a row-major index:

  ```dart
  Pos.fromRowMajor(5, 3, 10); // Pos(5, 3)
  Pos(5, 3).toRowMajor(10); // 35
  ```

- Added `Pos.fromList` as an inverse of `<Pos>.toList` to create a position from
  a list of integers, optionally with a start index:

  ```dart
  Pos.fromList([5, 5]); // Pos(5, 5)
  Pos.fromList([1, 2, 3], 1); // Pos(2, 3)
  ```

  In addition, added `unsafe` variants of these methods that do not check the
  bounds of the list:

  ```dart
  Pos.fromListUnsafe([5, 5]); // Pos(5, 5)
  Pos.fromListUnsafe([1, 2, 3], 1); // Pos(2, 3)
  ```

- Tweaked `<Pos>.toList` to support writing to an existing list instead of
  allocating a new one:

  ```dart
  Pos(5, 5).toList([0, 0], 1); // [0, 5, 5]
  ```

  In addition, added `unsafe` variants of these methods that do not check the
  bounds of the list:

  ```dart
  Pos(5, 5).toListUnsafe([0, 0], 1); // [0, 5, 5]
  ```

**Deprecations**:

- The extension `IntPair` has been deprecated in favor of `Pos.fromXY`:

  ```diff
  - (5, 5).toPos();
  + Pos.fromXY(5, 5);
  ```

- The following functions have been renamed (the originals are deprecated):

  Replacement           | Original
  ----------------------|--------------------
  `distanceSquared`     | `euclideanSquared`
  `distanceApproximate` | `euclideanApproximate`
  `distanceManhattan`   | `manhattan`
  `distanceChebyshev`   | `chebyshev`
  `distanceDiagonal`    | `diagonal`
  `lineBresenham`       | `bresenham`
  `lineVector`          | `vectorLine`
  `<Pos>.lineTo`        | `<Pos>.pathTo`

## 0.1.4

**Features**:

- Added `Rect.size` to get the width and height of a rectangle as a `Pos`:

  ```dart
  Rect.fromLTWH(5, 5, 2, 2).size; // Pos(2, 2)
  ```

## 0.1.3+2

No public API changes.

## 0.1.3+1

No public API changes.

## 0.1.3

**Features**:

- Added optional parameter `size` to `<Pos>.toRect` when converting a position:

  ```dart
  Pos(5, 5).toRect(size: Pos(2, 2)); // Rect.fromLTWH(5, 5, 2, 2)
  ```

- Added `<Pos>.toSize` to convert a position, optionally with an offset:

  ```dart
  Pos(5, 5).toSize(); // Rect.fromLTWH(0, 0, 5, 5)
  Pos(5, 5).toSize(Pos(2, 2)); // Rect.fromLTWH(2, 2, 5, 5)
  ```

- Added `Rect.fromWH` to create a width, height, and optional offset:

  ```dart
  Rect.fromWH(5, 5); // Rect.fromLTWH(0, 0, 5, 5)
  Rect.fromWH(5, 5, Pos(2, 2)); // Rect.fromLTWH(2, 2, 5, 5)
  ```

- Added `<Rect>.normalize()` to convert a rectangle to one with positive width
  and height:

  ```dart
  Rect.fromLTRB(5, 5, 3, 3).normalize(); // Rect.fromLTRB(3, 3, 5, 5)
  Rect.fromLTRB(3, 3, -2, -2).normalize(); // Rect.fromLTRB(-2, -2, 3, 3)
  ```

## 0.1.2

**Features**:

- Added `Pos.truncate` to convert doubles to an integer position:

  ```dart
  Pos.truncate(5.5, 5.5); // Pos(5, 5)
  ```

- Added `Pos.floor` to convert doubles to an integer position, rounding down:

  ```dart
  Pos.floor(5.5, 5.5); // Pos(5, 5)
  ```

- Added `Pos.byDistanceTo` to create a comparator that sorts positions based
  on distance to a given position:

  ```dart
  final comparator = Pos.byDistanceTo(Pos(5, 5));
  [Pos(0, 0), Pos(1, 1), Pos(2, 2)].sort(comparator); // [Pos(2, 2), Pos(1, 1), Pos(0, 0)]
  ```

- Added `<Pos>.map` to apply a function to each component of a position:

  ```dart
  Pos(5, 5).map((x) => x * 2); // Pos(10, 10)
  ```

- Added `<Pos>.toList` to convert a position to a list of integers:

  ```dart
  Pos(5, 5).toList(); // [5, 5]
  ```

- Added `<Pos>.xy` to get the x and y components of a position as a tuple:

  ```dart
  Pos(5, 5).xy; // (5, 5)
  ```

## 0.1.1+1

**Deprecations**:

- Deprecated `Direction.values` in favor of the identical `Direction.all`:

  ```diff
  - for (final dir in Direction.values) {
  + for (final dir in Direction.all) {
  ```

**Misc**:

- Added dartdoc categories for upstream use in `package:sector`.

## 0.1.1

**Features**:

Most new additions were to the `Pos` class:

- Added `vectorLine` as a faster `Line` function (alternative to `bresenham`):

  ```dart
  vectorLine(Pos(0, 0), Pos(2, 2)); // [Pos(0, 0), Pos(1, 1), Pos(2, 2)]
  ```

- Added `diagonal` distance to compliment `manhattan` and `chebyshev` distances:

  ```dart
  Pos(0, 0).distanceTo(Pos(3, 4), diagonal); // 5.0
  ```

- Added `<Pos>.inflate`, which uses the position as the center of a rectangle
  and inflates it by the given delta `Pos` offset:

  ```dart
  Pos(5, 5).inflate(Pos(2, 2)); // Rect.fromLTRB(3, 3, 7, 7)
  ```

- Added `<Pos>.toRect()` to convert a position to a rectangle with a size of
  1x1:

  ```dart
  Pos(5, 5).toRect(); // Rect.fromLTWH(5, 5, 1, 1)
  ```

- Added `<Pos>.max`, `<Pos>.min`, and `<Pos>.clamp` to get the maximum, minimum,
  and clamped position between two positions:

  ```dart
  Pos(5, 5).max(Pos(3, 3)); // Pos(5, 5)
  Pos(5, 5).min(Pos(3, 3)); // Pos(3, 3)
  Pos(5, 5).clamp(Pos(3, 3), Pos(7, 7)); // Pos(5, 5)
  ```

- Added `<Pos>.approximateNormalized`, which returns a new position with the
- same direction but a magnitude _as close as possible_ to 1, which is the best
- possible for fixed-point positions:

  ```dart
  Pos(10, 20).approximateNormalized; // Pos(1, 2)
  ```

- Added `<Pos>.dot` and `<Pos>.cross` to calculate the dot and cross products
  between two positions:

  ```dart
  Pos(1, 2).dot(Pos(3, 4)); // 11
  Pos(1, 2).cross(Pos(3, 4)); // -2
  ```

- Added missing core operators: `~/`, `%`, `~`, `<<`, `>>`.

New changes to the `Rect` class:

- Added `<Rect>.inflate` and `<Rect>.deflate`, which, given a delta `Pos` offset
  inflates or deflates the rectangle by that amount:

  ```dart
  final rect = Rect.fromLTWH(0, 0, 10, 10);
  rect.inflate(Pos(2, 2)); // Rect.fromLTRB(-2, -2, 12, 12)
  rect.deflate(Pos(2, 2)); // Rect.fromLTRB(2, 2, 8, 8)
  ```

Other new features:

- Added a new extension on `(int, int)` to convert a tuple to a `Pos`:

  ```dart
  (5, 5).toPos(); // Pos(5, 5)
  ```

- Added `approximateSqrt`, to calculate the integer square root of a number
  without rounding:

  ```dart
  approximateSqrt(10); // 3
  ```

## 0.1.0

🎉 Initial release 🎉
