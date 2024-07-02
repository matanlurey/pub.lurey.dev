# Change Log

## 0.3.0-dev

- Fixed a bug in `Grid.fromColumns` (and `ListGrid.fromColumns`) where the
  columns were not copied correctly, and the grid was not initialized with the
  correct dimensions.

- Fixed a bug in `<Grid>.columns.remove*` where, similar to above, the grid was
  not updated correctly.

- Moved `<Grid>.layoutHint` and `<Grid>.getByIndexUnchecked` to the optional
  mixin `EfficientIndexGrid`, which only provides these methods. This allows
  users to opt-in to these methods, and not have them clutter the API of the
  main `Grid` class:

  ```dart
  class MyListGrid<T> with Grid<T>, EfficientIndexGrid<T> {
    final List<T> _list;

    /* ... */

    @override
    LayoutHint get layoutHint => LayoutHint.rowMajorContinguous;

    @override
    T getByIndexUnchecked(int index) => _list[index];
  }
  ```

- Replaced `Rows` and `Columns` with `GridAxis`; both of these types only
  existed to have a common interface for iterating over rows and columns, but
  ironically the only common base was `Iterable<Iterable<T>>`.

  `GridAxis` is a more general type that can be used to iterate over rows and
  columns, and even allow users to define their own axis. The common way to
  implement those will be `RowsMixin` and `ColumnsMixin`, which replaces the
  types `RowsBase` and `ColumnsBase` accordingly.

  ```diff
  - class MyRows extends Iterable<Iterable<T>> with RowsBase<T> { /* ... */ }
  + class MyRows extends GridAxis<T> with RowsMixin<T> { /* ... */ }
  ```

- Extending or mixing in `Grid<T>` provides a default implementation of `clear`.

- Added `UnmodifiableGridView`, which wraps a `Grid` and makes it unmodifiable.

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
