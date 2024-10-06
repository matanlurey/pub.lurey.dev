part of '../../webby.dart';

/// Current state of an operation.
extension type FileReaderReadyState._(JSString _) implements JSString {
  /// The operation has not yet started.
  static final empty = FileReaderReadyState._('EMPTY'.toJS);

  /// The operation is currently loading.
  static final loading = FileReaderReadyState._('LOADING'.toJS);

  /// The operation has been completed.
  static final done = FileReaderReadyState._('DONE'.toJS);
}
