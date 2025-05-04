part of '../descriptor.dart';

/// Describes a value that is a struct of indexed values.
final class IndexedDescriptor with _MatchesOptional implements Descriptor {
  /// Creates a [Descriptor] that is a struct of indexed values.
  IndexedDescriptor(
    List<Descriptor> values, //
  ) : values = List.unmodifiable(values);

  /// The value types this can be.
  ///
  /// This list is unmodifiable.
  final List<Descriptor> values;

  @override
  bool _matchesUnwrappedOptional(Value value) {
    if (value case ListValue(:final value) when value.length == values.length) {
      for (var i = 0; i < values.length; i++) {
        if (!values[i].matches(value[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (other is! IndexedDescriptor) {
      return false;
    }

    return values.orderedEquals(other.values);
  }

  @override
  int get hashCode {
    return Object.hashAll(values);
  }

  @override
  String toString() {
    return 'Descriptor.indexed($values)';
  }
}
