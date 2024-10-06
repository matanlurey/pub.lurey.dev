part of '../../webby.dart';

/// Object which represents either a file or directory entry.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/File_System_API>.
extension type FileSystemHandle._(JSObject _) implements JSObject {
  /// Type of file system entry.
  external FileSystemHandleKind get kind;

  /// Name of the associated entry.
  ///
  /// Does not include the full path.
  external JSString get name;

  /// Returns whether `this` represents the same file or directory as [other].
  external JSPromise<JSBoolean> isSameEntry(FileSystemHandle other);
}
