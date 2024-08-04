import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

void main() {
  test('sequence random', () {
    final sequence = SequenceRandom([0.0, 0.5, 1.0]);
    check(sequence.nextDouble()).equals(0.0);
    check(sequence.nextDouble()).equals(0.5);
    check(sequence.nextDouble()).equals(1.0);
    check(sequence.nextDouble()).equals(0.0);
  });
}
