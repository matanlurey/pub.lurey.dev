part of '../../webby.dart';

/// Represents a writable file stream.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FileSystemWritableFileStream>.
extension type FileSystemWritableFileStream._(JSObject _)
    implements WritableStream {
  /// Seeks to the given position.
  external JSPromise seek(JSNumber position);

  /// Resizes the file to the specified size on bytes.
  external JSPromise truncate(JSNumber size);

  /// Writes data to the file at the current position.
  external JSPromise write(BlobPart data);
}
