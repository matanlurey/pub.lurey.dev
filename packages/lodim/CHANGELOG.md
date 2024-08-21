# Changelog

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
