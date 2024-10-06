part of '../../webby.dart';

/// Represents an HTML element.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement>.
extension type HTMLElement._(JSObject _) implements Element {
  /// Fires when the user modifies the element's value.
  Stream<Event> get onChange => on('change');
}
