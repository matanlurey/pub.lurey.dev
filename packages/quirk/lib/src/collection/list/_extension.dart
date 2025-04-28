part of '../../collection.dart';

/// Extension methods for [List].
extension ListExtension<E> on List<E> {
  /// Returns `this` as an unmodifiable [List].
  List<E> asUnmodifiable() {
    return UnmodifiableListView(this);
  }
}

/// Extension methods for [List] or `null`.
extension NullableListExtension<E> on List<E>? {
  /// Returns an empty list if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  List<E> get orEmpty => this ?? const [];
}
