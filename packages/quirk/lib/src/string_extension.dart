/// Extensions for [String]s.
extension StringExtension on String {
  /// Returns this string with the first character capitalized.
  ///
  /// If this string is empty, it will be returned as-is.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print('hello'.capitalize()); // 'Hello'
  /// print(''.capitalize()); // ''
  /// ```
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  /// Splits this string assuming it is a `'camelCase'`.
  ///
  /// Each element in the returned iterable will be a word.
  ///
  /// If this string is empty, the returned iterable will be empty.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print('helloWorld'.splitCamelCase()); // ('hello', 'world')
  /// print(''.splitCamelCase()); // ()
  /// ```
  Iterable<String> splitCamelCase() {
    if (isEmpty) {
      return const Iterable.empty();
    }
    // TODO: Optimize by using an Iterator instead of a RegExp.
    return _camelCase.allMatches(this).map((match) => match.group(0)!);
  }

  // Matches a word in a camel case string.
  static final _camelCase = RegExp('[A-Z]?[a-z]+');
}
