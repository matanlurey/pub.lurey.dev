part of '../value.dart';

/// A wrapper for a list of [Value]s.
final class ListValue implements Value {
  /// Wraps a list of [Value]s.
  const ListValue(this.value);

  @override
  final List<Value> value;

  @override
  ListValue clone() => ListValue([for (final v in value) v.clone()]);

  @override
  ValueKind get kind => ValueKind.list;

  @override
  String toString() {
    return '$value';
  }
}
