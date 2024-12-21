part of '../lodim.dart';

/// Returns an approximation of the integer square root of [n].
///
/// This function is much faster than [math.sqrt] for integers, but is an
/// _approximation_ that is likely good enough for most use-cases (e.g. games).
///
/// The algorithm is based on the Newton's method, which iteratively refines
/// the guess by averaging it with the original number divided by the guess.
///
/// ## Example
///
/// ```dart
/// print(approximateSqrt(9)); // => 3
/// print(approximateSqrt(16)); // => 4
/// print(approximateSqrt(25)); // => 5
/// ```
int sqrtApproximate(int n) {
  var g = 0x8000;
  var c = 0x8000;
  while (true) {
    if (g * g > n) {
      g ^= c;
    }
    c >>= 1;
    if (c == 0) {
      return g;
    }
    g |= c;
  }
}
