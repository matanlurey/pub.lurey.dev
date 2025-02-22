part of '../lodim.dart';

/// Checks that an integer [value] is positive.
///
/// Throws if the value is not positive (either zero or negative).
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `value`.
///
/// Returns [value] if it is positive.
int checkPositive(int value, [String? name, String? message]) {
  if (value <= 0) {
    throw RangeError.value(
      value,
      name ?? 'value',
      message ?? 'must be positive',
    );
  }
  return value;
}

/// Checks that an integer [value] is positive.
///
/// If [assertions][] are enabled, throws if the value is not positive (either
/// zero or negative).
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `value`.
///
/// Returns [value] if it is positive, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
int assertPositive(int value, [String? name, String? message]) {
  return _assertionsEnabled ? checkPositive(value, name, message) : value;
}

/// Checks that an integer [value] is non-negative.
///
/// Throws if the value is negative.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `index`.
///
/// Returns [value] if it is non-negative.
///
/// This method is identical to [RangeError.checkNotNegative] and is provided
/// for consistency.
int checkNonNegative(int value, [String? name, String? message]) {
  return RangeError.checkNotNegative(value, name ?? 'index', message);
}

/// Checks that an integer [value] is non-negative.
///
/// If [assertions][] are enabled, throws if the value is negative.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `index`.
///
/// Returns [value] if it is non-negative, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
int assertNonNegative(int value, [String? name, String? message]) {
  return _assertionsEnabled ? checkNonNegative(value, name, message) : value;
}

/// Checks that [cells] is a non-empty iterable and that it is rectangular.
///
/// A rectangular 1-dimensional iterable has a length that is a multiple of
/// [width], and if provided, [height] (if height is omitted, it defaults to
/// `cells.length ~/ width`).
///
/// Throws if the iterable is not rectangular or if it is empty (has no cells).
///
/// Returns the iterable and dimensions of the rectangle if it is rectangular.
(Iterable<E>, Pos) checkRectangular1D<E>(
  Iterable<E> cells, {
  required int width,
  int? height,
}) {
  return _checkRectangular1D(cells, check: true, width: width, height: height);
}

/// Checks that [cells] is a non-empty iterable and that it is rectangular.
///
/// A rectangular 1-dimensional iterable has a length that is a multiple of
/// [width], and if provided, [height] (if height is omitted, it defaults to
/// `cells.length ~/ width`).
///
/// If [assertions][] are enabled, throws if the iterable is not rectangular or
/// if it is empty (has no cells).
///
/// Returns the iterable and dimensions of the rectangle if it is rectangular.
(Iterable<E>, Pos) assertRectangular1D<E>(
  Iterable<E> cells, {
  required int width,
  int? height,
}) {
  return _checkRectangular1D(
    cells,
    check: _assertionsEnabled,
    width: width,
    height: height,
  );
}

@_pragmaInline
(Iterable<E>, Pos) _checkRectangular1D<E>(
  Iterable<E> cells, {
  required bool check,
  required int width,
  int? height,
}) {
  final length = cells.length;
  if (check && length == 0) {
    throw ArgumentError.value(cells, 'cells', 'must not be empty');
  }

  if (check) {
    checkPositive(width, 'width');

    // Check that it divides the length.
    if (length % width != 0) {
      throw RangeError.value(width, 'width', 'must divide the length of cells');
    }
  }

  if (height == null) {
    height = length ~/ width;
  } else if (length != width * height) {
    throw ArgumentError.value(cells, 'cells', 'must be rectangular');
  }

  return (cells, Pos(width, height));
}

/// Checks that the provided iterable of [rows] is rectangular and non-empty.
///
/// Throws if the iterable is not rectangular or if it is empty (has no rows).
///
/// Returns the iterable and dimensions of the rectangle if it is rectangular.
(Iterable<E>, Pos) checkRectangular2D<E>(Iterable<Iterable<E>> rows) {
  return _checkRectangular2D(rows, check: true);
}

/// Checks that the provided iterable of [rows] is rectangular and non-empty.
///
/// If [assertions][] are enabled, throws if the iterable is not rectangular or
/// if it is empty (has no rows).
///
/// Returns the iterable and dimensions of the rectangle if it is rectangular.
(Iterable<E>, Pos) assertRectangular2D<E>(Iterable<Iterable<E>> rows) {
  return _checkRectangular2D(rows, check: _assertionsEnabled);
}

@_pragmaInline
(Iterable<E>, Pos) _checkRectangular2D<E>(
  Iterable<Iterable<E>> rows, {
  required bool check,
}) {
  final height = rows.length;
  if (check && height == 0) {
    throw ArgumentError.value(rows, 'rows', 'must not be empty');
  }

  final width = rows.first.length;
  if (check && width == 0) {
    throw ArgumentError.value(rows, 'rows', 'must not contain empty rows');
  }

  if (check && rows.any((row) => row.length != width)) {
    throw ArgumentError.value(rows, 'rows', 'must be rectangular');
  }

  return (rows.expand((row) => row), Pos(width, height));
}
