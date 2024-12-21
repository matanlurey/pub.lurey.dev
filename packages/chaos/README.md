<!-- #region(HEADER) -->
# `chaos`

Fast and high quality pseudo-random number generators (PRNGs) with cloneable state.

| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |
|:----------|:-----------|:--------|:--------------|
| [![Build status for package/chaos](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_chaos.yaml/badge.svg)](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_chaos.yaml) | [![Pub version for package/chaos](https://img.shields.io/pub/v/chaos)](https://pub.dev/packages/chaos) | [![Dart documentation for package/chaos](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/chaos) | [![GitHub Issues for package/chaos](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-chaos?label=issues)](https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-chaos) |
<!-- #endregion -->

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
  final sequence = SequenceRandom([1, 2, 3, 4, 5], max: 6);

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

<!-- #region(CONTRIBUTING) -->
## Contributing

We welcome contributions to this package!

Please [file an issue][] before contributing larger changes.

[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new?labels=pkg-chaos

This package uses repository specific tooling to enforce formatting, static analysis, and testing. Please run the following commands locally before submitting a pull request:

- `./dev.sh --packages packages/chaos check `
- `./dev.sh --packages packages/chaos test `


<!-- #endregion -->
