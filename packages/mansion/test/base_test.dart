import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  test('Sequence.empty emits an empty string', () {
    check(Sequence.empty).writesAnsiString.equals('');
  });

  group('LiteralText', () {
    test('.empty should emit an empty string', () {
      check(Print.empty).writesAnsiString.equals('');
    });

    test('.checkInvalid should allow valid text', () {
      check(Print.checkInvalid('hello')).writesAnsiString.equals('hello');
    });

    test('.checkInvalid should throw on invalid text', () {
      check(
        () => Print.checkInvalid('hello\x1B'),
      ).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(5)
        ..has((e) => e.message, 'message').contains('Contains')
        ..has((e) => e.source, 'source').equals('hello\x1B');
    });

    test('.checkInvalid should throw on invalid text (allowAscii: true)', () {
      check(
        () => Print.checkInvalid('hello\x1B', allowAscii: true),
      ).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(5)
        ..has((e) => e.message, 'message').contains('Contains')
        ..has((e) => e.source, 'source').equals('hello\x1B');
    });

    test('.checkInvalid should allow ASCII codes', () {
      check(Print.checkInvalid('hello\x07', allowAscii: true))
          .writesAnsiString
          .equals('hello\x07');
    });

    test('.checkInvalid with allowAscii: false disallows ASCII codes', () {
      check(
        () => Print.checkInvalid('hello\n'),
      ).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(5)
        ..has((e) => e.message, 'message').contains(
          'Contains control character',
        )
        ..has((e) => e.source, 'source').equals('hello\n');
    });

    test('should escape invalid text', () {
      check(Print('hello\x1b')).writesAnsiString.equals(r'hello\x1b');
    });

    test('should allow ASCII codes', () {
      check(
        Print('hello\x07', allowAscii: true),
      ).writesAnsiString.equals('hello\x07');
    });

    test('with allowAscii: false disallows ASCII codes', () {
      check(Print('hello\n')).writesAnsiString.equals(r'hello\xa');
    });

    test('== hashCode toString()', () {
      check(Print('hello'))
        ..equals(Print('hello'))
        ..has((p) => p.hashCode, 'hashCode').equals(Print('hello').hashCode)
        ..has((p) => p.toString(), 'toString').equals('Print(hello)');
    });
  });

  group(Unknown, () {
    test('== hashCode toString()', () {
      check(Unknown('\x1B[3W'))
        ..equals(Unknown('\x1b[3W'))
        ..has((p) => p.hashCode, 'hashCode').equals(Unknown('\x1b[3W').hashCode)
        ..has((p) => p.toString(), 'toString').equals(r'Unknown(\x1b[3W)');
    });

    test('== hashCode toString() with offset', () {
      check(Unknown('\x1B[3W', offset: 5))
        ..equals(Unknown('\x1b[3W', offset: 5))
        ..has((p) => p.hashCode, 'hashCode')
            .equals(Unknown('\x1b[3W', offset: 5).hashCode)
        ..has((p) => p.toString(), 'toString')
            .equals(r'Unknown(\x1b[3W, offset: 5)');
    });
  });
}
