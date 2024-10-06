part of '../../webby.dart';

/// Represents an event that takes place on an [EventTarget].
extension type Event._(JSObject _) implements JSObject {
  /// Creates a new event of the given [type].
  factory Event(
    String type, {
    bool bubbles = false,
    bool cancelable = false,
    bool composed = false,
  }) {
    if (bubbles || cancelable || composed) {
      return Event._native(
        type.toJS,
        _EventOptions(
          bubbles: bubbles.toJS,
          cancelable: cancelable.toJS,
          composed: composed.toJS,
        ),
      );
    }
    return Event._native(type.toJS);
  }

  external factory Event._native(JSString type, [_EventOptions options]);

  /// Whether the event bubbles up through the DOM or not.
  external JSBoolean get bubbles;

  /// Whether the event is cancelable or not.
  external JSBoolean get cancelable;

  /// Type of the event.
  external JSString get type;
}

extension type _EventOptions._(JSObject _) implements JSObject {
  external factory _EventOptions({
    JSBoolean bubbles,
    JSBoolean cancelable,
    JSBoolean composed,
  });
}
