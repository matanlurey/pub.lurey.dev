/// This is an experimental API and is subject to change or removal.
@experimental
library;

import 'package:lodim/lodim.dart';
import 'package:meta/meta.dart';

part 'grid/grid_view.dart';
part 'grid/linear_grid_iterable.dart';

/// A minimal API for grid-like objects where elements [T] are accessible by a
/// 2D position [Pos].
///
/// While not a full-fledged grid implementation, this mixin provides a common
/// interface for grid-like objects, and static utility methods for operations
/// that might otherwise be cumbersome and inefficient to implement from
/// cratch, such as [fillRect], and [copyRect] (not every implementation will
/// want them exposed, those that do can implement methods that use the static
/// methods as implementation details).
abstract mixin class GridLike<T> implements GridView<T> {
  /// Creates a [GridLike] accessor from [getUnsafe] and [setUnsafe] functions.
  ///
  /// The [width] and [height] parameters specify the dimensions of the grid.
  ///
  /// This constructor is intended for quickly adapting objects that do not
  /// implement the [GridLike] interface to be used with other methods that
  /// expect a [GridLike] object; it is recommended to implement or mix-in the
  /// [GridLike] interface directly when possible.
  factory GridLike.fromGetSet(
    T Function(Pos) getUnsafe,
    void Function(Pos, T) setUnsafe, {
    required int width,
    required int height,
  }) = _GridLike<T>;

  /// Creates a [GridLike] accessor from a [List] of elements in row-major
  /// order.
  ///
  /// The [width] and [height] parameters specify the dimensions of the grid.
  ///
  /// This constructor is intended for quickly adapting objects that store
  /// elements in a [List] to be used with other methods that expect a
  /// [GridLike] object; it is recommended to implement or mix-in the [GridLike]
  /// interface directly when possible.
  factory GridLike.withList(
    List<T> data, {
    required int width,
    required int height,
  }) = _LinearGridLike<T>;

  /// Width of the grid in cells.
  @override
  int get width;

  /// Height of the grid in cells.
  @override
  int get height;

  /// Returns the element at a valid position within the grid.
  @override
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
  @override
  T getUnsafe(Pos pos);

  /// Sets the element at a valid position within the grid.
  void set(Pos pos, T value) {
    if (pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height) {
      throw RangeError('Position $pos is out of bounds for grid');
    }
    setUnsafe(pos, value);
  }

  /// Sets the element at a valid position within the grid.
  ///
  /// If the position is out of bounds the behavior is undefined.
  ///
  /// This method is intended for performance-critical code where bounds
  /// checking is not necessary, such as in loops iterating over over parts of
  /// the grid, or where bounds checking is done elsewhere.
  void setUnsafe(Pos pos, T value);

  /// Fills the elements of a rectangular region of the grid with a [value].
  ///
  /// If [bounds] is not specified, the entire grid is filled.
  ///
  /// {@macro lodim.GridLike:clampBounds}
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
  /// GridLike.fillRect(grid, 0, bounds: Rect.fromLTWH(1, 1, 2, 2));
  /// print(grid.data); // [1, 2, 3, 4, 0, 0, 7, 0, 0]
  /// ```
  static void fillRect<T>(GridLike<T> grid, T value, {Rect? bounds}) {
    bounds = bounds?.intersect(GridView.getBounds(grid));
    fillRectUnsafe(grid, value, bounds: bounds);
  }

  /// Fills the elements of a rectangular region of the grid with a [value].
  ///
  /// If [bounds] is not specified, the entire grid is filled.
  ///
  /// {@macro lodim.GridLike:unsafeBounds}
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
  /// GridLike.fillRectUnsafe(grid, 0, bounds: Rect.fromLTWH(1, 1, 2, 2));
  /// print(grid.data); // [1, 2, 3, 4, 0, 0, 7, 0, 0]
  /// ```
  static void fillRectUnsafe<T>(GridLike<T> grid, T value, {Rect? bounds}) {
    if (grid is LinearGridLike<T>) {
      return _fillLinearUnsafe(grid, value, bounds: bounds);
    }
    bounds ??= GridView.getBounds(grid);
    for (final pos in bounds.positions) {
      grid.setUnsafe(pos, value);
    }
  }

  static void _fillLinearUnsafe<T>(
    LinearGridLike<T> grid,
    T value, {
    Rect? bounds,
  }) {
    // Optimization: if bounds are not specified, fill the entire grid.
    if (bounds == null) {
      return grid.data.fillRange(0, grid.data.length, value);
    }

    // Optimization: if the width of the bounds are equal, fill a range.
    if (bounds.width == grid.width) {
      final start = bounds.top * grid.width;
      final end = bounds.bottom * grid.width;
      return grid.data.fillRange(start, end, value);
    }

    // Otherwise, fill a range per row.
    // This is still faster than computing the positions.
    var start = bounds.top * grid.width + bounds.left;
    final stride = bounds.width + grid.width - bounds.width;
    for (var y = bounds.top; y < bounds.bottom; y++) {
      grid.data.fillRange(start, start + bounds.width, value);
      start += stride;
    }
  }

  /// Fills the elements of a rectangular region of the grid with [elements].
  ///
  /// If [bounds] is not specified, the entire grid is filled.
  ///
  /// {@macro lodim.GridLike:clampBounds}
  ///
  /// [elements] must have a `length` equal to the area of the rectangle.
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
  /// final elements = [0, 0, 0, 0];
  /// GridLike.fillRectFrom(grid, elements, bounds: Rect.fromLTWH(1, 1, 2, 2));
  ///
  /// print(grid.data); // [1, 2, 3, 4, 0, 0, 7, 0, 0]
  /// ```
  static void fillRectFrom<T>(
    GridLike<T> grid,
    Iterable<T> elements, {
    Rect? bounds,
  }) {
    bounds = bounds?.intersect(GridView.getBounds(grid));
    if (bounds != null && bounds.area != elements.length ||
        bounds == null && grid.width * grid.height != elements.length) {
      throw ArgumentError.value(
        elements.length,
        'elements.length',
        'Length must be equal to the area of the grid being filled',
      );
    }
    fillRectFromUnsafe(grid, elements, bounds: bounds);
  }

  /// Fills the elements of a rectangular region of the grid with [elements].
  ///
  /// If [bounds] is not specified, the entire grid is filled.
  ///
  /// {@macro lodim.GridLike:unsafeBounds}
  ///
  /// If [elements] does not have a `length` equal to the area of the rectangle,
  /// the behavior is undefined.
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
  /// final elements = [0, 0, 0, 0];
  /// GridLike.fillRectFromUnsafe(grid, elements, bounds: Rect.fromLTWH(1, 1, 2, 2));
  ///
  /// print(grid.data); // [1, 2, 3, 4, 0, 0, 7, 0, 0]
  /// ```
  static void fillRectFromUnsafe<T>(
    GridLike<T> grid,
    Iterable<T> elements, {
    Rect? bounds,
  }) {
    if (grid is LinearGridLike<T>) {
      return _fillLinearFromUnsafe(grid, elements, bounds: bounds);
    }
    bounds ??= GridView.getBounds(grid);
    final it = elements.iterator;
    for (final pos in bounds.positions) {
      if (!it.moveNext()) {
        return;
      }
      grid.setUnsafe(pos, it.current);
    }
  }

  @pragma('dart2js:index-bounds:trust')
  @pragma('vm:unsafe:no-bounds-checks')
  static void _fillLinearFromUnsafe<T>(
    LinearGridLike<T> grid,
    Iterable<T> elements, {
    Rect? bounds,
  }) {
    // Optimization: if bounds are not specified, fill the entire grid.
    if (bounds == null) {
      return grid.data.setAll(0, elements);
    }

    // Optimization: if the width of the bounds are equal, fill a range.
    if (bounds.width == grid.width) {
      return grid.data.setRange(
        bounds.top * grid.width,
        bounds.bottom * grid.width,
        elements,
      );
    }

    // Otherwise, use setRange multiple times.
    var skipCount = 0;
    var dstStart = bounds.top * grid.width + bounds.left;
    var dstEnd = dstStart + bounds.width;
    for (var y = bounds.top; y < bounds.bottom; y++) {
      grid.data.setRange(dstStart, dstEnd, elements, skipCount);
      skipCount += bounds.width;
      dstStart += grid.width;
      dstEnd += grid.width;
    }
  }

  /// Copies the elements of a rectangular region of the grid to another grid.
  ///
  /// - If [source] is not specified, the entire source grid is copied.
  /// - If [target] is not specified, the grid is copied to the top-left corner.
  ///
  /// {@macro lodim.GridLike:clampBounds}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final src = GridLike.withList(
  ///   [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// final dst = GridLike.withList(
  ///   [0, 0, 0, 0, 0, 0, 0, 0, 0],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// GridLike.copyRect(
  ///   src,
  ///   dst,
  ///   source: Rect.fromLTWH(1, 1, 2, 2),
  ///   target: Pos(1, 1),
  /// );
  ///
  /// print(dst.data); // [0, 0, 0, 0, 5, 6, 0, 8, 9]
  /// ```
  static void copyRect<T>(
    GridLike<T> src,
    GridLike<T> dst, {
    Rect? source,
    Pos? target,
  }) {
    // TODO: Consider additional optimizations for linear grids.
    // Use a combination of getRect and fillRectFrom to copy the elements.
    final elements = GridView.getRect(src, bounds: source);
    GridLike.fillRectFrom(
      dst,
      elements,
      bounds: Rect.fromTLBR(
        target ?? Pos.zero,
        source?.bottomRight ?? Pos(src.width, src.height),
      ),
    );
  }

  /// Copies the elements of a rectangular region of the grid to another grid.
  ///
  /// - If [source] is not specified, the entire source grid is copied.
  /// - If [target] is not specified, the grid is copied to the top-left corner.
  ///
  /// {@macro lodim.GridLike:unsafeBounds}
  ///
  /// ## Example
  ///
  /// ```dart
  /// final src = GridLike.withList(
  ///   [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// final dst = GridLike.withList(
  ///   [0, 0, 0, 0, 0, 0, 0, 0, 0],
  ///   width: 3,
  ///   height: 3,
  /// );
  ///
  /// GridLike.copyRectUnsafe(
  ///   src,
  ///   dst,
  ///   source: Rect.fromLTWH(1, 1, 2, 2),
  ///   target: Pos(1, 1),
  /// );
  ///
  /// print(dst.data); // [0, 0, 0, 0, 5, 6, 0, 8, 9]
  /// ```
  static void copyRectUnsafe<T>(
    GridView<T> src,
    GridLike<T> dst, {
    Rect? source,
    Pos target = Pos.zero,
  }) {
    // TODO: Consider additional optimizations for linear grids.
    // Use a combination of getRect and fillRectFrom to copy the elements.
    final elements = GridView.getRectUnsafe(src, bounds: source);
    GridLike.fillRectFromUnsafe(
      dst,
      elements,
      bounds: Rect.fromTLBR(
        target,
        source?.bottomRight ?? Pos(src.width, src.height),
      ),
    );
  }
}

/// Grid-like object that stores elements in row-major order in linear memory.
///
/// This interface permits efficient access to elements in a grid-like object
/// that stores elements in a [List]. The [data] getter provides direct access
/// to elements by their linear index, which can be used to implement efficient
/// algorithms that iterate over the grid in a linear fashion.
///
/// It is _not_ recommended to expose this interface directly to users, as it
/// bypasses the bounds checking provided by the [GridLike] interface, and
/// instead should be used as an implementation detail of a grid-like object.
abstract mixin class LinearGridLike<T>
    implements LinearGridView<T>, GridLike<T> {
  @override
  @visibleForOverriding
  List<T> get data;

  @override
  @pragma('dart2js:index-bounds:trust')
  @pragma('vm:unsafe:no-bounds-checks')
  T getUnsafe(Pos pos) => data[pos.y * width + pos.x];

  @override
  @pragma('dart2js:index-bounds:trust')
  @pragma('vm:unsafe:no-bounds-checks')
  void setUnsafe(Pos pos, T value) {
    data[pos.y * width + pos.x] = value;
  }

  @override
  T get(Pos pos) {
    if (pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height) {
      throw RangeError('Position $pos is out of bounds for grid');
    }
    return getUnsafe(pos);
  }

  @override
  void set(Pos pos, T value) {
    if (pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height) {
      throw RangeError('Position $pos is out of bounds for grid');
    }
    setUnsafe(pos, value);
  }
}

final class _GridLike<T> with GridLike<T> {
  _GridLike(
    this._getUnsafe,
    this._setUnsafe, {
    required this.width,
    required this.height,
  }) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');
  }

  @override
  T getUnsafe(Pos pos) => _getUnsafe(pos);
  final T Function(Pos) _getUnsafe;

  @override
  void setUnsafe(Pos pos, T value) => _setUnsafe(pos, value);
  final void Function(Pos, T) _setUnsafe;

  @override
  final int width;

  @override
  final int height;
}

final class _LinearGridLike<T> with LinearGridLike<T> {
  _LinearGridLike(
    this.data, {
    required this.width,
    required this.height,
  }) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');
    if (data.length != width * height) {
      throw ArgumentError('Length of data must be equal to width * height');
    }
  }

  @override
  final List<T> data;

  @override
  T getUnsafe(Pos pos) => data[pos.y * width + pos.x];

  @override
  void setUnsafe(Pos pos, T value) {
    data[pos.y * width + pos.x] = value;
  }

  @override
  final int width;

  @override
  final int height;
}
