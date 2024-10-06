part of '../../webby.dart';

/// Types of data that can be added to or read from a `DataTransfer` object.
extension type DataTransferItemKind._(JSString _) implements JSString {
  /// Represents a file.
  static final file = DataTransferItemKind._('file'.toJS);

  /// Represents a string.
  static final string = DataTransferItemKind._('string'.toJS);
}
