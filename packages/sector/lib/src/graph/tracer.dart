part of '../graph.dart';

/// A utility for capturing events during a graph traversal or pathfinding.
///
/// {@category Graphs}
/// {@category Debugging}
abstract mixin class Tracer<E> {
  /// Clears all recorded events.
  ///
  /// Tracers that do not record events will do nothing.
  void clear();

  /// Called when a [node] is visited.
  void onVisit(E node);

  /// Called when a [node] is skipped.
  void onSkip(E node);

  /// Adds a scalar value to the trace.
  void pushScalar(TraceKey key, double value);

  /// Returns a [Tracer] that chains this [Tracer] with another [Tracer].
  ///
  /// The returned [Tracer] will call the [onVisit] and [onSkip] methods of
  /// this [Tracer] and the [other] [Tracer] in the order they are provided.
  Tracer<E> chain(Tracer<E> other) => _ChainedTracer(this, other);
}

/// A known key for a scalar value in a trace.
///
/// This type is used for known keys in a trace, and is used to push scalar
/// values, such as [heuristic] values, to a trace, or allow custom values
/// using the [TraceKey.custom] constructor.
///
/// {@category Graphs}
/// {@category Debugging}
extension type const TraceKey._(String _) {
  /// The key for a heuristic value.
  static TraceKey heuristic = TraceKey._('heuristic');

  /// The key for a custom value.
  const TraceKey.custom(String key) : this._(key);
}

/// A utility for recording events during a graph traversal or pathfinding.
///
/// A [TraceRecorder] records all events that occur during a traversal or
/// pathfinding operation, and can be used to validate or replay the events
/// that occurred during the operation; for example, to debug an algorithm
/// or visualize the traversal.
///
/// {@category Graphs}
/// {@category Debugging}
final class TraceRecorder<E> with Tracer<E> {
  final _events = <TraceEvent<E>>[];

  /// The events that have been recorded, in the order they were recorded.
  ///
  /// This list is unmodifiable.
  late final List<TraceEvent<E>> events = UnmodifiableListView(_events);

  @override
  void clear() {
    _events.clear();
  }

  @override
  void onVisit(E node) {
    _events.add(TraceEvent.onVisit(node));
  }

  @override
  void onSkip(E node) {
    _events.add(TraceEvent.onSkip(node));
  }

  @override
  void pushScalar(TraceKey key, double value) {
    _events.add(TraceEvent.pushScalar(key, value));
  }

  /// Replays the recorded events using the provided [tracer].
  ///
  /// Returns a lazy iterable that replays the recorded events using the
  /// provided [tracer]. The [tracer] will receive the same events in the
  /// same order they were recorded, one event at a time as the iterable is
  /// iterated.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final recorder = TraceRecorder<Pos>();
  ///
  /// // Record some events.
  /// recorder.onVisit(Pos(0, 0));
  /// recorder.onVisit(Pos(1, 0));
  ///
  /// // Replay the events.
  /// for (final _ in recorder.replay(Tracer<Pos>.noop())) {
  ///   // Do nothing.
  /// }
  /// ```
  @experimental
  Iterable<void> replayStepped(Tracer<E> tracer) sync* {
    for (final event in events) {
      switch (event) {
        case VisitEvent<E>(:final node):
          tracer.onVisit(node);
        case SkipEvent<E>(:final node):
          tracer.onSkip(node);
        case ScalarEvent<E>(:final key, :final value):
          tracer.pushScalar(key, value);
      }
      yield null;
    }
  }
}

final class _ChainedTracer<E> with Tracer<E> {
  const _ChainedTracer(this._previous, this._next);
  final Tracer<E> _previous;
  final Tracer<E> _next;

  @override
  void clear() {
    _previous.clear();
    _next.clear();
  }

  @override
  void onVisit(E node) {
    _previous.onVisit(node);
    _next.onVisit(node);
  }

  @override
  void onSkip(E node) {
    _previous.onSkip(node);
    _next.onSkip(node);
  }

  @override
  void pushScalar(TraceKey key, double value) {
    _previous.pushScalar(key, value);
    _next.pushScalar(key, value);
  }
}

/// An event captured by a [TraceRecorder].
///
/// {@category Graphs}
/// {@category Debugging}
@immutable
sealed class TraceEvent<E> {
  const TraceEvent();

  /// Creates a [TraceEvent] for [Tracer.onVisit].
  const factory TraceEvent.onVisit(E node) = VisitEvent<E>;

  /// Creates a [TraceEvent] for [Tracer.onSkip].
  const factory TraceEvent.onSkip(E node) = SkipEvent<E>;

  /// Creates a [TraceEvent] for [Tracer.pushScalar].
  const factory TraceEvent.pushScalar(
    TraceKey key,
    double value,
  ) = ScalarEvent<E>;
}

/// A captured [Tracer.onVisit] event.
///
/// {@category Graphs}
/// {@category Debugging}
final class VisitEvent<E> extends TraceEvent<E> {
  /// Creates a [VisitEvent] for [Tracer.onVisit].
  const VisitEvent(this.node);

  /// The visited node.
  final E node;

  @override
  bool operator ==(Object other) {
    return other is VisitEvent && node == other.node;
  }

  @override
  int get hashCode => Object.hash(VisitEvent, node);

  @override
  String toString() => 'TraceEvent.onVisit($node)';
}

/// A captured [Tracer.onSkip] event.
///
/// {@category Graphs}
/// {@category Debugging}
final class SkipEvent<E> extends TraceEvent<E> {
  /// Creates a [SkipEvent] for [Tracer.onSkip].
  const SkipEvent(this.node);

  /// The skipped node.
  final E node;

  @override
  bool operator ==(Object other) {
    return other is SkipEvent && node == other.node;
  }

  @override
  int get hashCode => Object.hash(SkipEvent, node);

  @override
  String toString() => 'TraceEvent.onSkip($node)';
}

/// A captured [Tracer.pushScalar] event.
///
/// {@category Graphs}
/// {@category Debugging}
final class ScalarEvent<E> extends TraceEvent<E> {
  /// Creates a [ScalarEvent] for [Tracer.pushScalar].
  const ScalarEvent(this.key, this.value);

  /// The key for the scalar value.
  final TraceKey key;

  /// The scalar value.
  final double value;

  @override
  bool operator ==(Object other) {
    return other is ScalarEvent && key == other.key && value == other.value;
  }

  @override
  int get hashCode => Object.hash(ScalarEvent, key, value);

  @override
  String toString() => 'TraceEvent.pushScalar($key, $value)';
}
