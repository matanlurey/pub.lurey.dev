part of '../../webby.dart';

/// Represents a data transfer object used in drag-and-drop operations.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer>.
extension type DataTransfer._(JSObject _) implements JSObject {
  /// Create a new data transfer object.
  external factory DataTransfer();

  /// Files being dragged, if any.
  external FileList get files;

  /// Item list.
  external DataTransferItemList get items;
}
