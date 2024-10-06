part of '../../webby.dart';

/// Type of file system entry.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/FileSystemHandle/kind>.
extension type FileSystemHandleKind._(JSString _) implements JSString {
  /// File.
  static final file = FileSystemHandleKind._('file'.toJS);

  /// Directory.
  static final directory = FileSystemHandleKind._('directory'.toJS);
}
