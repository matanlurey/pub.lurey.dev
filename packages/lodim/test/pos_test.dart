import '_prelude.dart';

void main() {
  test('should create a Pos(x, y)', () {
    final pos = Pos(10, 20);
    check(pos.x).equals(10);
    check(pos.y).equals(20);
  });

  test('zero is (0, 0)', () {
    check(Pos.zero).equals(Pos(0, 0));
  });

  test('should create a Pos from two doubles, truncating', () {
    // Positive values.
    check(Pos.truncate(1.5, 2.5)).equals(Pos(1, 2));

    // Negative values.
    check(Pos.truncate(-1.5, -2.5)).equals(Pos(-1, -2));
  });

  test('should create a Pos from two doubles, flooring', () {
    // Positive values.
    check(Pos.floor(1.5, 2.5)).equals(Pos(1, 2));

    // Negative values.
    check(Pos.floor(-1.5, -2.5)).equals(Pos(-2, -3));
  });

  group('distanceTo', () {
    test('defaults to euclideanSquared', () {
      final a = Pos(10, 20);
      final b = Pos(30, 40);
      check(a.distanceTo(b)).equals(800);
    });

    test('can specify an alternate distance function', () {
      final a = Pos(10, 20);
      final b = Pos(30, 40);
      check(a.distanceTo(b, using: distanceManhattan)).equals(40);
    });
  });

  group('pathTo', () {
    test('defaults to bresenham', () {
      final a = Pos(0, 0);
      final b = Pos(2, 2);
      check(a.pathTo(b)).deepEquals([
        Pos(0, 0),
        Pos(1, 1),
        Pos(2, 2),
      ]);
    });

    test('can specify an alternate line function', () {
      final a = Pos(0, 0);
      final b = Pos(2, 2);

      Iterable<Pos> fakeLine(Pos a, Pos b, {bool exclusive = false}) sync* {
        yield a;
        yield b;
      }

      check(a.pathTo(b, using: fakeLine)).deepEquals([
        a,
        b,
      ]);
    });
  });

  group('midpoints', () {
    test('returns the middle of two points', () {
      final a = Pos(0, 0);
      final b = Pos(2, 2);
      check(a.midpoints(b)).deepEquals([Pos(1, 1)]);
    });

    test('returns the middle of two points with a remainder', () {
      final a = Pos(0, 0);
      final b = Pos(3, 3);
      check(a.midpoints(b)).deepEquals([Pos(1, 1), Pos(2, 2)]);
    });
  });

  group('rotate45', () {
    test('1 (45)', () {
      check(Pos(1, 0).rotate45()).equals(Pos(1, 1));
    });

    test('2 (90)', () {
      check(Pos(1, 0).rotate45(2)).equals(Pos(0, 1));
    });

    test('3 (135)', () {
      check(Pos(1, 0).rotate45(3)).equals(Pos(-1, -1));
    });

    test('4 (180)', () {
      check(Pos(1, 0).rotate45(4)).equals(Pos(-1, 0));
    });

    test('5 (225)', () {
      check(Pos(1, 0).rotate45(5)).equals(Pos(-1, -1));
    });

    test('6 (270)', () {
      check(Pos(1, 0).rotate45(6)).equals(Pos(0, -1));
    });

    test('7 (315)', () {
      check(Pos(1, 0).rotate45(7)).equals(Pos(1, -1));
    });

    test('8 (360)', () {
      check(Pos(1, 0).rotate45(8)).equals(Pos(1, 0));
    });

    test('-1 (-45)', () {
      check(Pos(1, 0).rotate45(-1)).equals(Pos(1, -1));
    });
  });

  group('rotate90', () {
    test('1 (90)', () {
      check(Pos(1, 0).rotate90()).equals(Pos(0, 1));
    });

    test('2 (180)', () {
      check(Pos(1, 0).rotate90(2)).equals(Pos(-1, 0));
    });

    test('3 (270)', () {
      check(Pos(1, 0).rotate90(3)).equals(Pos(0, -1));
    });

    test('4 (360)', () {
      check(Pos(1, 0).rotate90(4)).equals(Pos(1, 0));
    });

    test('-1 (-90)', () {
      check(Pos(1, 0).rotate90(-1)).equals(Pos(0, -1));
    });
  });

  test('rotate180', () {
    check(Pos(1, 0).rotate180()).equals(Pos(-1, 0));
  });

  test('scale', () {
    check(Pos(1, 2).scale(Pos(2, 4))).equals(Pos(2, 8));
  });

  test('abs', () {
    check(Pos(-1, -2).abs()).equals(Pos(1, 2));
  });

  test('pow', () {
    check(Pos(2, 3).pow(2)).equals(Pos(4, 9));
  });

  test('negation', () {
    check(-Pos(1, 2)).equals(Pos(-1, -2));
  });

  test('+', () {
    check(Pos(1, 2) + Pos(3, 4)).equals(Pos(4, 6));
  });

  test('-', () {
    check(Pos(1, 2) - Pos(3, 4)).equals(Pos(-2, -2));
  });

  test('*', () {
    check(Pos(1, 2) * 3).equals(Pos(3, 6));
  });

  test('|', () {
    check(Pos(1, 2) | Pos(3, 4)).equals(Pos(3, 6));
  });

  test('&', () {
    check(Pos(1, 2) & Pos(3, 4)).equals(Pos(1, 0));
  });

  test('^', () {
    check(Pos(1, 2) ^ Pos(3, 4)).equals(Pos(2, 6));
  });

  test('~/', () {
    check(Pos(1, 2) ~/ 3).equals(Pos(0, 0));
  });

  test('%', () {
    check(Pos(1, 2) % 3).equals(Pos(1, 2));
  });

  test('~', () {
    check(~Pos(1, 2)).equals(Pos(-2, -3));
  });

  test('<<', () {
    check(Pos(1, 2) << 1).equals(Pos(2, 4));
  });

  test('>>', () {
    check(Pos(1, 2) >> 1).equals(Pos(0, 1));
  });

  test('hashCode', () {
    check(Pos(1, 2).hashCode).equals(Pos(1, 2).hashCode);
  });

  test('toString', () {
    check(Pos(1, 2).toString()).equals('Pos(1, 2)');
  });

  test('fromXY', () {
    check(Pos.fromXY((1, 2))).equals(Pos(1, 2));
  });

  test('fromList', () {
    check(Pos.fromList([1, 2])).equals(Pos(1, 2));
  });

  test('fromList with offset', () {
    check(Pos.fromList([0, 1, 2], 1)).equals(Pos(1, 2));
  });

  test('fromList must have at least two elements', () {
    check(() => Pos.fromList([1])).throws<RangeError>();
  });

  test('fromList must have at least two elements after the offset', () {
    check(() => Pos.fromList([1, 2], 1)).throws<RangeError>();
  });

  test('fromListUnsafe', () {
    check(Pos.fromListUnsafe([1, 2])).equals(Pos(1, 2));
  });

  test('fromListUnsafe with offset', () {
    check(Pos.fromListUnsafe([0, 1, 2], 1)).equals(Pos(1, 2));
  });

  test('fromListUnsafe must have at least two elements', () {
    check(() => Pos.fromListUnsafe([1])).throws<RangeError>();
  });

  test('toList', () {
    check(Pos(1, 2).toList()).deepEquals([1, 2]);
  });

  test('toListUnsafe', () {
    check(Pos(1, 2).toListUnsafe()).deepEquals([1, 2]);
  });

  test('toList index must be 0 if output is null', () {
    check(() => Pos(1, 2).toList(null, 1)).throws<ArgumentError>();
  });

  test('toListUnsafe index must be 0 if output is null', () {
    check(() => Pos(1, 2).toListUnsafe(null, 1)).throws<ArgumentError>();
  });

  test('toList writes to an existing list', () {
    final list = [0, 0];
    check(Pos(1, 2).toList(list)).equals(list);
    check(list).deepEquals([1, 2]);
  });

  test('toListUnsafe writes to an existing list', () {
    final list = [0, 0];
    check(Pos(1, 2).toListUnsafe(list)).equals(list);
    check(list).deepEquals([1, 2]);
  });

  test('toList writes to an existing list with an offset', () {
    final list = [0, 0, 0];
    check(Pos(1, 2).toList(list, 1)).equals(list);
    check(list).deepEquals([0, 1, 2]);
  });

  test('toListUnsafe writes to an existing list with an offset', () {
    final list = [0, 0, 0];
    check(Pos(1, 2).toListUnsafe(list, 1)).equals(list);
    check(list).deepEquals([0, 1, 2]);
  });

  test('xy', () {
    check(Pos(1, 2).xy).equals((1, 2));
  });

  test('fromRowMajor', () {
    check(Pos.fromRowMajor(12, width: 4)).equals(Pos(0, 3));
  });

  test('toRowMajor', () {
    check(Pos(0, 3).toRowMajor(width: 4)).equals(12);
  });

  group('should sort byMagntiude', () {
    test('1, 2, 3', () {
      final list = [Pos(3, 3), Pos(1, 1), Pos(2, 2)];
      list.sort(Pos.byMagnitude());
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });

    test('3, 2, 1', () {
      final list = [Pos(2, 2), Pos(3, 3), Pos(1, 1)];
      list.sort(Pos.byMagnitude());
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });
  });

  group('should sort byRowMajor', () {
    test('1, 2, 3', () {
      final list = [Pos(1, 1), Pos(2, 2), Pos(3, 3)];
      list.sort(Pos.byRowMajor);
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });

    test('3, 2, 1', () {
      final list = [Pos(3, 3), Pos(2, 2), Pos(1, 1)];
      list.sort(Pos.byRowMajor);
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });
  });

  group('should sort byColumnMajor', () {
    test('1, 2, 3', () {
      final list = [Pos(1, 1), Pos(2, 2), Pos(3, 3)];
      list.sort(Pos.byColumnMajor);
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });

    test('3, 2, 1', () {
      final list = [Pos(3, 3), Pos(2, 2), Pos(1, 1)];
      list.sort(Pos.byColumnMajor);
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });
  });

  group('should sort byDistanceTo', () {
    test('1, 2, 3', () {
      final list = [Pos(3, 3), Pos(1, 1), Pos(2, 2)];
      list.sort(Pos.byDistanceTo(Pos(0, 0)));
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });

    test('3, 2, 1', () {
      final list = [Pos(2, 2), Pos(3, 3), Pos(1, 1)];
      list.sort(Pos.byDistanceTo(Pos(0, 0)));
      check(list).deepEquals([Pos(1, 1), Pos(2, 2), Pos(3, 3)]);
    });
  });

  test('inflate', () {
    check(Pos(2, 2).inflate(Pos(2, 2))).equals(Rect.fromLTWH(0, 0, 4, 4));
  });

  test('min', () {
    check(Pos(1, 2).min(Pos(3, 4))).equals(Pos(1, 2));
  });

  test('max', () {
    check(Pos(1, 2).max(Pos(3, 4))).equals(Pos(3, 4));
  });

  test('clamp', () {
    check(Pos(1, 2).clamp(Pos(3, 4), Pos(5, 6))).equals(Pos(3, 4));
  });

  group('normalizedApproximate', () {
    test('returns 0 if both offsets are 0', () {
      check(Pos(0, 0).normalizedApproximate).equals(Pos(0, 0));
    });

    test('returns the GCD', () {
      check(Pos(2, 4).normalizedApproximate).equals(Pos(1, 2));
    });
  });

  test('dot', () {
    check(Pos(1, 2).dot(Pos(3, 4))).equals(11);
  });

  test('cross', () {
    check(Pos(1, 2).cross(Pos(3, 4))).equals(-2);
  });

  test('toRect with default size', () {
    check(Pos(1, 2).toRect()).equals(Rect.fromLTWH(1, 2, 1, 1));
  });

  test('toRect with provided size', () {
    check(Pos(1, 2).toRect(Pos(3, 4))).equals(Rect.fromLTWH(1, 2, 3, 4));
  });

  test('toSize with default offset', () {
    check(Pos(1, 2).toSize()).equals(Rect.fromLTWH(0, 0, 1, 2));
  });

  test('toSize with provided offset', () {
    check(Pos(1, 2).toSize(Pos(3, 4))).equals(Rect.fromLTWH(3, 4, 1, 2));
  });

  test('map', () {
    check(Pos(1, 2).map((i) => i * 2)).equals(Pos(2, 4));
  });

  test('toPos', () {
    // Test the deprecated method.
    // ignore: deprecated_member_use_from_same_package
    check((1, 2).toPos()).equals(Pos(1, 2));
  });
}
