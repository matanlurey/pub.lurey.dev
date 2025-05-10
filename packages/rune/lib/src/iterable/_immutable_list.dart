part of '../iterable.dart';

/// An immutable list.
///
/// The list only allows read operations and is not modified after creation.
///
/// Unlike a standard [List], both [Object.==] and [Object.hashCode] are
/// overridden to provide value equality and a consistent hash code based on the
/// contents of the list.
@immutable
abstract final class ImmutableList<E> implements ReadOnlyList<E> {
  /// Creates an immutable list by copying [elements].
  factory ImmutableList.from(Iterable<E> elements) = _ImmutableList<E>.copyFrom;

  /// Creates an immutable list by wrapping an existing [list].
  ///
  /// ## Safety
  ///
  /// The list is **not** copied, so it is unsafe and may lead to undefined
  /// behavior if the list is modified after this call.
  factory ImmutableList.unsafeView(List<E> list) = _ExternalImmutableList<E>;

  @override
  ImmutableList<R> cast<R>();
}

base mixin _DelegatingImmutableList<E> implements ImmutableList<E> {
  List<E> get _delegate;

  @override
  ImmutableList<R> cast<R>() {
    return _ExternalImmutableList(_delegate.cast());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ImmutableList<E> ||
        other.length != length ||
        hashCode != other.hashCode) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (_delegate[i] != other[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  late final hashCode = Object.hashAll(_delegate);
}

final class _ImmutableList<E>
    with
        _DelegatingIterable<E>,
        _ReadOnlyListView<E>,
        _DelegatingImmutableList<E>
    implements ImmutableList<E> {
  _ImmutableList.copyFrom(Iterable<E> elements) : _delegate = [...elements];

  @override
  final List<E> _delegate;
}

final class _ExternalImmutableList<E>
    with
        _DelegatingIterable<E>,
        _ReadOnlyListView<E>,
        _DelegatingImmutableList<E>
    implements ImmutableList<E> {
  _ExternalImmutableList(this._delegate);

  @override
  final List<E> _delegate;
}
