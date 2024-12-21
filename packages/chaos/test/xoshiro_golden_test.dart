import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

/// Tests that the Dart implementation of the xoshiro128+ and xoshiro128++ PRNGs
/// generate the same results on all platforms.
///
/// In practice the other tests should also catch any issues.
void main() {
  test('generates 10 doubles', () {
    final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
    final numbers = List.generate(10, (_) => random.nextDouble());
    const expected = [
      0.0,
      0.00000286102294921875,
      0.005862236022949219,
      0.006352901458740234,
      0.00928497314453125,
      0.26551008224487305,
      0.7628254890441895,
      0.9569878578186035,
      0.09309101104736328,
      0.49928998947143555,
    ];

    // Check within a reasonable tolerance.
    for (var i = 0; i < 10; i++) {
      check(numbers[i]).isCloseTo(expected[i], 1e-10);
    }
  });

  test('generates 10 bools', () {
    final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
    final bools = List.generate(10, (_) => random.nextBool());
    const expected = [
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      true,
      false,
      false,
    ];

    check(bools).deepEquals(expected);
  });

  test('generates 10 ints', () {
    final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
    final ints = List.generate(10, (_) => random.nextInt());
    const expected = [
      5,
      12295,
      25178119,
      27286542,
      39879690,
      1140358681,
      3276312097,
      4110231701,
      399823256,
      2144435200,
    ];

    check(ints).deepEquals(expected);
  });
}
