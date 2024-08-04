import 'dart:math';

import 'package:mirage/mirage.dart';

/// A white noise function.
///
/// This pattern generates random values between -1.0 and 1.0.
///
/// Unlike most patterns, this pattern is _intentionally_ not deterministic;
/// the given random number generator with the same seed _will_ produce the same
/// pattern if and only if the same seed is used and the same number of values
/// are generated in the same order.
///
/// ![Example](https://github.com/user-attachments/assets/665131a8-0571-4200-8487-3f6f179f11b1)
///
/// ## Example
///
/// ```dart
/// final random = Random();
/// final pattern = White(random);
/// print(pattern.get(0, 0));
/// ```
final class White with Pattern2d {
  /// Creates a new white noise pattern using the given random number generator.
  const White(this._random);
  final Random _random;

  @override
  double get2df(double x, double y) => _random.nextDouble() * 2.0 - 1.0;
}
