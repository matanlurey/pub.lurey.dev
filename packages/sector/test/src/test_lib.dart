import 'dart:async';

import 'package:checks/context.dart';
import 'package:test/test.dart';

import '../prelude.dart';

extension TestWalkableBase<T> on WalkableBase<T> {
  /// Returns any walkable as a weighted walkable.
  ///
  /// If `this` is already a weighted walkable, it throws an error.
  ///
  /// Otherwise, [weight] is a function that returns the weight of the edge
  /// connecting two nodes. If `null`, the weight is assumed to be `1.0`.
  WeightedWalkable<T> asWeightedForced([double Function(T, T)? weight]) {
    if (this is WeightedWalkable<T>) {
      throw StateError('This walkable is already weighted');
    }
    return asUnweighted().asWeighted(weight ?? (_, _) => 1.0);
  }
}

extension WalkableChecks<V> on Subject<Walkable<V>> {
  void isEmpty() {
    context.expect(() => ['is empty'], (actual) {
      if (actual.isEmpty) return null;
      return Rejection(which: ['is not empty']);
    });
  }

  void isNotEmpty() {
    context.expect(() => ['is not empty'], (actual) {
      if (actual.isNotEmpty) return null;
      return Rejection(which: ['is empty']);
    });
  }

  void containsEdge(Edge<V> edge) {
    context.expect(() => ['contains edge $edge'], (actual) {
      if (actual.containsEdge(edge)) return null;
      return Rejection(which: ['does not contain edge $edge']);
    });
  }

  void containsRoot(V node) {
    context.expect(() => ['contains root $node'], (actual) {
      if (actual.containsRoot(node)) return null;
      return Rejection(which: ['does not contain root $node']);
    });
  }
}

extension WeightedTraversalChecks<E> on Subject<WeightedWalkable<E>> {
  void isEmpty() {
    context.expect(() => ['is empty'], (actual) {
      if (actual.isEmpty) return null;
      return Rejection(which: ['is not empty']);
    });
  }

  void isNotEmpty() {
    context.expect(() => ['is not empty'], (actual) {
      if (actual.isNotEmpty) return null;
      return Rejection(which: ['is empty']);
    });
  }

  void containsEdge(Edge<E> edge) {
    context.expect(() => ['contains edge $edge'], (actual) {
      if (actual.containsEdge(edge)) return null;
      return Rejection(which: ['does not contain edge $edge']);
    });
  }

  void containsRoot(E node) {
    context.expect(() => ['contains root $node'], (actual) {
      if (actual.containsRoot(node)) return null;
      return Rejection(which: ['does not contain root $node']);
    });
  }
}

extension GridChecks<E> on Subject<Grid<E>> {
  void isEmpty() {
    context.expect(() => ['is empty'], (actual) {
      if (actual.isEmpty) return null;
      return Rejection(which: ['is not empty']);
    });
  }

  void isNotEmpty() {
    context.expect(() => ['is not empty'], (actual) {
      if (actual.isNotEmpty) return null;
      return Rejection(which: ['is empty']);
    });
  }

  Subject<int> get width {
    return has((p) => p.width, 'width');
  }

  Subject<int> get height {
    return has((p) => p.height, 'height');
  }

  Subject<Iterable<Iterable<E>>> get rows {
    return has((p) => p.rows, 'rows');
  }

  Subject<Iterable<Iterable<E>>> get columns {
    return has((p) => p.columns, 'columns');
  }
}

extension SplayTreeGridChecks<E> on Subject<SplayTreeGrid<E>> {
  Subject<Iterable<(Pos, E)>> get nonEmptyEntries {
    return has((p) => p.nonEmptyEntries, 'nonEmptyEntries');
  }
}

final class TestTracer<E> with Tracer<E> {
  TestTracer({this.expectRepeatedVisits = false}) {
    addTearDown(_printEventsOnFailure);
  }

  final _recorder = TraceRecorder<E>();
  final _visited = <E>{};
  var _didRepeat = false;

  /// Whether to expect [onVisit] to be called multiple times for the same node.
  ///
  /// If `false` (the default), [onVisit] is called at most once per node, or
  /// an assertion is raised, i.e. to avoid infinite loops or unexpected
  /// behavior for algorithms that rely on the assumption that nodes are visited
  /// at most once.
  final bool expectRepeatedVisits;

  /// Events recorded by the tracer.
  List<TraceEvent<E>> get events => _recorder.events;

  @override
  void clear() {
    _recorder.clear();
    _visited.clear();
  }

  @override
  void onSkip(E node) {
    _recorder.onSkip(node);
  }

  @override
  void onVisit(E node) {
    _recorder.onVisit(node);
    if (!_visited.add(node)) {
      if (!expectRepeatedVisits) {
        fail(
          'ERROR: Node $node was visited more than once.\n\n'
          'If you see this error, it most likely means that the algorithm in the '
          'stack trace is not working as intended or will loop infinitely.\n\n'
          'If your algorithm is intended to visit nodes more than once, set '
          '`allowRepeatedVisits` to `true` when creating the tracer.\n\n'
          'Visited nodes: ${[..._visited, node]}',
        );
      } else {
        _didRepeat = true;
      }
    }
  }

  @override
  void pushScalar(TraceKey key, double value) {
    _recorder.pushScalar(key, value);
  }

  void _printEventsOnFailure() {
    scheduleMicrotask(() {
      printOnFailure(
        'TEST FAILED. Printing trace events for debugging purposes:\n\n'
        '${_recorder.events.join('\n')}',
      );
    });
    if (!_didRepeat && expectRepeatedVisits) {
      fail(
        'ERROR: The test failed as the tracer was set to expect repeated visits.\n\n'
        'If you see this error, it most likely means that the algorithm in the '
        'stack trace is not working as intended or has changed its behavior.\n\n'
        'If your algorithm is intended to visit nodes at most once, set '
        '`allowRepeatedVisits` to `false` when creating the tracer.\n\n'
        'Visited nodes: $_visited',
      );
    }
  }
}

extension PathChecks<T> on Subject<Path<T>> {
  void notFound() {
    context.expect(() => const ['not found'], (actual) {
      if (!actual.isFound) {
        return null;
      }
      return Rejection(which: ['found nodes when none were expected']);
    });
  }

  void nodesEquals(Iterable<T> expected) {
    has((p) => p.nodes, 'nodes').deepEquals(expected);
  }

  void nodesBetween(T start, T end) {
    context.expect(() => ['nodes between $start and $end'], (actual) {
      if (actual.isNotFound) {
        return Rejection(which: ['not found']);
      }
      final reasons = <String>[];
      if (actual.nodes.first != start) {
        reasons.add('first node is not $start');
      }
      if (actual.nodes.last != end) {
        reasons.add('last node is not $end');
      }
      if (reasons.isNotEmpty) {
        return Rejection(which: reasons);
      }
      return null;
    });
  }
}

bool _inOrderEquals<T>(Iterable<T> a, Iterable<T> b) {
  final aIterator = a.iterator;
  final bIterator = b.iterator;
  while (aIterator.moveNext()) {
    if (!bIterator.moveNext() || aIterator.current != bIterator.current) {
      return false;
    }
  }
  return !bIterator.moveNext();
}

extension PathTupleChecks<T> on Subject<(Path<T>, double)> {
  void notFound() {
    context.expect(() => const ['not found with a cost of infinity'], (actual) {
      final reasons = <String>[];
      if (actual.$2 != double.infinity) {
        reasons.add('found a path with cost ${actual.$2}');
      }
      if (actual.$1.isFound) {
        reasons.add('found nodes when none were expected');
      }
      if (reasons.isEmpty) {
        return null;
      }
      return Rejection(which: reasons);
    });
  }

  void pathEquals(Iterable<T> expected, [double? cost]) {
    context.expect(() => ['path $expected with cost $cost'], (actual) {
      cost ??= expected.isEmpty
          ? double.infinity
          : (actual.$1.nodes.length - 1).toDouble();
      if (actual.$1.isFound &&
          _inOrderEquals(actual.$1.nodes, expected) &&
          actual.$2 == cost) {
        return null;
      }
      return Rejection(which: ['path $actual with cost ${actual.$2}']);
    });
  }
}
