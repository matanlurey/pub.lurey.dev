part of '../../webby.dart';

/// Provides information about files and allows access to their content.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/File>.
extension type File._(JSObject _) implements Blob {
  /// Creates a new [File] object.
  ///
  /// Elements of the provided array can be of type:
  /// - [JSArrayBuffer]
  /// - [JSTypedArray]
  /// - [JSDataView]
  /// - [Blob]
  /// - [JSString]
  ///
  /// ... or a mix of any of the above.
  ///
  /// If [type] is provided, it will be the MIME type of the data contained in
  /// the file.
  ///
  /// If [endings] is provided, it will be the line endings for the file.
  ///
  /// If [lastModified] is provided, it will be the last modified time of the
  /// file as a Unix time epoch; if not provided, it will be the current time.
  factory File(
    JSArray<BlobPart> fileBits,
    JSString fileName, {
    JSString? type,
    JSString? endings,
    JSNumber? lastModified,
  }) {
    if (type != null || endings != null || lastModified != null) {
      return File._native(
        fileBits,
        fileName,
        _FileOptions(type: type, endings: endings, lastModified: lastModified),
      );
    }
    return File._native(fileBits, fileName);
  }

  @JS('')
  external factory File._native(
    JSArray<BlobPart> fileBits,
    JSString fileName, [
    _FileOptions options,
  ]);

  /// Last modified time of the file as a Unix time epoch in milliseconds.
  external JSNumber get lastModified;

  /// Name of the file.
  ///
  /// Does not include the full path.
  external JSString get name;
}

extension type _FileOptions._(JSObject _) implements JSObject {
  external factory _FileOptions({
    JSString? type,
    JSString? endings,
    JSNumber? lastModified,
  });
}
