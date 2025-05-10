import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

part 'value/_bool.dart';
part 'value/_bytes.dart';
part 'value/_double.dart';
part 'value/_int.dart';
part 'value/_list.dart';
part 'value/_map.dart';
part 'value/_none.dart';
part 'value/_record.dart';
part 'value/_string.dart';

/// An immutable wrapper representing all low-level wire-compatible types.
@immutable
sealed class Value {}

/// A value representing a single indivisible value rather than a nested value.
mixin ScalarValue<T> implements Value {
  /// The value of this scalar.
  T get value;

  @override
  @nonVirtual
  bool operator ==(Object other) {
    return other is ScalarValue && value == other.value;
  }

  @override
  @nonVirtual
  int get hashCode => value.hashCode;

  @override
  @mustBeOverridden
  String toString();
}
