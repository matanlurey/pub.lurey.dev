import 'package:checks/checks.dart';
import 'package:sector/sector.dart';

export 'package:checks/checks.dart';
export 'package:sector/sector.dart';
export 'package:test/test.dart' show group, test;

/// Convenience methods for testing [Grid] implementations.
extension GridSubject<T> on Subject<Grid<T>> {
  Subject<int> get width => has((it) => it.width, 'width');

  Subject<int> get height => has((it) => it.height, 'height');

  Subject<bool> get isEmpty => has((it) => it.isEmpty, 'isEmpty');

  Subject<bool> containsXY(int x, int y) {
    return has((it) => it.containsXY(x, y), 'contains($x, $y)');
  }

  Subject<bool> containsXYWH(int x, int y, int width, int height) {
    return has(
      (it) => it.containsXYWH(x, y, width, height),
      'containsXYWH($x, $y, $width, $height)',
    );
  }

  Subject<T> at(int x, int y) {
    return has((it) => it.get(x, y), 'get($x, $y)');
  }

  Subject<GridAxis<T>> get rows => has((it) => it.rows, 'rows');

  Subject<GridAxis<T>> get columns => has((it) => it.columns, 'columns');

  Subject<bool> get isEmptyRows => rows.has((it) => it.isEmpty, 'isEmpty');
}
