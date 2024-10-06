part of '../../webby.dart';

/// Represents a data item that can be added to or read from a `DataTransfer` object.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItem>.
extension type DataTransferItem._(JSObject _) implements JSObject {
  /// Kind of drag data item, either `'file'` or `'string'`.
  external DataTransferItemKind get kind;

  /// The drag data item's type, typically a MIME type.
  external JSString get type;

  /// Retrieves the drag data item's data as a [File].
  ///
  /// Returns `null` if the item is not a file.
  external File? getAsFile();

  /// Invokes a callback with the drag data string data.
  ///
  /// If the item is not a string, the callback is not invoked.
  external void getAsString(JSFunction callback);
}
