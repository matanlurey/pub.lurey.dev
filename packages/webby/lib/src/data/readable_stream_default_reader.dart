part of '../../webby.dart';

/// Represents a default reader that can read stream data.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader>.
extension type ReadableStreamDefaultReader._(JSObject _) implements JSObject {
  /// Returns a promise that fulfills when the stream closes or lock released.
  external JSPromise get closed;

  /// Returns a promise when the stream is cancelled.
  external JSPromise cancel();

  /// Returns a promise that resolves with the next chunk of data.
  external JSPromise<AsyncResult<JSUint8Array>> read();

  /// Releases the lock on the stream.
  external void releaseLock();

  /// Converts the stream as a Dart [Stream].
  Stream<JSUint8Array> get toDart async* {
    while (true) {
      final result = await read().toDart;
      if (result.done.toDart) {
        break;
      }
      yield result.value;
    }
  }
}
