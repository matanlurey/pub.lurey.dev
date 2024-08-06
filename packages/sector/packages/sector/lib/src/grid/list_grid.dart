part of '../grid.dart';

/// A dense grid implementation using a 1-dimension [List] to store elements.
///
/// This implementation is the default grid type returned by the constructors in
/// the [Grid] interface. It is a row-major dense grid, where each row is stored
/// contiguously in memory; the most common layout for a grid, and is often the
/// most efficient for most use-cases.
///
/// ## Performance
///
/// [ListGrid] is optimized for dense grids, sacrificing memory efficiency for
/// runtime speed.
///
/// Operation           | Time Complexity
/// ------------------- | ---------------
/// `get`               | `O(1)`
/// `set`               | `O(1)`
/// `isEmpty`           | `O(n)`
/// `rows` or `columns` | `O(n)`
///
/// {@category Grids}
abstract final class ListGrid<E> with Grid<E> {
  const ListGrid._();

  /// Creates a new list grid with the given [width] and [height].
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
  /// final grid = ListGrid.filled(2, 2, empty: 0);
  ///
  /// print(grid.width); // 2
  /// print(grid.height); // 2
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// ```
  factory ListGrid.filled(
    int width,
    int height, {
    required E empty,
    E? fill,
  }) {
    RangeError.checkNotNegative(width, 'width');
    RangeError.checkNotNegative(height, 'height');
    final list = List.filled(
      width * height,
      fill ?? empty,
      growable: true,
    );
    return _ListGrid(width, height, empty, list);
  }

  /// Creates a new list grid with the given [width] and [height].
  ///
  /// Each element in the grid is initialized by calling [generator] with the
  /// position of the element. The [empty] element is used as the default value.
  ///
  /// The [width] and [height] must be non-negative.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = ListGrid.generate(2, 2, (pos) => pos.x + pos.y, empty: 0);
  ///
  /// print(grid.get(Pos(0, 0))); // 0
  /// print(grid.get(Pos(1, 0))); // 1
  /// ```
  factory ListGrid.generate(
    int width,
    int height,
    E Function(Pos pos) generator, {
    required E empty,
  }) {
    final list = List<E>.generate(width * height, (index) {
      final pos = Pos(index % width, index ~/ width);
      return generator(pos);
    });
    return _ListGrid(width, height, empty, list);
  }

  /// Creates a new list grid from an existing grid.
  ///
  /// The newer grid is a shallow copy of the existing grid, with the same size,
  /// position, and elements. The [empty] element is used as the default value,
  /// which defaults to `other.empty` if omitted.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final grid = ListGrid.filled(2, 2, empty: 0);
  /// grid.set(Pos(0, 0), 1);
  ///
  /// final copy = ListGrid.from(grid);
  /// print(copy.get(Pos(0, 0))); // 1
  /// ```
  factory ListGrid.from(Grid<E> other, {E? empty}) {
    if (other is _ListGrid<E>) {
      return _ListGrid(
        other._width,
        other._height,
        empty ?? other.empty,
        List<E>.from(other._elements),
      );
    }
    final list = List.of(other.rows.expand((row) => row));
    return _ListGrid(other.width, other.height, empty ?? other.empty, list);
  }

  /// Creates a new list grid from a 2D list of rows of columns.
  ///
  /// Each element in `rows`, a column, must have the same length, and the
  /// resulting grid will have a width equal to the number of columns, and a
  /// height equal to the length of each column.
  ///
  /// The grid is initialized with the elements in the rows, where the element
  /// at index `(x, y)` is `rows.elementAt(y).elementAt(x)`. If the [empty]
  /// element is omitted, the most common element in the rows is used, in which
  /// case the rows must be non-empty.
  factory ListGrid.fromRows(Iterable<Iterable<E>> rows, {E? empty}) {
    final height = rows.length;
    final list = List.of(_expandEqualLength(rows));
    final width = height == 0 ? 0 : list.length ~/ height;
    return _ListGrid(
      width,
      height,
      empty ?? _mostCommonElement(list),
      list,
    );
  }

  /// Creates a new list grid from [elements] in row-major order.
  ///
  /// Each element in `rows`, a column, must have the same length, and the
  /// resulting grid will have a width equal to the number of columns, and a
  /// height equal to the length of each column.
  ///
  /// The grid is initialized with the elements in the rows, where the element
  /// at index `(x, y)` is `rows.elementAt(y).elementAt(x)`. If the [empty]
  /// element is omitted, the most common element in the rows is used, in which
  /// case the rows must be non-empty.
  factory ListGrid.fromCells(
    Iterable<E> elements, {
    required int width,
    E? empty,
  }) {
    if (width == 0) {
      return _ListGrid(0, 0, ArgumentError.checkNotNull(empty, 'empty'));
    }
    final list = List.of(elements);
    final height = list.length ~/ width;
    if (list.length % width != 0) {
      throw ArgumentError.value(
        elements,
        'elements',
        'Must have a length that is a multiple of $width.',
      );
    }
    return _ListGrid(width, height, empty ?? _mostCommonElement(list), list);
  }

  /// Creates a new grid backed by the provided [elements] in row-major order.
  ///
  /// The grid will have a width of [width], and the number of rows is
  /// determined by the number of elements divided by the width, which must be
  /// an integer.
  ///
  /// Changes to the provided list will be reflected in the grid, and changes
  /// to the grid will be reflected in the list accordingly, with `elements[i]`
  /// being the element at position `Pos(i % width, i ~/ width)`.
  ///
  /// > [!WARNING]
  /// > The provided list must not be modified in a way that violates the
  /// > constraints of the grid, such as changing the length of the list, or
  /// > changing the elements in a way that violates the width of the grid.
  /// >
  /// > If the list will support appending rows or columns at runtime, access
  /// > must carefully avoid modifying the length during iteration, including by
  /// > [ListGrid.columns], [ListGrid.rows], or any other iterative operation.
  ///
  /// ## Performance
  ///
  /// This constructor exists in order to avoid copying the elements of the list
  /// into a new list, which can be expensive for large lists, or for using a
  /// different sub-type of [List] such as [Uint8List] or [Float32List].
  factory ListGrid.withList(
    List<E> elements, {
    required int width,
    required E empty,
  }) {
    final height = elements.length ~/ width;
    if (elements.length % width != 0) {
      throw ArgumentError.value(
        elements,
        'elements',
        'Must have a length that is a multiple of $width.',
      );
    }
    return _ListGrid(width, height, empty, elements);
  }
}

final class _ListGrid<E> extends ListGrid<E> {
  _ListGrid(
    this._width,
    this._height,
    this.empty, [
    List<E>? elements,
  ])  : _elements = elements ??
            List.filled(
              _width * _height,
              empty,
              growable: true,
            ),
        super._();
  final List<E> _elements;

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
  /// Growing and shrinking the grid is an expensive operation, as it requires
  /// shifting every individual row in the grid. If you need to grow or shrink
  /// the grid, consider using [height] instead, which is much more efficient.
  ///
  /// See also: [SplayTreeGrid] for a cheaper way to grow the width of a grid.
  @override
  set width(int value) {
    RangeError.checkNotNegative(value, 'width');
    if (value == _width) {
      return;
    }
    if (value < _width) {
      // Remove in reverse order to avoid shifting elements multiple times.
      for (var y = _height - 1; y >= 0; y--) {
        _elements.removeRange(y * _width + value, y * _width + _width);
      }
    } else {
      // Add in reverse order to avoid shifting elements multiple times.
      for (var y = 0; y < _height; y++) {
        _elements.insertAll(
          y * value + _width,
          List.filled(
            value - _width,
            empty,
          ),
        );
      }
    }
    _width = value;
  }

  /// Sets the number of rows in the grid.
  ///
  /// The behavior of this method is as follows:
  /// - If the grid would shrink, elements outside the new bounds are removed.
  /// - If the grid would grow, the new elements are filled with [empty].
  ///
  /// Growing and shrinking the grid only requires adding or removing elements
  /// from the end of the list.
  @override
  set height(int value) {
    RangeError.checkNotNegative(value, 'height');
    if (value == _height) {
      return;
    }
    if (value < _height) {
      _elements.removeRange(value * _width, _height * _width);
    } else {
      _elements.addAll(List.filled((value - _height) * _width, empty));
    }
    _height = value;
  }

  /// Whether the grid is zero-length _or_ is entirely filled with [empty].
  ///
  /// > [!WARNING]
  /// > This operation is `O(n)` time complexity in the worst case.
  @override
  bool get isEmpty => _elements.every((element) => element == empty);

  /// Whether the grid contains at least one element that is not [empty].
  ///
  /// > [!WARNING]
  /// > This operation is `O(n)` time complexity in the worst case.
  @override
  bool get isNotEmpty => !isEmpty;

  @override
  E getUnchecked(Pos pos) {
    return _elements[pos.y * _width + pos.x];
  }

  @override
  void setUnchecked(Pos pos, E value) {
    _elements[pos.y * _width + pos.x] = value;
  }

  @override
  Iterable<Iterable<E>> get rows => _ListGridRowsIterable(this);
}

final class _ListGridRowsIterable<E> extends FixedLengthIterable<Iterable<E>> {
  _ListGridRowsIterable(this._grid);

  final _ListGrid<E> _grid;

  @override
  int get length => _grid.height;

  @override
  Iterable<E> elementAt(int index) {
    final start = index * _grid.width;
    return _grid._elements.sublist(start, start + _grid.width);
  }
}
