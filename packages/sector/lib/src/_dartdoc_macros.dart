/// {@template warn-grid-might-not-be-growable}
/// > [!WARNING]
/// > Not all grid implementations support growable grids, or grids that can
/// > be resized after they have been created. You should typically only attempt
/// > to resize a grid if you constructed the grid yourself and know this
/// > instance supports resizing.
/// >
/// > For example, the [ListGrid] class supports growable grids, but the default
/// > grid implementation returned by [Grid.asSubGrid] only supports resizing if
/// > the view is "complete"; meaning that [Grid.clear] only works if the view
/// > covers the entire grid, [Rows.insertAt], [Rows.removeAt] only work if the
/// > view's width is the same as the original grid's width and
/// > [Columns.insertAt], [Columns.removeAt] only work if the view's height is the
/// > same as the original grid's height.
/// {@endtemplate}
library;

import 'package:sector/sector.dart';
