import 'package:meta/meta.dart';
import 'package:sector/sector.dart';

/// An interface for getting cells, one at a time, typically from a [Grid].
///
/// The `for`-`in` construct transparently uses `GridIterator` to test for the
/// end of the iteration, and to get each cell (or it's position).
///
/// If the grid iterated over is changed during the iteration, the behavior is
/// unspecified.
///
/// The `GridIterator` is initially positioned before the first cell. Before
/// accessing the first cell the iterator must be advanced using [moveNext],
/// to point to the first cell. If no cell is left, then [moveNext] returns
/// false, and all further calls to [moveNext] will also return false.
///
/// The [current] value and [position] must not be accessed before calling
/// [moveNext] or after a call to [moveNext] has returned false.
abstract mixin class GridIterator<E> implements Iterator<E> {
  /// Creates an empty grid iterator.
  const factory GridIterator.empty() = _EmptyGridIterator<E>;

  /// The current cell value.
  ///
  /// If the iterator has not yet been moved to the first cell ([moveNext] has
  /// not been called yet), or if the iterator has been moved past the last
  /// element of the grid, then [current] is unspecified; a grid iterator may
  /// either throw or return an iterator specific default value.
  ///
  /// The [current] getter should keep its value until the next call to
  /// [moveNext], even if the grid changes. After a successful call to
  /// [moveNext], the user doesn't need to cache the current cell, but can keep
  /// reading it from the iterator.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   ['a', 'b'],
  ///   ['c', 'd'],
  /// ]);
  /// final it = grid.traverse().iterator;
  /// while (it.moveNext()) {
  ///   print(it.current);
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
  @override
  E get current;

  /// The position of the [current] cell.
  ///
  /// If the iterator has not yet been moved to the first cell ([moveNext] has
  /// not been called yet), or if the iterator has been moved past the last
  /// element of the grid, then [position] is unspecified; a grid iterator may
  /// either throw or return an iterator specific default value.
  ///
  /// The [position] getter should keep its value until the next call to
  /// [moveNext], even if the grid changes. After a successful call to
  /// [moveNext], the user doesn't need to cache the current cell, but can keep
  /// reading it from the iterator.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   ['a', 'b'],
  ///   ['c', 'd'],
  /// ]);
  /// final it = grid.traverse().iterator;
  /// while (it.moveNext()) {
  ///   print(it.position);
  /// }
  /// ```
  ///
  /// The output of the example is:
  ///
  /// ```txt
  /// (0, 0)
  /// (1, 0)
  /// (0, 1)
  /// (1, 1)
  /// ```
  (int x, int y) get position;

  /// Advances the iterator to the next cell of the iteration.
  ///
  /// Should be called before reading [current] or [position].
  ///
  /// If the call to `moveNext` returns `true`, then [current] will contain the
  /// next cell of the iteration, and [position] will contain the position of
  /// the next cell, until `moveNext` is called again. If the call returns
  /// `false`, there are no further cells and [current] and [position] should
  /// not be used any more.
  ///
  /// It is safe to call [moveNext] after it has already returned `false`, but
  /// it must keep returning `false` and not have any other effect.
  ///
  /// A call to `moveNext` may throw for various reasons, including a concurrent
  /// change to an underlying grid. If that happens, the iterator may be in an
  /// inconsistent state, and any further behavior of the iterator is
  /// unspecified, including the effect of reading [current] or [position].
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   ['a', 'b'],
  ///   ['c', 'd'],
  /// ]);
  /// final it = grid.traverse().iterator;
  /// print(it.moveNext()); // true
  /// print(it.moveNext()); // true
  /// print(it.moveNext()); // true
  /// print(it.moveNext()); // true
  /// print(it.moveNext()); // false
  /// ```
  @override
  bool moveNext();

  /// Moves the iterator forward by [steps] cells.
  ///
  /// This method is equivalent to calling [moveNext] [steps] times, which is
  /// the default implementation. Subclasses may override this method to provide
  /// a more efficient implementation for iterators that can seek to a position
  /// without iterating through each cell.
  ///
  /// Returns `true` if the iterator is positioned at a valid cell after seeking
  /// [steps] cells, otherwise `false`. If [steps] is not at least 1 the
  /// behavior is unspecified.
  ///
  /// ## Examples
  ///
  /// ```dart
  /// final grid = Grid.fromRows([
  ///   ['a', 'b'],
  ///   ['c', 'd'],
  /// ]);
  /// final it = grid.traverse().iterator;
  /// print(it.seek(2)); // true
  /// print(it.current); // c
  /// print(it.position); // (0, 1)
  /// ```
  bool seek(int steps) {
    if (steps < 1) {
      throw RangeError.value(steps, 'steps', 'Must be at least 1');
    }
    for (var i = 0; i < steps; i++) {
      if (!moveNext()) {
        return false;
      }
    }
    return true;
  }

  /// Returns the remaining number of steps to the end of the iteration.
  ///
  /// If the number of remaining steps is unknown, the getter returns `null`.
  ///
  /// This getter is useful for algorithms that need to know how many steps are
  /// left to the end of the iteration, e.g. to calculate the distance to the
  /// end of the iteration.
  int? get remainingSteps => null;
}

final class _EmptyGridIterator<E> with GridIterator<E> {
  const _EmptyGridIterator();

  @override
  E get current => _noElement();

  @override
  (int, int) get position => _noElement();

  @override
  bool moveNext() => false;
}

final class _PositionIterator implements GridIterator<(int, int)> {
  const _PositionIterator(this._iterator);
  final GridIterator<void> _iterator;

  @override
  (int, int) get current => _iterator.position;

  @override
  (int, int) get position => _iterator.position;

  @override
  bool moveNext() => _iterator.moveNext();

  @override
  int? get remainingSteps => _iterator.remainingSteps;

  @override
  bool seek(int steps) => _iterator.seek(steps);
}

final class _PositionedIterator<E> implements GridIterator<(int, int, E)> {
  const _PositionedIterator(this._iterator);
  final GridIterator<E> _iterator;

  @override
  (int, int, E) get current {
    final (x, y) = _iterator.position;
    return (x, y, _iterator.current);
  }

  @override
  (int, int) get position => _iterator.position;

  @override
  bool moveNext() => _iterator.moveNext();

  @override
  int? get remainingSteps => _iterator.remainingSteps;

  @override
  bool seek(int steps) => _iterator.seek(steps);
}

Never _noElement() => throw StateError('No element');

/// A collection of cells that can be accessed sequentially.
///
/// A [GridIterable] is _mostly_ equivalent to an [Iterable], but with the
/// additional ability to access the [positions] of each cell, or even combine
/// them with the cell as [positioned] values `(x, y, cell)`.
///
/// ## Performance
///
/// Where possible, the iterable will seek to the desired position in the grid
/// without iterating through each cell. An [Iterator] can optimize methods in
/// this class by overriding [GridIterator.seek] and providing
/// [GridIterator.remainingSteps].
final class GridIterable<E> extends Iterable<E> {
  /// Creates a new iterable which generates cells from the provided iterator.
  ///
  /// The generated iterable invokes the provided factory function to create a
  /// new iterator each time the iterable is iterated. The function should
  /// always return a new iterator that is positioned before the first cell.
  const GridIterable.from(this._iterator);

  /// Creates an empty iterable.
  const GridIterable.empty() : _iterator = GridIterator.empty;

  // Generates the iterator for the iterable.
  final GridIterator<E> Function() _iterator;

  /// An iterable that generates the _positions_ of each cell.
  ///
  /// The positions are returned as a tuple of `(x, y)` coordinates.
  Iterable<(int, int)> get positions {
    return GridIterable.from(() => _PositionIterator(_iterator()));
  }

  /// An iterable that generates the _positions_ and _values_ of each cell.
  ///
  /// The positions are returned as a tuple of `(x, y)` coordinates.
  Iterable<(int, int, E)> get positioned {
    return GridIterable.from(() => _PositionedIterator(_iterator()));
  }

  @override
  @nonVirtual
  Iterator<E> get iterator => _iterator();

  @override
  int get length {
    final it = _iterator();
    if (it.remainingSteps case final int length) {
      return length;
    }
    var count = 0;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }

  @override
  Iterable<E> skip(int count) {
    RangeError.checkNotNegative(count, 'count');
    return GridIterable.from(() => _iterator()..seek(count));
  }

  @override
  E get last {
    final it = _iterator();
    if (it.remainingSteps case final int length) {
      if (length == 0) {
        _noElement();
      }
      it.seek(length);
      return it.current;
    }
    E? last;
    while (it.moveNext()) {
      last = it.current;
    }
    return last ?? _noElement();
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    final it = _iterator();

    // If we have a known length, we can seek in reverse.
    if (it.remainingSteps case final int length) {
      for (var i = length - 1; i > 0; i--) {
        it.seek(i);
        if (test(it.current)) {
          return it.current;
        }
      }
      if (orElse != null) {
        return orElse();
      }
      _noElement();
    }

    // Fallback to the default implementation.
    E? last;
    while (it.moveNext()) {
      if (test(it.current)) {
        last = it.current;
      }
    }
    return last ?? (orElse != null ? orElse() : _noElement());
  }

  @override
  E get single {
    final it = _iterator();
    if (it.remainingSteps case final int length) {
      if (length != 1) {
        throw StateError('Expected exactly one element, but found $length');
      }
      it.moveNext();
      return it.current;
    }
    if (!it.moveNext()) {
      _noElement();
    }
    if (it.moveNext()) {
      throw StateError('Expected exactly one element, but found more');
    }
    return it.current;
  }

  @override
  E elementAt(int index) {
    RangeError.checkNotNegative(index, 'index');
    final it = _iterator();
    if (it.seek(index + 1)) {
      return it.current;
    }
    throw IndexError.withLength(index, length, indexable: this, name: 'index');
  }
}
