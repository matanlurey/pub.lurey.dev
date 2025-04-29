part of '../value.dart';

bool _deepEqualsNullable(Value? a, Value? b) {
  if (a is OptionalValue) {
    a = a.value;
  }
  if (b is OptionalValue) {
    b = b.value;
  }
  if (a is BytesValue) {
    if (b is! BytesValue || a.value.length != b.value.length) {
      return false;
    }
    for (var i = 0; i < a.value.length; i++) {
      if (a.value[i] != b.value[i]) {
        return false;
      }
    }
    return true;
  }
  if (a is ListValue) {
    if (b is! ListValue || a.value.length != b.value.length) {
      return false;
    }
    for (var i = 0; i < a.value.length; i++) {
      if (!_deepEqualsNullable(a.value[i], b.value[i])) {
        return false;
      }
    }
    return true;
  }
  if (a is MapValue) {
    if (b is! MapValue || a.value.length != b.value.length) {
      return false;
    }
    for (final entry in a.value.entries) {
      if (!_deepEqualsNullable(entry.value, b.value[entry.key])) {
        return false;
      }
    }
    return true;
  }
  return a?.value == b?.value;
}

int _deepHashCode(Value value) {
  return switch (value) {
    // Primitive values
    BoolValue(:final Object value) ||
    DoubleValue(:final Object value) ||
    IntValue(:final Object value) ||
    StringValue(:final Object value) => value.hashCode,

    BytesValue(:final value) => Object.hashAll(value),
    ListValue(:final value) => Object.hashAll(value.map(_deepHashCode)),
    MapValue(:final value) => Object.hashAll(
      value.entries.expand((e) => [e.key, _deepHashCode(e.value)]),
    ),

    OptionalValue(:final value) => value == null ? 0 : _deepHashCode(value),
  };
}
