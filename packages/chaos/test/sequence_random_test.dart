import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

void main() {
  test('doubles', () {
    final sequence = SequenceRandom([0.0, 0.5, 1.0]);

    check(sequence.nextDouble()).equals(0.0);
    check(sequence.nextDouble()).equals(0.5);
    check(sequence.nextDouble()).isCloseTo(1.0, 0.0001);
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

  test('bools', () {
    final sequence = SequenceRandom.bools([true, false]);

    check(sequence.nextBool()).equals(true);
    check(sequence.nextBool()).equals(false);
    check(sequence.nextBool()).equals(true);
    check(sequence.nextBool()).equals(false);
  });

  test('uniform', () {
    final sequence = SequenceRandom.uniform(6);

    check(sequence.nextInt(6)).equals(0);
    check(sequence.nextInt(6)).equals(1);
    check(sequence.nextInt(6)).equals(2);
    check(sequence.nextInt(6)).equals(3);
    check(sequence.nextInt(6)).equals(4);
    check(sequence.nextInt(6)).equals(5);
    check(sequence.nextInt(6)).equals(0);
  });
}
