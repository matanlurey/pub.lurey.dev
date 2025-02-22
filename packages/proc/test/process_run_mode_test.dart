import 'package:proc/proc.dart';

import '_prelude.dart';

void main() {
  test('normal', () {
    check(
      ProcessRunMode.normal,
    ).has((a) => a.toString(), 'toString()').equals('ProcessRunMode.normal');
  });

  test('inheritStdio', () {
    check(ProcessRunMode.inheritStdio)
        .has((a) => a.toString(), 'toString()')
        .equals('ProcessRunMode.inheritStdio');
  });

  test('detached', () {
    check(
      ProcessRunMode.detached,
    ).has((a) => a.toString(), 'toString()').equals('ProcessRunMode.detached');
  });

  test('detachedWithOutput', () {
    check(ProcessRunMode.detachedWithOutput)
        .has((a) => a.toString(), 'toString()')
        .equals('ProcessRunMode.detachedWithOutput');
  });
}
