import 'package:chaos/chaos.dart';
import 'package:omen/omen.dart';

import '../_prelude.dart';

void main() {
  test('const list', () {
    final random = SequenceRandom.uniform(3);
    const items = ListDistribution(['A', 'B', 'C']);

    check(items.sample(random)).equals('A');
    check(items.sample(random)).equals('B');
    check(items.sample(random)).equals('C');
  });

  test('iterable', () {
    final random = SequenceRandom.uniform(3);
    final items = ListDistribution.from(['A', 'B', 'C']);

    check(items.sample(random)).equals('A');
    check(items.sample(random)).equals('B');
    check(items.sample(random)).equals('C');
  });
}
