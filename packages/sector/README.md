# Sector

A 🔥 _fast_ (benchmarked) and 👍🏼 _intuitive_ (idiomatic) 2D Grid API.

[![CI](https://github.com/matanlurey/sector/actions/workflows/ci.yaml/badge.svg)](https://github.com/matanlurey/sector/actions/workflows/ci.yaml)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/sector/badge.svg?branch=main)](https://coveralls.io/github/matanlurey/sector?branch=main)
[![Pub Package](https://img.shields.io/pub/v/sector.svg)](https://pub.dev/packages/sector)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/sector/latest/)

![Demo](https://github.com/matanlurey/sector/assets/168174/259a0d08-8a7c-4830-beb9-491fc1ea47d9)

## Getting Started

Add a dependency in your `pubspec.yaml` or run the following command:

```bash
dart pub add sector
```

### Usage

`Grid` is the 2-dimensional equivalent of a `List` in Dart:

```dart
// Create a 2D grid with 80 columns and 24 rows filled with spaces.
final grid = Grid.filled(80, 24, ' ');
```

```dart
// Create a 2D grid from an existing 2D matrix-like collection.
final grid = Grid.fromRows([
  [' ', '#', '#', ' '],
  [' ', ' ', '#', ' '],
  [' ', ' ', ' ', ' '],
]);
```

Check the bounds, `get`, and `set` elements:

```dart
// Check if a point is within the bounds of the grid.
if (grid.containsXY(0, 0)) {
  // ...
}

// Get the element at a point.
final element = grid.get(0, 0);

// Set the element at a point.
grid.set(0, 0, '#');
```

Iterate over the grid with `rows` and `columns`:

```dart
// Iterate over the rows of the grid.
for (final row in grid.rows) {
  // ...
}
```

```dart
// Expand or shrink the grid on demand.
grid.rows.insertFirst(['#', '#', '#', '#']);
```

## Features

- Platform _independent_, works on the Web, Flutter, and Dart VM.
- *Idiomatic*ally Dart, with a familiar and fully documented API.
- _Extensible_, with a focus on performance and ergonomics.
- _Well-tested_, with 100% code coverage and property-based tests.
- _Lightweight_, with zero dependencies, minimal overhead, and benchmarked.

### Benchmarks

For a data structure like a `Grid`, it will almost always be faster to
hand-write an optimal repsentation for your specific use case. However,
`sector` is designed to be a general-purpose 2D grid that is fast enough
for most applications.

[Compared to a baseline implementation](./benchmark/README.md), `Grid` is
roughly the _same speed_ as a hand-optimized implementation, in JIT and AOT
modes (within <1% difference).

> [!NOTE]
> Results on my personal M2 Macbook Pro, your mileage may vary.

#### Baseline

```sh
$ dart run ./benchmark/baseline.dart
Allocate 80x24 grid(RunTime): 16.06649213472959 us.
Iterate 80x24 grid(RunTime): 19.974587703298372 us.
Removes the top row and adds at bottom(RunTime): 36.68761446674683 us.

$ dart compile exe ./benchmark/baseline.dart
$ ./benchmark/baseline.exe
Allocate 80x24 grid(RunTime): 13.26583125 us.
Iterate 80x24 grid(RunTime): 19.46614307164082 us.
Removes the top row and adds at bottom(RunTime): 41.7737068469836 us.
```

#### Grid

```sh
$ dart run ./benchmark/list_grid.dart
Allocate 80x24 grid(RunTime): 15.735960664285184 us.
Iterate 80x24 grid using for-loops and rows(RunTime): 19.53493233680822 us.
Removes the top row and adds at bottom(RunTime): 41.14004523902736 us.

$ dart compile exe ./benchmark/list_grid.dart
$ ./benchmark/list_grid.exe
Allocate 80x24 grid(RunTime): 13.095811723035522 us.
Iterate 80x24 grid using for-loops and rows(RunTime): 20.751487810640235 us.
Removes the top row and adds at bottom(RunTime): 40.39716505669887 us.
```

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
