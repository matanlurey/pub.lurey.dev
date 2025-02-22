import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  test('read text file', () async {
    final file = File(
      [BlobPart.fromString('Hello World'.toJS)].toJS,
      'file.txt'.toJS,
    );

    final reader = FileReader();
    scheduleMicrotask(() {
      reader.readAsText(file);
    });
    await reader.onLoad.first;

    final buffer = reader.resultAsString;
    check(buffer).equals('Hello World'.toJS);
  });

  test('read binary file as array buffer', () async {
    final file = File(
      [
        BlobPart.fromTypedArray(Uint8List.fromList([1, 2, 3]).toJS),
      ].toJS,
      'file.txt'.toJS,
    );

    final reader = FileReader();
    scheduleMicrotask(() {
      reader.readAsArrayBuffer(file);
    });
    await reader.onLoad.first;

    final buffer = reader.resultAsArrayBuffer!.toDart.asUint8List();
    check(buffer).deepEquals([1, 2, 3]);
  });

  test('read binary file as data URL', () async {
    final file = File(
      [
        BlobPart.fromTypedArray(Uint8List.fromList([1, 2, 3]).toJS),
      ].toJS,
      'file.txt'.toJS,
    );

    final reader = FileReader();
    scheduleMicrotask(() {
      reader.readAsDataURL(file);
    });
    await reader.onLoad.first;

    final buffer = reader.resultAsString!.toDart;
    check(buffer).startsWith('data:application/octet-stream;base64,');
    check(buffer).endsWith(base64.encode([1, 2, 3]));
  });
}
