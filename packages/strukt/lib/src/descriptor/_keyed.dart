part of '../descriptor.dart';

/// Describes a value that is a map of string keys to specific values.
final class KeyedDescriptor with _MatchesOptional implements Descriptor {
  /// Creates a [Descriptor] that is a map of values.
  KeyedDescriptor(
    Map<String, Descriptor> values, //
  ) : values = Map.unmodifiable(values);

  /// The value type of the map.
  ///
  /// This map is unmodifiable.
  final Map<String, Descriptor> values;

  @override
  bool _matchesUnwrappedOptional(Value value) {
    if (value case MapValue(:final value)) {
      return values.entries.every((e) {
        return e.value.matches(value[e.key] ?? const NoneValue());
      });
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (other is! KeyedDescriptor) {
      return false;
    }
    return values.unorderedEquals(other.values);
  }

  @override
  int get hashCode {
    return Object.hashAllUnordered(
      values.entries.expand((e) => [e.key, e.value]),
    );
  }

  @override
  String toString() {
    return 'Descriptor.keyed($values)';
  }
}
