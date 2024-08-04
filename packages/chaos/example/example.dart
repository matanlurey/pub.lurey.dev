import 'package:chaos/chaos.dart';

void main() {
  // Use a high-quality PRNG with inspectable and clonable state*
  //
  // * This is useful for save-states, replays, and debugging!
  //
  // Xoshiro128+ is a fast, high-quality PRNG with a 128-bit state.
  // https://prng.di.unimi.it/xoshiro128plus.c for the reference implementation.
  final random = Xoshiro128P();

  // "Roll" 10 d20s, and print the results!
  for (var i = 0; i < 10; i++) {
    print('d20: ${random.nextInt(20) + 1}');
  }

  // Clone and resume the PRNG from the saved state.
  final clone = random.clone();

  // "Roll" 10 d6s, and print the results!
  for (var i = 0; i < 10; i++) {
    print('d6: ${clone.nextInt(6) + 1}');
  }

  // Want very controlled artificial randomness for unit tests?
  // Use a pre-generated sequence of random numbers: SequenceRandom.
  final sequence = SequenceRandom.ints([1, 2, 3, 4, 5], max: 6);

  // "Roll" 5 d6s, and print the results!
  // (TIP: This is going to be 1, 2, 3, 4, 5)
  for (var i = 0; i < 5; i++) {
    print('d6: ${sequence.nextInt(6) + 1}');
  }
}
