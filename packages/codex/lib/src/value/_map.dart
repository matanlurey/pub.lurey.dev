part of '../value.dart';

/// A map of string keys to values.
final class MapValue with _NestedValue {
  /// Wraps a map of string keys to values.
  const MapValue(this.value);

  /// The map of string keys to values.
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
  int get hashCode => Object.hashAll(value);
}
