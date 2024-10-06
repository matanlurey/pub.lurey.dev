part of '../../webby.dart';

/// Represents an HTML document.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/Document>.
extension type Document._(JSObject _) implements JSObject {
  /// Creates a new document.
  external factory Document();

  /// Creates a new element with the given tag name.
  external Element createElement(JSString tagName);

  /// Creates a new text node with the given text.
  external Text createTextNode(JSString text);

  /// Returns the first element that matches the given CSS selector.
  external Element? querySelector(JSString selector);

  /// Returns a static list of elements that match the given CSS selector.
  external NodeList querySelectorAll(JSString selector);
}
