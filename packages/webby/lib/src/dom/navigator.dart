part of '../../webby.dart';

/// Represents the state and identity of the user agent.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/Navigator>.
extension type Navigator._(JSObject _) implements JSObject {
  /// Storage capabilities of the user agent.
  external StorageManager get storage;
}
