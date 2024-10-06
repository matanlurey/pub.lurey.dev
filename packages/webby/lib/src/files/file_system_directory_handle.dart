part of '../../webby.dart';

/// Represents a handle to a file system entry.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FileSystemDirectoryHandle>.
extension type FileSystemDirectoryHandle._(JSObject _)
    implements FileSystemHandle {
  /// Returns an asynchronous iterator for entries in the directory.
  external AsyncIterator<FileSystemHandle> entries();

  /// Returns a handle for a subdirectory within the current directory.
  JSPromise<FileSystemDirectoryHandle> getDirectoryHandle(
    String name, {
    bool create = false,
  }) {
    if (create) {
      return _getDirectoryHandle(
        name,
        _GetHandleOptions(create: true.toJS),
      );
    }
    return _getDirectoryHandle(name);
  }

  @JS('getDirectoryHandle')
  external JSPromise<FileSystemDirectoryHandle> _getDirectoryHandle(
    String name, [
    _GetHandleOptions options,
  ]);

  /// Returns a handle for a file within the current directory.
  JSPromise<FileSystemFileHandle> getFileHandle(
    String name, {
    bool create = false,
  }) {
    if (create) {
      return _getFileHandle(
        name,
        _GetHandleOptions(create: true.toJS),
      );
    }
    return _getFileHandle(name);
  }

  @JS('getFileHandle')
  external JSPromise<FileSystemFileHandle> _getFileHandle(
    String name, [
    _GetHandleOptions options,
  ]);

  /// Returns an asynchronous iterator for keys in the directory.
  external AsyncIterator<JSString> keys();

  /// Attempts to remove an entry if the directory handle contains [name].
  ///
  /// If [recursive] is `true`, the operation will be recursive.
  JSPromise removeEntry(String name, {bool recursive = false}) {
    if (recursive) {
      return _removeEntry(
        name,
        _RemoveEntryOptions(recursive: true.toJS),
      );
    }
    return _removeEntry(name);
  }

  @JS('removeEntry')
  external JSPromise _removeEntry(String name, [_RemoveEntryOptions options]);

  /// Returns an array of directory names that leads to the provided directory.
  ///
  /// Returns `null` if the provided directory is not a descendant of `this`.
  external JSPromise<JSArray<JSString>?> resolve(
    FileSystemDirectoryHandle possibleDescendant,
  );

  /// Returns an asynchronous iterator for values in the directory.
  external AsyncIterator<FileSystemHandle> values();
}

extension type _GetHandleOptions._(JSObject _) implements JSObject {
  external factory _GetHandleOptions({JSBoolean create});
}

extension type _RemoveEntryOptions._(JSObject _) implements JSObject {
  external factory _RemoveEntryOptions({JSBoolean recursive});
}
