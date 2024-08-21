part of '../grid.dart';

/// Adapts a [Grid] into a [WeightedWalkable].
///
/// Each node in the grid is automatically connected to its neighbors, based on
/// the configuration provided; the neighbors are connected with the weight that
/// is a tuple of both the source and target node's values.
///
/// ## Example
///
/// ```dart
/// final grid = ListGrid.fromRows([
///   [1, 2, 3],
///   [4, 5, 6],
///   [7, 8, 9],
/// ]);
///
/// final graph = GridWalkable(grid);
/// ```
///
/// {@category Grids}
final class GridWalkable<E> with WeightedWalkable<Pos> {
  static double _defaultWeight(void a, void b, Pos c) => 1.0;

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// {@template sector.GridWalkable:weight}
  /// A weight is derived from the source and target nodes and the direction
  /// moved by calling the [weight] function. Any value that returns
  /// [double.infinity] is considered impassable and will not be connected to
  /// its neighbors.
  /// {@endtemplate}
  ///
  /// The [directions] are the relative positions of the neighbors to connect
  /// each node to. By default, the [Direction.cardinal] directions are used,
  /// which is the four cardinal directions (north, east, south, west).
  factory GridWalkable.from(
    Grid<E> grid, {
    double Function(E, E, Pos) weight = _defaultWeight,
    Iterable<Pos> directions = Direction.cardinal,
  }) {
    final list = identical(directions, Direction.cardinal)
        ? Direction.cardinal
        : List.of(directions);
    return GridWalkable._(
      grid,
      list,
      weight,
    );
  }

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// {@macro sector.GridWalkable:connectEmptyCells}
  ///
  /// Each diagonal, or _ordinal_ direction is connected to each node.
  factory GridWalkable.diagonal(
    Grid<E> grid, {
    double Function(E, E, Pos) weight = _defaultWeight,
  }) {
    return GridWalkable._(
      grid,
      Direction.ordinal,
      weight,
    );
  }

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// {@macro sector.GridWalkable:connectEmptyCells}
  ///
  /// Both the cardinal and ordinal directions are connected to each node.
  factory GridWalkable.all8Directions(
    Grid<E> grid, {
    double Function(E, E, Pos) weight = _defaultWeight,
  }) {
    return GridWalkable._(
      grid,
      Direction.all,
      weight,
    );
  }

  const GridWalkable._(
    this._grid,
    this._directions,
    this._weight,
  );

  final Grid<E> _grid;
  final List<Pos> _directions;
  final double Function(E, E, Pos) _weight;

  @override
  bool containsRoot(Pos node) {
    return _grid.containsPos(node);
  }

  @override
  Iterable<Pos> get roots {
    return _GridRootsIterable(this);
  }

  @override
  Iterable<(Pos, double)> successors(Pos node) {
    return _GridSuccessorsIterable(this, node);
  }
}

final class _GridRootsIterable<E> extends FixedLengthIterable<Pos> {
  const _GridRootsIterable(this._adaptor);
  final GridWalkable<E> _adaptor;

  @override
  int get length => _adaptor._grid.length;

  @override
  Pos elementAt(int index) {
    final row = index % _adaptor._grid.width;
    final col = index ~/ _adaptor._grid.width;
    return Pos(row, col);
  }
}

final class _GridSuccessorsIterable<E> extends Iterable<(Pos, double)> {
  const _GridSuccessorsIterable(this._adaptor, this._node);
  final GridWalkable<E> _adaptor;
  final Pos _node;

  @override
  Iterator<(Pos, double)> get iterator {
    return _GridSuccessorsIterator(_adaptor, _node);
  }
}

final class _GridSuccessorsIterator<E> implements Iterator<(Pos, double)> {
  _GridSuccessorsIterator(this._adaptor, this._node);
  final GridWalkable<E> _adaptor;
  final Pos _node;

  var _index = 0;

  @override
  late (Pos, double) current;

  @override
  bool moveNext() {
    while (_index < _adaptor._directions.length) {
      final next = _node + _adaptor._directions[_index++];
      if (!_adaptor._grid.containsPos(next)) {
        continue;
      }
      final weight = _adaptor._weight(
        _adaptor._grid.getUnsafe(_node),
        _adaptor._grid.getUnsafe(next),
        next - _node,
      );
      if (weight != double.infinity) {
        current = (next, weight);
        return true;
      }
    }
    return false;
  }
}
