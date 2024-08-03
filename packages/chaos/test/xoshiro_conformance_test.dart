import 'package:chaos/chaos.dart';

import 'src/prelude.dart';
import 'src/xoshiro_pregen.dart';

/// Tests that the Dart implementation of the xoshiro128+ and xoshiro128++ PRNGs
/// matches the C implementation.
void main() {
  group('xoshiro128plus', () {
    test('generates expected random numbers', () {
      final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128P$0_1_2_4$first10Integers);
    });

    test('jump, and then generate 10 random numbers', () {
      final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
      random.jump();
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128P$0_1_2_4$jump$next10Integers);
    });

    test('long jump, and then generate 10 random numbers', () {
      final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);
      random.longJump();
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128P$0_1_2_4$longJump$next10Integers);
    });
  });

  group('xoshiro128plusplus', () {
    test('generates expected random numbers', () {
      final random = Xoshiro128PP.fromSeed([1, 2, 3, 4]);
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128PP$0_1_2_4$first10Integers);
    });

    test('jump, and then generate 10 random numbers', () {
      final random = Xoshiro128PP.fromSeed([1, 2, 3, 4]);
      random.jump();
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128PP$0_1_2_4$jump$next10Integers);
    });

    test('long jump, and then generate 10 random numbers', () {
      final random = Xoshiro128PP.fromSeed([1, 2, 3, 4]);
      random.longJump();
      check(
        [for (var i = 0; i < 10; i++) random.nextInt()],
      ).deepEquals(xoshiro128PP$0_1_2_4$longJump$next10Integers);
    });
  });
}
