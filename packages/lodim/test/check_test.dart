import '_prelude.dart';

void main() {
  test('checkPositive throws an error if the value is negative', () {
    check(() => checkPositive(-1)).throws<RangeError>();
  });

  test('checkPositive throws an error if the value is zero', () {
    check(() => checkPositive(0)).throws<RangeError>();
  });

  test('checkPositive returns the value if it is positive', () {
    check(checkPositive(1)).equals(1);
  });

  test('checkNonNegative throws an error if the value is negative', () {
    check(() => checkNonNegative(-1)).throws<RangeError>();
  });

  test('checkNonNegative returns the value if it is zero', () {
    check(checkNonNegative(0)).equals(0);
  });

  test('checkNonNegative returns the value if it is positive', () {
    check(checkNonNegative(1)).equals(1);
  });

  test('assertNonNegative throws an error if the value is negative', () {
    check(() => assertNonNegative(-1)).throws<Error>();
  });

  group('checkRectangular1d', () {
    test('throws if width is negative', () {
      check(() => checkRectangular1D([1, 2], width: -1)).throws<RangeError>();
    });

    test('throws if the width is 0', () {
      check(() => checkRectangular1D([1, 2], width: 0)).throws<RangeError>();
    });

    test('throws if the width is greater than the length', () {
      check(() => checkRectangular1D([1, 2], width: 3)).throws<RangeError>();
    });

    test('throws if the width does not divide the length', () {
      check(() => checkRectangular1D([1, 2, 3], width: 2)).throws<RangeError>();
    });

    test('throws if height is negative', () {
      check(
        () => checkRectangular1D([1, 2], width: 2, height: -1),
      ).throws<ArgumentError>();
    });

    test('throws if height is 0', () {
      check(
        () => checkRectangular1D([1, 2], width: 2, height: 0),
      ).throws<ArgumentError>();
    });

    test('throws if height is greater than the length', () {
      check(
        () => checkRectangular1D([1, 2], width: 2, height: 2),
      ).throws<ArgumentError>();
    });

    test('throws if height is not a multiple of the width', () {
      check(
        () => checkRectangular1D([1, 2, 3], width: 2, height: 2),
      ).throws<ArgumentError>();
    });

    test('returns the cells and dimensions if the rectangle is valid', () {
      final (cells, pos) = checkRectangular1D([1, 2, 3, 4], width: 2);
      check(cells).deepEquals([1, 2, 3, 4]);
      check(pos).equals(Pos(2, 2));
    });
  });

  test('assertRectangular1d throws if the cells are empty', () {
    check(() => assertRectangular1D([], width: 1)).throws<ArgumentError>();
  });

  group('checkRectangular2d', () {
    test('throws if the matrix is empty', () {
      check(() => checkRectangular2D([])).throws<ArgumentError>();
    });

    test('throws if the rows are empty', () {
      check(() => checkRectangular2D([[]])).throws<ArgumentError>();
    });

    test('throws if the rows are not rectangular', () {
      check(
        () => checkRectangular2D([
          [1, 2],
          [1],
        ]),
      ).throws<ArgumentError>();
    });

    test('returns the matrix if it is rectangular', () {
      final matrix = [
        [1, 2],
        [3, 4],
      ];
      final (cells, pos) = checkRectangular2D(matrix);
      check(cells).deepEquals([1, 2, 3, 4]);
      check(pos).equals(Pos(2, 2));
    });
  });
}
