import 'package:chaos/chaos.dart';
import 'package:omen/omen.dart';

import '../_prelude.dart';

void main() {
  test('const string', () {
    final random = SequenceRandom.ints([0, 1, 2]);
    const items = CodeUnitDistribution('ABC');

    check(items.sample(random)).equals(0x41);
    check(items.sample(random)).equals(0x42);
    check(items.sample(random)).equals(0x43);
  });

  test('non-const string', () {
    final random = SequenceRandom.ints([0, 1, 2]);
    final items = CodeUnitDistribution.from('ABC');

    check(items.sample(random)).equals(0x41);
    check(items.sample(random)).equals(0x42);
    check(items.sample(random)).equals(0x43);
  });
}
