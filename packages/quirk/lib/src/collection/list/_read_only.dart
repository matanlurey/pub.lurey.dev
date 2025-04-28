part of '../../collection.dart';

/// A read-only view of a list.
///
/// This type exposes the read-only methods of [List] (and [Iterable]) but by
/// contract does not expose the mutating methods. For APIs that require the
/// full [List] API, see [asList].
abstract interface class ReadOnlyList<E> implements Iterable<E> {
  /// Creates a read-only view of a list.
  const factory ReadOnlyList.view(List<E> delegate) = _ReadOnlyList<E>;

  @override
  ReadOnlyList<R> cast<R>();

  /// The object at the given [index] in the list.
  ///
  /// See [List.operator []].
  E operator [](int index);

  /// An [Iterable] of the objects in this list in reverse order.
  ///
  /// See [List.reversed].
  Iterable<E> get reversed;

  /// The first index of [element] in this list.
  int indexOf(E element, [int start = 0]);

  /// The first index in the list that satisfies the provided [test].
  int indexWhere(bool Function(E element) test, [int start = 0]);

  /// The last index of [element] in this list.
  int lastIndexOf(E element, [int? start]);

  /// The last index in the list that satisfies the provided [test].
  int lastIndexWhere(bool Function(E element) test, [int? start]);

  /// Returns the concatenation of this list and [other].
  List<E> operator +(List<E> other);

  /// Returns a new list containing the elements between [start] and [end].
  List<E> sublist(int start, [int? end]);

  /// Creates an [Iterable] that iterates over a range of elements.
  Iterable<E> getRange(int start, int end);

  /// An unmodifiable [Map] view of this list.
  Map<int, E> asMap();

  /// Returns an unmodifiable [List] view of this list.
  List<E> asList();
}

final class _ReadOnlyList<E>
    with
        _DelegatingIterableMixin<E>, //
        _DelegatingListReadMixin<E>
    implements ReadOnlyList<E> {
  const _ReadOnlyList(this._delegate);

  @override
  final List<E> _delegate;

  @override
  ReadOnlyList<R> cast<R>() {
    return ReadOnlyList.view(_delegate.cast());
  }
}
