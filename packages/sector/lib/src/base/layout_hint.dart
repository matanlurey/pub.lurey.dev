import 'package:sector/sector.dart';

/// Optional hint for the layout of the data in memory.
///
/// Can be used to optimize performance for certain operations.
enum LayoutHint {
  /// The layout of the data is unknown or not specified.
  private,

  /// Each cell is stored in a contiguous block of memory in row-major order.
  ///
  /// When calling [Grid.getByIndexUnchecked], the position is calculated as:
  /// ```dart
  /// final x = index % width;
  /// final y = index ~/ width;
  /// ```
  rowMajorContiguous,

  // Prevents the enum from being exhaustively checked.
  // ignore: unused_field
  _;
}
