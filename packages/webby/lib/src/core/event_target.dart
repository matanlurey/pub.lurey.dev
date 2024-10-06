part of '../../webby.dart';

/// Implemented by objects that can receive events.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/EventTarget>.
extension type EventTarget._(JSObject _) implements JSObject {
  /// Creates a new event target.
  external factory EventTarget();

  /// Adds an event listener to the object.
  void addEventListener(
    JSString type,
    JSFunction listener, {
    bool capture = false,
    bool once = false,
    bool passive = false,
    AbortSignal? signal,
  }) {
    if (capture || once || passive || signal != null) {
      _addEventListener(
        type,
        listener,
        _EventListenerOptions(
          capture: capture.toJS,
          once: once.toJS,
          passive: passive.toJS,
          signal: signal,
        ),
      );
    } else {
      _addEventListener(type, listener);
    }
  }

  @JS('addEventListener')
  external void _addEventListener(
    JSString type,
    JSFunction listener, [
    _EventListenerOptions options,
  ]);

  /// Dispatches an event to this object.
  ///
  /// Returns `false` if the event was canceled.
  external JSBoolean dispatchEvent(JSObject event);

  /// Removes an event listener from the object.
  void removeEventListener(
    JSString type,
    JSFunction listener, {
    bool capture = false,
  }) {
    if (capture) {
      _removeEventListener(
        type,
        listener,
        _EventListenerOptions(capture: capture.toJS),
      );
    } else {
      _removeEventListener(type, listener);
    }
  }

  @JS('removeEventListener')
  external void _removeEventListener(
    JSString type,
    JSFunction listener, [
    _EventListenerOptions options,
  ]);

  /// Returns a stream that emits events of the given [type].
  ///
  /// This is a convenience method that creates a new [Stream] and listens to
  /// events using [addEventListener], then removes the listener when the stream
  /// is canceled.
  Stream<E> on<E extends Event>(
    String type, {
    bool capture = false,
    bool once = false,
    bool passive = false,
  }) {
    AbortController? abort;
    late final StreamController<E> controller;
    controller = StreamController<E>.broadcast(
      onListen: () {
        abort = AbortController();
        addEventListener(
          type.toJS,
          (Event event) {
            controller.add(event as E);
            if (once) {
              unawaited(controller.close());
            }
          }.toJS,
          capture: capture,
          once: once,
          passive: passive,
          signal: abort!.signal,
        );
      },
      onCancel: () {
        abort!.abort();
      },
      sync: true,
    );
    return controller.stream;
  }
}

extension type _EventListenerOptions._(JSObject _) implements JSObject {
  external factory _EventListenerOptions({
    JSBoolean? capture,
    JSBoolean? once,
    JSBoolean? passive,
    AbortSignal? signal,
  });
}
