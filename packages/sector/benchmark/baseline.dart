/// Benchmarks as a baseline for the performance of the library.
///
/// Creates, iterates, and modifies a 2D grid made with a 1-dimensional [List].
library;

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';

void main() {
  _AllocateGrid().report();
  _IterateGrid().report();
  _AddRowsGrid().report();
}

final class _AllocateGrid extends BenchmarkBase {
  _AllocateGrid() : super('Allocate 80x24 grid');

  late _Grid<int> grid;

  @override
  void run() {
    grid = _Grid<int>.fill(80, 24, 0);
  }
}

final class _IterateGrid extends BenchmarkBase {
  _IterateGrid() : super('Iterate 80x24 grid');

  late _Grid<int> grid;

  @override
  void setup() {
    grid = _Grid<int>.fill(80, 24, 0);
  }

  @override
  void run() {
    var adder = 0;
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        adder += grid.get(x, y);
      }
    }
    if (adder == math.Random().nextInt(1000) + 1) {
      throw StateError('This should never happen');
    }
  }
}

final class _AddRowsGrid extends BenchmarkBase {
  _AddRowsGrid() : super('Removes the top row and adds at bottom');

  late _Grid<int> grid;

  @override
  void setup() {
    grid = _Grid<int>.fill(80, 24, 0);
  }

  @override
  void run() {
    grid._cells.removeRange(0, grid.width);
    grid._cells.addAll(List<int>.filled(grid.width, 0));
  }
}

/// A simple 2D grid implemented with a 1-dimensional [List].
final class _Grid<T> {
  factory _Grid.fill(int width, int height, T fill) {
    final cells = List<T>.filled(width * height, fill, growable: true);
    return _Grid._(cells, width);
  }

  _Grid._(this._cells, this.width);

  /// Cells of the grid.
  final List<T> _cells;

  /// Width of the grid.
  final int width;

  int get height => _cells.length ~/ width;

  T get(int x, int y) {
    return _cells[x + y * width];
  }

  void set(int x, int y, T value) {
    _cells[x + y * width] = value;
  }
}
