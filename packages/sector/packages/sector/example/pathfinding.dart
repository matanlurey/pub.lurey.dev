import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:sector/sector.dart';

void main(List<String> arguments) {
  final args = _parser.parse(arguments);
  if (args.flag('help')) {
    io.stdout.writeln(_parser.usage);
    return;
  }

  final grid = Grid.fromRows(
    [
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', 'S', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X'],
    ],
    empty: '#',
  );

  final start = grid.cells.firstWhere((cell) => cell.$2 == 'S').$1;
  final goal = grid.cells.firstWhere((cell) => cell.$2 == 'X').$1;
  final graph = grid.asWeighted(
    weight: (a, b, _) {
      if (a == '#' || b == '#') {
        return double.infinity;
      }
      return 1;
    },
  );

  final pathfinder = switch (args.option('algorithm')) {
    'bfs' => breadthFirstSearch,
    'dfs' => depthFirstSearch,
    // TODO: Enable when it doesn't hang.
    // 'iddfs' => iterativeDepthFirstSearch,
    'dijkstra' => dijkstra,
    'greedy' => greedyBestFirstSearch,
    'astar' => astar,
    'astar-fringe' => fringeAstar,
    _ => throw ArgumentError('Invalid algorithm'),
  };

  _printGrid(grid, start, goal);

  final heuristic = switch (args.option('heuristic')) {
    'always-min' => Heuristic<Pos>.zero(),
    'always-max' => Heuristic<Pos>.always(double.maxFinite),
    'manhattan' => GridHeuristic.manhattan(goal),
    'euclidean' => GridHeuristic.euclidean(goal),
    _ => throw ArgumentError('Invalid heuristic'),
  };

  io.stdout.writeln();
  io.stdout.writeln('Press Enter to start...');
  io.stdin.readLineSync();

  io.stdout.writeln(
    'Running ${args.option('algorithm')}'
    '${pathfinder is HeuristicPathfinder ? ' with ${args.option('heuristic')}' : ''}...',
  );
  final stopwatch = Stopwatch()..start();

  late Path<Pos> path;
  for (var i = 0; i < 100; i++) {
    if (pathfinder is Pathfinder) {
      path = pathfinder.findPath(graph, start, Goal.node(goal));
    } else if (pathfinder is BestPathfinder) {
      final (p, _) = pathfinder.findBestPath(graph, start, Goal.node(goal));
      path = p;
    } else if (pathfinder is HeuristicPathfinder) {
      final (p, _) = pathfinder.findBestPath(
        graph,
        start,
        Goal.node(goal),
        heuristic,
      );
      path = p;
    } else {
      throw StateError('Unknown pathfinder: ${pathfinder.runtimeType}');
    }
  }

  stopwatch.stop();

  for (final node in path.nodes) {
    grid[node] = '*';
  }
  _printGrid(grid, start, goal);
  io.stdout.writeln();
  io.stdout.writeln(
    'Path: ${path.nodes.length} nodes (100x times) in ${stopwatch.elapsed.inMilliseconds}ms',
  );
}

final _parser = ArgParser(allowTrailingOptions: false)
  ..addFlag(
    'help',
    negatable: false,
  )
  ..addOption(
    'algorithm',
    abbr: 'a',
    allowed: [
      'bfs',
      'dfs',
      // TODO: Enable when it doesn't hang.
      // 'iddfs',
      'dijkstra',
      'greedy',
      'astar',
      'astar-fringe',
    ],
    defaultsTo: 'dijkstra',
  )
  ..addOption(
    'heuristic',
    abbr: 'h',
    allowed: [
      'always-min',
      'always-max',
      'manhattan',
      'euclidean',
    ],
    defaultsTo: 'manhattan',
  );

void _printGrid(Grid<String> grid, Pos start, Pos goal) {
  for (var row = 0; row < grid.height; row++) {
    for (var col = 0; col < grid.width; col++) {
      final pos = Pos(col, row);
      if (pos == start) {
        io.stdout.write('S');
      } else if (pos == goal) {
        io.stdout.write('X');
      } else {
        io.stdout.write(grid[pos]);
      }
    }
    io.stdout.writeln();
  }
}
