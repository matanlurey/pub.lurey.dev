<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.3.0-alpha+2

- Bumped Dart to `^3.8.0`.
- Removed all collection-based APIs, which were moved into `package:armory`.

## 0.3.0-alpha+1

- Added `checkNotEmpty` and `assertNotEmpty`
- Added `checkStringNotEmpty` and `assertStringNotEmpty`
- Added `checkNotBlank` and `assertNotBlank`
- Added `NullableStringExtension`
- Added `orderedEquals` and `unorderedEquals` to `MapExtension`

## 0.3.0-alpha

Major set of changes, including breaking changes.

**New features**:

- Added `Delegating*` classes for `Iterable`, `List`, `Set` and `Map`.
- Added `CopyOnWrite*` classes for `List`, `Set` and `Map`.

**Breaking changes**:

- Reduced the API surface considerably.

## 0.2.0

- Added `ListExtension` and `SetExtension`.

**New features**:

- Added `MapExtension`, with similar functionality to `IterableExtension`.
- Added `IterableOrNullExtension` and `MapOrNullExtension`.

**Breaking changes**:

- Methods labeled `*Unordered` are now `*`, and the inverse are `*Ordered`.

**Bug fixes**:

- Many methods had slightly incorrect implementations, which have been fixed
  and better tests added.

## 0.1.2

- Added `assertionsEnabled`.
- Added `assertPositive`, `checkNonNegative`, and `assertNonNegative`.
- Removed `SetExtension` in favor of optimizations in `IterableExtension`.

## 0.1.1

- Bumped Dart to `^3.7.0`.
- Added optional arguments `name` and `message` to `to[Unmodifiable]SetRejectDuplicates`.

## 0.1.0

Initial release.
