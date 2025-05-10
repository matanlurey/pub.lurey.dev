part of '../iterable.dart';

/// A read-only view of a list.
///
/// The underlying list may be mutable, but this class does not provide any
/// methods to modify the list.
abstract interface class ReadOnlyList<E> implements Iterable<E> {
  /// Returns a view of this list view as a list of [R] instances.
  ///
  /// If this view contains only instances of [R], all read operations will
  /// workj correctly. If any operartion tries to read an element that is not
  /// an instance of [R], the access will throw instead.
  @override
  ReadOnlyList<R> cast<R>();

  /// The object at the given [index] in the list.
  ///
  /// The [index] must be a valid index of this list, which means that [index]
  /// must be non-negative and less than [length].
  E operator [](int index);

  /// An [Iterable] of the objects in this list in reverse order.
  ///
  /// See [List.reversed].
  Iterable<E> get reversed;

  /// The first index of [element] in this list.
  ///
  /// See [List.indexOf].
  int indexOf(E element, [int start = 0]);

  /// The first index in the list that satisfies the provided [test].
  ///
  /// See [List.indexWhere].
  int indexWhere(bool Function(E element) test, [int start = 0]);

  /// The last index of [element] in this list.
  ///
  /// See [List.lastIndexOf].
  int lastIndexOf(E element, [int start = 0]);

  /// The last index in the list that satisfies the provided [test].
  ///
  /// See [List.lastIndexWhere].
  int lastIndexWhere(bool Function(E element) test, [int start = 0]);

  /// Returns a new list containing the elements between [start] and [end].
  ///
  /// See [List.sublist].
  List<E> sublist(int start, [int? end]);

  /// Creates an [Iterable] that iterates over a range of elements.
  ///
  /// See [List.getRange].
  Iterable<E> getRange(int start, int end);

  /// An unmodifiable [Map] view of this list.
  ///
  /// See [List.asMap].
  Map<int, E> asMap();

  /// An unmodifiable [List] view of this list.
  ///
  /// Adapts the [ReadOnlyList] to a [List] where all operations that modify the
  /// list throw an [UnsupportedError].
  List<E> asList();
}
