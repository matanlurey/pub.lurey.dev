import 'package:lodim/lodim.dart';

import '../prelude.dart';

void main() {
  final grid = Grid.fromRows(
    [
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
      [' ', ' ', 'W', ' ', ' ', ' ', ' ', 'S', ' ', ' ', ' ', ' ', '#', ' '],
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
  final waypoint = grid.cells.firstWhere((cell) => cell.$2 == 'W').$1;
  final graph = grid.asWeighted(
    weight: (a, b, ___) {
      if (a == '#' || b == '#') {
        return double.infinity;
      }
      return 1;
    },
  );

  late TestTracer<Pos> tracer;

  setUp(() {
    tracer = TestTracer<Pos>();
  });

  test('dijkstra should find the shortest path, but does a lot of work', () {
    final (path, cost) = dijkstra.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      tracer: tracer,
    );

    check(path).nodesBetween(start, goal);
    check(cost).equals(22);
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(130);
  });

  test('greedy fails with no accurate guidance', () {
    final (path, _) = greedyBestFirstSearch.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      Heuristic.zero(),
      tracer: tracer,
    );

    check(path).notFound();
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(35);
  });

  test('greedy fails with a manhattan heuristic', () {
    final (path, _) = greedyBestFirstSearch.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      GridHeuristic.manhattan(goal),
      tracer: tracer,
    );

    check(path).notFound();
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(63);
  });

  test('greedy should find a path with a custom "waypoint" heuristic', () {
    var atWaypoint = false;
    final (path, _) = greedyBestFirstSearch.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      Heuristic((next) {
        if (atWaypoint) {
          return 1;
        }

        // Guide towards 'waypoint' until we hit it.
        if (next == waypoint) {
          atWaypoint = true;
          return 1;
        }

        // Return guidance towards the waypoint.
        return manhattan(next, waypoint).toDouble();
      }),
      tracer: tracer,
    );
    check(path).nodesBetween(start, goal);
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(32);
  });

  test('a* should find the shortest path with a "manhattan" heuristic', () {
    tracer = TestTracer<Pos>(expectRepeatedVisits: true);

    final (path, cost) = astar.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      GridHeuristic.manhattan(goal),
      tracer: tracer,
    );
    check(path).nodesBetween(start, goal);
    check(cost).equals(22);
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(88);
  });

  test('fringe should find the shortest path with a "manhattan" heuristic', () {
    tracer = TestTracer<Pos>(expectRepeatedVisits: true);

    final (path, cost) = fringeAstar.findBestPath<Pos>(
      graph,
      start,
      Goal.node(goal),
      GridHeuristic.manhattan(goal),
      tracer: tracer,
    );
    check(path).nodesBetween(start, goal);
    check(cost).equals(22);
    check(tracer.events.whereType<VisitEvent<Pos>>()).length.equals(182);
  });
}
