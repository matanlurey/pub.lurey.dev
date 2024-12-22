part of '../graph.dart';

/// Indicates a cycle was detected in a graph expected to be acyclic.
///
/// {@category Graphs}
final class CycleException<T> implements Exception {
  /// Creates a new cycle exception with a single vertex involved in the cycle.
  CycleException(this.involved);

  /// An arbitrary vertex involved in the cycle.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final Graph<int> graph = ...;
  /// try {
  ///   // ... something that throws a CycleException ...
  /// } on CycleException<int> catch (e) {
  ///   final loop = graph.findCycle(e.involved);
  ///
  ///   // rethrow, or log, or handle the loop in some way.
  /// }
  /// ```
  final T involved;

  @override
  String toString() => 'Cycle detected at node $involved.';
}
