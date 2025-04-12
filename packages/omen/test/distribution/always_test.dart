import 'dart:math';

import 'package:omen/omen.dart';

import '../_prelude.dart';

void main() {
  test('always returns the same result', () {
    final distribution = Distribution.always(42);
    final randomNumbers = Random();

    for (var i = 0; i < 100; i++) {
      check(distribution.sample(randomNumbers)).equals(42);
    }
  });
}
