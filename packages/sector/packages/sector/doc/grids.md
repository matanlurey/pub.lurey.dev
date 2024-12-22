Grid data structures and adaptors to work as a graph.

---

Table of Contents:

- [Overview](#overview)
- [Sparse Grids](#sparse-grids)
- [Adapting a Grid to a Graph](#adapting-a-grid-to-a-graph)

---

## Overview

A grid is a collection of elements accessible by a two-dimensional index and
with a default (`empty`) value:

```dart
enum Tile {
  wall,
  floor,
}

// Create a 5x8 grid filled with `Tile.wall`.
//
// When resizing a grid, the `empty` value is used to fill the new cells.
final grid = Grid.filled(5, 8, empty: Tile.wall);
```

Or, to specify a different default fill:

```dart
// Create a 5x8 grid filled with `Tile.floor`, but the default is `Tile.wall`.
final grid = Grid.filled(5, 8, empty: Tile.wall, fill: Tile.floor);
```

To retrieve and update cells in the grid:

```dart
// Retrieve the value at (2, 3).
print(grid.get(2, 3)); // Tile.wall

// Update the value at (2, 3).
grid.set(2, 3, Tile.floor);
print(grid.get(2, 3)); // Tile.floor
```

Or to iterate over the grid:

```dart
for (final row in grid.rows) {
  for (final cell in row) {
    print(cell);
  }
}
```

## Sparse Grids

The default grid implementation is a dense grid, `ListGrid`, which is backed by
a 1-dimensional `List`.

Dense grids are ideal for small to medium-sized grids, or where most cells are
filled with the non-empty value. For larger grids where most cells are empty and
iteration over the full set of cells is a rare operation, a sparse grid,
provided by `SplayTreeGrid`, can be more efficient:

```dart
final grid = SplayTreeGrid.fileld(5, 8, empty: Tile.wall);

print(grid.get(2, 3)); // Tile.wall
print(grid.nonEmptyEntries.length); // 0
```

## Adapting a Grid to a Graph

A `Grid` can be represented as a graph-like structure with `GridWalkable`:

```dart
final grid = Grid.filled(5, 8, empty: Tile.wall);
final graph = GridWalkable.from(grid);
```

An implicit grid is formed where each cell is a node, and edges are created
between horizontal and vertical neighbors.

Alternatively, custom directions can be specified:

```dart
// Use diagonal directions instead of horizontal and vertical.
final a = GridWalkable.diagonal(grid);

// Use all 8 directions, both horizontal, vertical, and diagonal.
final b = GridWalkable.all8Directions(grid);

// Or, to specify your own directions. For example, just left and down:
final c = GridWalkable.from(grid, directions: [
  const Pos(1, 0),
  const Pos(0, 1),
]);
```

These adaptors are entirely lazy, and you could imagine using a different one
for different movement patterns:

```dart
// A knight in chess can move in an L-shape.
const chessKnight = [
  Pos(1, 2),
  Pos(2, 1),
  Pos(2, -1),
  Pos(1, -2),
  Pos(-1, -2),
  Pos(-2, -1),
  Pos(-2, 1),
  Pos(-1, 2),
];
```
