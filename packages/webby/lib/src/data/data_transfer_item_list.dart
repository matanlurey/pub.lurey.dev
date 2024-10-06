part of '../../webby.dart';

/// Represents items being dragged.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/DataTransferItemList>.
extension type DataTransferItemList._(JSObject _) implements JSObject {
  /// The number of items in the list.
  external JSNumber get length;

  /// Adds a file to the list.
  DataTransferItem addFile(File file) => _add(file);

  /// Adds a string to the list, with an optional type.
  DataTransferItem addString(JSString data, [String? type]) {
    if (type != null) {
      return _add(data, type.toJS);
    }
    return _add(data);
  }

  @JS('add')
  external DataTransferItem _add([JSAny dataOrFile, JSString type]);

  /// Clears the list.
  external void clear();

  /// Removes an item from the list at the given index.
  external void remove(JSNumber index);
}
