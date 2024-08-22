part of '../grid.dart';

/// A minimal API for grid-like objects where elements [T] are readable by a
/// 2D position [Pos].
///
/// While not a full-fledged grid implementation, this mixin provides a common
/// interface for grid-like objects, and static utility methods for operations
/// that might otherwise be cumbersome and inefficient to implement from
/// cratch, such as [getBounds] and [getRect] (not every implementation will
/// want them exposed, those that do can implement methods that use the static
/// methods as implementation details).
abstract mixin class GridView<T> {
  /// Creates a grid-view that delegates to [getUnsafe] for reading elements.
  ///
  /// The [width] and [height] parameters specify the dimensions of the grid.
  ///
  /// This constructor is intended for quickly adapting objects that do not
  /// implement the [GridView] interface to be used with other methods that
  /// expect a [GridView] object; it is recommended to implement or mix-in the
  /// [GridView] interface directly when possible.
  factory GridView(
    T Function(Pos) getUnsafe, {
    required int width,
    required int height,
  }) {
    return _GridLike(
      getUnsafe,
      (_, __) => throw UnsupportedError('Readonly'),
      width: width,
      height: height,
    );
  }

  /// Creates a [GridView] accessor from a [List] of elements in row-major
  /// order.
  ///
  /// The [width] and [height] parameters specify the dimensions of the grid.
  ///
  /// This constructor is intended for quickly adapting objects that store
  /// elements in a [List] to be used with other methods that expect a
  /// [GridView] object; it is recommended to implement or mix-in the [GridView]
  /// interface directly when possible.
  factory GridView.withList(
    List<T> data, {
    required int width,
    required int height,
  }) = _LinearGridLike<T>;

  /// Width of the grid in cells.
  int get width;

  /// Height of the grid in cells.
  int get height;

  /// Returns the element at a valid position within the grid.
  T get(Pos pos) {
    if (pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height) {
      throw RangeError('Position $pos is out of bounds for grid');
    }
    return getUnsafe(pos);
  }

  /// Returns the element at a valid position within the grid.
  ///
  /// If the position is out of bounds the behavior is undefined.
  ///
  /// This method is intended for performance-critical code where bounds
  /// checking is not necessary, such as in loops iterating over over parts of
  /// the grid, or where bounds checking is done elsewhere.
  T getUnsafe(Pos pos);

  /// Returns the bounds of the grid as a [Rect].
  ///
  /// May optionally take an [offset] to shift the bounds by, otherwise is
  /// relative to the top-left corner.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = GridLike.withList(
  ///   [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// print(GridView.getBounds(grid)); // Rect.fromLTRB(0, 0, 3, 3)
  /// print(GridView.getBounds(grid, offset: Pos(1, 1))); // Rect.fromLTRB(1, 1, 4, 4)
  /// ```
  static Rect getBounds(GridView<void> grid, [Pos offset = Pos.zero]) {
    return Rect.fromWH(grid.width, grid.height, offset: offset);
  }

  /// Returns the elements of a rectangular region of the grid as an iterable.
  ///
  /// Elements are yielded in row-major order, starting from the top-left corner
  /// of the rectangle to the bottom-right corner.
  ///
  /// If [bounds] is not specified, the entire grid is returned.
  ///
  /// {@template lodim.GridLike:clampBounds}
  /// If a rectangle extends beyond the bounds of the grid, the region is
  /// clamped to the bounds of the grid.
  /// {@endtemplate}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = GridView.withList(
  ///   [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// final it = GridView.getRect(grid, bounds: Rect.fromLTWH(1, 1, 2, 2));
  /// print(it.toList()); // [5, 6, 8, 9]
  /// ```
  static Iterable<T> getRect<T>(GridView<T> grid, {Rect? bounds}) {
    bounds = bounds?.intersect(GridView.getBounds(grid));
    return getRectUnsafe(grid, bounds: bounds);
  }

  /// Returns the elements of a rectangular region of the grid as an iterable.
  ///
  /// Elements are yielded in row-major order, starting from the top-left corner
  /// of the rectangle to the bottom-right corner.
  ///
  /// If [bounds] is not specified, the entire grid is returned.
  ///
  /// {@template lodim.GridLike:unsafeBounds}
  /// If a rectangle extends beyond the bounds of the grid, **the behavior is
  /// undefined**.
  ///
  /// > [!WARNING]
  /// > This method is intended for performance-critical code where bounds
  /// > checking is not necessary, such as in tight loops iterating over parts of
  /// > the grid, or where bounds checking is verifiably done elsewhere.
  /// {@endtemplate}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = GridView.withList(
  ///   [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// final it = GridView.getRectUnsafe(grid, bounds: Rect.fromLTWH(1, 1, 2, 2));
  /// print(it.toList()); // [5, 6, 8, 9]
  /// ```
  static Iterable<T> getRectUnsafe<T>(GridView<T> grid, {Rect? bounds}) {
    if (grid is LinearGridView<T>) {
      return _getLinearUnsafe(grid, bounds: bounds);
    }
    bounds ??= GridView.getBounds(grid);
    return bounds.positions.map(grid.getUnsafe);
  }

  static Iterable<T> _getLinearUnsafe<T>(
    LinearGridView<T> grid, {
    Rect? bounds,
  }) {
    // Optimization: if bounds are not specified, return the entire grid.
    if (bounds == null) {
      return grid.data;
    }

    // Optimization: if the width of the bounds are equal, return a range.
    if (bounds.width == grid.width) {
      return grid.data.getRange(0, bounds.height * grid.width);
    }

    // Otherwise, iterate over the bounds manually.
    // This is still faster than computing the positions.
    // The amount to skip to get to the next row.
    // 0 1 2
    // 3 4 5
    // 6 7 8
    //
    // If we start on 4, we need to skip 2 to get to 6.

    // Calculate the starting and ending offsets.
    final startOffset = bounds.top * grid.width + bounds.left;
    final endOffset = (bounds.bottom - 1) * grid.width + bounds.right;
    final skipToNextRow = grid.width - bounds.width;

    return _LinearGridIterable(
      grid.data,
      startOffset,
      endOffset,
      bounds.right,
      skipToNextRow,
    );
  }
}

/// Grid view object that stores elements in row-major order in linear memory.
///
/// This interface permits efficient access to elements in a grid-like object
/// that stores elements in a [List]. The [data] getter provides direct access
/// to elements by their linear index, which can be used to implement efficient
/// algorithms that iterate over the grid in a linear fashion.
///
/// It is _not_ recommended to expose this interface directly to users, as it
/// bypasses the bounds checking provided by the [GridView] interface, and
/// instead should be used as an implementation detail of a grid-like object.
abstract mixin class LinearGridView<T> implements GridView<T> {
  /// Linear memory backing the grid.
  ///
  /// Elements must be stored contiguously in row-major order (i.e. an element
  /// at position `(x, y)` is stored at index `y * width + x`), and the length
  /// of the list must be equal to `width * height`.
  ///
  /// If the length of the list can change during the lifetime of the object,
  /// the [width] and [height] properties must be updated accordingly, otherwise
  /// the behavior is undefined.
  @visibleForOverriding
  List<T> get data;
}
