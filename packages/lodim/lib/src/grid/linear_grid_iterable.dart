part of '../grid.dart';

/// An iterator that reads elements from a 2D grid in a linear fashion.
///
/// Operations that compute and dispatch 2D positions can be optimized by
/// iterating over the grid in a linear fashion, which can be more
/// cache-friendly when the grid is stored in a linear data structure such as
/// a [List].
final class _LinearGridIterable<T> extends Iterable<T> {
  const _LinearGridIterable(
    this._rowMajor,
    this._startOffset,
    this._endOffset,
    this._columnWidth,
    this._rowStride,
  );

  final List<T> _rowMajor;
  final int _startOffset;
  final int _endOffset;
  final int _columnWidth;
  final int _rowStride;

  @override
  Iterator<T> get iterator {
    return _LinearGridIterator(
      _rowMajor,
      _startOffset - 1,
      _endOffset,
      _columnWidth,
      _rowStride,
    );
  }
}

final class _LinearGridIterator<T> implements Iterator<T> {
  _LinearGridIterator(
    this._rowMajor,
    this._startOffset,
    this._endOffset,
    this._columnWidth,
    this._rowStride,
  );

  final List<T> _rowMajor;
  int _startOffset;
  final int _endOffset;
  final int _columnWidth;
  final int _rowStride;

  @override
  @pragma('dart2js:index-bounds:trust')
  @pragma('vm:unsafe:no-bounds-checks')
  T get current => _rowMajor[_startOffset];

  @override
  bool moveNext() {
    var start = _startOffset;
    if (++start >= _endOffset) {
      return false;
    }

    if (start % _columnWidth == 0) {
      start += _rowStride;
    }
    _startOffset = start;

    return true;
  }
}
