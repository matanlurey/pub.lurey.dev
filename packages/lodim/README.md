# lodim

_Fast_ and _pixel accurate_ fixed-point 2D geometry without approximations.

[![CI](https://github.com/matanlurey/lodim/actions/workflows/ci.yaml/badge.svg)](https://github.com/matanlurey/lodim/actions/workflows/ci.yaml)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/lodim/badge.svg?branch=main)](https://coveralls.io/github/matanlurey/lodim?branch=main)
[![Pub Package](https://img.shields.io/pub/v/lodim.svg)](https://pub.dev/packages/lodim)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/lodim/latest/)

Optimal for the following use cases:

- 2D game development that uses tile-based or grid-based rendering.
- Graphic rendering of pixel art or other fixed-point rasterized graphics.
- Fixed-point geometry for performance or consistency reasons.

## Features

Use `lodim` to quickly work with 2D geometry in a fixed-point space:

- **Fixed-point**: All values and results are _always_ integers.
- **Fast**: AOT and JIT benchmarked on the Dart VM.
- **Pixel accurate**: Minimal[^1] ambiguity or hidden rounding errors.
- **Ergonomics**: Familiar API to `dart:ui` (and similar) for ease of use.
- **Cross-platform**: Works on all Dart platforms, including Flutter and web.

[^1]: `lodim` does provide some algorithms that make approximations, such as
      `<Pos>.lineTo`, which uses [Bresenham's line algorithm][bresenham].
      However, all of these algorithms are cleanly defined and documented, and
      allow user-defined overrides.

[bresenham]: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm

## Usage

Just add a dependency in your `pubspec.yaml` or run the following command:

```bash
dart pub add lodim
```

If you've used another 2D geometry library, such as [`dart:ui`][dart_ui] from
Flutter, you will find `lodim` to be very similar. Work with similar types such
as `Pos` (i.e. `Offset`) and `Rect`:

[dart_ui]: https://api.flutter.dev/flutter/dart-ui/dart-ui-library.html

```dart
// Creates a (x, y) position.
final pos = Pos(10, 20);

// Creates a rectangle.
final rect = Rect.fromLTWH(0, 0, 100, 100);
```

Take advantage of tested and benchmarked common operations:

```dart
// Rotate a position by 135 degrees counter-clockwise.
final rotated = pos.rotate45(-3);

// Get the intersection of two rectangles.
final intersection = rect.intersect(a, b);
```

Use built-in algorithms for common tasks, or define your own:

```dart
// Determine the distance between two positions.
final distance = pos1.distanceTo(pos2);

// Use another algorithm to determine the distance or define your own.
final manhattan = pos1.distanceTo(pos2, using: manhattan);

// Draw a line from one position to another.
final line = pos1.lineTo(pos2);

// Use your own algorithm to draw a line.
final custom = pos1.lineTo(pos2, using: someOtherAlgorithm);
```

## Benchmarks

To run the benchmarks, run:

```shell
dart run benchmark/benchmark.dart

# Or, to use AOT:
dart compile exe benchmark/benchmark.dart
./benchmark/benchmark.exe

# Or, to profile using devtools:
dart run --pause-isolates-on-start --observe benchmark/benchmark.dart
```

In local benchmarks on a M2 Macbook Pro, compared to [baseline][^2] code.

[^2]: What users might write themselves, using `(int, int)` tuples or similar.

**JIT**:

| Benchmark                  | `lodim`      | Baseline    | Delta  |
| -------------------------- | ------------ | ----------- | ------ |
| 10k allocations positions  | 479.8 us     | 362.9 us    | -25%   |
| 10k euclidian distance     | 138.3 us     | 153.5 us    | +11%   |
| 10k rotations in 45° steps | 6875.8 us    | 13658.7 us  | +98%   |
| 10k lines drawn            | 1340049.5    | -           | -      |

**AOT**:

| Benchmark                  | `lodim`      | Baseline    | Delta  |
| -------------------------- | ------------ | ----------- | ------ |
| 10k allocations positions  | 342.7 us     | 463.9 us    | +35%   |
| 10k euclidian distance     | 139.7 us     | 132.7 us    | -5%    |
| 10k rotations in 45° steps | 5858.2 us    | 11708.0 us  | +100%  |
| 10k lines drawn            | 1333651.0 us | -           | -      |

**tl;dr**: `lodim` is _faster_ than baseline code, using both JIT and AOT.
Specializing based on fixed-point geometry allows for optimizations that are
not possible with general-purpose code, such as jump-table based rotations.

## Contributing

To run the tests, run:

```shell
dart test
```

To check code coverage locally, run:

```shell
dart tool/coverage.dart
```

To preview `dartdoc` output locally, run:

```shell
dart tool/dartdoc.dart
```
