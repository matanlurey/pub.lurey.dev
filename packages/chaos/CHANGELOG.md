# Changelog

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
