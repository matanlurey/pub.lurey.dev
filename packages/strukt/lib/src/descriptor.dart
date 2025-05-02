import 'package:meta/meta.dart';
import 'package:quirk/quirk.dart';

/// Describes the type a value can be in a struct.
///
/// This is used to describe the type of a value in a struct, and is used to
/// validate, encode, and decode values.
@immutable
sealed class Descriptor {
  /// A boolean value.
  static const Descriptor bool = _Descriptor.bool;

  /// A byte array.
  static const Descriptor bytes = _Descriptor.bytes;

  /// A double-precision floating-point number.
  static const Descriptor double = _Descriptor.double;

  /// An integer.
  static const Descriptor int = _Descriptor.int;

  /// A string value.
  static const Descriptor string = _Descriptor.string;

  /// Creates a [Descriptor] that is optional.
  const factory Descriptor.optional(
    Descriptor value, //
  ) = OptionalDescriptor;

  /// Creates a [Descriptor] that is a list of values.
  const factory Descriptor.list(
    Descriptor value, //
  ) = ListDescriptor;

  /// Creates a [Descriptor] that is a map of string keys to values.
  const factory Descriptor.map(
    Descriptor value, //
  ) = MapDescriptor;

  /// Creates a [Descriptor] that is a struct with specific keyed values.
  factory Descriptor.keyed(
    Map<String, Descriptor> value, //
  ) = KeyedDescriptor;

  /// Creates a [Descriptor] that is a struct of indexed values.
  factory Descriptor.indexed(
    List<Descriptor> values, //
  ) = IndexedDescriptor;

  /// Creates a [Descriptor] that is one of multiple values.
  factory Descriptor.oneOf(
    List<Descriptor> values, //
  ) = OneOfDescriptor;
}

enum _Descriptor implements Descriptor {
  bool,
  bytes,
  double,
  int,
  string;

  @override
  String toString() {
    return 'Descriptor.$name';
  }
}

/// Describes a value that is optional.
final class OptionalDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is optional.
  const OptionalDescriptor(this.value);

  /// The value this can be if not `null`.
  final Descriptor value;

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

/// Describes a value that is a list of values.
final class ListDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is a list of values.
  const ListDescriptor(this.value);

  /// The value this can be if not `null`.
  final Descriptor value;

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

/// Describes a value that is a map of string keys to values.
final class MapDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is a map of values.
  const MapDescriptor(this.value);

  /// The value type of the map.
  final Descriptor value;

  @override
  bool operator ==(Object other) {
    if (other is! MapDescriptor) {
      return false;
    }
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'Descriptor.map($value)';
  }
}

/// Describes a value that is a map of string keys to specific values.
final class KeyedDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is a map of values.
  KeyedDescriptor(
    Map<String, Descriptor> values, //
  ) : values = Map.unmodifiable(values);

  /// The value type of the map.
  ///
  /// This map is unmodifiable.
  final Map<String, Descriptor> values;

  @override
  bool operator ==(Object other) {
    if (other is! KeyedDescriptor || other.values.length != values.length) {
      return false;
    }

    // TODO: https://github.com/matanlurey/pub.lurey.dev/issues/28.
    for (final entry in values.entries) {
      if (other.values[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hashAll(values.entries.expand((e) => [e.key, e.value]));
  }

  @override
  String toString() {
    return 'Descriptor.keyed($values)';
  }
}

/// Describes a value that is a struct of indexed values.
final class IndexedDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is a struct of indexed values.
  IndexedDescriptor(
    List<Descriptor> values, //
  ) : values = List.unmodifiable(values);

  /// The value types this can be.
  ///
  /// This list is unmodifiable.
  final List<Descriptor> values;

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

/// Describes a value that can be one-of multiple values.
final class OneOfDescriptor implements Descriptor {
  /// Creates a [Descriptor] that is one of multiple values.
  ///
  /// Must be non-empty.
  OneOfDescriptor(
    List<Descriptor> values, //
  ) : values = List.unmodifiable(values) {
    // TODO: https://github.com/matanlurey/pub.lurey.dev/issues/29.
    if (values.isEmpty) {
      throw ArgumentError.value(values, 'values', 'Must be non-empty.');
    }
  }

  /// The value types this can be.
  ///
  /// This list is unmodifiable.
  final List<Descriptor> values;

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
