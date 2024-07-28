import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:test/test.dart';

void main() {
  late io.Directory tmpDir;

  setUp(() {
    tmpDir = io.Directory.systemTemp.createTempSync('chore_test');
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  test('can run dartdoc with --output', () async {
    final chore = Chore.withCommands(
      isCI: true,
      commands: [Dartdoc.new],
    );
    await chore.run(['dartdoc', '--output=${tmpDir.path}']);
  });
}
