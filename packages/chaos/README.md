# Chaos

Fast and high quality pseudo-random number generators (PRNGs) with cloneable
state.

[![Binary on pub.dev][pub_img]][pub_url]
[![Code coverage][cov_img]][cov_url]
[![Github action status][gha_img]][gha_url]
[![Dartdocs][doc_img]][doc_url]
[![Style guide][sty_img]][sty_url]

[pub_url]: https://pub.dartlang.org/packages/chaos
[pub_img]: https://img.shields.io/pub/v/chaos.svg
[gha_url]: https://github.com/matanlurey/chaos.dart/actions
[gha_img]: https://github.com/matanlurey/chaos.dart/actions/workflows/check.yaml/badge.svg
[cov_url]: https://coveralls.io/github/matanlurey/chaos.dart?branch=main
[cov_img]: https://coveralls.io/repos/github/matanlurey/chaos.dart/badge.svg?branch=main
[doc_url]: https://www.dartdocs.org/documentation/chaos/latest
[doc_img]: https://img.shields.io/badge/Documentation-binary-blue.svg
[sty_url]: https://pub.dev/packages/oath
[sty_img]: https://img.shields.io/badge/style-oath-9cf.svg

## Usage

_Chaos_ provides a common interface for pseudo-random number generators (PRNGs)
beyond the built-in `Random` class, including high-quality PRNGs with saveable
and cloneable state, and deterministic sequences for testing:

```dart
import 'package:chaos/chaos.dart';

void main() {
  // Use a high-quality PRNG with inspectable and cloneable state*
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
  final sequence = SequenceRandom([1, 2, 3, 4, 5]);

  // "Roll" 5 d6s, and print the results!
  // (TIP: This is going to be 1, 2, 3, 4, 5)
  for (var i = 0; i < 5; i++) {
    print('d6: ${sequence.nextInt(6) + 1}');
  }
}
```

## Features

For many usages, the default `dart:math` `Random` class is sufficient; however,
_Chaos_ provides additional features for more advanced use-cases, such as game
development, simulations, and testing:

- **High-quality `Xoshiro128+` and `Xoshiro128++` PRNGs**: Fast and high-quality
  PRNGs with 128-bit state, and clonable state for save-states, replays, and
  debugging, carefully tested against the reference implementations using Dart
  FFI.
- **Deterministic `SequenceRandom`**: A PRNG that generates numbers from a
  pre-defined sequence, useful for unit tests and debugging with tightly
  controlled randomness. Answer that age-old question: _"What happens if the
  player rolls a 20 every time?"_.
- **Common `SeedableGenerator` interface**: A common interface for PRNGs that
  can can be created with a seed. Want your own PRNG? Implement this interface
  and swap PRNGs with ease.

## Contributing

To run the tests, run:

```shell
dart test
```

To check code coverage locally, run:

```shell
./chore coverage
```

To preview `dartdoc` output locally, run:

```shell
./chore dartodc
```
