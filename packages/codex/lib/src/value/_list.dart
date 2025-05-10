part of '../value.dart';

/// A sequence of elements of other values.
final class ListValue with _NestedValue {
  /// Wraps a list of values.
  const ListValue(this.value);

  /// Sequence of values.
  @override
  final List<Value> value;

  @override
  bool operator ==(Object other) {
    if (other is! ListValue) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return value.deepEquals(other.value);
  }

  @override
  int get hashCode => Object.hashAll(value);

  @override
  Object? toJson() {
    return [for (final v in value) v.toJson()];
  }
}
