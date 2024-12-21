<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.2.0+1

- Merged into the `pub.luery.dev` monorepo.
- Bumped the minimum SDK constraint to Dart `3.5.0`.

## 0.2.0

**New features**:

- Added `ScalarField`, a 2-dimensional field of scalar values, typically built
  from patterns or noise functions, and `buildPlaneMap`, a utility function to
  build a flat plane from a `ScalarField`, useful for terrain generation.

**Breaking changes**:

- Added `<Plattern>.get2df`, as an alternative to `get2d` that takes floating
  point coordinates, which is required for some use cases such the aformentioned
  `buildPlaneMap`. `get2d` still exists and is recommended for integer
  coordinates, and is automatically converted to `get2df` when needed.

**Bug fixes**:

- Fixed a variety of small math bugs that are hard to describe in detail.

## 0.1.0+1

- Update preview images in README.

## 0.1.0

- Initial release.
