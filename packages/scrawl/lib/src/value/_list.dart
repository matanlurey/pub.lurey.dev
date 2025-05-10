part of '../value.dart';

/// A sequence of elements of other values.
final class ListValue implements Value {
  /// Creates an array by copying an existing list of values.
  ListValue.from(
    Iterable<Value> values, //
  ) : value = List.unmodifiable(values);

  /// Sequence of values.
  ///
  /// This list is unmodifiable.
  final List<Value> value;
}
