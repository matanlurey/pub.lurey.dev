part of '../../webby.dart';

/// Immutable, raw data; they can be read as text or binary data.
extension type Blob._(JSObject _) implements JSObject {
  /// Creates a blob with the specified content.
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
  /// the blob.
  ///
  /// If [native] is `true`, the line endings will be normalized to the host
  /// system's line endings.
  ///
  /// ---
  ///
  /// See <https://developer.mozilla.org/en-US/docs/Web/API/Blob/Blob>.
  factory Blob(
    JSArray<BlobPart> parts, {
    String type = '',
    bool native = false,
  }) {
    if (type.isNotEmpty || native) {
      return Blob._from(
        parts,
        _BlobOptions(
          type: type.toJS,
          endings: native ? 'native'.toJS : 'transparent'.toJS,
        ),
      );
    }
    return Blob._from(parts);
  }

  @JS('')
  external factory Blob._from(JSArray<BlobPart> parts, [_BlobOptions options]);

  /// Size of the blob in bytes.
  external JSNumber get size;

  /// MIME type of the blob, or an empty string if the type is unknown.
  external JSString get type;

  /// Returns a promise that resolves with the contents as an [JSArrayBuffer].
  external JSPromise<JSArrayBuffer> arrayBuffer();

  /// Returns a promise that resolves with the contents as a [JSUint8Array].
  external JSPromise<JSUint8Array> bytes();

  /// Returns a new blob object containing data from a subset of the blob.
  external Blob slice([JSNumber? start, JSNumber? end, JSString? contentType]);

  /// Returns a stream of the blob's data.
  external ReadableStream stream();

  /// Returns a promise that resolves with the contents as UTF-8 text.
  external JSPromise<JSString> text();
}

extension type _BlobOptions._(JSObject _) implements JSObject {
  external factory _BlobOptions({
    JSString? type,
    JSString? endings,
  });
}

/// Value representing a part of a call into [Blob.new].
extension type BlobPart._(JSAny _) implements JSAny {
  /// A [JSArrayBuffer] value.
  factory BlobPart.fromArrayBuffer(JSArrayBuffer value) = BlobPart._;

  /// A [JSTypedArray] value.
  factory BlobPart.fromTypedArray(JSTypedArray value) = BlobPart._;

  /// A [JSDataView] value.
  factory BlobPart.fromDataView(JSDataView value) = BlobPart._;

  /// A [Blob] value.
  factory BlobPart.fromBlob(Blob value) = BlobPart._;

  /// A [JSString] value.
  factory BlobPart.fromString(JSString value) = BlobPart._;
}
