import 'dart:io' as io;
import 'dart:isolate';

import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:sector/sector.dart';

/// Runs a simple game of life simulation using a [Grid].
///
/// If no arguments are provided, a single threaded single program simulation
/// will be run for 100 ticks, with artificial delays between each tick to make
/// the simulation visible.
///
/// If the `--parallel` or `-p` flag is provided, will 1 run simulation per
/// [io.Platform.numberOfProcessors] in parallel, and print the results of each
/// simulation after they have all completed 100 ticks, as well as the total
/// time taken.
void main(List<String> args) async {
  if (args.isEmpty) {
    // Run a single threaded single program 100 ticks.
    final grid = Grid<int>.generate(
      20,
      10,
      (_) => Random().nextInt(2),
      empty: 0,
    );
    for (var i = 0; i < 100; i++) {
      runTick(grid);
      await Future<void>.delayed(const Duration(milliseconds: 25));
      io.stdout.writeln(grid);
    }
    return;
  }
  if (args.contains('--parallel') || args.contains('-p')) {
    final grids = List<Grid<int>>.generate(io.Platform.numberOfProcessors, (_) {
      final buffer = Uint8List(20 * 10);
      final grid = ListGrid.withList(buffer, width: 20, empty: 0);
      final random = Random();
      for (var i = 0; i < buffer.length; i++) {
        buffer[i] = random.nextInt(2);
      }
      return grid;
    });

    final stopwatch = Stopwatch()..start();

    // Spawn isolates to run the simulation in parallel.
    final futures = <Future<void>>[
      for (var i = 0; i < grids.length; i++)
        Isolate.run(() {
          final grid = grids[i];
          for (var i = 0; i < 100; i++) {
            runTick(grid);
          }
        }),
    ];

    await Future.wait(futures);

    for (final grid in grids) {
      io.stdout.writeln(grid);
    }

    io.stdout.writeln(
      'All simulations (${grids.length}) completed 100 ticks each in '
      '${stopwatch.elapsedMilliseconds}ms.',
    );
  }
}

void runTick(Grid<int> grid) {
  final previous = Grid.from(grid);
  for (var y = 0; y < grid.height; y++) {
    for (var x = 0; x < grid.width; x++) {
      final neighbors = _countNeighbors(previous, x, y);
      final cell = previous.get(Pos(x, y));
      if (cell == 1) {
        grid.set(Pos(x, y), neighbors == 2 || neighbors == 3 ? 1 : 0);
      } else {
        grid.set(Pos(x, y), neighbors == 3 ? 1 : 0);
      }
    }
  }
}

int _countNeighbors(Grid<int> grid, int x, int y) {
  var count = 0;
  for (var dy = -1; dy <= 1; dy++) {
    for (var dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0) continue;
      final nx = x + dx;
      final ny = y + dy;
      if (nx < 0 || nx >= grid.width) continue;
      if (ny < 0 || ny >= grid.height) continue;
      count += grid.get(Pos(nx, ny));
    }
  }
  return count;
}
