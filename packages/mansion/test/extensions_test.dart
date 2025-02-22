import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  group('AnsiStringSink', () {
    test('writeAnsi', () {
      final buffer = StringBuffer();
      buffer.writeAnsi(SetStyles(Style.foreground(Color4.red)));
      buffer.writeAnsi(Print('Hello, World!'));
      buffer.writeln();
      check(buffer.toString()).equals('\x1B[31mHello, World!\n');
    });

    test('writeAnsiAll', () {
      final buffer = StringBuffer();
      buffer.writeAnsiAll([
        SetStyles(Style.foreground(Color4.red)),
        Print('Hello, World!'),
        AsciiControl.lineFeed,
        SetStyles.reset,
      ]);
      check(buffer.toString()).equals('\x1B[31mHello, World!\n\x1B[0m');
    });
  });

  test('syncAnsiUpdate', () {
    final buffer = StringBuffer();
    buffer.syncAnsiUpdate((out) {
      out.writeAnsiAll([
        SetStyles(Style.foreground(Color4.red)),
        Print('Hello, World!'),
        AsciiControl.lineFeed,
        SetStyles.reset,
      ]);
    });

    check(
      buffer.toString(),
    ).equals('\x1B[?2026h\x1B[31mHello, World!\n\x1B[0m\x1B[?2026l');
  });

  test('syncAnsiUpdate that throws still ends the update', () {
    final buffer = StringBuffer();
    check(() => buffer.syncAnsiUpdate((_) => throw StateError('Oops')))
        .throws<StateError>()
        .has((e) => e.toString(), 'toString()')
        .contains('Oops');

    check(buffer.toString()).equals('\x1B[?2026h\x1B[?2026l');
  });

  test('AnsifyString', () {
    check(
      'Hello, World!'.style(Style.bold, Style.foreground(Color4.red)),
    ).equals('\x1B[1;31mHello, World!\x1B[0m');
  });

  test('ToAnsiString', () {
    check(
      SetStyles(Style.bold, Style.foreground(Color4.red)).toAnsiString(),
    ).equals('\x1B[1;31m');
  });
}
