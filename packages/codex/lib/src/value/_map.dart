part of '../value.dart';

/// A map of string keys to values.
final class MapValue with _NestedValue {
  /// Wraps a map of string keys to values.
  const MapValue(this.value);

  /// The map of string keys to values.
  @override
  final Map<String, Value> value;

  @override
  bool operator ==(Object other) {
    if (other is! MapValue) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return value.deepEquals(other.value);
  }

  @override
  int get hashCode {
    return Object.hashAll(
      value.entries.map((e) => Object.hash(e.key, e.value)),
    );
  }

  @override
  Object? toJson() {
    return {for (final entry in value.entries) entry.key: entry.value.toJson()};
  }
}
