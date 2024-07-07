import 'package:lodim/lodim.dart';

/// Calculates positions along a line using a fast 2D vector algorithm.
///
/// Considered less "pixel-perfect" than [bresenham], but faster and simpler.
///
/// ## Example
///
/// By default (i.e. `exclusive = false`):
///
/// ```dart
/// final line = vectorLine(Pos(0, 0), Pos(2, 2));
/// print(line); // (0, 0), (1, 1), (2, 2)
/// ```
///
/// When `exclusive = true`:
///
/// ```dart
/// final line = vectorLine(Pos(0, 0), Pos(2, 2), exclusive: true);
/// print(line); // (0, 0), (1, 1)
/// ```
Iterable<Pos> vectorLine(Pos start, Pos end, {bool exclusive = false}) {
  final slope = (end - start).normalizedApproximate;
  if (exclusive) {
    end -= slope;
  }
  return _VectorLine(start, end, slope);
}

final class _VectorLine extends Iterable<Pos> {
  const _VectorLine(this._start, this._end, this._slope);

  final Pos _start;
  final Pos _end;
  final Pos _slope;

  @override
  Iterator<Pos> get iterator {
    return _VectorLineIterator(_start - _slope, _end, _slope);
  }
}

class _VectorLineIterator implements Iterator<Pos> {
  _VectorLineIterator(this._start, this._end, this._slope);

  Pos _start;
  final Pos _end;
  final Pos _slope;

  @override
  Pos get current => _start;

  @override
  bool moveNext() {
    if (_start == _end) {
      return false;
    }
    _start += _slope;
    return true;
  }
}
