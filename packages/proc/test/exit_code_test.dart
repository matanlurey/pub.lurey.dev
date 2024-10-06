import 'package:proc/proc.dart';

import '_prelude.dart';

void main() {
  test('success', () {
    check(ExitCode.success)
      ..has((a) => a.code, 'code').equals(0)
      ..has((a) => a.isSuccess, 'isSuccess').isTrue()
      ..has((a) => a.isFailure, 'isFailure').isFalse();
  });

  test('failure', () {
    check(ExitCode.failure)
      ..has((a) => a.code, 'code').equals(1)
      ..has((a) => a.isSuccess, 'isSuccess').isFalse()
      ..has((a) => a.isFailure, 'isFailure').isTrue();
  });

  test('.from', () {
    final $2 = ExitCode.from(2);
    check($2)
      ..has((a) => a.code, 'code').equals(2)
      ..has((a) => a.isSuccess, 'isSuccess').isFalse()
      ..has((a) => a.isFailure, 'isFailure').isTrue();

    check($2)
      ..equals(ExitCode.from(2))
      ..has((a) => a.hashCode, 'hashCde').equals(ExitCode.from(2).hashCode)
      ..has((a) => a.toString(), 'toString()').equals('ExitCode <2>');
  });
}
