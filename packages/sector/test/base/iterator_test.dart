import 'package:sector/sector.dart';

import '../_prelude.dart';

void main() {
  group('$GridIterator', () {
    test('empty', () {
      final iterator = GridIterator<void>.empty();
      check(() => iterator.current).throws<StateError>();
      check(() => iterator.position).throws<StateError>();
    });

    test('steps throws on -1 or 1', () {
      final iterator = _FakeGridIterator([]);
      check(() => iterator.seek(-1)).throws<RangeError>();
      check(() => iterator.seek(0)).throws<RangeError>();
    });

    test('steps calls moveNext() by default n times', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      check(iterator.seek(3)).isTrue();
      check(iterator.current).equals((2, 0));
      check(iterator.seek(3)).isFalse();
    });
  });

  group('$GridIterable', () {
    test('empty', () {
      check(GridIterable<void>.empty()).isEmpty();
    });

    test('iterates with a GridIterator', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable).deepEquals([(0, 0), (1, 0), (2, 0), (3, 0)]);
    });

    test('iterates through the positions', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.positions).deepEquals([(0, 0), (1, 0), (2, 0), (3, 0)]);
    });

    test('positions still stores positions', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final positions = GridIterable.from(() => iterator).positions.iterator;

      // For this test only, don't actually do this!
      positions as GridIterator<(int, int)>;
      positions.moveNext();
      check(positions.position).equals((0, 0));
    });

    test('iterates through positions when optimized', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.positions.last).equals((3, 0));
    });

    test('iterates through the positions and cells', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.positioned).deepEquals([
        (0, 0, (0, 0)),
        (1, 0, (1, 0)),
        (2, 0, (2, 0)),
        (3, 0, (3, 0)),
      ]);
    });

    test('iterates through positions and cells when optimized', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.positioned.last).equals((3, 0, (3, 0)));
    });

    test('positioned still stores positions and cells', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final positioned = GridIterable.from(() => iterator).positioned.iterator;

      // For this test only, don't actually do this!
      positioned as GridIterator<(int, int, (int, int))>;
      positioned.moveNext();
      check(positioned.position).equals((0, 0));
    });

    test('.length', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.length).equals(4);
    });

    test('.length with optimization', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.length).equals(4);
    });

    test('.skip', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.skip(2)).deepEquals([(2, 0), (3, 0)]);
    });

    test('.last', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.last).equals((3, 0));
    });

    test('.last with optimization', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.last).equals((3, 0));
    });

    test('.last throws on empty', () {
      final iterator = _FakeGridIterator([]);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.last).throws<StateError>();
    });

    test('.last with optimization throws on empty', () {
      final iterator = _FakeGridIterator([], useRemainingSteps: true);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.last).throws<StateError>();
    });

    test('.lastWhere', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.lastWhere((it) => it.$1 == 2)).equals((2, 0));
    });

    test('.lastWhere with optimization', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.lastWhere((it) => it.$1 == 2)).equals((2, 0));
    });

    test('.lastWhere throws on no match', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.lastWhere((it) => it.$1 == 2)).throws<StateError>();
    });

    test('.lastWhere returns orElse on no match', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(
        iterable.lastWhere((it) => it.$1 == 2, orElse: () => (4, 0)),
      ).equals((4, 0));
    });

    test('.lastWhere with optimization returns orElse on no match', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(
        iterable.lastWhere((it) => it.$1 == 2, orElse: () => (4, 0)),
      ).equals((4, 0));
    });

    test('.lastWhere with optimization throws on no match', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.lastWhere((it) => it.$1 == 2)).throws<StateError>();
    });

    test('.single', () {
      final iterator = _FakeGridIterator([(0, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.single).equals((0, 0));
    });

    test('.single throws no more than one element', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.single).throws<StateError>();
    });

    test('.single throws on no elements', () {
      final iterator = _FakeGridIterator([]);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.single).throws<StateError>();
    });

    test('.single with optimization', () {
      final iterator = _FakeGridIterator([(0, 0)], useRemainingSteps: true);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.single).equals((0, 0));
    });

    test('.single with optimization throws no more than one element', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.single).throws<StateError>();
    });

    test('.single with optimization throws on no elements', () {
      final iterator = _FakeGridIterator([], useRemainingSteps: true);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.single).throws<StateError>();
    });

    test('.elementAt', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(iterable.elementAt(2)).equals((2, 0));
    });

    test('.elementAt throws on out of bounds', () {
      final iterator = _FakeGridIterator([(0, 0), (1, 0), (2, 0), (3, 0)]);
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.elementAt(4)).throws<IndexError>();
    });

    test('.elementAt with optimization', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(iterable.elementAt(2)).equals((2, 0));
    });

    test('.elementAt with optimization throws on out of bounds', () {
      final iterator = _FakeGridIterator(
        [(0, 0), (1, 0), (2, 0), (3, 0)],
        useRemainingSteps: true,
      );
      final iterable = GridIterable.from(() => iterator);
      check(() => iterable.elementAt(4)).throws<IndexError>();
    });
  });
}

final class _FakeGridIterator with GridIterator<(int, int)> {
  _FakeGridIterator(
    this._elements, {
    bool useRemainingSteps = false,
  }) : _optimize = useRemainingSteps;

  final List<(int, int)> _elements;
  final bool _optimize;

  @override
  late (int, int) current;

  @override
  (int, int) get position => current;

  @override
  bool moveNext() {
    if (_elements.isEmpty) {
      return false;
    }
    current = _elements.removeAt(0);
    return true;
  }

  @override
  int? get remainingSteps {
    return _optimize ? _elements.length : super.remainingSteps;
  }
}
