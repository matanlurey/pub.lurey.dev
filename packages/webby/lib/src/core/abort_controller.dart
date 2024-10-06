part of '../../webby.dart';

/// Represents a controller object that allows you to abort requests.
extension type AbortController._(JSObject _) implements JSObject {
  /// Creates a new [AbortController].
  external factory AbortController();

  /// The signal that can be used to abort requests.
  external AbortSignal get signal;

  /// Aborts the controller.
  external void abort([JSAny reason]);
}
