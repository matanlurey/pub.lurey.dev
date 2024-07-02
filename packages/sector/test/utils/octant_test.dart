import 'package:sector/sector.dart';

import '../_prelude.dart';

void main() {
  group('should convert two points to each $Octant', () {
    test(Octant.first.name, () {
      final (x1, y1) = (0, 0);
      final (x2, y2) = (0, 0);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.first);
    });

    test(Octant.second.name, () {
      final (x1, y1) = (3, 1);
      final (x2, y2) = (3, 2);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.second);
    });

    test(Octant.third.name, () {
      final (x1, y1) = (3, 1);
      final (x2, y2) = (2, 1);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.third);
    });

    test(Octant.fourth.name, () {
      final (x1, y1) = (5, 0);
      final (x2, y2) = (0, 8);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.fourth);
    });

    test(Octant.fifth.name, () {
      final (x1, y1) = (0, 0);
      final (x2, y2) = (-5, -2);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.fifth);
    });

    test(Octant.sixth.name, () {
      final (x1, y1) = (1, 0);
      final (x2, y2) = (1, -1);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.sixth);
    });

    test(Octant.seventh.name, () {
      final (x1, y1) = (-3, 2);
      final (x2, y2) = (0, 0);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.seventh);
    });

    test(Octant.eighth.name, () {
      final (x1, y1) = (0, 0);
      final (x2, y2) = (2, -3);
      check(Octant.fromPoints(x1, y1, x2, y2)).equals(Octant.eighth);
    });
  });

  group('toOctant1', () {
    test('from ${Octant.first.name}', () {
      final (x, y) = (2, -1);
      check(Octant.first.toOctant1(x, y)).equals((2, -1));
    });

    test('from ${Octant.second.name}', () {
      final (x, y) = (2, -1);
      check(Octant.second.toOctant1(x, y)).equals((-1, 2));
    });

    test('from ${Octant.third.name}', () {
      final (x, y) = (2, -1);
      check(Octant.third.toOctant1(x, y)).equals((-1, -2));
    });

    test('from ${Octant.fourth.name}', () {
      final (x, y) = (2, -1);
      check(Octant.fourth.toOctant1(x, y)).equals((-2, -1));
    });

    test('from ${Octant.fifth.name}', () {
      final (x, y) = (2, -1);
      check(Octant.fifth.toOctant1(x, y)).equals((-2, 1));
    });

    test('from ${Octant.sixth.name}', () {
      final (x, y) = (2, -1);
      check(Octant.sixth.toOctant1(x, y)).equals((1, -2));
    });

    test('from ${Octant.seventh.name}', () {
      final (x, y) = (2, -1);
      check(Octant.seventh.toOctant1(x, y)).equals((1, 2));
    });

    test('from ${Octant.eighth.name}', () {
      final (x, y) = (2, -1);
      check(Octant.eighth.toOctant1(x, y)).equals((2, 1));
    });
  });

  group('fromOctant1', () {
    test('to ${Octant.first.name}', () {
      final (x, y) = (2, -1);
      check(Octant.first.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.second.name}', () {
      final (x, y) = (-1, 2);
      check(Octant.second.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.third.name}', () {
      final (x, y) = (-1, -2);
      check(Octant.third.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.fourth.name}', () {
      final (x, y) = (-2, -1);
      check(Octant.fourth.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.fifth.name}', () {
      final (x, y) = (-2, 1);
      check(Octant.fifth.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.sixth.name}', () {
      final (x, y) = (1, -2);
      check(Octant.sixth.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.seventh.name}', () {
      final (x, y) = (1, 2);
      check(Octant.seventh.fromOctant1(x, y)).equals((2, -1));
    });

    test('to ${Octant.eighth.name}', () {
      final (x, y) = (2, 1);
      check(Octant.eighth.fromOctant1(x, y)).equals((2, -1));
    });
  });
}
