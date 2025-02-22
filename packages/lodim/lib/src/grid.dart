part of '../lodim.dart';

/// Returns the start  indices of the full-width rectangle.
///
/// If the rectangle is not full-width, returns `null`.
int? _checkFullWidth(Rect rect, {required int width}) {
  if (rect.width == width) {
    return rect.topLeft.toRowMajor(width: width);
  }
  return null;
}

/// Checks that the bounds are valid for a linear grid.
void _assertValidLinearBounds(
  int length, {
  required int width,
  Rect? bounds,
  String name = 'Source',
}) {
  // coverage:ignore-start
  // Check that width is positive, and can sub-divide the length evenly.
  assertPositive(width, '$name width');
  assert(length % width == 0, '$name length must be divisible by width.');

  // Check that the bounds are valid if specified.
  if (bounds != null) {
    assert(
      bounds.width <= width,
      '$name bounds width must be less than or equal to width.',
    );
    assert(
      bounds.height <= length ~/ width,
      '$name bounds height must be less than or equal to height.',
    );
  }
  // coverage:ignore-end
}

/// Returns each element within [bounds], exclusive of the bottom-right edge.
///
/// The [get] function is called with each position within the bounds, and the
/// return value is lazily yielded.
///
/// {@template lodim:GridUnsafeNotice}
/// It is the caller's responsibility to ensure that the bounds are valid or
/// the behavior is undefined. This function is intended as a low-level utility
/// for grid-like structures; consider asserting or clamping the bounds if
/// necessary before calling this function.
/// {@endtemplate}
///
/// The result is in row-major order.
///
/// ## Example
///
/// {@template lodim:GridExampleNotice}
/// For the below examples, we use a simple 2-dimensional list as the grid-like
/// structure.
///
/// Consider [`package:sector`](https://pub.dev/packages/sector) for a complete
/// implementation.
/// {@endtemplate}
///
/// ### All elements in a grid
///
/// ```dart
/// final grid = [
///   [1, 2, 3],
///   [4, 5, 6],
/// ];
///
/// final allElemennts = getRect(
///   Rect.fromWH(3, 2),
///   (pos) => grid[pos.y][pos.x],
/// );
/// print(allElemennts); // => [1, 2, 3, 4, 5, 6]
/// ```
///
/// ### Sub-elements in a grid
///
/// ```dart
/// final subElements = getRect(
///   Rect.fromLTWH(1, 0, 2, 1),
///   (pos) => grid[pos.y][pos.x],
/// );
/// print(subElements); // => [2, 3]
/// ```
Iterable<E> getRect<E>(Rect bounds, E Function(Pos) get) {
  return bounds.positions.map(get);
}

/// Returns each element within [bounds], exclusive of the bottom-right edge.
///
/// {@template lodim:GridLinearNotice}
/// The [linear] list is assumed to contain all elements in row-major order,
/// and a position `(x, y)` is at index `y * width + x`. It is the caller's
/// responsibility to ensure that the bounds are valid, and [width] is the
/// width of the grid, or the behavior is undefined.
///
/// This function is intended as a low-level utility for grid-like structures;
/// consider asserting or clamping the bounds if necessary before calling this
/// function.
/// {@endtemplate}
///
/// If [bounds] is omitted, the default is the entire grid.
///
/// The result is in row-major order.
///
/// ## Example
///
/// ### All elements in a grid
///
/// ```dart
/// final grid = [
///   1, 2, 3,
///   4, 5, 6,
/// ];
///
/// final allElemennts = getRectLinear(
///   grid,
///   width: 3,
/// );
/// print(allElemennts); // => [1, 2, 3, 4, 5, 6]
/// ```
///
/// ### Sub-elements in a grid
///
/// ```dart
/// final grid = [
///   1, 2, 3,
///   4, 5, 6,
/// ];
///
/// final subElements = getRectLinear(
///   grid,
///   width: 3,
///   bounds: Rect.fromLTWH(1, 0, 2, 1),
/// );
///
/// print(subElements); // => [2, 3]
/// ```
@_pragmaSpecialize
Iterable<E> getRectLinear<E>(
  List<E> linear, {
  required int width,
  Rect? bounds,
}) {
  _assertValidLinearBounds(linear.length, width: width, bounds: bounds);

  // Optimization: Entire grid.
  if (bounds == null) {
    return linear;
  }

  // Optimization: 1 contiguous region.
  if (_checkFullWidth(bounds, width: width) case final start?) {
    return linear.getRange(start, start + bounds.area);
  }

  // General case: Multiple regions.
  return Iterable.generate(bounds.height, (y) {
    final start = bounds.topLeft.toRowMajor(width: width) + y * width;
    final end = start + bounds.width;
    return linear.getRange(start, end);
  }).expand((e) => e);
}

/// Fills each element within [bounds], exclusive of the bottom-right edge,
/// with [value].
///
/// The [set] function is called with each position within the bounds, and the
/// [value] is passed as the second argument.
///
/// {@macro lodim:GridUnsafeNotice}
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// {@macro lodim:GridExampleNotice}
///
/// ### Fill a grid with a value
///
/// ```dart
/// final grid = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// fillRect(
///   Rect.fromWH(3, 2),
///   (pos, value) => grid[pos.y][pos.x] = value,
///   1,
/// );
///
/// print(grid); // => [[1, 1, 1], [1, 1, 1]]
/// ```
///
/// ### Fill a sub-region with a value
///
/// ```dart
/// final grid = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// fillRect(
///   Rect.fromLTWH(1, 0, 2, 1),
///   (pos, value) => grid[pos.y][pos.x] = value,
///   1,
/// );
///
/// print(grid); // => [[0, 1, 1], [0, 0, 0]]
/// ```
void fillRect<E>(Rect bounds, void Function(Pos, E) set, E value) {
  for (final pos in bounds.positions) {
    set(pos, value);
  }
}

/// Fills each element within [bounds], exclusive of the bottom-right edge,
/// with [value].
///
/// {@macro lodim:GridLinearNotice}
///
/// If [bounds] is omitted, the default is the entire grid.
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// ### Fill a grid with a value
///
/// ```dart
/// final grid = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// fillRectLinear(
///   grid,
///   1,
///   width: 3,
/// );
///
/// print(grid); // => [1, 1, 1, 1, 1, 1]
/// ```
///
/// ### Fill a sub-region with a value
///
/// ```dart
/// final grid = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// fillRectLinear(
///   grid,
///   1,
///   width: 3,
///   bounds: Rect.fromLTWH(1, 0, 2, 1),
/// );
/// ```
@_pragmaSpecialize
void fillRectLinear<E>(
  List<E> linear,
  E value, {
  required int width,
  Rect? bounds,
}) {
  _assertValidLinearBounds(linear.length, width: width, bounds: bounds);

  // Optimization: Entire grid.
  if (bounds == null) {
    return linear.fillRange(0, linear.length, value);
  }

  // Optimization: 1 contiguous region.
  if (_checkFullWidth(bounds, width: width) case final start?) {
    return linear.fillRange(start, start + bounds.area, value);
  }

  // General case: Multiple regions.
  for (var y = 0; y < bounds.height; y++) {
    final start = bounds.topLeft.toRowMajor(width: width) + y * width;
    final end = start + bounds.width;
    linear.fillRange(start, end, value);
  }
}

/// Fills each element within [bounds], exclusive of the bottom-right edge,
/// from an iterable of [values].
///
/// The [set] function is called with each position within the bounds, and the
/// corresponding value from [values] is passed as the second argument (which
/// is iterated in order).
///
/// {@macro lodim:GridUnsafeNotice}
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// {@macro lodim:GridExampleNotice}
///
/// ### Fill a grid with values
///
/// ```dart
/// final grid = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// fillRectFrom(
///   Rect.fromWH(3, 2),
///   (pos, value) => grid[pos.y][pos.x] = value,
///   [1, 2, 3, 4, 5, 6],
/// );
///
/// print(grid); // => [[1, 2, 3], [4, 5, 6]]
/// ```
///
/// ### Fill a sub-region with values
///
/// ```dart
/// final grid = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// fillRectFrom(
///   Rect.fromLTWH(1, 0, 2, 1),
///   (pos, value) => grid[pos.y][pos.x] = value,
///   [1, 2],
/// );
///
/// print(grid); // => [[0, 1, 2], [0, 0, 0]]
/// ```
void fillRectFrom<E>(
  Rect bounds,
  void Function(Pos, E) set,
  Iterable<E> values,
) {
  final pIt = bounds.positions.iterator;
  final vIt = values.iterator;
  while (pIt.moveNext() && vIt.moveNext()) {
    set(pIt.current, vIt.current);
  }
}

/// Fills each element within [bounds], exclusive of the bottom-right edge,
/// from an iterable of [values].
///
/// {@macro lodim:GridLinearNotice}
///
/// If [bounds] is omitted, the default is the entire grid.
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// ```dart
/// final grid = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// fillRectFromLinear(
///   grid,
///   [1, 2, 3, 4, 5, 6],
///   width: 3,
/// );
///
/// print(grid); // => [1, 2, 3, 4, 5, 6]
/// ```
///
/// ```dart
/// final grid = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// fillRectFromLinear(
///   grid,
///   [1, 2],
///   width: 3,
///   bounds: Rect.fromLTWH(1, 0, 2, 1),
/// );
///
/// print(grid); // => [0, 1, 2, 0, 0, 0]
/// ```
@_pragmaSpecialize
void fillRectFromLinear<E>(
  List<E> linear,
  Iterable<E> values, {
  required int width,
  Rect? bounds,
}) {
  _assertValidLinearBounds(linear.length, width: width, bounds: bounds);

  // Optimization: Entire grid.
  if (bounds == null) {
    return linear.setAll(0, values);
  }

  // Optimization: 1 contiguous region.
  if (_checkFullWidth(bounds, width: width) case final start?) {
    return linear.setAll(start, values);
  }

  // General case: Multiple regions.
  var skip = 0;
  for (var y = 0; y < bounds.height; y++) {
    final corner = Pos(bounds.left, bounds.top + y);
    final offset = corner.toRowMajor(width: width);
    linear.setRange(offset, offset + bounds.width, values, skip);
    skip += bounds.width;
  }
}

/// Copies each element within [source], exclusive of the bottom-right edge,
/// to another grid-like structure.
///
/// The [get] function is called with each position within the bounds, and the
/// return value is passed to the [set] function with the same position.
///
/// {@macro lodim:GridUnsafeNotice}
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// {@macro lodim:GridExampleNotice}
///
/// ### Copy a grid to another grid
///
/// ```dart
/// final grid = [
///   [1, 2, 3],
///   [4, 5, 6],
/// ];
///
/// final other = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// copyRect(
///   Rect.fromWH(3, 2),
///   (pos) => grid[pos.y][pos.x],
///   (pos, value) => other[pos.y][pos.x] = value,
/// );
///
/// print(other); // => [[1, 2, 3], [4, 5, 6]]
/// ```
///
/// ### Copy a sub-region to another grid
///
/// ```dart
/// final grid = [
///   [1, 2, 3],
///   [4, 5, 6],
/// ];
///
/// final other = [
///   [0, 0, 0],
///   [0, 0, 0],
/// ];
///
/// copyRect(
///   Rect.fromLTWH(1, 0, 2, 1),
///   (pos) => grid[pos.y][pos.x],
///   (pos, value) => other[pos.y][pos.x] = value,
///   target: Pos(1, 0),
/// );
///
/// print(other); // => [[0, 1, 2], [0, 0, 0]]
/// ```
void copyRect<E>(
  Rect source,
  E Function(Pos) get,
  void Function(Pos, E) set, {
  Pos target = Pos.zero,
}) {
  // Set each element in the target grid.
  // Assuming the following:
  // 0 0 0 0
  // 0 0 1 2
  // 0 0 3 4
  //
  // Copying into:
  // 0 0
  // 0 0
  //
  // (2, 2) -> (0, 0) if target is (0, 0)
  final srcRect = source;

  // Translate and re-anchor the source rectangle to the target position.
  final dstRect = Rect.fromTLBR(target, target + srcRect.size);

  // Iterate over each position in the source rectangle.
  final srcIt = srcRect.positions.iterator;
  final dstIt = dstRect.positions.iterator;
  while (srcIt.moveNext() && dstIt.moveNext()) {
    set(dstIt.current, get(srcIt.current));
  }
}

/// Copies each element within [source], exclusive of the bottom-right edge,
/// to another grid-like structure.
///
/// {@macro lodim:GridLinearNotice}
///
/// If [source] is omitted, the default is the entire grid.
///
/// The changes are applied in row-major order.
///
/// ## Example
///
/// ### Copy a grid to another grid
///
/// ```dart
/// final grid = [
///   1, 2, 3,
///   4, 5, 6,
/// ];
///
/// final other = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// copyRectLinear(
///   grid,
///   other,
///   srcWidth: 3,
///   dstWidth: 3,
/// );
///
/// print(other); // => [1, 2, 3, 4, 5, 6]
/// ```
///
/// ### Copy a sub-region to another grid
///
/// ```dart
/// final grid = [
///   1, 2, 3,
///   4, 5, 6,
/// ];
///
/// final other = [
///   0, 0, 0,
///   0, 0, 0,
/// ];
///
/// copyRectLinear(
///   grid,
///   other,
///   srcWidth: 3,
///   dstWidth: 3,
///   source: Rect.fromLTWH(1, 0, 2, 1),
///   target: Pos(1, 0),
/// );
///
/// print(other); // => [0, 1, 2, 0, 0, 0]
/// ```
@_pragmaSpecialize
void copyRectLinear<E>(
  List<E> src,
  List<E> dst, {
  required int srcWidth,
  required int dstWidth,
  Rect? source,
  Pos target = Pos.zero,
}) {
  // Check that the source and destination bounds are valid.
  _assertValidLinearBounds(src.length, width: srcWidth, bounds: source);
  _assertValidLinearBounds(
    dst.length,
    width: dstWidth,
    bounds: source?.translate(target),
    name: 'Destination',
  );

  // Optimization: Contiguous src -> dst copy.
  if (source == null && target.x == 0) {
    final offset = target.toRowMajor(width: dstWidth);
    return dst.setRange(offset, offset + src.length, src);
  }

  // General case: Multiple regions.
  final srcRect = source ?? Rect.fromWH(srcWidth, src.length ~/ srcWidth);
  final dstRect = Rect.fromTLBR(target, target + srcRect.size);

  // Iterate over each row and use a memcpy-compatible setRange.
  final srcOffset = srcRect.topLeft.toRowMajor(width: srcWidth);
  final dstOffset = dstRect.topLeft.toRowMajor(width: dstWidth);
  for (var y = 0; y < srcRect.height; y++) {
    final srcStart = srcOffset + y * srcWidth;
    final dstStart = dstOffset + y * dstWidth;
    dst.setRange(dstStart, dstStart + srcRect.width, src, srcStart);
  }
}
