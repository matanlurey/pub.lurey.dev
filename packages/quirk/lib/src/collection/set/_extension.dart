part of '../../collection.dart';

/// Extension methods for [Set].
extension SetExtension<E> on Set<E> {
  /// Returns `this` as an unmodifiable [Set].
  Set<E> asUnmodifiable() {
    return UnmodifiableSetView(this);
  }
}

/// Extension methods for [Set] or `null`.
extension NullableSetExtension<E> on Set<E>? {
  /// Returns an empty set if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  Set<E> get orEmpty => this ?? const {};
}
