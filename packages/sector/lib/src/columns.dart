import 'package:sector/sector.dart';

// ignore: unused_import
import 'package:sector/src/_dartdoc_macros.dart';

// False positives; the getter is in another type.
// ignore_for_file: avoid_setters_without_getters

/// A mutable iterable of columns in a grid.
///
/// This type is an extension of [Iterable] that provides a way to access and
/// modify columns in a grid. The columns are accessed by their index, where the
/// index `0` is the left-most column in the grid, and the index `width - 1` is
/// the right-most column in the grid.
///
/// The columns are represented as an iterable of elements, where each element
/// is a cell in the column. The elements are ordered from top to bottom, where
/// the element at index `0` is the top-most cell in the column, and the element
/// at index `height - 1` is the bottom-most cell in the column.
abstract class Columns<T> implements Iterable<Iterable<T>> {
  /// Sets the _first_ (left) column in the grid to the elements in [column].
  ///
  /// The grid must not be empty, and the length of [column] must be equal to
  /// the [Grid.height].
  set first(Iterable<T> column);

  /// Sets the _last_ (right) column in the grid to the elements in [column].
  ///
  /// The grid must not be empty, and the length of [column] must be equal to
  /// the [Grid.height].
  set last(Iterable<T> column);

  /// Sets the column at the given [index] to the elements in [column].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.width`, and the length
  /// of [column] must be equal to the [Grid.height].
  void operator []=(int index, Iterable<T> column);

  /// Returns the column at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.width`.
  ///
  /// Equivalent to [elementAt].
  Iterable<T> operator [](int index);

  /// Inserts a new column before the column at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index ≤ Grid.width`, and if [index]
  /// is equal to [Grid.width], the new column is appended to the grid. If the
  /// grid is empty, and [index] is `0`, the new column is inserted at the left
  /// of the grid and the grid is resized to have a width of `1` and a height of
  /// `row.length`.
  ///
  /// The length of [column] must be equal to the [Grid.width].
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertAt(int index, Iterable<T> column);

  /// Inserts a new column at the left of the grid.
  ///
  /// If the grid is empty, the column is inserted as the first column and the
  /// grid is resized to have a height of the length of the [column] and a width
  /// of `1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertFirst(Iterable<T> column);

  /// Inserts a new column at the right of the grid.
  ///
  /// If the grid is empty, the column is inserted as the first column and the
  /// grid is resized to have a height of the length of the [column] and a width
  /// of `1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertLast(Iterable<T> column);

  /// Removes the column at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < Grid.width`.
  ///
  /// The grid must not be empty. The grid is resized to have a width of
  /// `Grid.width - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeAt(int index);

  /// Removes the first, or left-most, column in the grid.
  ///
  /// The grid must not be empty. The grid is resized to have a width of
  /// `Grid.width - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeFirst();

  /// Removes the last, or right-most, column in the grid.
  ///
  /// The grid must not be empty. The grid is resized to have a width of
  /// `Grid.width - 1`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeLast();
}

/// A mixin that partially implements the [Columns] interface.
///
/// Given a reference to a [grid], this mixin provides implementations for most
/// operations other than [removeAt] and [insertAt], which are left unimplemented.
///
/// ## Examples
///
/// ```dart
/// class MyColumns<T> extends Iterable<Iterable<T>> with ColumnsBase<T> {}
/// ```
mixin ColumnsBase<T> on Iterable<Iterable<T>> implements Columns<T> {
  /// The grid that the columns are based on.
  Grid<T> get grid;

  @override
  Iterator<Iterable<T>> get iterator {
    return Iterable.generate(grid.width, (x) => this[x]).iterator;
  }

  @override
  set first(Iterable<T> column) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkLength(column, grid.height, name: 'column');
    for (var y = 0; y < grid.height; y++) {
      grid.set(0, y, column.elementAt(y));
    }
  }

  @override
  set last(Iterable<T> column) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkLength(column, grid.height, name: 'column');
    for (var y = 0; y < grid.height; y++) {
      grid.set(grid.width - 1, y, column.elementAt(y));
    }
  }

  @override
  void operator []=(int index, Iterable<T> column) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, index, 0);
    GridImpl.checkLength(column, grid.height, name: 'column');
    for (var y = 0; y < grid.height; y++) {
      grid.set(index, y, column.elementAt(y));
    }
  }

  @override
  Iterable<T> operator [](int index) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, index, 0);
    return Iterable.generate(grid.height, (y) => grid.get(index, y));
  }

  @override
  void insertFirst(Iterable<T> column) => insertAt(0, column);

  @override
  void insertLast(Iterable<T> column) => insertAt(grid.width, column);

  @override
  void removeFirst() => removeAt(0);

  @override
  void removeLast() => removeAt(grid.width - 1);
}
