<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.1.2

**New features:**

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
