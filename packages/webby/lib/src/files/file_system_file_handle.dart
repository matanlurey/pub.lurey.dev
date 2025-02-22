part of '../../webby.dart';

/// Represents a handle to a file system entry.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileHandle>.
extension type FileSystemFileHandle._(JSObject _) implements FileSystemHandle {
  /// Whether the [createWritable] method is supported by the current browser.
  static bool get isCreateWritableSupported {
    return _prototype['createWritable'].isDefinedAndNotNull;
  }

  @JS('prototype')
  external static JSObject get _prototype;

  /// Returns a promise that reoslves with a [File] object.
  external JSPromise<File> getFile();

  /// Creates a writable file stream.
  JSPromise<FileSystemWritableFileStream> createWritable({
    bool keepExistingData = false,
  }) {
    if (keepExistingData) {
      return _createWritable(
        _CreateWritableOptions(keepExistingData: true.toJS),
      );
    }
    return _createWritable();
  }

  @JS('createWritable')
  external JSPromise<FileSystemWritableFileStream> _createWritable([
    _CreateWritableOptions options,
  ]);
}

extension type _CreateWritableOptions._(JSObject _) {
  external factory _CreateWritableOptions({JSBoolean? keepExistingData});
}
