part of '../../webby.dart';

/// Represents a DOM character data node.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/CharacterData>.
extension type CharacterData._(JSObject _) implements Node {
  /// The character data of the node.
  external JSString get data;

  /// Length of the character data.
  external JSNumber get length;
}
