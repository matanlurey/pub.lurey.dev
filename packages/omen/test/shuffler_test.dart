import 'package:chaos/chaos.dart';
import 'package:omen/omen.dart';

import '_prelude.dart';

void main() {
  test('systemShuffler', () {
    // This can't really be "tested" outside of verifying that it shuffles.
    final list = [1, 2, 3, 4, 5];
    while (list.join() == '12345') {
      systemShuffler.shuffle(list);
    }
  });

  group('perfectRiffleShuffler', () {
    test('even length', () {
      final list = [1, 2, 3, 4, 5, 6];
      perfectRiffleShuffler.shuffle(list);
      check(list).deepEquals([1, 4, 2, 5, 3, 6]);
    });

    test('odd length', () {
      final list = [1, 2, 3, 4, 5];
      perfectRiffleShuffler.shuffle(list);
      check(list).deepEquals([1, 3, 2, 4, 5]);
    });
  });

  test('fromRandom', () {
    final list = [1, 2, 3, 4, 5];
    final random = Xoshiro128(10000);
    final shuffler = Shuffler.fromRandom(random);

    shuffler.shuffle(list);
    check(list).deepEquals([5, 1, 4, 2, 3]);
  });

  test('identity', () {
    final list = [1, 2, 3, 4, 5];
    final shuffler = Shuffler.identity();

    shuffler.shuffle(list);
    check(list).deepEquals([1, 2, 3, 4, 5]);
  });

  test('combine', () {
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    final shuffler = Shuffler.combine([
      perfectRiffleShuffler,
      perfectRiffleShuffler,
    ]);

    shuffler.shuffle(list);
    check(list).deepEquals([1, 8, 6, 4, 2, 9, 7, 5, 3, 10]);
  });
}
