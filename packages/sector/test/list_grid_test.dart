import 'dart:typed_data';

import 'package:sector/sector.dart';

import '_fixed_grid_suite.dart';
import '_grid_suite.dart';
import '_prelude.dart';
import '_sized_grid_suite.dart';

void main() {
  runGridTests(
    'ListGrid',
    filled: ListGrid.filled,
    from: ListGrid.from,
    generate: ListGrid.generate,
    fromCells: ListGrid.fromCells,
    fromRows: ListGrid.fromRows,
    fromColumns: ListGrid.fromColumns,
    empty: ListGrid.empty,
  );

  runResizableGridTests(
    'ListGrid',
    filled: ListGrid.filled,
    from: ListGrid.from,
    generate: ListGrid.generate,
    fromCells: ListGrid.fromCells,
    fromRows: ListGrid.fromRows,
    fromColumns: ListGrid.fromColumns,
    empty: ListGrid.empty,
  );

  runFixedGridSuite(
    'ListGrid',
    filled: (width, height, value) {
      final buffer = Uint8List(width * height);
      buffer.fillRange(0, buffer.length, value);
      return ListGrid.view(buffer, width: width);
    },
    from: (grid) {
      final buffer = Uint8List(grid.width * grid.height);
      for (var y = 0; y < grid.height; y++) {
        for (var x = 0; x < grid.width; x++) {
          buffer[y * grid.width + x] = grid.get(x, y);
        }
      }
      return ListGrid.view(buffer, width: grid.width);
    },
    generate: (width, height, generator) {
      final buffer = Uint8List(width * height);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          buffer[y * width + x] = generator(x, y);
        }
      }
      return ListGrid.view(buffer, width: width);
    },
    fromCells: (cells, {required width}) {
      final buffer = Uint8List.fromList(cells);
      return ListGrid.view(buffer, width: width);
    },
    fromRows: (rows) {
      final buffer = Uint8List.fromList(rows.expand((row) => row).toList());
      return ListGrid.view(buffer, width: rows.first.length);
    },
    fromColumns: (columns) {
      final buffer = Uint8List(columns.length * columns.first.length);
      for (var y = 0; y < columns.first.length; y++) {
        for (var x = 0; x < columns.length; x++) {
          buffer[y * columns.length + x] = columns[x][y];
        }
      }
      return ListGrid.view(buffer, width: columns.length);
    },
    empty: () {
      return ListGrid.view(Uint8List(0), width: 0);
    },
  );

  test('ListGrid.view throws on invalid width', () {
    check(() => ListGrid.view(Uint8List(10), width: 3)).throws<Error>();
  });
}
