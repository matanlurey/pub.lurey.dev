part of '../../webby.dart';

/// Provides a standard abstraction for writing streaming data to a destination.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/WritableStream>.
extension type WritableStream._(JSObject _) implements JSObject {
  /// Whether or not the stream is locked to a writer.
  external JSBoolean get locked;

  /// Aborts the stream.
  external JSPromise abort([JSAny reason]);

  /// Closes the stream.
  external JSPromise close();

  /// Returns and locks a writer that can be used to write to the stream.
  external WritableStreamDefaultWriter getWriter();
}
