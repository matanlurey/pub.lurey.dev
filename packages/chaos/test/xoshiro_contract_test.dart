import 'package:chaos/chaos.dart';

import 'src/prelude.dart';

/// Tests Xoshiro128+ and Xoshiro128++ PRNGs, without expecting specific values.
void main() {
  group('Xoshiro128+', () {
    test('can save and restore state', () {
      final random = Xoshiro128P.fromSeed([1, 2, 3, 4]);

      // Generate 100 numbers.
      for (var i = 0; i < 100; i++) {
        random.nextInt();
      }

      // Clone the state.
      final clone = random.clone();

      // Assert both generators generate the same next 100 numbers.
      for (var i = 0; i < 100; i++) {
        check(random.nextInt()).equals(clone.nextInt());
      }
    });

    test('generates booleans that are statistically random', () {
      // Not a perfect test; we should use a statistical test suite.
      // For now, let's generate the minimum number of booleans to ensure
      // the generator is not obviously broken.

      // Generate a "good" but deterministic seed.
      final random = Xoshiro128P(0xDEADBEEF);

      // Generate 10k booleans and count how many are true.
      var trueCount = 0;
      for (var i = 0; i < 10000; i++) {
        if (random.nextBool()) {
          trueCount++;
        }
      }

      // Assert the number of true booleans is within a reasonable range.
      check(
        trueCount,
        because: 'Within 1%',
      ).isCloseTo(5000, 100);
    });

    test('generates doubles that are well distributed', () {
      // Not a perfect test; we should use a statistical test suite.
      // For now, let's generate the minimum number of doubles to ensure
      // the generator is not obviously broken.

      // Generate a "good" but deterministic seed.
      final random = Xoshiro128P(0xDEADBEEF);

      // Generate 10k doubles and:
      // 1. Ensure all are in the range [0, 1).
      // 2. Check that the distribution is somewhat uniform.
      var min = double.infinity;
      var max = double.negativeInfinity;
      var sum = 0.0;
      var sum2 = 0.0;
      for (var i = 0; i < 10000; i++) {
        final value = random.nextDouble();
        min = value < min ? value : min;
        max = value > max ? value : max;
        sum += value;
        sum2 += value * value;
      }

      // Assert the range is within [0, 1).
      check(min).isNotNegative();
      check(max).isLessThan(1.0);

      // Assert the distribution is somewhat uniform.
      final mean = sum / 10000;
      final variance = sum2 / 10000 - mean * mean;
      check(
        variance,
        because: 'Within 1%',
      ).isCloseTo(1 / 12, 1 / 1200);
    });
  });

  group('Xoshiro128++', () {
    test('can save and restore state', () {
      final random = Xoshiro128PP.fromSeed([1, 2, 3, 4]);

      // Generate 100 numbers.
      for (var i = 0; i < 100; i++) {
        random.nextInt();
      }

      // Clone the state.
      final clone = random.clone();

      // Assert both generators generate the same next 100 numbers.
      for (var i = 0; i < 100; i++) {
        check(random.nextInt()).equals(clone.nextInt());
      }
    });

    test('generates booleans that are statistically random', () {
      // Not a perfect test; we should use a statistical test suite.
      // For now, let's generate the minimum number of booleans to ensure
      // the generator is not obviously broken.

      // Generate a "good" but deterministic seed.
      final random = Xoshiro128PP(0xDEADBEEF);

      // Generate 10k booleans and count how many are true.
      var trueCount = 0;
      for (var i = 0; i < 10000; i++) {
        if (random.nextBool()) {
          trueCount++;
        }
      }

      // Assert the number of true booleans is within a reasonable range.
      check(
        trueCount,
        because: 'Within 1%',
      ).isCloseTo(5000, 150);
    });

    test('generates doubles that are well distributed', () {
      // Not a perfect test; we should use a statistical test suite.
      // For now, let's generate the minimum number of doubles to ensure
      // the generator is not obviously broken.

      // Generate a "good" but deterministic seed.
      final random = Xoshiro128PP(0xDEADBEEF);

      // Generate 10k doubles and:
      // 1. Ensure all are in the range [0, 1).
      // 2. Check that the distribution is somewhat uniform.
      var min = double.infinity;
      var max = double.negativeInfinity;
      var sum = 0.0;
      var sum2 = 0.0;
      for (var i = 0; i < 10000; i++) {
        final value = random.nextDouble();
        min = value < min ? value : min;
        max = value > max ? value : max;
        sum += value;
        sum2 += value * value;
      }

      // Assert the range is within [0, 1).
      check(min).isNotNegative();
      check(max).isLessThan(1.0);

      // Assert the distribution is somewhat uniform.
      final mean = sum / 10000;
      final variance = sum2 / 10000 - mean * mean;
      check(
        variance,
        because: 'Within 1%',
      ).isCloseTo(1 / 12, 3 / 1200);
    });
  });
}
