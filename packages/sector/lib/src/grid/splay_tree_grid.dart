part of '../grid.dart';

/// A sparse grid implementation backed by a [SplayTreeMap].
///
/// Every element in the grid that is [empty] is not stored in the map, and
/// instead is assumed to be the default value; this allows the grid to use less
/// memory than a dense grid implementation and grow in size efficiently,
/// suitable for grids **where most elements are [empty] or full grid iteration
/// is not a common operation**, such as map editors.
///
/// ## Performance
///
/// [SplayTreeGrid] is optimized for sparse grids, sacrificing runtime speed for
/// memory efficiency.
///
/// Operation           | Time Complexity
/// ------------------- | ---------------
/// `get`               | `O(log n)`
/// `set`               | `O(log n)`
/// `isEmpty`           | `O(1)`
/// `nonEmptyEntries`   | `O(m)`[^1]
/// `rows` or `columns` | `O(m log n)`[^1]
///
/// [^1]: Where `m` is the number of non-empty entries in the grid.
///
/// {@category Grids}
abstract final class SplayTreeGrid<E> extends Grid<E> {
  const SplayTreeGrid._();

  /// Creates a new splay tree grid with the given [width] and [height].
  ///
  /// Each element in the grid is initialized to [empty], which is also used as
  /// the default, or [Grid.empty], element. An empty element does not consume
  /// memory and is ideally the most common element in the grid.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = SplayTreeGrid.filled(2, 2, empty: 0);
  ///
  /// print(grid.width); // 2
  /// print(grid.height); // 2
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// ```
  factory SplayTreeGrid.filled(int width, int height, {required E empty}) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');
    return _SplayTreeGrid(width, height, empty);
  }

  /// Creates a new splay tree grid with the given [width] and [height].
  ///
  /// Each element in the grid is initialized by calling [generator] with the
  /// position of the element. The [empty] element is used as the default value.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = SplayTreeGrid.generate(2, 2, (pos) => pos.x + pos.y, empty: 0);
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// print(grid.get(Pos(1, 0))); // 1
  /// ```
  factory SplayTreeGrid.generate(
    int width,
    int height,
    E Function(Pos) generator, {
    required E empty,
  }) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');
    final grid = SplayTreeGrid<E>.filled(width, height, empty: empty);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        grid.setUnchecked(Pos(x, y), generator(Pos(x, y)));
      }
    }
    return grid;
  }

  /// Creates a new splay tree grid from an existing grid.
  ///
  /// The new grid is a shallow copy of the existing grid, with the same size,
  /// position, and elements. The [empty] element is used as the default value,
  /// which defaults to `other.empty` if omitted.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = SplayTreeGrid.filled(2, 2, empty: 0);
  /// grid.set(Pos(0, 0), 1);
  ///
  /// final clone = SplayTreeGrid.from(grid);
  /// print(clone.get(Pos(0, 0))); // 1
  /// ```
  factory SplayTreeGrid.from(Grid<E> other, {E? empty}) {
    final clone = _SplayTreeGrid<E>(
      other.width,
      other.height,
      empty ?? other.empty,
    );
    if (other is _SplayTreeGrid<E>) {
      clone._nodes.addAll(other._nodes);
    } else {
      for (var y = 0; y < other.height; y++) {
        for (var x = 0; x < other.width; x++) {
          final pos = Pos(x, y);
          clone.setUnchecked(pos, other.getUnchecked(pos));
        }
      }
    }
    return clone;
  }

  /// Entries in the grid that are not equal to [empty], in row-major order.
  ///
  /// Useful for operations that need to iterate over non-empty entries, such
  /// as drawing the grid:
  /// ```dart
  /// clearScreen();
  /// for (final (pos, node) in grid.nonEmptyEntries) {
  ///   drawNode(pos, node);
  /// }
  /// ```
  ///
  /// Iterating, [Iterable.first], and [Iterable.last] are efficient operations.
  Iterable<(Pos, E)> get nonEmptyEntries;
}

final class _SplayTreeGrid<E> extends SplayTreeGrid<E> {
  _SplayTreeGrid(this._width, this._height, this.empty) : super._();
  final _nodes = SplayTreeMap<Pos, E>(Pos.byRowMajor);

  @override
  final E empty;

  @override
  int get width => _width;
  int _width;

  @override
  int get height => _height;
  int _height;

  /// Sets the number of columns in the grid.
  ///
  /// The behavior of this method is as follows:
  /// - If the grid would shrink, elements outside the new bounds are removed.
  /// - If the grid would grow, the new elements are filled with [empty].
  ///
  /// Growing the grid is `O(1)` time complexity, while shrinking the grid is
  /// `O(n)`.
  ///
  /// The width must be non-negative.
  @override
  set width(int value) {
    // If we're growing, it's effectively a no-op.
    if (value >= _width) {
      _width = value;
      return;
    }

    // Otherwise, we need to remove all nodes that are out of bounds.
    _nodes.removeWhere((pos, _) => pos.x >= value);
    _width = value;
  }

  /// Sets the number of rows in the grid.
  ///
  /// The behavior of this method is as follows:
  /// - If the grid would shrink, elements outside the new bounds are removed.
  /// - If the grid would grow, the new elements are filled with [empty].
  ///
  /// Growing the grid is `O(1)` time complexity, while shrinking the grid is
  /// `O(n)`.
  ///
  /// The height must be non-negative.
  @override
  set height(int value) {
    // If we're growing, it's effectively a no-op.
    if (value >= _height) {
      _height = value;
      return;
    }

    // Otherwise, we need to remove all nodes that are out of bounds.
    _nodes.removeWhere((pos, _) => pos.y >= value);
    _height = value;
  }

  @override
  bool get isEmpty => _nodes.isEmpty;

  @override
  E getUnchecked(Pos pos) {
    return _nodes[pos] ?? empty;
  }

  @override
  void setUnchecked(Pos pos, E value) {
    if (value == empty) {
      _nodes.remove(pos);
    } else {
      _nodes[pos] = value;
    }
  }

  @override
  Iterable<(Pos, E)> get nonEmptyEntries => _NonEmptyEntriesIterable(_nodes);

  @override
  Iterable<Iterable<E>> get rows {
    return Iterable.generate(height, (y) => _SplayTreeGridRowIterable(this, y));
  }
}

final class _NonEmptyEntriesIterable<E> extends Iterable<(Pos, E)> {
  const _NonEmptyEntriesIterable(this._nodes);
  final SplayTreeMap<Pos, E> _nodes;

  @override
  (Pos, E) get first {
    final first = _nodes.firstKey();
    if (first == null) {
      throw StateError('No non-empty entries');
    }
    return (first, _nodes[first]!);
  }

  @override
  (Pos, E) get last {
    final last = _nodes.lastKey();
    if (last == null) {
      throw StateError('No non-empty entries');
    }
    return (last, _nodes[last]!);
  }

  @override
  Iterator<(Pos, E)> get iterator {
    return _NonEmptyEntriesIterator(_nodes.entries.iterator);
  }
}

final class _NonEmptyEntriesIterator<E> implements Iterator<(Pos, E)> {
  const _NonEmptyEntriesIterator(this._iterator);
  final Iterator<MapEntry<Pos, E>> _iterator;

  @override
  bool moveNext() => _iterator.moveNext();

  @override
  (Pos, E) get current {
    final entry = _iterator.current;
    return (entry.key, entry.value);
  }
}

final class _SplayTreeGridRowIterable<E> extends FixedLengthIterable<E> {
  _SplayTreeGridRowIterable(this._grid, this._y);
  final _SplayTreeGrid<E> _grid;
  final int _y;

  @override
  int get length => _grid.width;

  @override
  E elementAt(int index) {
    final pos = Pos(index, _y);
    return _grid.getUnchecked(pos);
  }

  @override
  Iterator<E> get iterator => _SplayTreeGridRowIterator(_grid, _y);
}

final class _SplayTreeGridRowIterator<E> implements Iterator<E> {
  _SplayTreeGridRowIterator(this._grid, this._y) {
    _emptyGap = _grid._nodes.firstKeyAfter(Pos(_grid.width, _y - 1))?.x ?? 0;
    _x = _emptyGap;
  }

  final _SplayTreeGrid<E> _grid;
  final int _y;
  var _x = 0;
  var _emptyGap = 0;

  @override
  late E current;

  @override
  bool moveNext() {
    // If there is a gap of empty elements, return the next empty element.
    if (_emptyGap > 0) {
      current = _grid.empty;
      _emptyGap--;
      return true;
    }

    // If we are out of bounds, return false.
    if (_x >= _grid.width) {
      return false;
    }

    // Look for the next key after (x, y) in the map.
    final curPos = Pos(_x, _y);
    if (_grid._nodes.containsKey(curPos)) {
      // Get the value at the current key.
      // Move the cursor to the next key.
      current = _grid._nodes[curPos] as E;
      _x++;
      return true;
    }

    // There are no more keys period, so fill the rest with empty elements.
    final nextPos = _grid._nodes.firstKeyAfter(curPos);
    if (nextPos == null || nextPos.y > _y) {
      _emptyGap = _grid.width - _x;
      _x = _grid.width;
      return moveNext();
    }

    // Set the distance to the next key as a gap of empty elements.
    // Move the cursor to the next key.
    _emptyGap = nextPos.x - _x - 1;
    _x = nextPos.x;
    current = _grid.empty;
    return true;
  }
}
