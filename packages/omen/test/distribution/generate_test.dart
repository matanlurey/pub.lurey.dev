import 'package:chaos/chaos.dart';
import 'package:omen/omen.dart';

import '../_prelude.dart';

void main() {
  test('delegates to the provided function', () {
    final random = SequenceRandom.ints([0, 1, 2]);
    final items = Distribution.generate((r) => r.nextInt(100));

    check(items.sample(random)).equals(0);
    check(items.sample(random)).equals(50);
    check(items.sample(random)).equals(100);
  });
}
