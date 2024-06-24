/// Creates, iterates, and modifies the default [Grid] implementation.
library;

import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:sector/sector.dart';

void main() {
  _AllocateGrid().report();
  _IterateGetXYGrid().report();
  _IterateGetXYUncheckedGrid().report();
  _IterateRowsGrid().report();
  _AddRowsGrid().report();
}

final class _AllocateGrid extends BenchmarkBase {
  _AllocateGrid() : super('Allocate 80x24 grid');

  late Grid<int> grid;

  @override
  void run() {
    grid = Grid<int>.filled(80, 24, 0);
  }
}

final class _IterateGetXYGrid extends BenchmarkBase {
  _IterateGetXYGrid() : super('Iterate 80x24 grid using for-loops and get');

  late Grid<int> grid;
  late math.Random random;

  @override
  void setup() {
    grid = Grid<int>.filled(80, 24, 0);
    random = math.Random();
  }

  @override
  void run() {
    var adder = 0;
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        adder += grid.get(x, y);
      }
    }
    if (adder == random.nextInt(1000) + 1) {
      throw StateError('This should never happen');
    }
  }
}

final class _IterateGetXYUncheckedGrid extends BenchmarkBase {
  _IterateGetXYUncheckedGrid()
      : super('Iterate 80x24 grid using for-loops and getUnchecked');

  late Grid<int> grid;
  late math.Random random;

  @override
  void setup() {
    grid = Grid<int>.filled(80, 24, 0);
    random = math.Random();
  }

  @override
  void run() {
    var adder = 0;
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        adder += grid.getUnchecked(x, y);
      }
    }
    if (adder == random.nextInt(1000) + 1) {
      throw StateError('This should never happen');
    }
  }
}

final class _IterateRowsGrid extends BenchmarkBase {
  _IterateRowsGrid() : super('Iterate 80x24 grid using for-loops and rows');

  late Grid<int> grid;
  late math.Random random;

  @override
  void setup() {
    grid = Grid<int>.filled(80, 24, 0);
    random = math.Random();
  }

  @override
  void run() {
    var adder = 0;
    for (final row in grid.rows) {
      for (final cell in row) {
        adder += cell;
      }
    }
    if (adder == random.nextInt(1000) + 1) {
      throw StateError('This should never happen');
    }
  }
}

final class _AddRowsGrid extends BenchmarkBase {
  _AddRowsGrid() : super('Removes the top row and adds at bottom');

  late Grid<int> grid;

  @override
  void setup() {
    grid = Grid<int>.filled(80, 24, 0);
  }

  @override
  void run() {
    grid.rows.removeFirst();
    grid.rows.insertLast(List<int>.filled(grid.width, 0));
  }
}
