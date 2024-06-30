import 'package:sector/sector.dart';

import '_grid_suite.dart';
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
}
