part of '../../webby.dart';

/// Represents a readable stream of byte data.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream>.
extension type ReadableStream._(JSObject _) implements JSObject {
  /// Whether the stream is locked.
  external JSBoolean get locked;

  /// Returns a promise that resolves when the stream is cancelled.
  external JSPromise cancel([JSAny reason]);

  /// Creates a reader and locks the stream to it.
  external ReadableStreamDefaultReader getReader();
}
