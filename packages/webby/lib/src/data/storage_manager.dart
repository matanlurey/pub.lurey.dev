part of '../../webby.dart';

/// Interface for persistence permissions and estimating available storage.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/StorageManager>.
extension type StorageManager._(JSObject _) implements JSObject {
  /// Estimates the available storage for the current origin.
  external JSPromise<StorageManagerEstimate> estimate();

  /// Returns the root storage directory of the origin.
  external JSPromise<FileSystemDirectoryHandle> getDirectory();

  /// Requests permissions to use persistent storage.
  external JSPromise<JSBoolean> persist();

  /// Returns whether the origin has persistent storage.
  external JSPromise<JSBoolean> persisted();
}

/// Represents the estimated quota and usage for a storage type.
extension type StorageManagerEstimate._(JSObject _) implements JSObject {
  /// Estimated quota in bytes.
  external JSNumber get quota;

  /// Estimated usage in bytes.
  external JSNumber get usage;
}
