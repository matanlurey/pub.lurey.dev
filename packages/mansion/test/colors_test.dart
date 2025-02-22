import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  group('$Color4.dim contains the dim colors', () {
    check(Color4.values.where((v) => v.isDim)).deepEquals(Color4.dim);
  });

  group('$Color4.bright contains the bright colors', () {
    check(Color4.values.where((v) => v.isBright)).deepEquals(Color4.bright);
  });

  test('$Color4 has expected output', () {
    final expected = {
      Color4.black: (background: '\x1B[40m', foreground: '\x1B[30m'),
      Color4.red: (background: '\x1B[41m', foreground: '\x1B[31m'),
      Color4.green: (background: '\x1B[42m', foreground: '\x1B[32m'),
      Color4.yellow: (background: '\x1B[43m', foreground: '\x1B[33m'),
      Color4.blue: (background: '\x1B[44m', foreground: '\x1B[34m'),
      Color4.magenta: (background: '\x1B[45m', foreground: '\x1B[35m'),
      Color4.cyan: (background: '\x1B[46m', foreground: '\x1B[36m'),
      Color4.white: (background: '\x1B[47m', foreground: '\x1B[37m'),
      Color4.brightBlack: (background: '\x1B[100m', foreground: '\x1B[90m'),
      Color4.brightRed: (background: '\x1B[101m', foreground: '\x1B[91m'),
      Color4.brightGreen: (background: '\x1B[102m', foreground: '\x1B[92m'),
      Color4.brightYellow: (background: '\x1B[103m', foreground: '\x1B[93m'),
      Color4.brightBlue: (background: '\x1B[104m', foreground: '\x1B[94m'),
      Color4.brightMagenta: (background: '\x1B[105m', foreground: '\x1B[95m'),
      Color4.brightCyan: (background: '\x1B[106m', foreground: '\x1B[96m'),
      Color4.brightWhite: (background: '\x1B[107m', foreground: '\x1B[97m'),
    };

    for (final color in Color4.values) {
      final result = expected[color];
      if (result == null) {
        fail('Missing expected output for $color');
      }
      check(
        SetStyles(Style.background(color)),
        because: 'SetColors.background($color)',
      ).writesAnsiString.equals(result.background);
      check(
        SetStyles(Style.foreground(color)),
        because: 'SetColors.foreground($color)',
      ).writesAnsiString.equals(result.foreground);
    }
  });

  group(Color8, () {
    test('should ignore anything exceeding 8-bits', () {
      check(Color.from256(256)).equals(Color.from256(256 & 0xff));
    });

    test('should have equality semantics', () {
      check(Color.from256(0xff))
        ..equals(Color.from256(0xff))
        ..has(
          (c) => c.hashCode,
          'hashCode',
        ).equals(Color.from256(0xff).hashCode)
        ..has((c) => c.toString(), 'toString()').equals('Color.from256(0xff)');
    });

    test('should provide all 256 colors', () {
      check(Color8.values).deepEquals(List.generate(256, Color.from256));
    });
  });

  group(Color24, () {
    test('should have equality semantics', () {
      check(Color.fromRGB(0x00, 0x00, 0xff))
        ..equals(Color.fromRGB(0x00, 0x00, 0xff))
        ..has(
          (c) => c.hashCode,
          'hashCode',
        ).equals(Color.fromRGB(0x00, 0x00, 0xff).hashCode)
        ..has(
          (c) => c.toString(),
          'toString()',
        ).equals('Color.fromRGB(0x00, 0x00, 0xff)');
    });

    test('should separate into red/green/blue components', () {
      check(Color24(0x010203))
        ..has((c) => c.red, 'red').equals(1)
        ..has((c) => c.green, 'green').equals(2)
        ..has((c) => c.blue, 'blue').equals(3);
    });

    test('should have expected output', () {
      check(
        SetStyles(
          Style.foreground(Color24(0x010203)),
          Style.background(Color24(0x040506)),
        ),
      ).writesAnsiString.equals('\x1B[38;2;1;2;3;48;2;4;5;6m');
    });

    test('should provide a lazy iterable of all colors', () {
      check(
        Color24.generate(sample: 32),
      ).has((c) => c.length, 'length').equals(512);
    });

    test('toRGB should return the 24-bit RGB value', () {
      check(Color24(0x010203).toRGB()).equals(0x010203);
    });
  });

  group('SetColors', () {
    group('resetForeground', () {
      test('has expected output', () {
        final style = SetStyles(Style.foreground(Color.reset));
        check(style).writesAnsiString.equals('\x1B[39m');
      });

      test('has expected equality semantics', () {
        final style = SetStyles(Style.foreground(Color.reset));
        check(style)
          ..equals(style)
          ..has((s) => s.hashCode, 'hashCode').equals(style.hashCode)
          ..has(
            (s) => s.toString(),
            'toString()',
          ).equals('SetStyles(Style.foreground(Color.reset))');
      });
    });

    group('resetBackground', () {
      test('has expected output', () {
        final style = SetStyles(Style.background(Color.reset));
        check(style).writesAnsiString.equals('\x1B[49m');
      });

      test('has expected equality semantics', () {
        final style = SetStyles(Style.background(Color.reset));
        check(style)
          ..equals(style)
          ..has((s) => s.hashCode, 'hashCode').equals(style.hashCode)
          ..has(
            (s) => s.toString(),
            'toString()',
          ).equals('SetStyles(Style.background(Color.reset))');
      });
    });

    group('resetBoth', () {
      test('has expected output', () {
        final style = SetStyles(
          Style.foreground(Color.reset),
          Style.background(Color.reset),
        );
        check(style).writesAnsiString.equals('\x1B[39;49m');
      });

      test('has expected equality semantics', () {
        final style = SetStyles(
          Style.foreground(Color.reset),
          Style.background(Color.reset),
        );
        check(style)
          ..equals(style)
          ..has((s) => s.hashCode, 'hashCode').equals(style.hashCode)
          ..has((s) => s.toString(), 'toString()').equals(
            'SetStyles(Style.foreground(Color.reset), Style.background(Color.reset))',
          );
      });
    });

    group('foreground', () {
      test('should have expected output', () {
        final style = SetStyles(Style.foreground(Color.from256(0xff)));
        check(style).writesAnsiString.equals('\x1B[38;5;255m');
      });

      test('should have expected equality semantics', () {
        final style = SetStyles(Style.foreground(Color.from256(0xff)));
        check(style)
          ..equals(style)
          ..has((s) => s.hashCode, 'hashCode').equals(style.hashCode)
          ..has(
            (s) => s.toString(),
            'toString()',
          ).equals('SetStyles(Style.foreground(Color.from256(0xff)))');
      });
    });

    group('background', () {
      test('should have expected output', () {
        final style = SetStyles(Style.background(Color.from256(0xff)));
        check(style).writesAnsiString.equals('\x1B[48;5;255m');
      });

      test('should have expected equality semantics', () {
        final style = SetStyles(Style.background(Color.from256(0xff)));
        check(style)
          ..equals(style)
          ..has((s) => s.hashCode, 'hashCode').equals(style.hashCode)
          ..has(
            (s) => s.toString(),
            'toString()',
          ).equals('SetStyles(Style.background(Color.from256(0xff)))');
      });
    });

    group('both', () {
      test('should have expected output', () {
        check(
          SetStyles(
            Style.background(Color.from256(0xff)),
            Style.foreground(Color.from256(0xff)),
          ),
        ).writesAnsiString.equals('\x1B[48;5;255;38;5;255m');
      });

      test('should have expected equality semantics', () {
        check(
            SetStyles(
              Style.background(Color.from256(0xff)),
              Style.foreground(Color.from256(0xff)),
            ),
          )
          ..equals(
            SetStyles(
              Style.background(Color.from256(0xff)),
              Style.foreground(Color.from256(0xff)),
            ),
          )
          ..has((s) => s.hashCode, 'hashCode').equals(
            SetStyles(
              Style.background(Color.from256(0xff)),
              Style.foreground(Color.from256(0xff)),
            ).hashCode,
          )
          ..has((s) => s.toString(), 'toString()').equals(
            'SetStyles(Style.background(Color.from256(0xff)), Style.foreground(Color.from256(0xff)))',
          );
      });
    });
  });
}
