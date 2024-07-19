import 'package:flutter/material.dart';
import 'package:sector/sector.dart';

/// A grid of cells.
final class PathfinderGrid extends StatefulWidget {
  /// Creates a grid.
  const PathfinderGrid({
    required this.grid,
    required this.onTap,
    this.start,
    this.end,
    this.path,
    this.trace,
    super.key,
  });

  /// Called when a cell is tapped.
  final void Function(Pos) onTap;

  /// The grid to display.
  final Grid<bool> grid;

  /// The path to display, or `null` if not set.
  final Path<Pos>? path;

  /// A recording of the pathfinding algorithm.
  final TraceRecorder<Pos>? trace;

  /// The start position, if set.
  final Pos? start;

  /// The end position, if set.
  final Pos? end;

  @override
  State<PathfinderGrid> createState() => _PathfinderGridState();
}

final class _PathfinderGridState extends State<PathfinderGrid>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  Pos? get start => widget.start;
  Pos? get end => widget.end;
  Grid<bool> get grid => widget.grid;
  Path<Pos>? get path => widget.path;
  TraceRecorder<Pos>? get trace => widget.trace;

  @override
  void didUpdateWidget(covariant PathfinderGrid oldWidget) {
    _controller.reset();
    if (oldWidget.trace != widget.trace) {
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _GridPainter painter;
    if (trace case final TraceRecorder<Pos> trace) {
      final animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
      painter = _GridPainter.withTrace(
        grid: grid,
        trace: trace.events,
        path: path,
        animation: animation,
        start: start,
        end: end,
      );
    } else {
      painter = _GridPainter(
        grid: grid,
        start: start,
        end: end,
        path: path,
      );
    }
    return GestureDetector(
      onTapDown: (details) {
        final squareSize = 30.0;
        final viewSize = MediaQuery.sizeOf(context);
        final offsetX = (viewSize.width - grid.width * squareSize) / 2;
        final offsetY = (viewSize.height - grid.height * squareSize) / 2;
        final x = (details.localPosition.dx - offsetX) ~/ squareSize;
        final y = (details.localPosition.dy - offsetY) ~/ squareSize;
        final pos = Pos(x, y);
        widget.onTap(pos);
      },
      child: CustomPaint(
        foregroundPainter: painter,
        child: const SizedBox.expand(),
      ),
    );
  }
}

final class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.grid,
    this.start,
    this.end,
    this.path,
  })  : trace = null,
        animation = null;

  _GridPainter.withTrace({
    required this.grid,
    required this.trace,
    required this.path,
    required this.animation,
    required this.start,
    required this.end,
  }) : super(repaint: animation);

  final Grid<bool> grid;
  final Pos? start;
  final Pos? end;
  final Path<Pos>? path;
  final List<TraceEvent<Pos>>? trace;
  final Animation<double>? animation;

  static final _paintGrid = Paint()..style = PaintingStyle.stroke;
  static final _paintFill = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;
  static final _paintStart = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.fill;
  static final _paintEnd = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;
  static final _paintPath = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;
  static final _paintVisit = Paint()
    ..color = Colors.grey.shade300
    ..style = PaintingStyle.fill;
  static final _paintSkip = Paint()
    ..color = Colors.grey.shade100
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // The grid is full of 30x squares, centered in the middle of the canvas.
    final squareSize = 30.0;
    final gridWidth = grid.width * squareSize;
    final gridHeight = grid.height * squareSize;
    final offsetX = (size.width - gridWidth) / 2;
    final offsetY = (size.height - gridHeight) / 2;

    // Draw the grid.
    for (var x = 0; x < grid.width; x++) {
      for (var y = 0; y < grid.height; y++) {
        final rect = Rect.fromLTWH(
          offsetX + x * squareSize,
          offsetY + y * squareSize,
          squareSize,
          squareSize,
        );

        if (grid[Pos(x, y)]) {
          canvas.drawRect(rect, _paintFill);
        }

        canvas.drawRect(rect, _paintGrid);
      }
    }

    // Fill cells in the grid.
    for (final (pos, obstable) in grid.cells) {
      if (obstable) {
        final x = pos.x * squareSize + offsetX;
        final y = pos.y * squareSize + offsetY;
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          _paintFill,
        );
      }
    }

    // Draw the start and end positions, if set.
    if (start case final Pos start) {
      final rect = Rect.fromLTWH(
        offsetX + start.x * squareSize,
        offsetY + start.y * squareSize,
        squareSize,
        squareSize,
      );
      canvas.drawRect(rect.deflate(1), _paintStart);
    }

    if (end case final Pos end) {
      final rect = Rect.fromLTWH(
        offsetX + end.x * squareSize,
        offsetY + end.y * squareSize,
        squareSize,
        squareSize,
      );
      canvas.drawRect(rect.deflate(1), _paintEnd);
    }

    // Draw the path, if set.
    if (path case final Path<Pos> path when trace == null) {
      for (final pos in path.nodes.skip(1).take(path.nodes.length - 2)) {
        final rect = Rect.fromLTWH(
          offsetX + pos.x * squareSize,
          offsetY + pos.y * squareSize,
          squareSize,
          squareSize,
        );
        canvas.drawRect(rect.deflate(1), _paintPath);
      }
    }

    // Animate the trace, if set.
    final visited = <Pos>{};
    if (trace case final List<TraceEvent<Pos>> trace) {
      final animation = this.animation!.value;

      // Determine how many events to show based on the animation value.
      final events = (trace.length * animation).round();

      // Draw the events. Skips are grey, paths are blue.
      for (final event in trace
          .where((e) => e is VisitEvent || e is SkipEvent)
          .take(events)) {
        final Pos pos;
        Paint paint;
        switch (event) {
          case final VisitEvent<Pos> e:
            visited.add(e.node);
            pos = e.node;
            paint = _paintVisit;
            if (path!.nodes.contains(e.node)) {
              paint = _paintPath;
            }
          case final SkipEvent<Pos> e when !visited.contains(e.node):
            pos = e.node;
            paint = _paintSkip;
          default:
            continue;
        }

        if (pos == start || pos == end) {
          continue;
        }

        final rect = Rect.fromLTWH(
          offsetX + pos.x * squareSize,
          offsetY + pos.y * squareSize,
          squareSize,
          squareSize,
        );

        canvas.drawRect(rect.deflate(1), paint);
      }
    }
  }

  @override
  bool? hitTest(Offset position) => true;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
