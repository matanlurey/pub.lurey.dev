/// A wrapper around [Iterable] that prevents the use of [length].
final class IndeterminateIterable<T> extends Iterable<T> {
  /// Creates an instance of [IndeterminateIterable].
  const IndeterminateIterable(this._iterable);

  /// The wrapped iterable.
  final Iterable<T> _iterable;

  @override
  Iterator<T> get iterator => _iterable.iterator;

  @override
  int get length {
    throw StateError('Length should not be accessed on this iterable.');
  }
}
