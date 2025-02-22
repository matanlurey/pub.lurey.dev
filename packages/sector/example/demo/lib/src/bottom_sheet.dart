import 'package:flutter/material.dart';
import 'package:sector/sector.dart';

/// A persistent bottom sheet that provides UI for algorithms and buttons.
final class PathfinderBottomSheet<T> extends StatefulWidget {
  /// Creates a bottom sheet.
  ///
  /// - [onClear] is called when the "Clear" button is pressed.
  /// - [onFindPath] is called when the "Find Path" button is pressed.
  ///
  /// The [algorithms] map is used to populate the dropdown menu with
  /// algorithms, which must not be empty. If not provided, a default set of
  /// algorithms is used instead.
  PathfinderBottomSheet({
    required this.onClear,
    required this.onFindPath,
    super.key,
    Map<String, PathfinderBase<T>>? algorithms,
  }) : algorithms = algorithms ?? _defaultAlgorithms() {
    if (this.algorithms.isEmpty) {
      throw ArgumentError.value(algorithms, 'algorithms', 'must not be empty');
    }
  }

  /// Called when the "Clear" button is pressed.
  final void Function() onClear;

  /// Called when the "Find Path" button is pressed.
  // This is just an example, it is OK to have a meh API.
  // ignore: unsafe_variance
  final void Function(PathfinderBase<T>, {bool trace})? onFindPath;

  /// Which algorithms to display in the dropdown.
  final Map<String, PathfinderBase<T>> algorithms;
  static Map<String, PathfinderBase<T>> _defaultAlgorithms<T>() {
    return {
      'A*': Astar(),
      'Fringe A*': FringeAstar(),
      'Greedy': GreedyBestFirstSearch(),
      'Dijkstra': Dijkstra(),
      'BFS': BreadthFirstSearch(),
      'DFS': DepthFirstSearch(),
    };
  }

  @override
  State<PathfinderBottomSheet<T>> createState() {
    return _BottomSheetState<T>();
  }
}

final class _BottomSheetState<T> extends State<PathfinderBottomSheet<T>> {
  late final Map<String, PathfinderBase<T>> algorithms;
  late String algorithm;

  @override
  void initState() {
    super.initState();
    algorithms = widget.algorithms;
    algorithm = algorithms.keys.first;
  }

  bool get canFind => widget.onFindPath != null;

  void _onFindPath() {
    widget.onFindPath!(algorithms[algorithm]!, trace: false);
  }

  void _onTracePath() {
    widget.onFindPath!(algorithms[algorithm]!, trace: true);
  }

  @override
  Widget build(BuildContext context) {
    // Lookup the background color of the current theme.
    final items = widget.algorithms.entries.map(
      (entry) => DropdownMenuItem(value: entry.key, child: Text(entry.key)),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: widget.onClear, child: const Text('Clear')),
          const SizedBox(width: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: canFind ? _onFindPath : null,
                child: const Text('Find Path'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: canFind ? _onTracePath : null,
                child: const Text('Trace Path'),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: algorithm,
                items: items.toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    algorithm = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
