import 'dart:collection';
import 'dart:math' as math;

import 'package:lodim/lodim.dart';
import 'package:meta/meta.dart';
import 'package:sector/src/collection.dart';
import 'package:sector/src/graph.dart';

// TODO: Replace with a docImport macro or back-ticks.
import 'package:sector/src/grid.dart';

part 'pathfinding/astar.dart';
part 'pathfinding/best_pathfinder.dart';
part 'pathfinding/bfs.dart';
part 'pathfinding/count_paths.dart';
part 'pathfinding/dfs.dart';
part 'pathfinding/dijkstra.dart';
part 'pathfinding/fringe.dart';
part 'pathfinding/goal.dart';
part 'pathfinding/greedy.dart';
part 'pathfinding/heuristic.dart';
part 'pathfinding/heuristic_pathfinder.dart';
part 'pathfinding/iddfs.dart';
part 'pathfinding/path_result.dart';
part 'pathfinding/pathfinder.dart';

/// Reverses a path from a start index to the root.
///
/// - The [parents] map contains the parent index for each node.
/// - The [parent] function returns the parent index for a node.
/// - [start] is the index of the node to start the path from.
List<N> _reversePath<N, V>(
  Map<N, V> parents,
  int Function(V) parent,
  int start,
) {
  final path = <N>[];
  while (true) {
    assert(
      start < parents.length,
      'Parent not found: $start.\n\n'
      'This is likely a bug in a pathfinding algorithm. Please file an issue '
      'with the algorithm you are using (check the stack trace) after '
      'verifying that the graph is correct.\n\n'
      'Path so far: $path\n\n',
    );
    final done = start == 0;
    final entry = parents.entries.elementAt(start);
    start = parent(entry.value);
    final node = entry.key;
    // coverage:ignore-start
    assert(
      !path.contains(node) || path.first == node,
      'Infinite loop detected: $node.\n\n'
      'This is likely a bug in a pathfinding algorithm. Please file an issue '
      'with the algorithm you are using (check the stack trace) after '
      'verifying that the graph is correct.\n\n'
      'Path so far: $path\n\n',
    );
    // coverage:ignore-end
    path.add(node);
    if (done) {
      break;
    }
  }
  return List.of(path.reversed);
}
