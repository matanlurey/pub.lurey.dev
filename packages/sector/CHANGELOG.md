<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.4.0+2

- Bumped Dart to `^3.7.0`.

## 0.4.0+1

- Merged into the `pub.luery.dev` monorepo.

## 0.4.0

- Published `0.4.0-alpha+3` as `0.4.0` with no changes.

## 0.4.0-alpha+3

- Upgraded to `lodim: ^0.1.6`.

- `Grid` and its subtypes must be non-empty (a width and height of at least 1);
  in practice this was already the case, but it is now enforced by the various
  constructors and factory methods.

- Added `<Grid>.copyFrom` to copy the contents of one grid to another.

## 0.4.0-alpha+2

- Optimized (and tested) `<Grid>.fill` and `<ListGrid>.fill`.

## 0.4.0-alpha+1

- Deprecated `getUnchecked` and `setUnchecked` in favor of `getUnsafe` and
  `setUnsafe`.

## 0.4.0-alpha

**Breaking changes**:

- `Grid` and `Graph` are now `abstract base mixin class`; in other words, they
  must either be extended or mixed into a class to be used. It is unlikely that
  this will affect any users, but it is a breaking change nevertheless; there
  should be no need to mock either class, as concrete implementations are
  already provided, and they are difficult to mock in isolation.

- `UndirectedGraph` is now a `base mixin` for a similar reason.

- Renamed `clear` to `fill`, and changed the type signature:

  ```diff
  - void clear([E? fill])
  + void clear([Rect? bounds])
  + void fill(E fill, [Rect? bounds])
  ```

## 0.3.0+1

Cosmetic changes to the `pubspec.yaml` file only.

## 0.3.0

Major overhaul of the API, almost all classes and methods have been renamed or
restructured; the API is now more consistent and easier to use, and has been
layered partially on top of [`package:lodim`](https://pub.dev/packages/lodim);
`sector` now includes data structures, graphs, grids, and pathfinding, with
a more consistent API and is better tested and tuned for performance.

In summary:

- Sector now depends on, and uses, `package:lodim` for 2D vector operations.
- Sector now has types and functionality for general-purpose graphs and
  pathfinding.
- `Grid` operations based on column-major order have been removed.
- `Grid` has an `empty` field used for resizing and sparse-grid optimizations.
- `Grid` resizing is now doen via setting `widht` or `height` respectively
- Traversals have moved into general graph algorithms in `package:sector`.

## 0.2.0

- Renamed `<Grid>.contains` to `<Grid>.containsXY`:

  ```diff
  - if (grid.contains(0, 0)) {
  + if (grid.containsXY(0, 0)) {
  ```

- Added `<Grid>.contains` to check if a given element is within the grid,
  similar to `List.contains`:

  ```dart
  if (grid.contains('#')) {
    // ...
  }
  ```

- Removed `Uint8Grid`, in favor of `ListGrid.view(List<T>, {int width})`:

  ```diff
  - final grid = Uint8Grid(3, 3);
  + final grid = ListGrid.view(Uint8List(3 * 3), width: 3);
  ```

  This reducs the API surface, and focuses on the key use-case of creating a
  grid without copying the data: using compact lists as backing storage without
  generics or codegen.

- Added `GridIterator`, `GridIterable` and `Traversal`. These classes provide
  ways to iterate over the elements of a grid, and to traverse the grid in
  different directions.

  For example, a _row-major_ traversal:

  ```dart
  for (final element in grid.traverse(rowMajor())) {
    // ...
  }
  ```

  See also:

  - `rowMajor`
  - `drawLine`

- Added `<Grid>.layoutHint` and `<Grid>.getByIndexUnchecked`; these methods
  allow for more efficient traversal of the grid, by providing a hint about the
  layout of the grid, and by accessing elements by index without extra bounds
  checking.
  
  Most users never need to use these methods.

## 0.1.1

- Added `Uint8Grid`, the first sub-type of `TypedDataGrid`. A `Uint8Grid`, like
  it's counterpart `Uint8List`, is a grid of _unsigned 8-bit integers_, which
  makes it suitable for storing pixel data, tile maps, and other data that can
  be represented as a grid of 8-bit values.

## 0.1.0

🎉 Initial release 🎉
