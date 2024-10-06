part of '../../webby.dart';

/// Returns a promise fulfilling to an iterator result object.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncIterator>.
extension type AsyncIterator<T extends JSAny>._(JSObject _)
    implements JSObject {
  /// Returns a promise fulfilling to an iterator result object.
  external JSPromise<AsyncResult<T>> next();

  /// Converts the iterator into a dart [Stream].
  Stream<T> get toDart async* {
    var result = await next().toDart;
    while (!result.done.toDart) {
      yield result.value;
      result = await next().toDart;
    }
  }
}

/// Represents the result of [AsyncIterator.next].
extension type AsyncResult<T extends JSAny>._(JSObject _) implements JSObject {
  /// Whether the iterator is done.
  ///
  /// If `true`, [value] must not be accessed.
  external JSBoolean get done;

  /// Value returned by the iterator.
  external T get value;
}
