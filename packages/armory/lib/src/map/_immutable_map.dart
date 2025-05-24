part of '../map.dart';

/// An immutable map.
///
/// This map only allows read operations and is not modified after creation.
///
/// Unlike a standard [Map], both [Object.==] and [Object.hashCode] are
/// overridden to provide value equality and a consistent hash code based on the
/// contents of the map.
@immutable
abstract final class ImmutableMap<K, V> implements ReadOnlyMap<K, V> {
  /// Creates an immutable map by copying an existing [map].
  factory ImmutableMap(
    Map<K, V> map, //
  ) = _ImmutableMap<K, V>.copyFrom;

  /// Creates an immutable map by copying existing map entries.
  factory ImmutableMap.fromEntries(
    Iterable<MapEntry<K, V>> entries, //
  ) = _ImmutableMap<K, V>.fromEntries;

  /// Creates an immutable map by wrapping an existing [map].
  ///
  /// ## Safety
  ///
  /// The map is **not** copied, so it is unsafe and may lead to undefined
  /// behavior if the map is modified after this call.
  factory ImmutableMap.unsafe(
    Map<K, V> map, //
  ) = _ExternalImmutableMap<K, V>;

  @protected
  Map<K, V> get _delegate;

  @override
  ImmutableMap<RK, RV> cast<RK, RV>();
}

base mixin _DelegatingImmutableMap<K, V> implements ImmutableMap<K, V> {
  @override
  Map<K, V> get _delegate;

  @override
  ImmutableMap<RK, RV> cast<RK, RV>() {
    return _ExternalImmutableMap(_delegate.cast());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ImmutableMap<K, V> ||
        other.length != length ||
        hashCode != other.hashCode) {
      return false;
    }
    return _delegate._deepEqualsMap(other._delegate);
  }

  @override
  late final hashCode = Object.hashAll(
    _delegate.entries.map((e) => Object.hash(e.key, e.value)),
  );

  @override
  Type get runtimeType => ImmutableMap;
}

final class _ImmutableMap<K, V>
    with _DelegatingImmutableMap<K, V>, _ReadOnlyMap<K, V>
    implements ImmutableMap<K, V> {
  _ImmutableMap(this._delegate);

  @override
  final Map<K, V> _delegate;

  /// Creates an immutable map by copying an existing [map].
  factory _ImmutableMap.copyFrom(Map<K, V> map) {
    return _ImmutableMap(Map.unmodifiable(map));
  }

  /// Creates an immutable map by copying existing map entries.
  factory _ImmutableMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    return _ImmutableMap(Map.unmodifiable(Map.fromEntries(entries)));
  }
}

final class _ExternalImmutableMap<K, V>
    with _DelegatingImmutableMap<K, V>, _ReadOnlyMap<K, V>
    implements ImmutableMap<K, V> {
  _ExternalImmutableMap(this._delegate);

  @override
  final Map<K, V> _delegate;
}
