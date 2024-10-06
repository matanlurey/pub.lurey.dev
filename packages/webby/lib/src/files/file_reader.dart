part of '../../webby.dart';

extension type _FileReaderBase._(JSObject _) implements EventTarget {
  /// Last error that occurred while reading the file.
  external JSObject? get error;

  /// Provides the current state of a reading operation.
  external FileReaderReadyState get readyState;

  /// The contents of the file, assuming the result is a [JSArrayBuffer].
  JSArrayBuffer? get resultAsArrayBuffer {
    final result = _result;
    if (result.isUndefinedOrNull) {
      return null;
    }
    if (result.isA<JSArrayBuffer>()) {
      return result as JSArrayBuffer;
    }
    throw StateError('The result is not a JSArrayBuffer.');
  }

  /// The contents of the file, assuming the result is a string.
  JSString? get resultAsString {
    final result = _result;
    if (result.isUndefinedOrNull) {
      return null;
    }
    if (result.isA<JSString>()) {
      return result as JSString;
    }
    throw StateError('The result is not a String.');
  }

  @JS('result')
  external JSAny get _result;

  /// Aborts the read operation.
  external void abort();

  /// Reads the contents of the specified [blob] as an array buffer.
  external void readAsArrayBuffer(Blob blob);

  /// Reads the contents of the specified [blob] as a data URL.
  external void readAsDataURL(Blob blob);

  /// Reads the contents of the specified [blob] as text.
  external void readAsText(Blob blob, [JSString? encoding]);

  /// Fired when a read operation has been aborted.
  Stream<ProgressEvent> get onAbort => on('abort');

  /// Fired when a read failed due to an error.
  Stream<ProgressEvent> get onError => on('error');

  /// Fired when a file has been read successfully.
  Stream<ProgressEvent> get onLoad => on('load');

  /// Fired when the read operation is completed (either in success or failure).
  Stream<ProgressEvent> get onLoadEnd => on('loadend');

  /// Fired when the read operation has begun.
  Stream<ProgressEvent> get onLoadStart => on('loadstart');

  /// Fired periodically as the [FileReader] reads data.
  Stream<ProgressEvent> get onProgress => on('progress');
}

/// Asynchronously reads the contents of files or raw data buffers.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FileReader>.
extension type FileReader._(JSObject _) implements _FileReaderBase {
  /// Creates a new file reader.
  external factory FileReader();
}
