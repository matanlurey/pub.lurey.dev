import 'dart:typed_data';

import 'package:sector/sector.dart';

import '_fixed_grid_suite.dart';
import '_grid_suite.dart';
import '_prelude.dart';

void main() {
  runGridTests(
    'Uint8Grid',
    filled: Uint8Grid.filled,
    from: Uint8Grid.from,
    generate: Uint8Grid.generate,
    fromCells: Uint8Grid.fromCells,
    fromRows: Uint8Grid.fromRows,
    fromColumns: Uint8Grid.fromColumns,
    empty: Uint8Grid.empty,
  );

  runFixedGridSuite(
    'Uint8Grid',
    filled: Uint8Grid.filled,
    generate: Uint8Grid.generate,
    fromCells: Uint8Grid.fromCells,
    fromRows: Uint8Grid.fromRows,
    fromColumns: Uint8Grid.fromColumns,
    from: Uint8Grid.from,
    empty: Uint8Grid.empty,
  );

  test('$Uint8List.filled can default to non-zero', () {
    final grid = Uint8Grid.filled(2, 2, 1);
    check(grid).rows.deepEquals([
      [1, 1],
      [1, 1],
    ]);
  });

  test('asBytes() returns underlying store', () {
    final list = Uint8List(4);
    final grid = Uint8Grid.withBytes(list, width: 2);
    check(grid).has((g) => g.asBytes(), 'asBytes()').identicalTo(list);
  });
}
