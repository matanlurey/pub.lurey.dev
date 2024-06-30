import 'package:sector/sector.dart';

import '_prelude.dart';

void runFixedGridSuite(
  String testing, {
  required Grid<int> Function(
    int width,
    int height,
    int fill,
  ) filled,
  required Grid<int> Function(
    int width,
    int height,
    int Function(int x, int y),
  ) generate,
  required Grid<int> Function(
    List<int> cells, {
    required int width,
  }) fromCells,
  required Grid<int> Function(
    List<List<int>> rows,
  ) fromRows,
  required Grid<int> Function(
    List<List<int>> columns,
  ) fromColumns,
  required Grid<int> Function(
    Grid<int> grid,
  ) from,
  required Grid<int> Function() empty,
}) {
  test('<$testing>.clear should fail', () {
    final grid = filled(2, 2, 0);
    check(grid.clear).throws<UnsupportedError>();
  });

  test('<$Rows>.insertAt should fail', () {
    final grid = filled(2, 2, 0);
    check(() => grid.rows.insertAt(0, [0, 0])).throws<UnsupportedError>();
  });

  test('<$Columns>.insertAt should fail', () {
    final grid = filled(2, 2, 0);
    check(() => grid.columns.insertAt(0, [0, 0])).throws<UnsupportedError>();
  });

  test('<$Rows>.removeAt should fail', () {
    final grid = filled(2, 2, 0);
    check(() => grid.rows.removeAt(0)).throws<UnsupportedError>();
  });

  test('<$Columns>.removeAt should fail', () {
    final grid = filled(2, 2, 0);
    check(() => grid.columns.removeAt(0)).throws<UnsupportedError>();
  });
}
