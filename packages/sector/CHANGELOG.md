# Change Log

## 0.2.0-dev

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

- Added `<Grid>.{offsetOf|offsetWhere|lastOffsetOf|lastOffsetWhere}` to find the
  index of an element within the grid, similar to `List.{indexOf|lastIndexOf}`:

  ```dart
  final offsetA = grid.offsetOf('#');
  final offsetB = grid.offsetWhere((element) => element == '#');
  final lastOffsetA = grid.lastOffsetOf('#');
  final lastOffsetB = grid.lastOffsetWhere((element) => element == '#');
  ```

- Removed `Uint8Grid`, in favor of `ListGrid.view(List<T>, {int width})`:

  ```diff
  - final grid = Uint8Grid(3, 3);
  + final grid = ListGrid.view(Uint8List(3 * 3), width: 3);
  ```

  This reducs the API surface, and focuses on the key use-case of creating a
  grid without copying the data: using compact lists as backing storage without
  generics or codegen.

## 0.1.1

- Added `Uint8Grid`, the first sub-type of `TypedDataGrid`. A `Uint8Grid`, like
  it's counterpart `Uint8List`, is a grid of _unsigned 8-bit integers_, which
  makes it suitable for storing pixel data, tile maps, and other data that can
  be represented as a grid of 8-bit values.

## 0.1.0

🎉 Initial release 🎉
