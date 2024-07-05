import '_prelude.dart';

void main() {
  group('bresenham', () {
    test('returns a line between two points', () {
      final start = Pos(0, 0);
      final end = Pos(3, 3);
      final line = bresenham(start, end).toList();
      check(line).deepEquals([
        Pos(0, 0),
        Pos(1, 1),
        Pos(2, 2),
        Pos(3, 3),
      ]);
    });

    test('returns an exclusive line between two points', () {
      final start = Pos(0, 0);
      final end = Pos(3, 3);
      final line = bresenham(start, end, exclusive: true).toList();
      check(line).deepEquals([
        Pos(0, 0),
        Pos(1, 1),
        Pos(2, 2),
      ]);
    });

    test('returns a line between two points in reverse', () {
      final start = Pos(3, 3);
      final end = Pos(0, 0);
      final line = bresenham(start, end).toList();
      check(line).deepEquals([
        Pos(3, 3),
        Pos(2, 2),
        Pos(1, 1),
        Pos(0, 0),
      ]);
    });

    test('returns an exclusive line between two points in reverse', () {
      final start = Pos(3, 3);
      final end = Pos(0, 0);
      final line = bresenham(start, end, exclusive: true).toList();
      check(line).deepEquals([
        Pos(3, 3),
        Pos(2, 2),
        Pos(1, 1),
      ]);
    });
  });
}
