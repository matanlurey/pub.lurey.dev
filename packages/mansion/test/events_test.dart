import 'dart:convert' show utf8;
import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  test('BracketedPaste', () {
    check(CapturePaste.values).writesAnsiStrings.deepEquals({
      CapturePaste.enable: '\x1B[?2004h',
      CapturePaste.disable: '\x1B[?2004l',
    });
  });

  test('MouseCapture', () {
    check(EnableMouseCapture.all).writesAnsiStrings.deepEquals({
      EnableMouseCapture.any: '\x1B[?1003h',
      EnableMouseCapture.button: '\x1B[?1002h',
      EnableMouseCapture.normal: '\x1B[?1000h',
      EnableMouseCapture.sgr: '\x1B[?1006h',
    });

    check(DisableMouseCapture.all).writesAnsiStrings.deepEquals({
      DisableMouseCapture.any: '\x1B[?1003l',
      DisableMouseCapture.button: '\x1B[?1002l',
      DisableMouseCapture.normal: '\x1B[?1000l',
      DisableMouseCapture.sgr: '\x1B[?1006l',
    });
  });

  group(CaptureFocus, () {
    test('enable', () {
      check(CaptureFocus.enable).writesAnsiString.equals('\x1B[?1004h');
    });

    test('disable', () {
      check(CaptureFocus.disable).writesAnsiString.equals('\x1B[?1004l');
    });
  });

  group(PasteEvent, () {
    test('has equality semantics', () {
      final a = PasteEvent('Hello, World!');
      final b = PasteEvent('Hello, World!');
      check(a)
        ..equals(b)
        ..has(
          (e) => e.hashCode,
          'hashCode',
        ).equals(b.hashCode)
        ..has(
          (e) => e.toString(),
          'toString()',
        ).equals('PasteEvent(Hello, World!)');
    });
  });

  group('MouseEvent', () {
    test('has equality semantics', () {
      final a = MouseEvent(
        row: 1,
        column: 2,
        kind: MouseEventKind.down,
        button: MouseButton.left,
      );
      final b = MouseEvent(
        row: 1,
        column: 2,
        kind: MouseEventKind.down,
        button: MouseButton.left,
      );
      check(a)
        ..equals(b)
        ..has(
          (e) => e.hashCode,
          'hashCode',
        ).equals(b.hashCode)
        ..has(
          (e) => e.toString(),
          'toString()',
        ).equals(
          'MouseEvent(row: 1, column: 2, kind: MouseEventKind.down, button: MouseButton.left)',
        );
    });
  });

  group('KeyModifiers', () {
    test('by default everything is false', () {
      final modifiers = KeyModifiers();
      check(modifiers)
        ..equals(KeyModifiers.none)
        ..has(
          (m) => m.hashCode,
          'hashCode',
        ).equals(KeyModifiers().hashCode)
        ..has(
          (m) => m.shiftKey,
          'shiftKey',
        ).isFalse()
        ..has(
          (m) => m.controlKey,
          'controlKey',
        ).isFalse()
        ..has(
          (m) => m.altKey,
          'altKey',
        ).isFalse()
        ..has(
          (m) => m.toString(),
          'toString()',
        ).equals('KeyModifiers.none');
    });

    test('shiftKey', () {
      final modifiers = KeyModifiers(shiftKey: true);
      check(modifiers)
        ..has(
          (m) => m.shiftKey,
          'shiftKey',
        ).isTrue()
        ..has(
          (m) => m.controlKey,
          'controlKey',
        ).isFalse()
        ..has(
          (m) => m.altKey,
          'altKey',
        ).isFalse()
        ..equals(KeyModifiers(shiftKey: true))
        ..has(
          (m) => m.hashCode,
          'hashCode',
        ).equals(KeyModifiers(shiftKey: true).hashCode)
        ..has(
          (m) => m.toString(),
          'toString()',
        ).equals('KeyModifiers(shiftKey)');
    });

    test('controlKey', () {
      final modifiers = KeyModifiers(controlKey: true);
      check(modifiers)
        ..has(
          (m) => m.shiftKey,
          'shiftKey',
        ).isFalse()
        ..has(
          (m) => m.controlKey,
          'controlKey',
        ).isTrue()
        ..has(
          (m) => m.altKey,
          'altKey',
        ).isFalse()
        ..equals(KeyModifiers(controlKey: true))
        ..has(
          (m) => m.hashCode,
          'hashCode',
        ).equals(KeyModifiers(controlKey: true).hashCode)
        ..has(
          (m) => m.toString(),
          'toString()',
        ).equals('KeyModifiers(controlKey)');
    });

    test('altKey', () {
      final modifiers = KeyModifiers(altKey: true);
      check(modifiers)
        ..has(
          (m) => m.shiftKey,
          'shiftKey',
        ).isFalse()
        ..has(
          (m) => m.controlKey,
          'controlKey',
        ).isFalse()
        ..has(
          (m) => m.altKey,
          'altKey',
        ).isTrue()
        ..equals(KeyModifiers(altKey: true))
        ..has(
          (m) => m.hashCode,
          'hashCode',
        ).equals(KeyModifiers(altKey: true).hashCode)
        ..has(
          (m) => m.toString(),
          'toString()',
        ).equals('KeyModifiers(altKey)');
    });

    test('all', () {
      final modifiers = KeyModifiers(
        shiftKey: true,
        controlKey: true,
        altKey: true,
      );
      check(modifiers)
        ..has(
          (m) => m.shiftKey,
          'shiftKey',
        ).isTrue()
        ..has(
          (m) => m.controlKey,
          'controlKey',
        ).isTrue()
        ..has(
          (m) => m.altKey,
          'altKey',
        ).isTrue()
        ..equals(
          KeyModifiers(
            shiftKey: true,
            controlKey: true,
            altKey: true,
          ),
        )
        ..has(
          (m) => m.hashCode,
          'hashCode',
        ).equals(
          KeyModifiers(
            shiftKey: true,
            controlKey: true,
            altKey: true,
          ).hashCode,
        )
        ..has(
          (m) => m.toString(),
          'toString()',
        ).equals(
          'KeyModifiers('
          'shiftKey, '
          'controlKey, '
          'altKey'
          ')',
        );
    });
  });

  group('KeyEventState', () {
    group('KeyEvent', () {
      test('with just a key', () {
        check(KeyEvent(CharKey('x')))
          ..equals(KeyEvent(CharKey('x')))
          ..has(
            (e) => e.hashCode,
            'hashCode',
          ).equals(KeyEvent(CharKey('x')).hashCode)
          ..has(
            (e) => e.toString(),
            'toString()',
          ).equals('KeyEvent(CharKeyCode(x))');
      });

      test('with a key and modifiers', () {
        check(
          KeyEvent(CharKey('x'), modifiers: KeyModifiers(shiftKey: true)),
        )
          ..equals(
            KeyEvent(CharKey('x'), modifiers: KeyModifiers(shiftKey: true)),
          )
          ..has(
            (e) => e.hashCode,
            'hashCode',
          ).equals(
            KeyEvent(CharKey('x'), modifiers: KeyModifiers(shiftKey: true))
                .hashCode,
          )
          ..has(
            (e) => e.toString(),
            'toString()',
          ).equals(
            'KeyEvent(CharKeyCode(x), modifiers: KeyModifiers(shiftKey))',
          );
      });

      test('with a key and modifiers', () {
        check(
          KeyEvent(
            CharKey('x'),
            modifiers: KeyModifiers(shiftKey: true),
          ),
        )
          ..equals(
            KeyEvent(
              CharKey('x'),
              modifiers: KeyModifiers(shiftKey: true),
            ),
          )
          ..has(
            (e) => e.hashCode,
            'hashCode',
          ).equals(
            KeyEvent(
              CharKey('x'),
              modifiers: KeyModifiers(shiftKey: true),
            ).hashCode,
          )
          ..has(
            (e) => e.toString(),
            'toString()',
          ).equals(
            'KeyEvent('
            'CharKeyCode(x), '
            'modifiers: KeyModifiers(shiftKey)'
            ')',
          );
      });
    });

    test('CharKeyCode', () {
      check(CharKey('x'))
        ..equals(CharKey('x'))
        ..has(
          (c) => c.hashCode,
          'hashCode',
        ).equals(CharKey('x').hashCode)
        ..has(
          (c) => c.toString(),
          'toString()',
        ).equals('CharKeyCode(x)');
    });
  });

  group('Event.parse', () {
    final expected = <Event, List<int>>{
      KeyEvent(ControlKey.null$): [0x00],
      KeyEvent(ControlKey.enter): [0x0A],
      KeyEvent(ControlKey.tab): [0x09],
      KeyEvent(ControlKey.escape): [0x1B],
      KeyEvent(ControlKey.insert): [0x1B, 0x5B, 0x32, 0x7E],
      KeyEvent(ControlKey.delete): [0x1B, 0x5B, 0x33, 0x7E],
      KeyEvent(ControlKey.pageUp): [0x1B, 0x5B, 0x35, 0x7E],
      KeyEvent(ControlKey.pageDown): [0x1B, 0x5B, 0x36, 0x7E],
      KeyEvent(ControlKey.upArrow): [0x1B, 0x5B, 0x41],
      KeyEvent(ControlKey.downArrow): [0x1B, 0x5B, 0x42],
      KeyEvent(ControlKey.rightArrow): [0x1B, 0x5B, 0x43],
      KeyEvent(ControlKey.leftArrow): [0x1B, 0x5B, 0x44],
      KeyEvent(ControlKey.backTab): [0x1B, 0x5B, 0x5A],
      FocusEvent.gained: [0x1B, 0x5B, 0x49],
      FocusEvent.lost: [0x1B, 0x5B, 0x4F],
      KeyEvent(ControlKey.backspace): [0x7F],
    };

    for (final entry in expected.entries) {
      test(entry.key.toString(), () {
        final event = Event.tryParse(entry.value);
        check(event).equals(entry.key);
      });
    }

    group(CharKey, () {
      test('parses ASCII characters from 0x20 to 0x7E', () {
        for (var i = 0x20; i <= 0x7E; i++) {
          final event = Event.tryParse([i]);
          check(event).equals(KeyEvent(CharKey(String.fromCharCode(i))));
        }
      });

      test('parses extended ASCII characters from 0x80 to 0xFF', () {
        for (var i = 0x80; i <= 0xFF; i++) {
          final event = Event.tryParse([i]);
          check(event).equals(KeyEvent(CharKey(String.fromCharCode(i))));
        }
      });
    });

    test(PasteEvent, () {
      final header = [0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7e];
      final body = utf8.encode('Hello, World!');
      final footer = [0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7e];
      final event = Event.tryParse([...header, ...body, ...footer]);
      check(event).equals(PasteEvent(utf8.decode(body)));
    });

    group(MouseEvent, () {
      test(MouseEventKind.down, () {
        final header = [0x1B, 0x5B, 0x3c];
        final data = utf8.encode(
          [
            '0',
            '1',
            '1',
          ].join(';'),
        );
        check(Event.tryParse([...header, ...data, 0x4D])).equals(
          MouseEvent(
            row: 1,
            column: 1,
            kind: MouseEventKind.down,
            button: MouseButton.left,
          ),
        );
      });

      test(MouseEventKind.moved, () {
        final header = [0x1B, 0x5B, 0x3c];
        final data = utf8.encode(
          [
            '32',
            '1',
            '1',
          ].join(';'),
        );
        check(Event.tryParse([...header, ...data, 0x4D])).equals(
          MouseEvent(
            row: 1,
            column: 1,
            kind: MouseEventKind.moved,
            button: MouseButton.left,
          ),
        );
      });

      test(MouseButton.left, () {
        final header = [0x1B, 0x5B, 0x3c];
        final data = utf8.encode(
          [
            '0',
            '1',
            '1',
          ].join(';'),
        );
        check(Event.tryParse([...header, ...data, 0x4D])).equals(
          MouseEvent(
            row: 1,
            column: 1,
            kind: MouseEventKind.down,
            button: MouseButton.left,
          ),
        );
      });

      test(MouseButton.middle, () {
        final header = [0x1B, 0x5B, 0x3c];
        final data = utf8.encode(
          [
            '1',
            '1',
            '1',
          ].join(';'),
        );
        check(Event.tryParse([...header, ...data, 0x4D])).equals(
          MouseEvent(
            row: 1,
            column: 1,
            kind: MouseEventKind.down,
            button: MouseButton.middle,
          ),
        );
      });

      test(MouseButton.right, () {
        final header = [0x1B, 0x5B, 0x3c];
        final data = utf8.encode(
          [
            '2',
            '1',
            '1',
          ].join(';'),
        );
        check(Event.tryParse([...header, ...data, 0x4D])).equals(
          MouseEvent(
            row: 1,
            column: 1,
            kind: MouseEventKind.down,
            button: MouseButton.right,
          ),
        );
      });
    });
  });
}
