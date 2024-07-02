/// A 🔥 _fast_ (benchmarked) and 👍🏼 _intuitive_ (idiomatic) 2D Grid API.
///
/// ## Usage
///
/// Most users will only interact directly with the [Grid] interface, which
/// is a 2-dimensional counterpart to the [List] interface with a full featured
/// API:
///
/// ```dart
/// final grid = Grid.filled(3, 3, 0);
/// print(grid);
/// // ┌───────┐
/// // │ 0 0 0 │
/// // │ 0 0 0 │
/// // │ 0 0 0 │
/// // └───────┘
/// ```
///
/// ## Performance
///
/// The default [Grid] implementation, [ListGrid], is optimized and benchmarked
/// for similar performance to using a 1-dimensional [List] for a 2-dimensional
/// grid, but with a more intuitive API.
///
/// For better `Grid<int>` or `Grid<double>` performance, use [ListGrid.view]
/// with a backing store of a typed data list, such as [Uint8List] or
/// [Float32List], which can be used to store elements more efficiently:
/// ```dart
/// final buffer = Uint8List(9);
/// final grid = ListGrid.view(buffer, width: 3);
/// print(grid);
/// // ┌───────┐
/// // │ 0 0 0 │
/// // │ 0 0 0 │
/// // │ 0 0 0 │
/// // └───────┘
/// ```
///
/// ## Custom Implementations
///
/// The default implementation of [Grid] is [ListGrid], which is a dense grid
/// using a 1-dimensional [List] to store elements, but the full Dart source is
/// is available as a reference (no private APIs or FFI is used).
///
/// To make your own implementations easier, the following is recommended:
/// - Have your list extend or mixin [Grid]:
///   ```dart
///   class MyGrid<T> with Grid<T> { /*...*/ }
///   ```
///
/// - Use [GridImpl] for common functionality, such as bounds checking:
///   ```dart
///   // Assuming you could not use `Grid` as a mixin:
///   T get(int x, int y) {
///     GridImpl.checkBoundsInclusive(this, x, y);
///     return _cells[y * width + x];
///   }
///   ```
///
/// - Use [RowsBase] and [ColumnsBase] to implement [Rows] and [Columns]:
///   ```dart
///   class _Rows<T> extends Iterable<Iterable<T>> with RowsBase<T> { /*...*/ }
///   ```
///
/// After profiling, you may find that the default implementation is sufficient
/// for your use-case, but if you need to optimize further, you can replace the
/// built-in methods (either from a mixin or [GridImpl]) with your own.
library;

import 'dart:typed_data';

import 'package:sector/sector.dart';

export 'src/base/columns.dart' show Columns, ColumnsBase;
export 'src/base/iterator.dart' show GridIterable, GridIterator;
export 'src/base/rows.dart' show Rows, RowsBase;
export 'src/base/traversal.dart' show Traversal;
export 'src/grids/grid.dart' show Grid;
export 'src/grids/list.dart' show ListGrid;
export 'src/traverse/draw_line.dart' show drawLine;
export 'src/traverse/row_major.dart' show rowMajor;
export 'src/utils/grid_extension.dart' show GridExtension;
export 'src/utils/grid_impl.dart' show GridImpl;
export 'src/utils/octant.dart' show Octant;
