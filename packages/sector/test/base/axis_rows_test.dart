import '../_prelude.dart';
import '../src/naive_grid.dart';

void main() {
  test('returns all rows', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
  });

  test('.first returns the first row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.rows.first).deepEquals([1, 2, 3]);
  });

  test('.first throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.first).throws<StateError>();
  });

  test('.first= sets the first row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.first = [7, 8, 9];
    check(grid.rows).deepEquals([
      [7, 8, 9],
      [4, 5, 6],
    ]);
  });

  test('.first= throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.first = [1, 2, 3]).throws<StateError>();
    check(grid.rows).isEmpty();
  });

  test('.last returns the last row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.rows.last).deepEquals([4, 5, 6]);
  });

  test('.last throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.last).throws<StateError>();
  });

  test('.last= sets the last row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.last = [7, 8, 9];
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.last= throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.last = [1, 2, 3]).throws<StateError>();
    check(grid.rows).isEmpty();
  });

  test('.lastWhere returns the last column that satisfies the predicate', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final row = grid.rows.lastWhere((row) => row.first == 4);
    check(row).deepEquals([4, 5, 6]);
  });

  test('.lastWhere returns orElse if no column satisfies the predicate', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final row = grid.rows.lastWhere(
      (row) => row.first == 10,
      orElse: () => [10, 11, 12],
    );
    check(row).deepEquals([10, 11, 12]);
  });

  test('.lastWhere returns orElse if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    final row = grid.rows.lastWhere(
      (row) => row.first == 10,
      orElse: () => [10, 11, 12],
    );
    check(row).deepEquals([10, 11, 12]);
  });

  test('.lastWhere throws if orElse is null and no predicate matches', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      () => grid.rows.lastWhere((row) => row.first == 10),
    ).throws<StateError>();
  });

  test('.operator[] returns the row at the given index', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.rows[1]).deepEquals([4, 5, 6]);
  });

  test('.operator[] throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(() => grid.rows[2]).throws<RangeError>();
  });

  test('.elementAt is equivalent to operator[]', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.rows.elementAt(1)).deepEquals(grid.rows[1]);
  });

  test('.operator[]= sets the row at the given index', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows[1] = [7, 8, 9];
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.operator[]= throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(() => grid.rows[2] = [7, 8, 9]).throws<RangeError>();
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
    ]);
  });

  test('.insertAt inserts a row at the given index', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [7, 8, 9],
    ]);
    grid.rows.insertAt(1, [4, 5, 6]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
  });

  test('.insertAt can insert into an empty grid', () {
    final grid = NaiveListGrid.fromRows([]);
    grid.rows.insertAt(0, [1, 2, 3]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertAt throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
    ]);
    check(() => grid.rows.insertAt(2, [4, 5, 6])).throws<RangeError>();
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertFirst inserts a row at the beginning', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.insertFirst([7, 8, 9]);
    check(grid.rows).deepEquals([
      [7, 8, 9],
      [1, 2, 3],
      [4, 5, 6],
    ]);
  });

  test('.insertFirst can insert into an empty grid', () {
    final grid = NaiveListGrid.fromRows([]);
    grid.rows.insertFirst([1, 2, 3]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.insertLast inserts a row at the end', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.insertLast([7, 8, 9]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
  });

  test('.insertLast can insert into an empty grid', () {
    final grid = NaiveListGrid.fromRows([]);
    grid.rows.insertLast([1, 2, 3]);
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeAt removes the row at the given index', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    grid.rows.removeAt(1);
    check(grid.rows).deepEquals([
      [1, 2, 3],
      [7, 8, 9],
    ]);
  });

  test('.removeAt throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.removeAt(0)).throws<RangeError>();
  });

  test('.removeAt throws if the index is out of bounds', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
    ]);
    check(() => grid.rows.removeAt(1)).throws<RangeError>();
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeFirst removes the first row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.removeFirst();
    check(grid.rows).deepEquals([
      [4, 5, 6],
    ]);
  });

  test('.removeFirst throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.removeFirst()).throws<RangeError>();
  });

  test('.removeLast removes the last row', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    grid.rows.removeLast();
    check(grid.rows).deepEquals([
      [1, 2, 3],
    ]);
  });

  test('.removeLast throws if the grid is empty', () {
    final grid = NaiveListGrid.fromRows([]);
    check(() => grid.rows.removeLast()).throws<RangeError>();
  });

  test('.isEmpty returns true if the grid has no rows', () {
    final grid = NaiveListGrid.fromRows([]);
    check(grid.rows.isEmpty).isTrue();
  });

  test('.isNotEmpty returns false if the grid has no rows', () {
    final grid = NaiveListGrid.fromRows([]);
    check(grid.rows.isNotEmpty).isFalse();
  });

  test('.isEmpty returns false if the grid has rows', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
    ]);
    check(grid.rows.isEmpty).isFalse();
  });

  test('.isNotEmpty returns true if the grid has rows', () {
    final grid = NaiveListGrid.fromRows([
      [1, 2, 3],
    ]);
    check(grid.rows.isNotEmpty).isTrue();
  });
}
