import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  group('ScrollUp', () {
    test('.byRows writes the expected output', () {
      check(ScrollUp.byRows(3)).writesAnsiString.equals('\x1B[3S');
    });

    test('.byRows has the expected equality semantics', () {
      check(ScrollUp.byRows(3))
        ..equals(ScrollUp.byRows(3))
        ..has((s) => s.hashCode, 'hashCode').equals(ScrollUp.byRows(3).hashCode)
        ..has((s) => s.toString(), 'toString()').equals('ScrollUp.byRows(3)');
    });
  });

  group('ScrollDown', () {
    test('.byRows writes the expected output', () {
      check(ScrollDown.byRows(3)).writesAnsiString.equals('\x1B[3T');
    });

    test('.byRows has the expected equality semantics', () {
      check(ScrollDown.byRows(3))
        ..equals(ScrollDown.byRows(3))
        ..has(
          (s) => s.hashCode,
          'hashCode',
        ).equals(ScrollDown.byRows(3).hashCode)
        ..has((s) => s.toString(), 'toString()').equals('ScrollDown.byRows(3)');
    });
  });

  test('Clear has the expected output', () {
    check(Clear.values).writesAnsiStrings.deepEquals({
      Clear.all: '\x1B[2J',
      Clear.allAndScrollback: '\x1B[3J',
      Clear.afterCursor: '\x1B[0J',
      Clear.beforeCursor: '\x1B[1J',
      Clear.currentLine: '\x1B[2K',
      Clear.untilEndOfLine: '\x1B[0K',
    });
  });

  group('SetSize', () {
    test('writes the expected output', () {
      check(
        SetSize(rows: 3, columns: 5),
      ).writesAnsiString.equals('\x1B[8;3;5t');
    });

    test('has the expected equality semantics', () {
      check(SetSize(rows: 3, columns: 5))
        ..equals(SetSize(rows: 3, columns: 5))
        ..has(
          (s) => s.hashCode,
          'hashCode',
        ).equals(SetSize(rows: 3, columns: 5).hashCode)
        ..has(
          (s) => s.toString(),
          'toString()',
        ).equals('SetSize(rows: 3, columns: 5)');
    });
  });

  group('SetTitle', () {
    test('writes the expected output', () {
      check(
        SetTitle('Hello, World!'),
      ).writesAnsiString.equals('\x1B]0;Hello, World!\x07');
    });

    test('has the expected equality semantics', () {
      final a = SetTitle('Hello, World!');
      final b = SetTitle('Hello, World!');
      check(a)
        ..equals(b)
        ..has((s) => s.hashCode, 'hashCode').equals(b.hashCode)
        ..has(
          (s) => s.toString(),
          'toString()',
        ).equals('SetTitle(Hello, World!)');
    });
  });

  test('LineWrap has expected output', () {
    check(LineWrap.values).writesAnsiStrings.deepEquals({
      LineWrap.enable: '\x1B[?7h',
      LineWrap.disable: '\x1B[?7l',
    });
  });

  test('AlternateScreen has expected output', () {
    check(AlternateScreen.values).writesAnsiStrings.deepEquals({
      AlternateScreen.enter: '\x1B[?1049h',
      AlternateScreen.leave: '\x1B[?1049l',
    });
  });

  test('SynchronousUpdates', () {
    check(SynchronousUpdates.values).writesAnsiStrings.deepEquals({
      SynchronousUpdates.start: '\x1B[?2026h',
      SynchronousUpdates.end: '\x1B[?2026l',
    });
  });
}
