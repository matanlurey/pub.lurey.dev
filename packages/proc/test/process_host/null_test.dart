@TestOn('!vm')
library;

import 'package:proc/proc.dart';

import '../_prelude.dart';

void main() {
  test('unsupported', () {
    check(ProcessHost.new).throws<UnsupportedError>();
  });

  test('isSupported', () {
    check(ProcessHost.isSupported).isFalse();
  });
}
