/// {@template warn-grid-might-not-be-growable}
/// > [!WARNING]
/// > Not all grid implementations support growable grids, or grids that can
/// > be resized after they have been created. You should typically only attempt
/// > to resize a grid if you constructed the grid yourself and know this
/// > instance supports resizing.
/// >
/// > For example, the [ListGrid] class supports growable grids, but the default
/// > grid implementation returned by [Grid.asSubGrid] only supports resizing if
/// > the view is "complete"; and [TypedDataGrid] does not support resizing at
/// > all.
/// {@endtemplate}
library;

import 'package:sector/sector.dart';
