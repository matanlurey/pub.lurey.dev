import 'dart:js_interop';

import 'package:checks/checks.dart';

export 'package:checks/checks.dart';
export 'package:test/test.dart' show group, setUp, tearDown, test;

extension JSBooleanSubject on Subject<JSBoolean> {
  void isTrue() => has((a) => a.toDart, '').isTrue();
  void isFalse() => has((a) => a.toDart, '').isFalse();
}

extension JSNumberSubject on Subject<JSNumber> {
  void equalsInt(int expected) {
    has((a) => a.toDartInt, '').equals(expected);
  }

  void equalsDouble(double expected) {
    has((a) => a.toDartDouble, '').equals(expected);
  }
}

extension JSStringSubject on Subject<JSString> {
  void equals(String expected) {
    has((a) => a.toDart, '').equals(expected);
  }

  void isEmpty() => has((a) => a.toDart, '').isEmpty();
}
