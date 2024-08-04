import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

void main() {
  test('doubles', () {
    final sequence = SequenceRandom([0.0, 0.5, 1.0]);
    check(sequence.nextDouble()).equals(0.0);
    check(sequence.nextDouble()).equals(0.5);
    check(sequence.nextDouble()).equals(1.0);
    check(sequence.nextDouble()).equals(0.0);
  });

  test('ints', () {
    final sequence = SequenceRandom.ints([1, 2, 3, 4, 5], max: 6);
    check(sequence.nextInt(6)).equals(0);
    check(sequence.nextInt(6)).equals(1);
    check(sequence.nextInt(6)).equals(2);
    check(sequence.nextInt(6)).equals(3);
    check(sequence.nextInt(6)).equals(4);
    check(sequence.nextInt(6)).equals(0);
  });
}
