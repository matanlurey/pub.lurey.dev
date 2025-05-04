part of '../descriptor.dart';

/// Describes a value that can be one-of multiple values.
final class OneOfDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is one of multiple values.
  ///
  /// Must be non-empty.
  OneOfDescriptor(
    List<Descriptor> values, //
  ) : values = List.unmodifiable(values) {
    checkNotEmpty(values, 'values');
  }

  /// The value types this can be.
  ///
  /// This list is unmodifiable.
  final List<Descriptor> values;

  @override
  bool matches(Value value) {
    return values.any((v) => v.matches(value));
  }

  @override
  bool operator ==(Object other) {
    if (other is! OneOfDescriptor) {
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
    return 'Descriptor.oneOf($values)';
  }
}
