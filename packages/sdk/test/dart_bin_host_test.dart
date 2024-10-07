import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  final dart = Dart.current;
  if (dart == null) {
    fail('Could not determine the Dart SDK.');
  }

  late io.Directory tmpDir;

  setUp(() async {
    tmpDir = await io.Directory.systemTemp.createTemp('sdk_test');
  });

  tearDown(() async {
    await tmpDir.delete(recursive: true);
  });

  test('all well-formatted Dart returns false', () async {
    io.File(p.join(tmpDir.path, 'file.dart'))
      ..createSync()
      ..writeAsStringSync('void main() {}\n');

    await check(dart.format([tmpDir.path])).completes((e) => e.isFalse());
  });

  test('ill-formatted Dart returns true', () async {
    io.File(p.join(tmpDir.path, 'file.dart'))
      ..createSync()
      ..writeAsStringSync('void   main() {}');

    await check(dart.format([tmpDir.path])).completes((e) => e.isTrue());
  });

  test('all well-formatted Dart returns no elements', () async {
    io.File(p.join(tmpDir.path, 'file.dart'))
      ..createSync()
      ..writeAsStringSync('void main() {}\n');

    await check(dart.formatCheck([tmpDir.path])).withQueue.isDone();
  });

  test('ill-formatted Dart returns paths', () async {
    io.File(p.join(tmpDir.path, 'file.dart'))
      ..createSync()
      ..writeAsStringSync('void   main() {}');

    await check(dart.formatCheck([tmpDir.path]))
        .withQueue
        .emits((e) => e.endsWith('file.dart'));
  });
}