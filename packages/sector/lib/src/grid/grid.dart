part of '../grid.dart';

/// A collection of elements accessible by a two-dimensional index.
///
/// Grids are a representation of a two-dimensional matrix, where there is a
/// default, or [empty] element that initially fills the grid, and is used when
/// the grid is resized, and can be replaced by a different element of the same
/// type, [E].
///
/// {@category Grids}
abstract mixin class Grid<E> {
  // ignore: public_member_api_docs
  const Grid();

  /// Creates a new [ListGrid] with the given [width] and [height].
  ///
  /// Each element in the grid is initialized to [empty], which is also used as
  /// the default, or [Grid.empty], element. An empty element still consumes
  /// memory, but is used to allow resizing the grid.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.generate(2, 2, (pos) => pos.x + pos.y, empty: 0);
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// print(grid.get(Pos(1, 0))); // 1
  /// ```
  factory Grid.filled(
    int width,
    int height, {
    required E empty,
    E? fill,
  }) = ListGrid<E>.filled;

  /// Creates a new [ListGrid] with the given [width] and [height].
  ///
  /// Each element in the grid is initialized by calling [generator] with the
  /// position of the element. The [empty] element is used as the default value.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.generate(2, 2, (pos) => pos.x + pos.y, empty: 0);
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// print(grid.get(Pos(1, 0))); // 1
  /// ```
  factory Grid.generate(
    int width,
    int height,
    E Function(Pos pos) generator, {
    required E empty,
  }) = ListGrid<E>.generate;

  /// Creates a new [ListGrid] from an existing grid.
  ///
  /// The newer grid is a shallow copy of the existing grid, with the same size,
  /// position, and elements. The [empty] element is used as the default value,
  /// which defaults to `other.empty` if omitted.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.filled(2, 2, empty: 0);
  /// grid.set(Pos(0, 0), 1);
  ///
  /// final copy = Grid.from(grid);
  /// print(copy.get(Pos(0, 0))); // 1
  /// ```
  factory Grid.from(Grid<E> other, {E? empty}) = ListGrid<E>.from;

  // Creates a new [ListGrid] from a 2D list of rows of columns.
  ///
  /// Each element in `rows`, a column, must have the same length, and the
  /// resulting grid will have a width equal to the number of columns, and a
  /// height equal to the length of each column.
  ///
  /// The grid is initialized with the elements in the rows, where the element
  /// at index `(x, y)` is `rows.elementAt(y).elementAt(x)`. If the [empty]
  /// element is omitted, the most common element in the rows is used, in which
  /// case the rows must be non-empty.
  factory Grid.fromRows(
    Iterable<Iterable<E>> rows, {
    E? empty,
  }) = ListGrid<E>.fromRows;

  /// Creates a new [ListGrid] from [elements] in row-major order.
  ///
  /// Each element in `rows`, a column, must have the same length, and the
  /// resulting grid will have a width equal to the number of columns, and a
  /// height equal to the length of each column.
  ///
  /// The grid is initialized with the elements in the rows, where the element
  /// at index `(x, y)` is `rows.elementAt(y).elementAt(x)`. If the [empty]
  /// element is omitted, the most common element in the rows is used, in which
  /// case the rows must be non-empty.
  factory Grid.fromCells(
    Iterable<E> elements, {
    required int width,
    E? empty,
  }) = ListGrid<E>.fromCells;

  /// The default element for the grid, or the "empty" element.
  ///
  /// The empty element is used to represent the default value of the grid, and
  /// is used when resizing the grid. Depending on the implementation, the empty
  /// element may use less or no memory, and may be shared among all instances
  /// of the grid.
  ///
  /// An empty element should be considered immutable.
  E get empty;

  /// Number of columns in the grid, and the upper bound for the x-coordinate.
  ///
  /// Always non-negative.
  int get width;

  /// Sets the number of columns in the grid.
  ///
  /// The behavior of this method is as follows:
  /// - If the grid would shrink, elements outside the new bounds are removed.
  /// - If the grid would grow, the new elements are filled with [empty].
  ///
  /// The width must be non-negative.
  set width(int value);

  /// Number of rows in the grid, and the upper bound for the y-coordinate.
  ///
  /// Always non-negative.
  int get height;

  /// Sets the number of rows in the grid.
  ///
  /// The behavior of this method is as follows:
  /// - If the grid would shrink, elements outside the new bounds are removed.
  /// - If the grid would grow, the new elements are filled with [empty].
  ///
  /// The height must be non-negative.
  set height(int value);

  /// Total number of elements in the grid.
  int get length => width * height;

  /// Whether the grid is zero-length _or_ is entirely filled with [empty].
  bool get isEmpty;

  /// Whether the grid contains at least one element that is not [empty].
  bool get isNotEmpty => !isEmpty;

  /// Returns whether a position is within the bounds of the grid.
  bool containsPos(Pos pos) {
    return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height;
  }

  /// Returns the element at a position in the grid.
  ///
  /// The position must be within the bounds of the grid.
  ///
  /// This is an alias for [get].
  E operator [](Pos pos) => get(pos);

  /// Returns the element at a position in the grid.
  ///
  /// The position must be within the bounds of the grid.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.fromRows(
  ///   empty: Tile.wall,
  ///   [
  ///     [Tile.wall, Tile.wall, Tile.wall],
  ///     [Tile.wall, Tile.floor, Tile.wall],
  ///   ],
  /// );
  /// final pos = Pos(1, 1);
  /// print(grid.get(pos)); // Tile.floor
  /// ```
  E get(Pos pos) {
    if (!containsPos(pos)) {
      throw RangeError('Position $pos is out of bounds');
    }
    return getUnchecked(pos);
  }

  /// Returns the element at a position in the grid.
  ///
  /// If the position is not within the bounds of the grid, the behavior is
  /// undefined. This method is intended to be used in cases where the position
  /// can be trusted, such as an iterator or other trusted synchronous
  /// operations.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.fromRows(
  ///   empty: Tile.wall,
  ///   [
  ///     [Tile.wall, Tile.wall, Tile.wall],
  ///     [Tile.wall, Tile.floor, Tile.wall],
  ///   ],
  /// );
  ///
  /// for (var y = 0; y < grid.height; y++) {
  ///   for (var x = 0; x < grid.width; x++) {
  ///     final pos = Pos(x, y);
  ///     print(grid.getUnchecked(pos));
  ///   }
  /// }
  /// ```
  E getUnchecked(Pos pos);

  /// Sets the element at a position in the grid.
  ///
  /// The position must be within the bounds of the grid.
  ///
  /// This is an alias for [set].
  void operator []=(Pos pos, E value) => set(pos, value);

  /// Sets the element at a position in the grid.
  ///
  /// The position must be within the bounds of the grid.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.filled(2, 2, 0);
  /// final pos = Pos(1, 1);
  /// grid.set(pos, 1);
  /// print(grid.get(pos)); // 1
  /// ```
  void set(Pos pos, E value) {
    if (!containsPos(pos)) {
      throw RangeError('Position $pos is out of bounds');
    }
    setUnchecked(pos, value);
  }

  /// Sets the element at a position in the grid.
  ///
  /// If the position is not within the bounds of the grid, the behavior is
  /// undefined. This method is intended to be used in cases where the position
  /// can be trusted, such as an iterator or other trusted synchronous
  /// operations.
  ///
  /// ## Example
  ///
  /// ```dart
  /// for (var y = 0; y < grid.height; y++) {
  ///   for (var x = 0; x < grid.width; x++) {
  ///     final pos = Pos(x, y);
  ///     grid.setUnchecked(pos, 1);
  ///   }
  /// }
  /// ```
  void setUnchecked(Pos pos, E value);

  /// Rows of the grid.
  ///
  /// An iterable of rows, where each row is an iterable representing the
  /// columns of that particular row, in the order they appear in the grid;
  /// the first row is the top-most row, and the last row is the bottom-most
  /// row.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.fromRows(
  ///   [
  ///     [Tile.wall, Tile.wall, Tile.wall],
  ///     [Tile.wall, Tile.floor, Tile.wall],
  ///   ],
  ///   fill: Tile.wall,
  /// );
  /// print(grid.rows.first); // [Tile.wall, Tile.wall, Tile.wall]
  /// print(grid.rows.last); // [Tile.wall, Tile.floor, Tile.wall]
  /// ```
  Iterable<Iterable<E>> get rows => _Rows(this);

  /// Columns of the grid.
  ///
  /// An iterable of columns, where each column is an iterable representing the
  /// rows of that particular column, in the order they appear in the grid; the
  /// first column is the left-most column, and the last column is the right-
  /// most column.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = Grid.fromRows(
  ///   [
  ///     [Tile.wall, Tile.wall, Tile.wall],
  ///     [Tile.wall, Tile.floor, Tile.wall],
  ///   ],
  ///   fill: Tile.wall,
  /// );
  /// print(grid.columns.first); // [Tile.wall, Tile.wall]
  /// print(grid.columns.last); // [Tile.wall, Tile.wall]
  /// ```
  Iterable<Iterable<E>> get columns => _Columns(this);

  /// An iterable of positions and elements in the grid, in row-major order.
  Iterable<(Pos, E)> get cells => _Cells(this);

  /// The top-left position of the grid.
  Pos get topLeft => Pos(0, 0);

  /// The top-right position of the grid.
  Pos get topRight => Pos(width - 1, 0);

  /// The bottom-left position of the grid.
  Pos get bottomLeft => Pos(0, height - 1);

  /// The bottom-right position of the grid.
  Pos get bottomRight => Pos(width - 1, height - 1);

  /// Returns a view of this grid as an unweighted walkable.
  ///
  /// The view is a [Walkable] where nodes are positions in the grid, and edges
  /// are pairs of elements at each position. The [directions] are the relative
  /// positions of the neighbors to connect each node to, which by default are
  /// the four cardinal directions (north, east, south, west).
  Walkable<Pos> asUnweighted({
    Iterable<Pos> directions = Direction.cardinal,
  }) {
    return asWeighted(
      directions: directions,
      weight: _eachWeightIs1,
    ).asUnweighted();
  }

  static double _eachWeightIs1(void a, void b, void c) => 1.0;

  /// Returns a view of this grid as a weighted walkable.
  ///
  /// The view is a [WeightedWalkable] where nodes are positions in the grid,
  /// and edges are pairs of elements at each position. The [directions] are the
  /// relative positions of the neighbors to connect each node to, which by
  /// default are the four cardinal directions (north, east, south, west).
  ///
  /// {@macro sector.GridWalkable:weight}
  WeightedWalkable<Pos> asWeighted({
    required double Function(E, E, Pos) weight,
    Iterable<Pos> directions = Direction.cardinal,
  }) {
    return GridWalkable.from(
      this,
      directions: directions,
      weight: weight,
    );
  }

  /// Converts a [Grid] to a string like [toString].
  ///
  /// Each fill element is represented by a `#`, and each element in the grid
  /// is represented by `.`. The grid is represented as a series of rows, where
  /// each row is separated by a newline character.
  ///
  /// Alternate characters can be used by providing the [empty] and [fill]
  /// parameters:
  ///
  /// ```dart
  /// final grid = Grid.fromRows(
  ///   [
  ///     [Tile.wall, Tile.wall, Tile.wall],
  ///     [Tile.wall, Tile.floor, Tile.wall],
  ///   ],
  ///   empty: Tile.wall,
  /// );
  /// print(grid.toString());
  /// ```
  ///
  /// The above code will output:
  ///
  /// ```txt
  /// ###
  /// #.#
  /// ```
  static String gridToString(
    Grid<Object?> grid, {
    String fill = '.',
    String empty = '#',
  }) {
    final buffer = StringBuffer();
    for (final row in grid.rows) {
      for (final element in row) {
        buffer.write(element == grid.empty ? empty : fill);
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  @override
  String toString() => gridToString(this);
}

final class _Rows<E> extends FixedLengthIterable<Iterable<E>> {
  const _Rows(this._grid);
  final Grid<E> _grid;

  @override
  int get length => _grid.height;

  @override
  Iterable<E> elementAt(int index) {
    return Iterable.generate(_grid.width, (x) {
      return _grid.getUnchecked(Pos(x, index));
    });
  }
}

final class _Columns<E> extends FixedLengthIterable<Iterable<E>> {
  const _Columns(this._grid);
  final Grid<E> _grid;

  @override
  int get length => _grid.width;

  @override
  Iterable<E> elementAt(int index) {
    return Iterable.generate(_grid.height, (y) {
      return _grid.getUnchecked(Pos(index, y));
    });
  }
}

final class _Cells<E> extends FixedLengthIterable<(Pos, E)> {
  const _Cells(this._grid);
  final Grid<E> _grid;

  @override
  int get length => _grid.length;

  @override
  (Pos, E) elementAt(int index) {
    final y = index ~/ _grid.width;
    final x = index % _grid.width;
    return (Pos(x, y), _grid.getUnchecked(Pos(x, y)));
  }
}
