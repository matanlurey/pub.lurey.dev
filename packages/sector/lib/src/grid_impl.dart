import 'dart:math' as math;

import 'package:sector/sector.dart';
import 'package:sector/src/sub_grid_view.dart';

/// A collection of static methods for implementing the [Grid] interface.
///
/// This extension is a namespace that provides static methods that implement
/// shared functionality for [Grid]s. Dart does not have the concept of default
/// methods, and mixins cannot inherit from other mixins, so this extension
/// provides a way to share common implementation details across multiple
/// classes.
extension GridImpl on Never {
  /// Checks that the grid is not empty.
  ///
  /// If the grid is empty, a [StateError] is thrown.
  static void checkNotEmpty(Grid<void> grid) {
    if (grid.isEmpty) {
      throw StateError('Cannot perform operation on an empty grid.');
    }
  }

  /// Checks that the provided [x] and [y] are within the bounds of the grid.
  ///
  /// If the coordinates are out of bounds, a [RangeError] is thrown.
  static void checkBoundsExclusive(Grid<void> grid, int x, int y) {
    if (!grid.containsXY(x, y)) {
      throw RangeError('Coordinates out of bounds: ($x, $y)');
    }
  }

  /// Checks that the provided [x] and [y] are within the bounds of the grid.
  ///
  /// Unlike [checkBoundsExclusive], this method allows the coordinates to be
  /// equal to the width and height of the grid. This is useful when it is valid
  /// to insert elements at the end of the grid.
  ///
  /// If the coordinates are out of bounds, a [RangeError] is thrown.
  static void checkBoundsInclusive(Grid<void> grid, int x, int y) {
    if (x < 0 || x > grid.width || y < 0 || y > grid.height) {
      throw RangeError('Coordinates out of bounds: ($x, $y)');
    }
  }

  /// Checks that the provided [x], [y], [width], [height] are within bounds.
  ///
  /// If the coordinates are out of bounds, a [RangeError] is thrown.
  static void checkBoundsXYWH(
    Grid<void> grid,
    int x,
    int y,
    int width,
    int height,
  ) {
    if (!grid.containsXYWH(x, y, width, height)) {
      throw RangeError('Bounds out of grid: ($x, $y, $width, $height)');
    }
  }

  /// Checks that the length of [elements] is equal to the provided [length].
  ///
  /// This method is used to validate the length of an iterable of elements
  /// before performing an operation that requires a specific length; for
  /// example when setting a row in a grid.
  ///
  /// An [ArgumentError] is thrown if the length of [elements] is not equal.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// GridImpl.checkLength([1, 2, 3], 3, name: 'row');
  /// ```
  static void checkLength(
    Iterable<void> elements,
    int length, {
    required String name,
  }) {
    if (elements.length != length) {
      throw ArgumentError.value(
        elements,
        name,
        'Length must be $length, but got ${elements.length}.',
      );
    }
  }

  /// [Iterable.expand] that checks each sub-iterable has the same length.
  static Iterable<T> checkedExpand<T>(Iterable<Iterable<T>> elements) {
    int? length;
    return elements.expand((subIterable) {
      if (length == null) {
        length = subIterable.length;
      } else if (subIterable.length != length) {
        throw ArgumentError('All sub-iterables must have the same length.');
      }
      return subIterable;
    });
  }

  /// Returns a string representation of the grid.
  ///
  /// This method is a default implementation for the [Grid.toString] method,
  /// and uses ASCII box drawing characters to represent the grid. The [format]
  /// function is used to convert each cell value to a string, and defaults to
  /// calling `toString` on the value.
  ///
  /// The exact format of this string is not guaranteed, and may change in the
  /// future as it is only intended for debugging purposes. Prefer building your
  /// own representation or use properties such as [Grid.rows] to assert against
  /// the grid contents:
  /// ```dart
  /// expect(grid.rows, [...]);
  /// ```
  static String debugString<T>(
    Grid<T> grid, {
    String Function(T) format = _format,
  }) {
    // Pre-format the cells in row-major order, and track the longest cell.
    final output = <String>[];
    var longest = 0;
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        final cell = format(grid.get(x, y));
        longest = math.max(longest, cell.length);
        output.add(cell);
      }
    }

    final buffer = StringBuffer();

    buffer.write('┌');
    for (var x = 0; x < grid.width; x++) {
      buffer.write('─' * (longest * 2));
    }
    if (grid.width > 0) {
      buffer.write('─');
    }
    buffer.write('┐\n');

    for (var y = 0; y < grid.height; y++) {
      buffer.write('│');
      for (var x = 0; x < grid.width; x++) {
        final cell = output[y * grid.width + x];
        buffer.write(' ');
        buffer.write(cell.padRight(longest));
      }
      if (grid.width > 0) {
        buffer.write(' ');
      }
      buffer.write('│\n');
    }

    buffer.write('└');
    for (var x = 0; x < grid.width; x++) {
      buffer.write('─' * (longest * 2));
    }
    if (grid.width > 0) {
      buffer.write('─');
    }
    buffer.write('┘');

    return buffer.toString();
  }

  static String _format(Object? o) => o.toString();

  /// Returns a sub-grid view of the provided grid.
  ///
  /// This method is a default implementation for the [Grid.asSubGrid] method.
  static Grid<T> subGridView<T>(
    Grid<T> grid, {
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    width ??= grid.width - left;
    height ??= grid.height - top;
    GridImpl.checkBoundsXYWH(grid, left, top, width, height);

    return SubGridView.fromLTWH(
      grid,
      left,
      top,
      width,
      height,
    );
  }

  /// Resizes the grid to the provided [width] and [height].
  ///
  /// This is an optional default implementation for the [Grid.resize] method.
  /// It can be used as almost the entire implementation for the method, with
  /// the exception of setting any internal state that is specific to the grid
  /// implementation, such as the width and height of a list-based grid:
  /// ```dart
  /// class ListGrid<T> with Grid<T> {
  ///   ListGrid._(this._cells, this._width);
  ///   final List<T> _cells;
  ///   int _width;
  ///
  ///   @override
  ///   void resize(int width, int height, {T? fill}) {
  ///     GridImpl.resize(this, width, height, fill: fill);
  ///     _width = width;
  ///   }
  /// }
  /// ```
  ///
  /// - If the size is not changing, this method does nothing.
  /// - If the width or height is zero, [Grid.clear] is called.
  ///
  /// If the width or height is _less_ than the current size, the grid is
  /// truncated by removing rows or columns from the end of the grid, which is
  /// the bottom for rows and the right for columns, by calling the
  /// [Rows.removeLast] or [Columns.removeLast] methods respectively.
  ///
  /// If the width or height is _greater_ than the current size, the grid is
  /// expanded by adding rows or columns to the end of the grid, which is the
  /// bottom for rows and the right for columns, by calling the
  /// [Rows.insertLast] or [Columns.insertLast] methods respectively, with
  /// the provided [fill] value, which must be non-null if the grid cannot
  /// accept `null` values.
  // static void resize<T>(Grid<T> grid, int width, int height, {T? fill}) {
  //   RangeError.checkNotNegative(width, 'width');
  //   RangeError.checkNotNegative(height, 'height');

  //   // If we are not changing the size, do nothing.
  //   if (width == grid.width && height == grid.height) {
  //     return;
  //   }

  //   // If either the width or height is zero, clear the grid.
  //   if (width == 0 || height == 0) {
  //     grid.clear();
  //     return;
  //   }

  //   if (width > 0 && height > 0 && fill is! T) {
  //     throw ArgumentError.notNull('fill');
  //   }

  //   // If the height is growing or shrinking, we need to adjust the rows.
  //   if (height < grid.height) {
  //     final rows = grid.rows;
  //     do {
  //       rows.removeLast();
  //     } while (height < grid.height);
  //   } else if (height > grid.height) {
  //     fill as T;
  //     final rows = grid.rows;
  //     do {
  //       rows.insertLast(Iterable.generate(width, (_) => fill));
  //     } while (height > grid.height);
  //   }

  //   // If the width is growing or shrinking, we need to adjust the columns.
  //   if (width < grid.width) {
  //     final columns = grid.columns;
  //     do {
  //       columns.removeLast();
  //     } while (width < grid.width);
  //   } else if (width > grid.width) {
  //     fill as T;
  //     final columns = grid.columns;
  //     do {
  //       columns.insertLast(Iterable.generate(height, (_) => fill));
  //     } while (width > grid.width);
  //   }
  // }
}
