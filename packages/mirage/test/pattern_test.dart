import 'package:mirage/mirage.dart';

import 'src/prelude.dart';

void main() {
  test('map', () {
    final pattern = Constant(0.5);

    final mapped = pattern.map((value) => value * 2.0);
    check(mapped.get2d(0, 0)).equals(1.0);
  });

  test('scale', () {
    final pattern = Constant(0.5);

    final scaled = pattern * 2.0;
    check(scaled.get2d(0, 0)).equals(1.0);
  });

  test('absolute', () {
    final pattern = Constant(-0.5);
    final absolute = pattern.absolute;
    check(absolute.get2d(0, 0)).equals(0.5);
  });

  test('normalized', () {
    final pattern = Constant(-0.5);

    final normalized = pattern.normalized;
    check(normalized.get2d(0, 0)).equals(0.25);
  });

  test('inverted', () {
    final pattern = Constant(0.5);

    final inverted = -pattern;
    check(inverted.get2d(0, 0)).equals(-0.5);
  });

  test('transposed', () {
    final pattern = Pattern2d.from((x, y) => x / y);
    check(pattern.get2d(1, 2)).equals(0.5);

    final transposed = pattern.transposed;
    check(transposed.get2d(1, 2)).equals(2.0);
  });

  test('add', () {
    final a = Constant(0.5);
    final b = Constant(0.5);

    final sum = a + b;
    check(sum.get2d(0, 0)).equals(1.0);
  });

  test('subtract', () {
    final a = Constant(0.5);
    final b = Constant(0.5);

    final difference = a - b;
    check(difference.get2d(0, 0)).equals(0.0);
  });

  test('max', () {
    final a = Constant(0.25);
    final b = Constant(0.75);

    final max = a.max(b);
    check(max.get2d(0, 0)).equals(0.75);
  });

  test('min', () {
    final a = Constant(0.25);
    final b = Constant(0.75);

    final min = a.min(b);
    check(min.get2d(0, 0)).equals(0.25);
  });

  group('checkerboard', () {
    test('even', () {
      final pattern = Checkerboard.even;
      check(pattern.get2d(0, 0)).equals(1.0);
      check(pattern.get2d(1, 0)).equals(-1.0);
    });

    test('odd', () {
      final pattern = Checkerboard.odd;
      check(pattern.get2d(0, 0)).equals(-1.0);
      check(pattern.get2d(1, 0)).equals(1.0);
    });
  });
}
