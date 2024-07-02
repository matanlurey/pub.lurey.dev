import '../_prelude.dart';
import '../src/naive_grid.dart';

void main() {
  test('returns all columns', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid).height.equals(3);
    check(grid).width.equals(2);
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
    ]);
  });

  test('.first returns the first column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.columns.first).deepEquals([1, 2, 3]);
  });

  test('.first throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.first).throws<StateError>();
  });

  test('.first= sets the first column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.first = [7, 8, 9];
    check(grid.columns).deepEquals([
      [7, 8, 9],
      [4, 5, 6],
    ]);
  });

  test('.first= throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.first = [1, 2, 3]).throws<StateError>();
    check(grid.columns).isEmpty();
  });

  test('.last returns the last column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.columns.last).deepEquals([4, 5, 6]);
  });

  test('.last throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.last).throws<StateError>();
  });

  test('.last= sets the last column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.last = [7, 8, 9];
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.lastWhere returns the last column that satisfies the predicate', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final column = grid.columns.lastWhere((column) => column.first == 4);
    check(column).deepEquals([4, 5, 6]);
  });

  test('.lastWhere returns orElse if no column satisfies the predicate', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final column = grid.columns.lastWhere(
      (column) => column.first == 10,
      orElse: () => [10, 11, 12],
    );
    check(column).deepEquals([10, 11, 12]);
  });

  test('.lastWhere returns orElse if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    final column = grid.columns.lastWhere(
      (column) => column.first == 10,
      orElse: () => [10, 11, 12],
    );
    check(column).deepEquals([10, 11, 12]);
  });

  test('.lastWhere throws if orElse is null and no predicate matches', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      () => grid.columns.lastWhere((column) => column.first == 10),
    ).throws<StateError>();
  });

  test('.last= throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.last = [1, 2, 3]).throws<StateError>();
    check(grid.columns).isEmpty();
  });

  test('.operator[] returns the column at the given index', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.columns[1]).deepEquals([4, 5, 6]);
  });

  test('.operator[] throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(() => grid.columns[2]).throws<RangeError>();
  });

  test('.elementAt is equivalent to operator[]', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.columns.elementAt(1)).deepEquals(grid.columns[1]);
  });

  test('.operator[]= sets the column at the given index', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns[1] = [7, 8, 9];
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.operator[]= throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(() => grid.columns[2] = [7, 8, 9]).throws<RangeError>();
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
    ]);
  });

  test('.insertAt inserts a column at the given index', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [7, 8, 9],
    ]);
    grid.columns.insertAt(1, [4, 5, 6]);
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
  });

  test('.insertAt can insert into an empty grid', () {
    final grid = NaiveListGrid.fromColumns([]);
    grid.columns.insertAt(0, [1, 2, 3]);
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertAt throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
    ]);
    check(() => grid.columns.insertAt(2, [4, 5, 6])).throws<RangeError>();
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertFirst inserts a column at the beginning', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.insertFirst([7, 8, 9]);
    check(grid.columns).deepEquals([
      [7, 8, 9],
      [1, 2, 3],
      [4, 5, 6],
    ]);
  });

  test('.insertFirst can insert into an empty grid', () {
    final grid = NaiveListGrid.fromColumns([]);
    grid.columns.insertFirst([1, 2, 3]);
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertLast inserts a column at the end', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.insertLast([7, 8, 9]);
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
  });

  test('.insertLast can insert into an empty grid', () {
    final grid = NaiveListGrid.fromColumns([]);
    grid.columns.insertLast([1, 2, 3]);
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeAt removes the column at the given index', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    grid.columns.removeAt(1);
    check(grid.columns).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.removeAt throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.removeAt(0)).throws<RangeError>();
  });

  test('.removeAt throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
    ]);
    check(() => grid.columns.removeAt(1)).throws<RangeError>();
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeFirst removes the first column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.removeFirst();
    check(grid.columns).deepEquals([
      [4, 5, 6],
    ]);
  });

  test('.removeFirst throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.removeFirst()).throws<RangeError>();
  });

  test('.removeLast removes the last column', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.columns.removeLast();
    check(grid.columns).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeLast throws if the grid is empty', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(() => grid.columns.removeLast()).throws<RangeError>();
  });

  test('.isEmpty returns true if the grid has no columns', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(grid.columns.isEmpty).isTrue();
  });

  test('.isNotEmpty returns false if the grid has no columns', () {
    final grid = NaiveListGrid.fromColumns([]);
    check(grid.columns.isNotEmpty).isFalse();
  });

  test('.isEmpty returns false if the grid has columns', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
    ]);
    check(grid.columns.isEmpty).isFalse();
  });

  test('.isNotEmpty returns true if the grid has columns', () {
    final grid = NaiveListGrid.fromColumns([
      [1, 2, 3],
    ]);
    check(grid.columns.isNotEmpty).isTrue();
  });
}
