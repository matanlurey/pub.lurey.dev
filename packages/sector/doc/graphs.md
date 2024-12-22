Graph data structures, sorting, traversal, and graph algorithms & utilities.

---

Table of Contents:

- [Walkables](#walkables)
- [Graphs](#graphs)
- [Sorting and Traversing](#sorting-and-traversing)

---

## Walkables

Sector provides foundational sequential access to graph nodes, or
`Walkable`, which is to iterable what `Graph` is to `List`, representing a
collection of nodes and edges:

```dart
void example(Walkable<String> walkable) {
  for (final node in walkable.roots) {
    for (final successor in walkable.successors(node)) {
      print('$node -> $successor');
    }
  }
}
```

Ephemeral collections can be created without needing a concrete
implementation:

```dart
// a -> b -> c
Walkable.linear(['a', 'b', 'c']);

// a -> b -> a
Walkable.circular(['a', 'b']);

//    a
//   / \
//  b - c
Walkable.star(['a', 'b', 'c']);
```

See also `WeightedWalkable`, a variant of `Walkable` that includes floating
point edge weights, and can be derived using `Walkable.asWeighted`; algorithms
that can operate on both types of walkables can be implemented in terms of
`WalkableBase` (which many algorithms in this package do).

## Graphs

Graphs are a collection of nodes, and edges between nodes.

Sector contains an interface and concrete implementation, `Graph` and
`AdjacencyListGraph`, respectively, which is an
[adjacency list](https://en.wikipedia.org/wiki/Adjacency_list)
representation of a graph, ideal for _sparse_ (few edges) graphs:

```dart
final graph = Graph<String>();

graph.addEdge(Edge('a', 'b'));
graph.addEdge(Edge('b', 'c'));

print(graph.roots); // ['a']
print(graph.successors('b')); // ['c']
```

By default, most graphs are _directed_, meaning an edge has an explicit
source and target node. However, undirected graphs can be created by
using `directed: false`, or by mixing-in the `UndirectedGraph` mixin:

```dart
final graph = Graph<String>(directed: false);

graph.addEdge(Edge('a', 'b'));

print(graph.successors('a')); // ['b']
print(graph.successors('b')); // ['a']

// ...

final class MyUndirectedGraph<E> = MyGraph<E> with UndirectedGraph<E> {}
```

## Sorting and Traversing

A few utilities are provided for sorting and traversing graphs:

- `topologicalSort` for sorting a directed acyclic graph dependency order.
- `stronglyConnected` and for finding cycles (strong components) in a graph.
- `breadthFirst` for traversing a graph in breadth-first (shallower-first)
  order.
- `depthFirst` for traversing a graph in depth-first (deeper-first) order.
