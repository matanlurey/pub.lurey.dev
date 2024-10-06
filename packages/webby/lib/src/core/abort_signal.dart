part of '../../webby.dart';

/// represents a signal object that allows you to abort an operation.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal>.
extension type AbortSignal._(JSObject _) implements EventTarget {
  /// Whether the signal is aborted or not.
  external JSBoolean get aborted;

  /// Reason why the signal was aborted.
  external JSAny get reason;

  /// Returns an [AbortSignal] that is already set as aborted.
  external static AbortSignal abort([JSAny reason]);

  /// Fires when the signal is aborted.
  Stream<Event> get onAbort => on('abort');
}
