import '../prelude.dart';

void main() {
  test('isNotFound', () {
    check(Path.notFound).has((p) => p.isNotFound, 'isNotFound').isTrue();
  });

  test('start', () {
    check(Path([1, 2, 3])).has((p) => p.start, 'start').equals(1);
  });

  test('goal', () {
    check(Path([1, 2, 3])).has((p) => p.goal, 'end').equals(3);
  });

  group('sIn', () {
    test('is always false for notFound', () {
      check(
        Path.notFound,
      ).has((p) => p.isIn(Walkable.empty()), 'isIn').isFalse();
    });

    test('is true for one-node paths where the node is itself', () {
      check(
        Path([1]),
      ).has((p) => p.isIn(Walkable.linear({1})), 'isIn').isTrue();
    });
  });
}
