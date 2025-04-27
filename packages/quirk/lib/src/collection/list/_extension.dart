part of '../../collection.dart';

/// Extension methods for [List] or `null`.
extension NullableListExtension<E> on List<E>? {
  /// Returns an empty list if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  List<E> get orEmpty => this ?? const [];
}
