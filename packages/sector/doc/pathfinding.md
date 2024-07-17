Pathfinding algorithms and utilities structured over `Walkable` and
`WeightedWalkable`s.

---

Table of Contents:

- [Finding a Path](#finding-a-path)
- [Directed Graphs](#directed-graphs)
- [Weighted Graphs](#weighted-graphs)
  - [Heuristics](#heuristics)
  - [Picking a Heuristic](#picking-a-heuristic)
  - [Writing a Heuristic](#writing-a-heuristic)

---

## Finding a Path

Pathfinding algorithms are implemented as a `Pathfinder` interface (or mixin),
which is a function that takes a `Walkable`, a `start` node, and teh concept of
a `Goal` (which can be a single node, a set of nodes, or a function that
determines if a node is a goal):

```dart
final graph = Walkable.linear(['a', 'b', 'c']);

final path = breadthFirstSearch(graph, 'a', Goal.node('c'));
print(path); // Path(['a', 'b', 'c'])
```

## Directed Graphs

Every `Graph` (and `Walkable`) implementation is always _directed_ (even
undirected graphs are represented as directed graphs with two edges for each
undirected edge), so every `Pathfinder` algorithm is designed to work with any
graph type without adaptation:

- [BFS][], `breadthFirstSearch`: explore nearest successors first, then widen
  the search.
- [DFS][], `depthFirstSearch`: explore a path as far as possible before
  backtracking.
- [IDDFS][], `iterativeDepthFirstSearch`: explore longer and longer paths
  at the cost of similar reexaminations.

[bfs]: https://en.wikipedia.org/wiki/Breadth-first_search
[dfs]: https://en.wikipedia.org/wiki/Depth-first_search
[iddfs]: https://en.wikipedia.org/wiki/Iterative_deepening_depth-first_search

<!--
## Undirected Graphs

TODO: Add Kruskal, connectedComponents.
-->

## Weighted Graphs

While breadth-first search finds the shortest path in an unweighted graph, it
is not guaranteed to find the shortest path in a _weighted_ graph, where edges
have a non-uniform cost. Weighted searches use the `BestPathfinder`, of which
the only implementation is `dijkstra`:

- [Dijkstra][], `dijkstra`: find the shortest path in a weighted graph.

[dijkstra]: https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

> [!NOTE]
> Dijkstra's algorithm is exhaustive, and can be slow for large graphs.

### Heuristics

Some graph algorithms can optimize on Dijkstra's algorithm by using a heuristic
to guide the search, which is an estimate of minimum cost to reach the target
node or goal. The canonical heuristic search algorithm is `astar`, which
implements `HeuristicPathfinder`:

- [A*][], `astar`: find the shortest path in a weighted graph using a heuristic.

[a*]: https://en.wikipedia.org/wiki/A*_search_algorithm

However, as with Dijkstra's algorithm, A* can be slow for large graphs. Other
heuristic search algorithms are available:

- [Greedy][], `greedy`: find the shortest path in a weighted graph using a
  heuristic, with a focus on speed.
- [Fringe][], `fringe`: find the shortest path in a weighted graph using a
  heuristic, with a focus on performance.

[greedy]: https://en.wikipedia.org/wiki/Greedy_best-first_search
[fringe]: https://en.wikipedia.org/wiki/Fringe_search

### Picking a Heuristic

A heuristic is a function that takes a node and returns an estimate of the
minimum cost to reach the goal.

For grid-based graphs, built-in `GridHeuristic` implementations are available:

- [Manhattan][], `GridHeuristic.manhattan`: estimate the minimum cost to reach
  the goal using the Manhattan distance.
- [Diagonal][], `GridHeuristic.diagonal`: estimate the minimum cost to reach
  the goal using the Diagonal distance.
- [Chebyshev][], `GridHeuristic.chebyshev`: estimate the minimum cost to reach
  the goal using the Chebyshev distance.
- [Euclidean][], `GridHeuristic.euclidean`: estimate the minimum cost to reach
  the goal using the Euclidean distance.

[manhattan]: https://en.wikipedia.org/wiki/Taxicab_geometry
[diagonal]: https://en.wikipedia.org/wiki/Chebyshev_distance
[chebyshev]: https://en.wikipedia.org/wiki/Chebyshev_distance
[euclidean]: https://en.wikipedia.org/wiki/Euclidean_distance

The heuristics can be further tweaked by applying a _ratio_, which is a
multiplier applied to the heuristic value. For example, a ratio of `1.0` is the
default heuristic, a ratio of `0.0` is equivalent to Dijkstra's algorithm, and
a much higher ratio approaches a greedy search.

```dart
final heuristic = GridHeuristic.manhattan(ratio: 2.0);
```

### Writing a Heuristic

When tweaking heuristics, or writing your own, following guidelines can help
optimize the search.

Given `h(n)`, the heuristic, and `g(n)`, the (unknown) actual cost:

| Heuristic             | Optimality Guarantee | Performance        |
|-----------------------|----------------------|--------------------|
| `h(n) == 0`           | Yes [^1]             | Potentially slower |
| `h(n) <= g(n)`        | Yes                  | Varies (slower with lower h(n)) |
| `h(n) == g(n)`        | Yes                  | Fastest possible   |
| `h(n) > g(n)`         | No                   | Faster             |
| `h(n) > g(n)`, always | No [^2]              | Very fast          |

[^1]: A*becomes Dijsktra's algorithm.
[^2]: A* becomes Greedy Best-First Search.

For example, the Manhattan heuristic is `h(n) = |x1 - x2| + |y1 - y2|`, which
is admissible (never overestimates the cost as long as the standard moves are
`1.0`), and consistent (the cost of moving from `n` to `n'` is always less than
or equal to `h(n) - h(n')`).

Other heuristics may not be admissible or consistent, but can still be useful.

See also: <https://www.redblobgames.com/pathfinding/a-star/introduction.html#heuristics>.
