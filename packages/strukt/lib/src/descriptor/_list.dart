part of '../descriptor.dart';

/// Describes a value that is a list of values.
final class ListDescriptor with _MatchesOptional implements Descriptor {
  /// Creates a [Descriptor] that is a list of values.
  const ListDescriptor(this.value);

  /// The value this can be if not `null`.
  final Descriptor value;

  @override
  bool _matchesUnwrappedOptional(Value value) {
    if (value case ListValue(:final value)) {
      return value.every((v) => this.value.matches(v));
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    if (other is! ListDescriptor) {
      return false;
    }
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Descriptor.list($value)';
  }
}
