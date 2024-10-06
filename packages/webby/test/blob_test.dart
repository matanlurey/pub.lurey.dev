import 'dart:js_interop';
import 'dart:typed_data';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  test('Blob from ArrayBuffer', () async {
    final data = ByteData(32)..buffer.asUint8List().fillRange(0, 32, 1);
    final blob = Blob(
      [
        BlobPart.fromArrayBuffer(data.buffer.toJS),
      ].toJS,
    );

    check(blob)
      ..has((a) => a.size, 'size').equalsInt(32)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as an ArrayBuffer.
    final arrayBuffer = (await blob.arrayBuffer().toDart).toDart;

    check(arrayBuffer)
      ..has((a) => a.lengthInBytes, 'lengthInBytes').equals(32)
      ..has(
        (a) => a.asUint8List(),
        'asUint8List',
      ).deepEquals(data.buffer.asUint8List());
  });

  test('Blob from TypedArray', () async {
    final data = Uint8List(32)..fillRange(0, 32, 1);
    final blob = Blob(
      [
        BlobPart.fromTypedArray(data.toJS),
      ].toJS,
    );

    check(blob)
      ..has((a) => a.size, 'size').equalsInt(32)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as an ArrayBuffer.
    final arrayBuffer = (await blob.arrayBuffer().toDart).toDart;

    check(arrayBuffer)
      ..has((a) => a.lengthInBytes, 'lengthInBytes').equals(32)
      ..has(
        (a) => a.asUint8List(),
        'asUint8List',
      ).deepEquals(data);
  });

  test('Blob from DataView', () async {
    final data = ByteData(32)..buffer.asUint8List().fillRange(0, 32, 1);
    final view = data.buffer.asByteData();
    final blob = Blob(
      [
        BlobPart.fromDataView(view.toJS),
      ].toJS,
    );

    check(blob)
      ..has((a) => a.size, 'size').equalsInt(32)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as an ArrayBuffer.
    final arrayBuffer = (await blob.arrayBuffer().toDart).toDart;

    check(arrayBuffer)
      ..has((a) => a.lengthInBytes, 'lengthInBytes').equals(32)
      ..has(
        (a) => a.asUint8List(),
        'asUint8List',
      ).deepEquals(data.buffer.asUint8List());
  });

  test('Blob from Blob', () async {
    final data = ByteData(32)..buffer.asUint8List().fillRange(0, 32, 1);
    final blob = Blob(
      [
        BlobPart.fromArrayBuffer(data.buffer.toJS),
      ].toJS,
    );

    final copy = Blob(
      [
        BlobPart.fromBlob(blob),
      ].toJS,
    );

    check(copy)
      ..has((a) => a.size, 'size').equalsInt(32)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as an ArrayBuffer.
    final arrayBuffer = (await copy.arrayBuffer().toDart).toDart;

    check(arrayBuffer)
      ..has((a) => a.lengthInBytes, 'lengthInBytes').equals(32)
      ..has(
        (a) => a.asUint8List(),
        'asUint8List',
      ).deepEquals(data.buffer.asUint8List());
  });

  test('Blob from String', () async {
    final data = 'Hello, world!';
    final blob = Blob(
      [
        BlobPart.fromString(data.toJS),
      ].toJS,
    );

    check(blob)
      ..has((a) => a.size, 'size').equalsInt(13)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as text.
    final text = (await blob.text().toDart).toDart;

    check(text).equals(data);
  });

  test('type', () async {
    final blob = Blob(
      [
        BlobPart.fromString('Hello, world!'.toJS),
      ].toJS,
      type: 'text/plain',
    );

    check(blob)
      ..has((a) => a.size, 'size').equalsInt(13)
      ..has((a) => a.type, 'type').equals('text/plain');
  });

  test('slice contents', () async {
    final data = ByteData(32)..buffer.asUint8List().fillRange(0, 32, 1);
    final blob = Blob(
      [
        BlobPart.fromArrayBuffer(data.buffer.toJS),
      ].toJS,
    );

    final slice = blob.slice(8.toJS, 24.toJS);

    check(slice)
      ..has((a) => a.size, 'size').equalsInt(16)
      ..has((a) => a.type, 'type').isEmpty();

    // Try reading the contents as an ArrayBuffer.
    final arrayBuffer = (await slice.arrayBuffer().toDart).toDart;

    check(arrayBuffer)
      ..has((a) => a.lengthInBytes, 'lengthInBytes').equals(16)
      ..has(
        (a) => a.asUint8List(),
        'asUint8List',
      ).deepEquals(data.buffer.asUint8List().sublist(8, 24));
  });

  test('stream contents', () async {
    final data = ByteData(32)..buffer.asUint8List().fillRange(0, 32, 1);
    final blob = Blob(
      [
        BlobPart.fromArrayBuffer(data.buffer.toJS),
      ].toJS,
    );

    final stream = blob.stream();
    final reader = stream.getReader();
    await check(reader.toDart).withQueue.emits((e) {
      e.has((a) => a.toDart, '').deepEquals(data.buffer.asUint8List());
    });
  });
}
