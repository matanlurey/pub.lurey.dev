import 'package:sector/sector.dart';

/// A traversal that can be used to iterate over a grid in a specific order.
///
/// This interface is used to define the order in which elements are visited
/// when iterating over a grid. For example, a row-major traversal will visit
/// each row in order from left to right, while a spiral traversal will visit
/// the elements in a spiral pattern starting from the center.
///
/// See some built-in traversals:
///
/// - [rowMajor]
/// - [drawLine]
///
/// ## Examples
///
/// To use a traversal, call the `traverse` method on the grid with the desired
/// type of traversal. For example, to iterate over a grid in row-major order:
/// ```dart
/// final grid = ListGrid.fromRows([
///   ['a', 'b'],
///   ['c', 'd'],
/// ]);
/// for (final cell in grid.traverse(rowMajor)) {
///   print(cell);
/// }
/// ```
///
/// The output of the example is:
///
/// ```txt
/// a
/// b
/// c
/// d
/// ```
typedef Traversal<T> = GridIterable<T> Function(Grid<T> grid);
