/// Extensions for [Set]s.
extension SetExtension<T> on Set<T> {
  /// Returns whether `this` contains only the elements in [other].
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// `this` and [other] in order to early exit if [other] is longer than
  /// `this`; otherwise, it will iterate over [other] to check if every element
  /// is contained in `this`. Use [containsOnlyIndeterminate] if you cannot
  /// guarantee that [length] can be efficiently computed for both [other] and
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final set = {1, 2, 3};
  /// final other = {1, 2, 3};
  /// print(set.containsOnly(other)); // true
  /// ```
  bool containsOnly(Iterable<T> other) {
    if (length != other.length) {
      return false;
    }
    return containsOnlyIndeterminate(other);
  }

  /// Returns whether `this` contains only the elements in [other].
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every element is
  /// contained in `this`. Use [containsOnly] if you can guarantee that [length]
  /// can be efficiently computed for both `this` and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final set = {1, 2, 3};
  /// final other = {1, 2, 3};
  /// print(set.containsOnlyIndeterminate(other)); // true
  /// ```
  bool containsOnlyIndeterminate(Iterable<T> other) {
    if (identical(this, other)) {
      return true;
    }
    var length = 0;
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
      length++;
    }
    return length == this.length;
  }
}
