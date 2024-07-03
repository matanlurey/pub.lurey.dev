import 'package:sector/sector.dart';

/// Additional convenience methods that are derived from [Grid].
///
/// Methods are added here, instead of on the [Grid] interface when they are
/// purely derived from the existing methods on the interface, and don't have
/// perceived value in specialization for specific implementations.
extension GridExtension<T> on Grid<T> {
  /// Returns `true` if the grid is _not_ empty.
  ///
  /// A grid is considered not empty if it has at least one element.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.filled(3, 3, 0);
  /// print(grid.isNotEmpty); // true
  ///
  /// final empty = Grid.filled(0, 0, 0);
  /// print(empty.isNotEmpty); // false
  /// ```
  bool get isNotEmpty => !isEmpty;

  /// Returns a sub-grid view of the grid.
  ///
  /// Unlike [subGrid], this method's returned grid is clamped to the bounds of
  /// the original grid, ensuring that the sub-grid is always within the bounds
  /// of the original grid.
  Grid<T> subGridClamped({
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    left = left.clamp(0, this.width);
    top = top.clamp(0, this.height);
    width = (width ?? this.width - left).clamp(0, this.width - left);
    height = (height ?? this.height - top).clamp(0, this.height - top);
    return subGrid(left: left, top: top, width: width, height: height);
  }

  /// Returns a sub-grid view of the grid.
  ///
  /// Unlike [asSubGrid], this method's returned grid is clamped to the bounds
  /// of the original grid, ensuring that the sub-grid is always within the
  /// bounds of the original grid.
  Grid<T> asSubGridClamped({
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    left = left.clamp(0, this.width);
    top = top.clamp(0, this.height);
    width = (width ?? this.width - left).clamp(0, this.width - left);
    height = (height ?? this.height - top).clamp(0, this.height - top);
    return asSubGrid(left: left, top: top, width: width, height: height);
  }

  /// Fills the grid traversed by the [order] with the given [value].
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9],
  /// ]);
  /// grid.fill(edges, 0);
  /// print(grid);
  /// ```
  ///
  /// The output of the example is:
  ///
  /// ```txt
  /// ┌───────┐
  /// | 0 0 0 |
  /// | 0 5 0 |
  /// | 0 0 0 |
  /// └───────┘
  /// ```
  void fill<R extends GridIterable<void>>(Traversal<R, T> order, T value) {
    for (final (x, y) in order(this).positions) {
      setUnchecked(x, y, value);
    }
  }

  /// Fills the grid traversed by the [order] by calling [value] for each cell.
  ///
  /// The [value] function is called with the current cell's position and the
  /// previous value at that position. The return value of the function is used
  /// as the new value for the cell.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9],
  /// ]);
  /// grid.fillWith(edges, (x, y, previous) => previous - 1);
  /// print(grid);
  /// ```
  ///
  /// The output of the example is:
  ///
  /// ```txt
  /// ┌───────┐
  /// | 0 1 2 |
  /// | 3 5 5 |
  /// | 6 7 8 |
  /// └───────┘
  /// ```
  void fillWith<R extends GridIterable<T>>(
    Traversal<R, T> order,
    T Function(int x, int y, T previous) value,
  ) {
    for (final (x, y, p) in order(this).positioned) {
      setUnchecked(x, y, value(x, y, p));
    }
  }
}
