part of '../../webby.dart';

extension type _UnmodifiableList<E extends JSAny>._(JSObject _)
    implements JSObject {
  /// Number of elements in the list.
  external int get length;

  /// Returns the element at the given index in the list.
  external E item(int index);

  /// Converts this list to an unmodifiable [List] by wrapping it.
  List<E> get toDart => _UnmodifiableListWrapper<E>(this);
}

final class _UnmodifiableListWrapper<E extends JSAny> with ListMixin<E> {
  _UnmodifiableListWrapper(this._list);
  final _UnmodifiableList<E> _list;

  @override
  int get length => _list.length;

  @override
  set length(int newLength) {
    throw UnsupportedError('List is unmodifiable');
  }

  @override
  E elementAt(int index) => _list.item(index);

  @override
  E operator [](int index) => _list.item(index);

  @override
  void operator []=(int index, E value) {
    throw UnsupportedError('List is unmodifiable');
  }
}
