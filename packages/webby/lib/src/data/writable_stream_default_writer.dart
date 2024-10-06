part of '../../webby.dart';

/// Locked writer for a [WritableStream].
extension type WritableStreamDefaultWriter._(JSObject _) implements JSObject {
  /// Promise that resolves when the stream is closed.
  external JSPromise get closed;

  /// Desired size of the writable stream's internal queue.
  external JSNumber get desiredSize;

  /// Promise that resolves when backpressure is no longer being applied.
  external JSPromise get ready;

  /// Aborts the stream.
  external JSPromise abort([JSAny reason]);

  /// Closes the stream.
  external JSPromise close();

  /// Releases the lock on the stream.
  external void releaseLock();

  /// Writes a chunk of binary data to the stream.
  external JSPromise write(JSAny chunk);
}
