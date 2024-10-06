part of '../../webby.dart';

/// Represents the window object the script is running in.
extension type Window._(JSObject _) implements JSObject {
  /// Document object associated with the window.
  external Document get document;

  /// State and identity of the user agent.
  external Navigator get navigator;
}
