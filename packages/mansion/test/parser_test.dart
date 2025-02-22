import 'package:mansion/mansion.dart';
import 'package:mansion/src/_mansion.dart' as internal;

import 'prelude.dart';

void main() {
  (List<Sequence>, Unknown?) parseAnsi(String input) {
    final output = <Sequence>[];
    final result = internal.parseAnsi(input, output);
    return (output, result);
  }

  test('parses empty text', () {
    final (output, partial) = parseAnsi('');
    check(output).isEmpty();
    check(partial).isNull();
  });

  test('parses literal text', () {
    final (output, partial) = parseAnsi('hello');
    check(output).deepEquals([Print('hello')]);
    check(partial).isNull();
  });

  group('parses ASCII escapes', () {
    final expected = <AsciiControl, String>{
      AsciiControl.terminalBell: '\x07',
      AsciiControl.backspace: '\x08',
      AsciiControl.horizontalTab: '\x09',
      AsciiControl.lineFeed: '\x0A',
      AsciiControl.verticalTab: '\x0B',
      AsciiControl.formFeed: '\x0C',
      AsciiControl.carriageReturn: '\x0D',
      AsciiControl.delete: '\x7F',
    };

    for (final entry in expected.entries) {
      test('parses ${entry.key.name}', () {
        final (output, partial) = parseAnsi(entry.value);
        check(output).deepEquals([entry.key]);
        check(partial).isNull();
      });
    }
  });

  test('parses literal text interweaved with literal text', () {
    final (output, partial) = parseAnsi('hello\nworld');
    check(
      output,
    ).deepEquals([Print('hello'), AsciiControl.lineFeed, Print('world')]);
    check(partial).isNull();
  });

  test('parses incomplete escape code', () {
    final (output, partial) = parseAnsi('\x1B');
    check(output).isEmpty();
    check(partial).isA<Unknown>().equals(Unknown('\x1B', offset: 0));
  });

  test('parses incomplete escape code interweaved with literal text', () {
    final (output, partial) = parseAnsi('\x1Bhello\x1B');
    check(output).deepEquals([Unknown('\x1B', offset: 0), Print('hello')]);
    check(partial).isNotNull().equals(Unknown('\x1B', offset: 6));
  });

  test('parses multiple incomplete escape codes', () {
    final (output, partial) = parseAnsi('\x1B\x1B');
    check(output).deepEquals([Unknown('\x1B', offset: 0)]);
    check(partial).isNotNull().equals(Unknown('\x1B', offset: 1));
  });

  group('CSI', () {
    test('parses incomplete CSI escape code', () {
      final (output, partial) = parseAnsi('\x1B[');
      check(output).isEmpty();
      check(partial).equals(Unknown('\x1B[', offset: 0));
    });

    test('parses unknown (unmatched) CSI', () {
      final (output, partial) = parseAnsi('\x1B[x');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[x', offset: 0));
    });

    test('parses multiple unknown (invalid) CSI', () {
      final (output, partial) = parseAnsi('\x1B[#\x1B[');
      check(output).deepEquals([Unknown('\x1B[', offset: 0), Print('#')]);
      check(partial).isNotNull().equals(Unknown('\x1B[', offset: 3));
    });

    test('parses multiple unknown (unmatched) CSI', () {
      final (output, partial) = parseAnsi('\x1B[x\x1B[y');
      check(output).deepEquals([Unknown('\x1B[x', offset: 0)]);
      check(partial).isNotNull().equals(Unknown('\x1B[y', offset: 3));
    });

    test('parses multiple unknown (unmatched) CSIs interweaved with text', () {
      final (output, partial) = parseAnsi('hello\x1B[xworld\x1B[y');
      check(output).deepEquals([
        Print('hello'),
        Unknown('\x1B[x', offset: 5),
        Print('world'),
      ]);
      check(partial).isNotNull().equals(Unknown('\x1B[y', offset: 13));
    });

    test('parses unknown (matched but bad params)', () {
      final (output, partial) = parseAnsi('\x1B[?26h');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[?26h', offset: 0));
    });

    test('parses unknown (matched but bad params), l-variant', () {
      final (output, partial) = parseAnsi('\x1B[?26l');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[?26l', offset: 0));
    });

    group(CursorVisibility, () {
      test('parses show', () {
        final (output, partial) = parseAnsi('\x1B[?25h');
        check(output).deepEquals([CursorVisibility.show]);
        check(partial).isNull();
      });

      test('parses hide', () {
        final (output, partial) = parseAnsi('\x1B[?25l');
        check(output).deepEquals([CursorVisibility.hide]);
        check(partial).isNull();
      });
    });

    group(CursorStyle, () {
      final expected = <CursorStyle, String>{
        CursorStyle.defaultUserShape: '0',
        CursorStyle.blinkingBlock: '1',
        CursorStyle.steadyBlock: '2',
        CursorStyle.blinkingUnderline: '3',
        CursorStyle.steadyUnderline: '4',
        CursorStyle.blinkingBar: '5',
        CursorStyle.steadyBar: '6',
      };

      for (final entry in expected.entries) {
        test('parses ${entry.key.name}', () {
          final (output, partial) = parseAnsi('\x1B[${entry.value}q');
          check(output).deepEquals([entry.key]);
          check(partial).isNull();
        });
      }
    });

    group(SetSize, () {
      test('parses', () {
        final (output, partial) = parseAnsi('\x1B[8;3;5t');
        check(output).deepEquals([SetSize(rows: 3, columns: 5)]);
        check(partial).isNull();
      });

      test('too many params', () {
        final (output, partial) = parseAnsi('\x1B[8;3;5;7t');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[8;3;5;7t', offset: 0));
      });

      test('too few params', () {
        final (output, partial) = parseAnsi('\x1B[8;3t');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[8;3t', offset: 0));
      });

      test('first param is not "8"', () {
        final (output, partial) = parseAnsi('\x1B[9;3;5t');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[9;3;5t', offset: 0));
      });

      test('rows is not a valid int', () {
        final (output, partial) = parseAnsi('\x1B[8;#;5t');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[8;#;5t', offset: 0));
      });

      test('columns is not a valid int', () {
        final (output, partial) = parseAnsi('\x1B[8;3;#;t');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[8;3;#;t', offset: 0));
      });
    });

    group(CursorPosition, () {
      group('.moveUp', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5A');
          check(output).deepEquals([CursorPosition.moveUp(5)]);
          check(partial).isNull();
        });

        test('parses default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[A');
          check(output).deepEquals([CursorPosition.moveUp(1)]);
          check(partial).isNull();
        });

        test('parses resetColumn', () {
          final (output, partial) = parseAnsi('\x1B[5F');
          check(
            output,
          ).deepEquals([CursorPosition.moveUp(5, resetColumn: true)]);
          check(partial).isNull();
        });

        test('parses resetColumn default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[F');
          check(
            output,
          ).deepEquals([CursorPosition.moveUp(1, resetColumn: true)]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;5A');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[5;5A', offset: 0));
        });

        test('bad params (not an int)', () {
          final (output, partial) = parseAnsi('\x1B[#F');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[#F', offset: 0));
        });

        test('bad params (not an int, variant-H)', () {
          final (output, partial) = parseAnsi('\x1B[#;#H');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[#;#H', offset: 0));
        });
      });

      group('.moveDown', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5B');
          check(output).deepEquals([CursorPosition.moveDown(5)]);
          check(partial).isNull();
        });

        test('parses default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[B');
          check(output).deepEquals([CursorPosition.moveDown(1)]);
          check(partial).isNull();
        });

        test('parses resetColumn', () {
          final (output, partial) = parseAnsi('\x1B[5E');
          check(
            output,
          ).deepEquals([CursorPosition.moveDown(5, resetColumn: true)]);
          check(partial).isNull();
        });

        test('parses resetColumn default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[E');
          check(
            output,
          ).deepEquals([CursorPosition.moveDown(1, resetColumn: true)]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;5B');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[5;5B', offset: 0));
        });
      });

      group('.moveRight', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5C');
          check(output).deepEquals([CursorPosition.moveRight(5)]);
          check(partial).isNull();
        });

        test('parses default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[C');
          check(output).deepEquals([CursorPosition.moveRight(1)]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;5C');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[5;5C', offset: 0));
        });
      });

      group('.moveLeft', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5D');
          check(output).deepEquals([CursorPosition.moveLeft(5)]);
          check(partial).isNull();
        });

        test('parses default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[D');
          check(output).deepEquals([CursorPosition.moveLeft(1)]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;5D');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[5;5D', offset: 0));
        });
      });

      group('.moveColumn', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5G');
          check(output).deepEquals([CursorPosition.moveToColumn(5)]);
          check(partial).isNull();
        });

        test('parses default value (1)', () {
          final (output, partial) = parseAnsi('\x1B[G');
          check(output).deepEquals([CursorPosition.resetColumn]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;5G');
          check(output).isEmpty();
          check(partial).isNotNull().equals(Unknown('\x1B[5;5G', offset: 0));
        });
      });

      group('.moveRowColumn', () {
        test('parses', () {
          final (output, partial) = parseAnsi('\x1B[5;10H');
          check(output).deepEquals([CursorPosition.moveTo(5, 10)]);
          check(partial).isNull();
        });

        test('parses default value (1, 1)', () {
          final (output, partial) = parseAnsi('\x1B[H');
          check(output).deepEquals([CursorPosition.reset]);
          check(partial).isNull();
        });

        test('bad params', () {
          final (output, partial) = parseAnsi('\x1B[5;10;15H');
          check(output).isEmpty();
          check(
            partial,
          ).isNotNull().equals(Unknown('\x1B[5;10;15H', offset: 0));
        });
      });
    });

    group(ScrollUp, () {
      test('parses', () {
        final (output, partial) = parseAnsi('\x1B[5S');
        check(output).deepEquals([ScrollUp.byRows(5)]);
        check(partial).isNull();
      });

      test('parses default value (1)', () {
        final (output, partial) = parseAnsi('\x1B[S');
        check(output).deepEquals([ScrollUp.byRows()]);
        check(partial).isNull();
      });

      test('bad params', () {
        final (output, partial) = parseAnsi('\x1B[5;5S');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[5;5S', offset: 0));
      });
    });

    group(ScrollDown, () {
      test('parses', () {
        final (output, partial) = parseAnsi('\x1B[5T');
        check(output).deepEquals([ScrollDown.byRows(5)]);
        check(partial).isNull();
      });

      test('parses default value (1)', () {
        final (output, partial) = parseAnsi('\x1B[T');
        check(output).deepEquals([ScrollDown.byRows()]);
        check(partial).isNull();
      });

      test('bad params', () {
        final (output, partial) = parseAnsi('\x1B[5;5T');
        check(output).isEmpty();
        check(partial).isNotNull().equals(Unknown('\x1B[5;5T', offset: 0));
      });
    });

    test(SetStyles.reset, () {
      final (output, partial) = parseAnsi('\x1B[m');
      check(output).deepEquals([SetStyles.reset]);
      check(partial).isNull();
    });

    test('parses invalid SGR', () {
      final (output, partial) = parseAnsi('\x1B[999m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999m', offset: 0));
    });

    test('parses invalid SGR (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[#m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[#m', offset: 0));
    });

    test('parses invalid SGR: invalid parameter (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[38;#m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[38;#m', offset: 0));
    });

    test('parses invalid SGR: invalid parameter (not recognized)', () {
      final (output, partial) = parseAnsi('\x1B[999999m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999999m', offset: 0));
    });

    test('parses invalid SGR: invalid extended (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[38;5;#m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[38;5;#m', offset: 0));
    });

    test('parses invalid SGR: invalid RGB (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[38;2;#;0;0m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[38;2;#;0;0m', offset: 0));
    });

    test('parses invalid SGR: invalid RGB (too few parameters)', () {
      final (output, partial) = parseAnsi('\x1B[38;2;0;0m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[38;2;0;0m', offset: 0));
    });

    test('parses invalid SGR: invalid format', () {
      final (output, partial) = parseAnsi('\x1B[38;9;0;0;0;0m');
      check(output).isEmpty();
      check(
        partial,
      ).isNotNull().equals(Unknown('\x1B[38;9;0;0;0;0m', offset: 0));
    });

    test('parses invalid SGR: invalid command', () {
      final (output, partial) = parseAnsi('\x1B[999m');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999m', offset: 0));
    });

    test('parses invalid $CursorStyle command', () {
      final (output, partial) = parseAnsi('\x1B[999q');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999q', offset: 0));
    });

    test('parses invalid $MoveUp (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[#A');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[#A', offset: 0));
    });

    test('parses invalid $MoveDown (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[#E');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[#E', offset: 0));
    });

    test('parses invalid $MoveTo (not an int)', () {
      final (output, partial) = parseAnsi('\x1B[#H');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[#H', offset: 0));
    });

    test('parses invalid $Clear', () {
      final (output, partial) = parseAnsi('\x1B[999J');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999J', offset: 0));
    });

    test('parses invalid $Clear (variant-K)', () {
      final (output, partial) = parseAnsi('\x1B[999K');
      check(output).isEmpty();
      check(partial).isNotNull().equals(Unknown('\x1B[999K', offset: 0));
    });
  });

  group('DEC', () {
    test('parses SaveCursorPosition', () {
      final (output, partial) = parseAnsi('\x1B7');
      check(output).deepEquals([CursorPosition.save]);
      check(partial).isNull();
    });

    test('parses RestoreCursorPosition', () {
      final (output, partial) = parseAnsi('\x1B8');
      check(output).deepEquals([CursorPosition.restore]);
      check(partial).isNull();
    });
  });

  group('OSC', () {
    group(SetTitle, () {
      test('parses', () {
        final (output, partial) = parseAnsi('\x1B]0;Hello, World!\x07');
        check(output).deepEquals([SetTitle('Hello, World!')]);
        check(partial).isNull();
      });

      test('bad params', () {
        final (output, partial) = parseAnsi('\x1B]1;Hello, World!\x07');
        check(output).isEmpty();
        check(
          partial,
        ).isNotNull().equals(Unknown('\x1B]1;Hello, World!\x07', offset: 0));
      });
    });

    test('did not found the end of the sequence', () {
      final (output, partial) = parseAnsi('\x1B]\x1B]');
      check(output).deepEquals([Unknown('\x1B]', offset: 0)]);
      check(partial).isNotNull().equals(Unknown('\x1B]', offset: 2));
    });
  });
}
