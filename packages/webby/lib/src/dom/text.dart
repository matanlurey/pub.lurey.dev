part of '../../webby.dart';

/// Represents a DOM text node.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/Text>.
extension type Text._(JSObject _) implements CharacterData {
  /// Creates a new text node with the given [data].
  external factory Text([JSString data]);
}
