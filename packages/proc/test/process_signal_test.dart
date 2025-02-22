import 'package:proc/proc.dart';

import '_prelude.dart';

void main() {
  test('sigint', () {
    check(ProcessSignal.sigint).has((a) => a.name, 'name').equals('sigint');
  });

  test('sigterm', () {
    check(ProcessSignal.sigterm).has((a) => a.name, 'name').equals('sigterm');
  });

  test('sigkill', () {
    check(ProcessSignal.sigkill).has((a) => a.name, 'name').equals('sigkill');
  });

  test('toString()', () {
    check(
      ProcessSignal.sigint,
    ).has((a) => a.toString(), 'toString()').equals('ProcessSignal.sigint');
  });
}
