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
/// ## Caveats
///
/// This package will always provide _2D_ data structures. If you need three
/// or more dimensions, look elsewhere. A [Grid] is a _container_ for all kinds
/// of data; if you need to perform matrix operations, you are better off with
/// a dedicated linear algebra library, such as [`vector_math`][vector_math].
///
/// [vector_math]: https://pub.dev/packages/vector_math
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
/// Grids may optionally implement [EfficientIndexGrid] to provide hints to
/// consumers about how the grid is laid out in memory, which can be used to
/// optimize traversal algorithms.
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
/// - Use [RowsMixin] and [ColumnsMixin] to implement [GridAxis]s:
///   ```dart
///   class _Rows<T> extends GridAxis<T> with RowsMixin<T> { /*...*/ }
///   ```
///
/// After profiling, you may find that the default implementation is sufficient
/// for your use-case, but if you need to optimize further, you can replace the
/// built-in methods (either from a mixin or [GridImpl]) with your own.
library;

import 'dart:typed_data';

import 'package:sector/sector.dart';

export 'src/base/axis.dart' show ColumnsMixin, GridAxis, RowsMixin;
export 'src/base/iterator.dart' show GridIterable, GridIterator;
export 'src/base/layout_hint.dart' show LayoutHint;
export 'src/base/traversal.dart' show Traversal;
export 'src/grids/grid.dart' show EfficientIndexGrid, Grid;
export 'src/grids/list.dart' show ListGrid;
export 'src/grids/splay_tree.dart' show SplayTreeGrid;
export 'src/traverse/breadth_first.dart' show breadthFirst;
export 'src/traverse/draw_line.dart' show drawLine;
export 'src/traverse/draw_rect.dart' show drawRect;
export 'src/traverse/edges.dart' show edges;
export 'src/traverse/neighbors.dart' show neighbors, neighborsDiagonal;
export 'src/traverse/pretty_print.dart' show prettyPrint;
export 'src/traverse/row_major.dart' show rowMajor;
export 'src/utils/grid_extension.dart' show GridExtension;
export 'src/utils/grid_impl.dart' show GridImpl;
export 'src/utils/octant.dart' show Octant;
export 'src/views/unmodifiable_grid_view.dart' show UnmodifiableGridView;
