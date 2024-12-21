import '_prelude.dart';

void main() {
  group('should convert two points to each $Octant', () {
    test(Octant.first.name, () {
      final a = Pos(0, 0);
      final b = Pos(0, 0);
      check(Octant.from(a, b)).equals(Octant.first);
    });

    test(Octant.second.name, () {
      final a = Pos(3, 1);
      final b = Pos(3, 2);
      check(Octant.from(a, b)).equals(Octant.second);
    });

    test(Octant.third.name, () {
      final a = Pos(3, 1);
      final b = Pos(2, 1);
      check(Octant.from(a, b)).equals(Octant.third);
    });

    test(Octant.fourth.name, () {
      final a = Pos(5, 0);
      final b = Pos(0, 8);
      check(Octant.from(a, b)).equals(Octant.fourth);
    });

    test(Octant.fifth.name, () {
      final a = Pos(0, 0);
      final b = Pos(-5, -2);
      check(Octant.from(a, b)).equals(Octant.fifth);
    });

    test(Octant.sixth.name, () {
      final a = Pos(1, 0);
      final b = Pos(1, -1);
      check(Octant.from(a, b)).equals(Octant.sixth);
    });

    test(Octant.seventh.name, () {
      final a = Pos(-3, 2);
      final b = Pos(0, 0);
      check(Octant.from(a, b)).equals(Octant.seventh);
    });

    test(Octant.eighth.name, () {
      final a = Pos(0, 0);
      final b = Pos(2, -3);
      check(Octant.from(a, b)).equals(Octant.eighth);
    });
  });

  group('toOctant1', () {
    test('from ${Octant.first.name}', () {
      final p = Pos(2, -1);
      check(Octant.first.toOctant1(p)).equals(Pos(2, -1));
    });

    test('from ${Octant.second.name}', () {
      final p = Pos(2, -1);
      check(Octant.second.toOctant1(p)).equals(Pos(-1, 2));
    });

    test('from ${Octant.third.name}', () {
      final p = Pos(2, -1);
      check(Octant.third.toOctant1(p)).equals(Pos(-1, -2));
    });

    test('from ${Octant.fourth.name}', () {
      final p = Pos(2, -1);
      check(Octant.fourth.toOctant1(p)).equals(Pos(-2, -1));
    });

    test('from ${Octant.fifth.name}', () {
      final p = Pos(2, -1);
      check(Octant.fifth.toOctant1(p)).equals(Pos(-2, 1));
    });

    test('from ${Octant.sixth.name}', () {
      final p = Pos(2, -1);
      check(Octant.sixth.toOctant1(p)).equals(Pos(1, -2));
    });

    test('from ${Octant.seventh.name}', () {
      final p = Pos(2, -1);
      check(Octant.seventh.toOctant1(p)).equals(Pos(1, 2));
    });

    test('from ${Octant.eighth.name}', () {
      final p = Pos(2, -1);
      check(Octant.eighth.toOctant1(p)).equals(Pos(2, 1));
    });
  });

  group('fromOctant1', () {
    test('to ${Octant.first.name}', () {
      final p = Pos(2, -1);
      check(Octant.first.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.second.name}', () {
      final p = Pos(-1, 2);
      check(Octant.second.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.third.name}', () {
      final p = Pos(-1, -2);
      check(Octant.third.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.fourth.name}', () {
      final p = Pos(-2, -1);
      check(Octant.fourth.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.fifth.name}', () {
      final p = Pos(-2, 1);
      check(Octant.fifth.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.sixth.name}', () {
      final p = Pos(1, -2);
      check(Octant.sixth.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.seventh.name}', () {
      final p = Pos(1, 2);
      check(Octant.seventh.fromOctant1(p)).equals(Pos(2, -1));
    });

    test('to ${Octant.eighth.name}', () {
      final p = Pos(2, 1);
      check(Octant.eighth.fromOctant1(p)).equals(Pos(2, -1));
    });
  });
}
