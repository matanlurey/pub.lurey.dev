part of '../descriptor.dart';

/// Describes a value that is a map of string keys to values.
final class MapDescriptor with _MatchesOptional implements Descriptor {
  /// Creates a [Descriptor] that is a map of values.
  const MapDescriptor(this.value);

  /// The value type of the map.
  final Descriptor value;

  @override
  bool _matchesUnwrappedOptional(Value value) {
    if (value case MapValue(:final value)) {
      return value.values.every((v) => this.value.matches(v));
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (other is! MapDescriptor) {
      return false;
    }
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Descriptor.map($value)';
  }
}
