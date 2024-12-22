import 'package:flutter/material.dart';
import 'package:sector/sector.dart';
import 'package:sector_demo/src/bottom_sheet.dart';
import 'package:sector_demo/src/grid.dart';

void main() {
  runApp(const MainApp());
}

/// Main shell of the demo application.
final class MainApp extends StatelessWidget {
  /// Creates a an application shell.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _PathfindView();
  }
}

final class _PathfindView extends StatefulWidget {
  const _PathfindView();

  @override
  State<_PathfindView> createState() => _PathfindViewState();
}

final class _PathfindViewState extends State<_PathfindView> {
  final grid = Grid.filled(100, 100, empty: false);
  Pos? start = Pos(45, 50);
  Pos? end = Pos(55, 50);
  Path<Pos>? path;
  TraceRecorder<Pos>? trace;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PathfinderGrid(
          grid: grid,
          path: path,
          start: start,
          end: end,
          trace: trace,
          onTap: _onTapCell,
          onDrag: (pos) => _onTapCell(pos, true),
        ),
        bottomSheet: PathfinderBottomSheet<Pos>(
          onClear: _onClearGrid,
          onFindPath: start != null && end != null ? _onFindPath : null,
        ),
      ),
    );
  }

  void _onTapCell(Pos cell, [bool? value]) {
    // If it was the starting node, toggle it off.
    if (cell == start) {
      setState(() {
        start = null;
      });
      return;
    }

    // If it was the ending node, toggle it off.
    if (cell == end) {
      setState(() {
        end = null;
      });
      return;
    }

    // If we had the starting node off, toggle it on.
    if (start == null) {
      setState(() {
        start = cell;
      });
      return;
    }

    // If we had the ending node off, toggle it on.
    if (end == null) {
      setState(() {
        end = cell;
      });
      return;
    }

    // Otherwise, just toggle the cell.
    setState(() {
      grid[cell] = value ?? !grid[cell];
    });
  }

  void _onClearGrid() {
    setState(() {
      grid.clear();
      start = Pos(45, 50);
      end = Pos(55, 50);
      path = null;
    });
  }

  static double _weight(bool from, bool to, Pos tile) {
    return from || to ? double.infinity : 1.0;
  }

  void _onFindPath(PathfinderBase<Pos> pathfinder, {bool trace = false}) {
    final TraceRecorder<Pos>? recorder;
    if (trace) {
      recorder = TraceRecorder();
    } else {
      recorder = null;
    }

    final Path<Pos> path;
    final graph = grid.asWeighted(weight: _weight);
    switch (pathfinder) {
      case final Pathfinder<Pos> p:
        path = p.findPath(
          graph,
          start!,
          Goal.node(end!),
          tracer: recorder,
        );
      case final BestPathfinder<Pos> p:
        final (result, _) = p.findBestPath(
          graph,
          start!,
          Goal.node(end!),
          tracer: recorder,
        );
        path = result;
      case final HeuristicPathfinder<Pos> p:
        final (result, _) = p.findBestPath(
          graph,
          start!,
          Goal.node(end!),
          GridHeuristic.manhattan(end!),
          tracer: recorder,
        );
        path = result;
    }

    setState(() {
      this.path = path;
      this.trace = recorder;
    });
  }
}
