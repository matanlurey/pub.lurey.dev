import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
// TODO: Use docImport instead when available.
import 'package:collection/collection.dart' show PriorityQueue;
import 'package:meta/meta.dart';

/// Obscures information from the compiler on how the object is used.
void _blackBox(Object? any) => Zone.current.runUnary((_) {}, any);

/// Base class for [PriorityQueue] benchmarks.
abstract base class QueueSuite<C> {
  const QueueSuite(this.name);

  /// Name of the benchmark suite.
  final String name;

  /// Runs the benchmark suite.
  @nonVirtual
  void run() {
    _EmptyPriorityQueueBenchmark(name, this).report();
    _Add1kEntriesBenchmark(name, this).report();
    _Pop1kEntriesBenchmark(name, this).report();
  }

  /// Should return a new empty queue of type [C].
  @protected
  C newEmptyQueue();

  /// Adds an element to the queue.
  @protected
  void add(C queue, int element, double priority);

  /// Removes and returns the element with the highest priority.
  @protected
  int pop(C queue);

  /// Returns the length of the queue.
  @protected
  int length(C queue);
}

final class _EmptyPriorityQueueBenchmark<C> extends BenchmarkBase {
  final QueueSuite<C> _suite;
  _EmptyPriorityQueueBenchmark(
    String name,
    this._suite,
  ) : super('$name:EmptyPriorityQueue');

  @override
  void run() {
    _blackBox(_suite.newEmptyQueue());
  }
}

final class _Add1kEntriesBenchmark<C> extends BenchmarkBase {
  final QueueSuite<C> _suite;
  _Add1kEntriesBenchmark(
    String name,
    this._suite,
  ) : super('$name:Add1kEntries');

  static final Uint32List _entries = (() {
    final entries = Uint32List(1000);
    for (var i = 0; i < 1000; i++) {
      entries[i] = i;
    }
    entries.shuffle(Random(0));
    return entries;
  })();

  @override
  void setup() {
    _blackBox(_entries);
  }

  @override
  void run() {
    final queue = _suite.newEmptyQueue();
    for (final entry in _entries) {
      _suite.add(queue, entry, entry.toDouble());
    }
    _blackBox(queue);
  }
}

final class _Pop1kEntriesBenchmark<C> extends BenchmarkBase {
  final QueueSuite<C> _suite;
  _Pop1kEntriesBenchmark(
    String name,
    this._suite,
  ) : super('$name:Pop1kEntries');

  static final Uint32List _entries = (() {
    final entries = Uint32List(1000);
    for (var i = 0; i < 1000; i++) {
      entries[i] = i;
    }
    entries.shuffle(Random(0));
    return entries;
  })();

  late C _queue;
  C _createQueue() {
    final queue = _suite.newEmptyQueue();
    for (final entry in _entries) {
      _suite.add(queue, entry, entry.toDouble());
    }
    return queue;
  }

  @override
  void setup() {
    _blackBox(_entries);
  }

  @override
  void run() {
    exercise();
  }

  @override
  void exercise() {
    final queue = _queue;
    for (var i = 0; i < 1000; i++) {
      _suite.pop(queue);
    }
    _blackBox(queue);
  }

  @override
  double measure() {
    // Because of the way warmups work, we need to create a new queue for each
    // iteration, but we don't want to count the time it takes to create the
    // queue in the benchmark. So we create the queue every run and exclude it
    // from the measurement.
    setup();

    // Warmup for at least 100ms. Discard result.
    _measureMicros(warmup, const Duration(milliseconds: 100));

    // Run the benchmark for at least 2000ms.
    final result = _measureMicros(exercise, const Duration(seconds: 2));
    return result;
  }

  double _measureMicros(void Function() fn, Duration minimum) {
    var iterations = 0;
    final elapsed = Stopwatch();
    while (elapsed.elapsed < minimum) {
      _queue = _createQueue();
      elapsed.start();
      fn();
      elapsed.stop();
      iterations++;
    }
    return elapsed.elapsedMicroseconds / iterations;
  }
}
