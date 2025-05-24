part of '../iterable.dart';

/// An immutable set.
///
/// The set only allows read operations and is not modified after creation.
///
/// Unlike a standard [Set], both [Object.==] and [Object.hashCode] are
/// overridden to provide value equality and a consistent hash code based on the
/// contents of the set.
@immutable
abstract final class ImmutableSet<E> implements ReadOnlySet<E> {
  /// Creates an immutable set by copying [elements].
  factory ImmutableSet(Iterable<E> elements) = _ImmutableSet<E>.copyFrom;

  /// Creates an immutable set by wrapping an existing [set].
  ///
  /// ## Safety
  ///
  /// The set is **not** copied, so it is unsafe and may lead to undefined
  /// behavior if the set is modified after this call.
  factory ImmutableSet.unsafe(Set<E> set) = _ExternalImmutableSet<E>;

  @protected
  Set<E> get _delegate;

  @override
  ImmutableSet<R> cast<R>();
}

base mixin _DelegatingImmutableSet<E> implements ImmutableSet<E> {
  @override
  Set<E> get _delegate;

  @override
  ImmutableSet<R> cast<R>() {
    return _ExternalImmutableSet(_delegate.cast());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ImmutableSet<E> ||
        other.length != length ||
        hashCode != other.hashCode) {
      return false;
    }
    return _delegate._deepEqualsSet(other._delegate);
  }

  @override
  late final hashCode = Object.hashAll(_delegate);

  @override
  Type get runtimeType => ImmutableSet;
}

final class _ImmutableSet<E>
    with _DelegatingIterable<E>, _ReadOnlySet<E>, _DelegatingImmutableSet<E>
    implements ImmutableSet<E> {
  _ImmutableSet(this._delegate);

  @override
  final Set<E> _delegate;

  /// Creates an immutable set by copying [elements].
  factory _ImmutableSet.copyFrom(Iterable<E> elements) {
    return _ImmutableSet(elements.toSet());
  }
}

final class _ExternalImmutableSet<E>
    with _DelegatingIterable<E>, _ReadOnlySet<E>, _DelegatingImmutableSet<E>
    implements ImmutableSet<E> {
  _ExternalImmutableSet(this._delegate);

  @override
  final Set<E> _delegate;
}
