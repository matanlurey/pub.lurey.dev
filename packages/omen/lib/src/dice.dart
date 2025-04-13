import 'dart:math';

import 'package:meta/meta.dart';
import 'package:omen/src/distribution.dart';
import 'package:quirk/quirk.dart';

/// A dice with 4-sides.
const d4 = Dice(4);

/// A dice with 6-sides.
const d6 = Dice(6);

/// A dice with 8-sides.
const d8 = Dice(8);

/// A dice with 10-sides.
const d10 = Dice(10);

/// A dice with 12-sides.
const d12 = Dice(12);

/// A dice with 20-sides.
const d20 = Dice(20);

/// A dice with 100-sides.
const d100 = Dice(100);

/// A multi-sided die that produces a random number between 1 and [sides].
@immutable
base class Dice with Distribution<int> {
  /// Defines a dice literal with the specified number of sides.
  ///
  /// This constructor is `const`, but must be used with a `const` constructor.
  const Dice(
    @mustBeConst this.sides, //
  ) : assert(sides > 0, 'sides must be greater than 0');

  /// Creates a [Dice] with the specified number of sides.
  Dice.from(this.sides) {
    checkPositive(sides, 'sides');
  }

  /// Number of sides on the die.
  ///
  /// Must be greater than 0.
  @nonVirtual
  final int sides;

  @override
  @nonVirtual
  bool operator ==(Object other) {
    return other is Dice &&
        runtimeType == other.runtimeType &&
        other.sides == sides;
  }

  @override
  @nonVirtual
  int get hashCode {
    return sides.hashCode;
  }

  @override
  int sample(Random random) {
    return random.nextInt(sides) + 1;
  }

  @override
  String toString() {
    return '$runtimeType($sides)';
  }
}
