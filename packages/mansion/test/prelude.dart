/// Test prelude for tests in this package.
library;

import 'package:checks/context.dart';
import 'package:mansion/mansion.dart';

export 'package:checks/checks.dart';
export 'package:test/test.dart'
    show
        Skip,
        TestOn,
        fail,
        group,
        pumpEventQueue,
        setUp,
        setUpAll,
        tearDown,
        tearDownAll,
        test;

/// Checks for [Sequence].
extension SequenceChecks on Subject<Sequence> {
  /// Extracts the ANSI string written by the sequence.
  Subject<String> get writesAnsiString {
    return context.nest(() => ['writes an ANSI string'], (actual) {
      final buffer = StringBuffer();
      actual.writeAnsiString(buffer);
      return Extracted.value(buffer.toString());
    });
  }
}

/// Checks for `values` from `enum T implements Sequence`.
extension EnumSequenceChecks on Subject<List<Sequence>> {
  /// Extracts each ANSI string written by a sequence as a map.
  Subject<Map<Sequence, String>> get writesAnsiStrings {
    return context.nest(() => ['writes ANSI strings'], (actual) {
      final map = <Sequence, String>{};
      for (final sequence in actual) {
        final buffer = StringBuffer();
        sequence.writeAnsiString(buffer);
        map[sequence] = buffer.toString();
      }
      return Extracted.value(map);
    });
  }
}
