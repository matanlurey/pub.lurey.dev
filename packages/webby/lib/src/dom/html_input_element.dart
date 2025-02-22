part of '../../webby.dart';

/// Represents an input element.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement>.
extension type HTMLInputElement._(JSObject _) implements HTMLElement {
  /// Creates a new input element.
  factory HTMLInputElement({String? type, bool? multiple}) {
    final el = window.document.createElement('input'.toJS) as HTMLInputElement;
    if (type != null) {
      el.type = type.toJS;
    }
    if (multiple != null) {
      el.multiple = multiple.toJS;
    }
    return el;
  }

  /// Files selected by the user.
  external FileList get files;

  /// Type of the input element.
  external JSString type;

  /// Whether multiple values (or files) can be selected.
  external JSBoolean multiple;

  /// Displays the browser picker for `this` input element.
  external void showPicker();
}
