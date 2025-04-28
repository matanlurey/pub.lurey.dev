part of '../value.dart';

/// A wrapper for a map of string keys to [Value]s.
final class MapValue implements Value {
  /// Wraps a map of string keys to [Value]s.
  const MapValue(this.value);

  @override
  final Map<String, Value> value;

  @override
  MapValue clone() => MapValue({
    for (final entry in value.entries) entry.key: entry.value.clone(),
  });

  @override
  ValueKind get kind => ValueKind.map;
}
