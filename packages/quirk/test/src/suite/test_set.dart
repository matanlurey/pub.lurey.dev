import '../../_prelude.dart';

/// Runs a test suite on the returned set from [create].
void testSet(Set<E> Function<E>(Set<E>) create) {
  test('cast', () {
    final set = create({1, 2, 3});
    final casted = set.cast<num>();

    check(casted).not((i) => i.identicalTo(set));
    check(casted).deepEquals({1, 2, 3});
  });

  test('lookup', () {
    final set = create({1, 2, 3});

    check(set.lookup(2)).equals(2);
    check(set.lookup(4)).isNull();
  });

  test('containsAll', () {
    final set = create({1, 2, 3});

    check(set.containsAll({2, 3})).isTrue();
    check(set.containsAll({2, 4})).isFalse();
  });

  test('intersection', () {
    final set = create({1, 2, 3});
    final other = create({2, 3, 4});

    final intersection = set.intersection(other);

    check(intersection).deepEquals({2, 3});
  });

  test('union', () {
    final set = create({1, 2, 3});
    final other = create({3, 4, 5});

    final union = set.union(other);

    check(union).deepEquals({1, 2, 3, 4, 5});
  });

  test('difference', () {
    final set = create({1, 2, 3});
    final other = create({2, 3, 4});

    final difference = set.difference(other);

    check(difference).deepEquals({1});
  });

  test('add', () {
    final set = create({1, 2, 3});

    check(set.add(4)).isTrue();
    check(set).deepEquals({1, 2, 3, 4});
  });

  test('addAll', () {
    final set = create({1, 2, 3});

    set.addAll({4, 5});

    check(set).deepEquals({1, 2, 3, 4, 5});
  });

  test('remove', () {
    final set = create({1, 2, 3});

    check(set.remove(2)).isTrue();
    check(set).deepEquals({1, 3});
  });

  test('removeAll', () {
    final set = create({1, 2, 3});

    set.removeAll({2, 3});

    check(set).deepEquals({1});
  });

  test('retainAll', () {
    final set = create({1, 2, 3});

    set.retainAll({2, 3});

    check(set).deepEquals({2, 3});
  });

  test('removeWhere', () {
    final set = create({1, 2, 3});

    set.removeWhere((e) => e > 1);

    check(set).deepEquals({1});
  });

  test('retainWhere', () {
    final set = create({1, 2, 3});

    set.retainWhere((e) => e > 1);

    check(set).deepEquals({2, 3});
  });

  test('clear', () {
    final set = create({1, 2, 3});

    set.clear();

    check(set).deepEquals({});
  });
}
