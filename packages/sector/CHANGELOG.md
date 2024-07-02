# Change Log

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
