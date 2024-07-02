import 'package:meta/meta.dart';
import 'package:sector/sector.dart';

// ignore: unused_import
import 'package:sector/src/_dartdoc_macros.dart';

Never _noElement() => throw StateError('No element');

/// A mutable iterable of sets of elements in a grid.
///
/// This type is an extension of [Iterable] that provides a way to access and
/// modify a defined axis in a grid. The axis is accessed by its index, where
/// the index `0` is the first axis in the grid, and the last index is defined
/// by it's implementation.
abstract class GridAxis<T> extends Iterable<Iterable<T>> {
  /// @nodoc
  const GridAxis();

  @override
  Iterable<T> get first => this[0];

  /// Sets the first axis in the grid to [cells].
  ///
  /// The grid must not be empty, and the length of [cells] must be equal to the
  /// [Grid.width] or [Grid.height] depending on the axis; which is defined by
  /// the implementation.
  set first(Iterable<T> cells) {
    this[0] = cells;
  }

  /// Sets the last axis in the grid to [cells].
  ///
  /// The grid must not be empty, and the length of [cells] must be equal to the
  /// [Grid.width] or [Grid.height] depending on the [length] of the axis; which
  /// is defined by the implementation.
  set last(Iterable<T> cells);

  /// Sets the axis at the given [index] to [cells].
  ///
  /// The [index] must be in the range `0 ≤ index < length`, and the length of
  /// [cells] must be equal to the [Grid.width] or [Grid.height] depending on
  /// the axis; which is defined by the implementation.
  void operator []=(int index, Iterable<T> cells);

  /// Returns the axis at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  ///
  /// Equivalent to [elementAt].
  Iterable<T> operator [](int index);

  @override
  Iterable<T> elementAt(int index) => this[index];

  /// Inserts a new axis before the axis at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index ≤ maximum`, and if [index] is
  /// equal to `maximum`, the new axis is appended to the grid. If the grid is
  /// empty, and [index] is `0`, the new axis is inserted in the grid and
  /// resizes the dimensions accordingly.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertAt(int index, Iterable<T> cells);

  /// Inserts a new axis at the starting position of the grid.
  ///
  /// Equivalent to `insertAt(0, cells)`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertFirst(Iterable<T> cells) => insertAt(0, cells);

  /// Inserts a new axis at the ending position of the grid.
  ///
  /// Equivalent to `insertAt(length - 1, cells)`.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void insertLast(Iterable<T> cells);

  /// Removes the axis at the given [index].
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  ///
  /// The grid must not be empty, and is resized as a result of the removal.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeAt(int index);

  /// Removes the first axis in the grid.
  ///
  /// Equivalent to `removeAt(0)`.
  ///
  /// The grid must not be empty, and is resized as a result of the removal.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeFirst() => removeAt(0);

  /// Removes the last axis in the grid.
  ///
  /// Equivalent to `removeAt(length - 1)`.
  ///
  /// The grid must not be empty, and is resized as a result of the removal.
  ///
  /// {@macro warn-grid-might-not-be-growable}
  void removeLast();
}

/// A mixin that provides a partial implementation of [GridAxis] for _rows_.
///
/// Given a reference to a [Grid] implementation, this mixin provides default
/// implementations for most remaining methods in [GridAxis] that are not
/// implemented, leaving only [grid], [removeAt], and [insertAt] up to the user.
///
/// ## Examples
///
/// ```dart
/// class MyRows<T> extends GridAxis<T> with RowsMixin<T> {
///   MyRows(this.grid);
///
///   @override
///   final Grid<T> grid;
///
///   @override
///   void removeAt(int index) { /* ... */ }
///
///   @override
///   void insertAt(int index, Iterable<T> row) { /* ... */ }
/// }
/// ```
mixin RowsMixin<T> on GridAxis<T> {
  /// The grid that the rows are associated with.
  @protected
  Grid<T> get grid;

  @override
  bool get isEmpty => grid.isEmpty;

  @override
  bool get isNotEmpty => grid.isNotEmpty;

  @override
  int get length => grid.height;

  @override
  Iterable<T> operator [](int index) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, 0, index);
    return Iterable.generate(grid.width, (x) => grid.getUnchecked(x, index));
  }

  @override
  void operator []=(int index, Iterable<T> row) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, 0, index);
    GridImpl.checkLength(row, grid.width, name: 'row');

    var x = 0;
    for (final cell in row) {
      grid.setUnchecked(x++, index, cell);
    }
  }

  @override
  Iterator<Iterable<T>> get iterator {
    return Iterable.generate(length, (i) => this[i]).iterator;
  }

  @override
  Iterable<T> get last => this[length - 1];

  @override
  set last(Iterable<T> cells) {
    this[length - 1] = cells;
  }

  @override
  Iterable<T> lastWhere(
    bool Function(Iterable<T> element) test, {
    Iterable<T> Function()? orElse,
  }) {
    for (var i = length - 1; i >= 0; i--) {
      final row = this[i];
      if (test(row)) {
        return row;
      }
    }
    return orElse?.call() ?? _noElement();
  }

  @override
  void insertLast(Iterable<T> cells) => insertAt(length, cells);

  @override
  void removeLast() => removeAt(length - 1);
}

/// A mixin that provides a partial implementation of [GridAxis] for _columns_.
///
/// Given a reference to a [Grid] implementation, this mixin provides default
/// implementations for most remaining methods in [GridAxis] that are not
/// implemented, leaving only [grid], [removeAt], and [insertAt] up to the user.
///
/// ## Examples
///
/// ```dart
/// class MyColumns<T> extends GridAxis<T> with ColumnsMixin<T> {
///   MyColumns(this.grid);
///
///   @override
///   final Grid<T> grid;
///
///   @override
///   void removeAt(int index) { /* ... */ }
///
///   @override
///   void insertAt(int index, Iterable<T> column) { /* ... */ }
/// }
/// ```
mixin ColumnsMixin<T> on GridAxis<T> {
  /// The grid that the rows are associated with.
  @protected
  Grid<T> get grid;

  @override
  bool get isEmpty => grid.isEmpty;

  @override
  bool get isNotEmpty => grid.isNotEmpty;

  @override
  int get length => grid.width;

  @override
  Iterable<T> operator [](int index) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, index, 0);
    return Iterable.generate(grid.height, (y) => grid.getUnchecked(index, y));
  }

  @override
  void operator []=(int index, Iterable<T> column) {
    GridImpl.checkNotEmpty(grid);
    GridImpl.checkBoundsExclusive(grid, index, 0);
    GridImpl.checkLength(column, grid.height, name: 'column');

    var y = 0;
    for (final cell in column) {
      grid.setUnchecked(index, y++, cell);
    }
  }

  @override
  Iterator<Iterable<T>> get iterator {
    return Iterable.generate(length, (i) => this[i]).iterator;
  }

  @override
  Iterable<T> get last => this[length - 1];

  @override
  set last(Iterable<T> cells) {
    this[length - 1] = cells;
  }

  @override
  Iterable<T> lastWhere(
    bool Function(Iterable<T> element) test, {
    Iterable<T> Function()? orElse,
  }) {
    for (var i = length - 1; i >= 0; i--) {
      final row = this[i];
      if (test(row)) {
        return row;
      }
    }
    return orElse?.call() ?? _noElement();
  }

  @override
  void insertLast(Iterable<T> cells) => insertAt(length, cells);

  @override
  void removeLast() => removeAt(length - 1);
}
