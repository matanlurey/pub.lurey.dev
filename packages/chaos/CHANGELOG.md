<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.1.2+3

**Bug fixes**:

- `SequenceRandom` no longer returns `max` for `nextInt(max)` or `1.0` for
  `nextDouble()`:

  ```dart
  final sequence = SequenceRandom([0.0, 0.5, 1.0]);

  check(sequence.nextDouble()).equals(0.0);
  check(sequence.nextDouble()).equals(0.5);
  check(sequence.nextDouble()).isCloseTo(1.0, 0.0001);
  ```

**Deprecations**:

- Deprecated `defaultRandom` in favor of `systemRandom`.

## 0.1.2+2

- Bumped Dart to `^3.7.0`.

## 0.1.2+1

- Expand `package:binary` to `^4.0.0` (was accidentally `4.0.0`).

## 0.1.2

**New features:**

- Merged into the `pub.luery.dev` monorepo.
- Exported `PersistentRandom` to the public API.
- Bumped the minimum SDK constraint to Dart `3.5.0`.

## 0.1.1

**New features:**

- Added `Xoroshiro128.randomSeed`.

**Bug fixes:**

- Fixed `SequenceRandom.ints`, which did not work as documented. The optional
  named arguments (newly added) `(min: ..., max: ...)` can now be used to set
  the range of the generated integers, and they are inferred from the sequence
  if not provided.

## 0.1.0+1

**Bug fixes:**

- Fixed a bug where the last element of a `SequenceRandom` was never used.

## 0.1.0

- Initial release.
