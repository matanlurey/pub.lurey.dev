<!-- #region(HEADER) -->
# `sector`

Fast and intuitive 2D data structures: grids, graphs, pathfinding & more.

| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |
|:----------|:-----------|:--------|:--------------|
| [![Build status for package/sector](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_sector.yaml/badge.svg)](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_sector.yaml) | [![Pub version for package/sector](https://img.shields.io/pub/v/sector)](https://pub.dev/packages/sector) | [![Dart documentation for package/sector](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/sector) | [![GitHub Issues for package/sector](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-sector?label=issues)](https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-sector) |
<!-- #endregion -->

[![Preview of the Demo App](https://github.com/user-attachments/assets/8071eab4-a234-492b-8c2e-1fa4233febed)](./example/demo)

## Getting Started

Add a dependency in your `pubspec.yaml` or run the following command:

```bash
dart pub add sector
```

## Features

- Platform _independent_, works on the Web, Flutter, and Dart VM.
- *Idiomatic*ally Dart, with a familiar and fully documented API.
- _Extensible_, with a focus on performance and ergonomics.
- _Well-tested_, with 100% code coverage and property-based tests.
- _Lightweight_, with zero dependencies, minimal overhead, and benchmarked.

## Usage

Sector offers a powerful toolkit for graphs, grids, pathfinding, and more.

### Graphs

Create a graph and add edges:

```dart
final graph = Graph<String>();

graph.addEdge(Edge('a', 'b'));
graph.addEdge(Edge('b', 'c'));

print(graph.roots); // ['a']
print(graph.successors('b')); // ['c']
```

### Grids

Create a grid and update cells:

```dart
enum Tile {
  wall,
  floor,
}

// Create a 5x8 grid filled with `Tile.wall`.
//
// When resizing a grid, the `empty` value is used to fill the new cells.
final grid = Grid.filled(5, 8, empty: Tile.wall);

// Itereate over the grid.
for (final row in grid.rows) {
  for (final cell in row) {
    print(cell);
  }
}
```

### Pathfinding

Use built-in pathfinding algorithms or write your own:

```dart
final graph = Walkable.linear(['a', 'b', 'c']);

final path = breadthFirstSearch(graph, 'a', Goal.node('c'));
print(path); // Path(['a', 'b', 'c'])
```

<!-- #region(CONTRIBUTING) -->
## Contributing

We welcome contributions to this package!

Please [file an issue][] before contributing larger changes.

[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new?labels=pkg-sector

This package uses repository specific tooling to enforce formatting, static analysis, and testing. Please run the following commands locally before submitting a pull request:

- `./dev.sh --packages packages/sector check `
- `./dev.sh --packages packages/sector test `


<!-- #endregion -->
