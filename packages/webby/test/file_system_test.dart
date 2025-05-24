import 'dart:async';
import 'dart:js_interop';
import 'dart:math';
import 'dart:typed_data';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  late FileSystemDirectoryHandle parent;
  late FileSystemDirectoryHandle tmpDir;

  setUp(() async {
    parent = await window.navigator.storage.getDirectory().toDart;
    final random = Random().nextInt(1 << 32 - 1).toRadixString(16);
    tmpDir = await parent
        .getDirectoryHandle('webby_test_$random', create: true)
        .toDart;
  });

  tearDown(() async {
    await parent.removeEntry(tmpDir.name.toDart, recursive: true).toDart;
  });

  test('read and write text file', () async {
    final handle = await tmpDir.getFileHandle('file.txt', create: true).toDart;
    final writer = await handle.createWritable().toDart;
    await writer.write(BlobPart.fromString('Hello World'.toJS)).toDart;
    await writer.close().toDart;

    final file = await handle.getFile().toDart;
    final reader = FileReader();
    scheduleMicrotask(() {
      reader.readAsText(file);
    });
    await reader.onLoad.first;

    final buffer = reader.resultAsString;
    check(buffer).equals('Hello World'.toJS);
  });

  test('read and write binary file', () async {
    final handle = await tmpDir.getFileHandle('file.bin', create: true).toDart;
    final writer = await handle.createWritable().toDart;
    await writer
        .write(BlobPart.fromTypedArray(Uint8List.fromList([1, 2, 3]).toJS))
        .toDart;
    await writer.close().toDart;

    final file = await handle.getFile().toDart;
    final reader = FileReader();
    scheduleMicrotask(() {
      reader.readAsArrayBuffer(file);
    });
    await reader.onLoad.first;

    final buffer = reader.resultAsArrayBuffer!.toDart.asUint8List();
    check(buffer).deepEquals([1, 2, 3]);
  });
}
