import 'package:sector/sector.dart';

/// Additional convenience methods that are derived from the [Grid] interface.
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
}
