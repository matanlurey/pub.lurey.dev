import 'package:sector/sector.dart';

import '_grid_suite.dart';

void main() {
  runSuite(
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
