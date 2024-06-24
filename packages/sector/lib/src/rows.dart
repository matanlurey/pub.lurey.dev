import 'package:meta/meta.dart';
import 'package:sector/sector.dart';

// ignore: unused_import
import 'package:sector/src/_dartdoc_macros.dart';

/// A mutable iterable of rows in a grid.
///
/// This type is an extension of [Iterable] that provides a way to access and
/// modify rows in a grid. The rows are accessed by their index, where the index
/// `0` is the top-most row in the grid, and the index `height - 1` is the
/// bottom-most row in the grid.
///
/// The rows are represented as an iterable of elements, where each element is a
/// cell in the row. The elements are ordered from left to right, where the
/// element at index `0` is the left-most cell in the row, and the element at
/// index `width - 1` is the right-most cell in the row.
abstract interface class Rows<T> implements Iterable<Iterable<T>> {
  /// Sets the _first_ (top) row in the grid to the elements in [row].
  ///
  /// The grid must not be empty, and the length of [row] must be equal to the
  /// [Grid.width].
  // ignore: avoid_setters_without_getters
  set first(Iterable<T> row);

  /// Sets the _last_ (bottom) row in the grid to the elements in [row].
  ///
  /// The grid must not be empty, and the length of [row] must be equal to the
  /// [Grid.width].
  // ignore: avoid_setters_without_getters
  set last(Iterable<T> row);

  /// Sets the row at the given [index] to the elements in [row].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.height`, and the length
  /// of [row] must be equal to the [Grid.width].
  void operator []=(int index, Iterable<T> row);

  /// Returns the row at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.height`.
  ///
  /// Equivalent to [elementAt].
  Iterable<T> operator [](int index);

  /// Inserts a new row before the row at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index ≤ Grid.height`, and if [index]
  /// is equal to [Grid.height], the new row is appended to the grid. If the
  /// grid is empty, and [index] is `0`, the new row is inserted at the top of
  /// the grid and the grid is resized to have a height of `1` and a width of
  /// `row.length`.
  ///
  /// The length of [row] must be equal to the [Grid.width].
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertAt(int index, Iterable<T> row);

  /// Inserts a new row at the top of the grid.
  ///
  /// If the grid is empty, the row is inserted as the first row and the grid is
  /// resized to have a height of `1` and a width of the length of the [row].
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertFirst(Iterable<T> row);

  /// Inserts a new row at the bottom of the grid.
  ///
  /// If the grid is empty, the row is inserted as the first row and the grid is
  /// resized to have a height of `1` and a width of the length of the [row].
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertLast(Iterable<T> row);

  /// Removes the row at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.height`.
  ///
  /// The grid must not be empty. The grid is resized to have a height of
  /// `Grid.height - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeAt(int index);

  /// Removes the first, or top-most, row in the grid.
  ///
  /// The grid must not be empty. The grid is resized to have a height of
  /// `Grid.height - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeFirst();

  /// Removes the last, or bottom-most, row in the grid.
  ///
  /// The grid must not be empty. The grid is resized to have a height of
  /// `Grid.height - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeLast();
}

/// A mixin that partially implements the [Rows] interface.
///
/// Given a reference to a [grid], this mixin provides implementations for most
/// operations other than [removeAt] and [insertAt], which are left unimplemented.
///
/// ## Examples
///
/// ```dart
/// class MyRows<T> extends Iterable<Iterable<T>> with RowsBase<T> {}
/// ```
mixin RowsBase<T> implements Rows<T> {
  /// The grid that the rows are associated with.
  @protected
  Grid<T> get grid;

  @override
  Iterator<Iterable<T>> get iterator {
    return Iterable.generate(grid.height, (y) => this[y]).iterator;
  }

  @override
  set first(Iterable<T> row) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkLength(row, grid.width, name: 'row');

    var x = 0;
    for (final cell in row) {
      grid.setUnchecked(x++, 0, cell);
    }
  }

  @override
  set last(Iterable<T> row) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkLength(row, grid.width, name: 'row');

    var x = 0;
    for (final cell in row) {
      grid.setUnchecked(x++, grid.height - 1, cell);
    }
  }

  @override
  void operator []=(int index, Iterable<T> row) {
    GridImpl.checkBoundsExclusive(grid, 0, index);
    GridImpl.checkLength(row, grid.width, name: 'row');

    var x = 0;
    for (final cell in row) {
      grid.setUnchecked(x++, index, cell);
    }
  }

  @override
  Iterable<T> operator [](int index) {
    GridImpl.checkBoundsExclusive(grid, 0, index);

    return Iterable.generate(grid.width, (x) => grid.getUnchecked(x, index));
  }

  @override
  void removeFirst() => removeAt(0);

  @override
  void removeLast() => removeAt(grid.height - 1);

  @override
  void insertFirst(Iterable<T> row) => insertAt(0, row);

  @override
  void insertLast(Iterable<T> row) => insertAt(grid.height, row);
}
