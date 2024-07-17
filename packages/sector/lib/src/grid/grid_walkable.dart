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
  static double _defaultWeight(void a, void b) => 1.0;

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// A weight is derived from the source and target nodes by calling the
  /// [weight] function.
  ///
  /// The [directions] are the relative positions of the neighbors to connect
  /// each node to. By default, the [Direction.cardinal] directions are used,
  /// which is the four cardinal directions (north, east, south, west).
  ///
  /// {@template sector.GridWalkable:connectEmptyCells}
  /// If [connectEmptyCells] is `true`, the empty cells in the grid are also
  /// connected to their neighbors. This is useful when the [weight] function
  /// will return [double.infinity] for impassable nodes instead of omitting
  /// them from the grid.
  /// {@endtemplate}
  factory GridWalkable.from(
    Grid<E> grid, {
    double Function(E, E) weight = _defaultWeight,
    Iterable<Pos> directions = Direction.cardinal,
    bool connectEmptyCells = false,
  }) {
    final list = identical(directions, Direction.cardinal)
        ? Direction.cardinal
        : List.of(directions);
    return GridWalkable._(
      grid,
      list,
      weight,
      connectEmptyCells: connectEmptyCells,
    );
  }

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// Each diagonal, or _ordinal_ direction is connected to each node.
  ///
  /// {@macro sector.GridWalkable:connectEmptyCells}
  factory GridWalkable.diagonal(
    Grid<E> grid, {
    double Function(E, E) weight = _defaultWeight,
    bool connectEmptyCells = false,
  }) {
    return GridWalkable._(
      grid,
      Direction.ordinal,
      weight,
      connectEmptyCells: connectEmptyCells,
    );
  }

  /// Creates a new lazily built weighted graph from a [grid].
  ///
  /// Both the cardinal and ordinal directions are connected to each node.
  ///
  /// {@macro sector.GridWalkable:connectEmptyCells}
  factory GridWalkable.all8Directions(
    Grid<E> grid, {
    double Function(E, E) weight = _defaultWeight,
    bool connectEmptyCells = false,
  }) {
    return GridWalkable._(
      grid,
      Direction.all,
      weight,
      connectEmptyCells: connectEmptyCells,
    );
  }

  const GridWalkable._(
    this._grid,
    this._directions,
    this._weight, {
    required bool connectEmptyCells,
  }) : _connectEmptyCells = connectEmptyCells;

  final Grid<E> _grid;
  final List<Pos> _directions;
  final double Function(E, E) _weight;
  final bool _connectEmptyCells;

  bool _isValid(Pos node) {
    if (!_grid.containsPos(node)) {
      return false;
    }
    final value = _grid.getUnchecked(node);
    return _connectEmptyCells || value != _grid.empty;
  }

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
  bool contains(Object? element) {
    return element is Pos && _adaptor._isValid(element);
  }

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
  int get length {
    for (var i = 0; i < _adaptor._directions.length; i++) {
      final next = _node + _adaptor._directions[i];
      if (_adaptor._isValid(next)) {
        return _adaptor._directions.length;
      }
    }
    return 0;
  }

  @override
  Iterator<(Pos, double)> get iterator {
    return _GridSuccessorsIterator(_adaptor, _node);
  }
}

final class _GridSuccessorsIterator<E> implements Iterator<(Pos, double)> {
  _GridSuccessorsIterator(this._adaptor, this._node);
  final GridWalkable<E> _adaptor;
  final Pos _node;

  late Pos _next;
  var _index = 0;

  @override
  (Pos, double) get current {
    return (
      _next,
      _adaptor._weight(
        _adaptor._grid.getUnchecked(_node),
        _adaptor._grid.getUnchecked(_next),
      ),
    );
  }

  @override
  bool moveNext() {
    while (_index < _adaptor._directions.length) {
      final next = _node + _adaptor._directions[_index++];
      if (_adaptor._isValid(next)) {
        _next = next;
        return true;
      }
    }
    return false;
  }
}
