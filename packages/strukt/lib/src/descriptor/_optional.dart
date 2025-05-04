part of '../descriptor.dart';

/// Describes a value that is optional.
final class OptionalDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is optional.
  const OptionalDescriptor(this.value);

  /// The value this can be if not `null`.
  final Descriptor value;

  @override
  bool matches(Value value) {
    if (value case NoneValue(:final value) when value == null) {
      return true;
    }
    return this.value.matches(value);
  }

  @override
  bool operator ==(Object other) {
    if (other is! OptionalDescriptor) {
      return false;
    }
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Descriptor.optional($value)';
  }
}
