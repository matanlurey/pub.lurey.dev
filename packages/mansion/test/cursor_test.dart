import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  test('CursorVisibility writes the expected output', () {
    check(
      CursorVisibility.values,
    ).writesAnsiStrings.deepEquals({
      CursorVisibility.hide: '\x1B[?25l',
      CursorVisibility.show: '\x1B[?25h',
    });
  });

  group('CursorStyle writes the expected output', () {
    check(CursorStyle.values).writesAnsiStrings.deepEquals({
      CursorStyle.defaultUserShape: '\x1B[0q',
      CursorStyle.blinkingBlock: '\x1B[1q',
      CursorStyle.steadyBlock: '\x1B[2q',
      CursorStyle.blinkingUnderline: '\x1B[3q',
      CursorStyle.steadyUnderline: '\x1B[4q',
      CursorStyle.blinkingBar: '\x1B[5q',
      CursorStyle.steadyBar: '\x1B[6q',
    });
  });

  group('CursorPosition', () {
    test('.save writes the expected output', () {
      check(CursorPosition.save).writesAnsiString.equals('\x1B7');
    });

    test('.save has the expected equality semantics', () {
      check(CursorPosition.save)
        ..equals(CursorPosition.save)
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.save.hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.save',
        );
    });

    test('.restore writes the expected output', () {
      check(CursorPosition.restore).writesAnsiString.equals('\x1B8');
    });

    test('.restore has the expected ==, hashCode, and toString()', () {
      check(CursorPosition.restore)
        ..equals(CursorPosition.restore)
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.restore.hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.restore',
        );
    });

    test('.moveUp writes the expected output', () {
      check(CursorPosition.moveUp(5)).writesAnsiString.equals('\x1B[5A');
    });

    test('.moveUp has the expected equality semantics', () {
      check(CursorPosition.moveUp(5))
        ..equals(CursorPosition.moveUp(5))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveUp(5).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveUp(5)',
        );
    });

    test('.moveUp with resetColumn: true writes the expected output', () {
      check(CursorPosition.moveUp(5, resetColumn: true))
          .writesAnsiString
          .equals('\x1B[5F');
    });

    test('.moveUp with resetColumn: true has the equality semantics', () {
      check(CursorPosition.moveUp(5, resetColumn: true))
        ..equals(CursorPosition.moveUp(5, resetColumn: true))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveUp(5, resetColumn: true).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveUp(5, resetColumn: true)',
        );
    });

    test('.moveDown writes the expected output', () {
      check(CursorPosition.moveDown(5)).writesAnsiString.equals('\x1B[5B');
    });

    test('.moveDown has the expected equality semantics', () {
      check(CursorPosition.moveDown(5))
        ..equals(CursorPosition.moveDown(5))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveDown(5).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveDown(5)',
        );
    });

    test('.moveDown with resetColumn: true writes the expected output', () {
      check(CursorPosition.moveDown(5, resetColumn: true))
          .writesAnsiString
          .equals('\x1B[5E');
    });

    test('.moveDown with resetColumn: true has the equality semantics', () {
      check(CursorPosition.moveDown(5, resetColumn: true))
        ..equals(CursorPosition.moveDown(5, resetColumn: true))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveDown(5, resetColumn: true).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveDown(5, resetColumn: true)',
        );
    });

    test('.moveRight writes the expected output', () {
      check(CursorPosition.moveRight(5)).writesAnsiString.equals('\x1B[5C');
    });

    test('.moveRight has the expected equality semantics', () {
      check(CursorPosition.moveRight(5))
        ..equals(CursorPosition.moveRight(5))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveRight(5).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveRight(5)',
        );
    });

    test('.moveLeft writes the expected output', () {
      check(CursorPosition.moveLeft(5)).writesAnsiString.equals('\x1B[5D');
    });

    test('.moveLeft has the expected equality semantics', () {
      check(CursorPosition.moveLeft(5))
        ..equals(CursorPosition.moveLeft(5))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveLeft(5).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveLeft(5)',
        );
    });

    test('.moveRowColumn writes the expected output', () {
      check(CursorPosition.moveTo(5, 10)).writesAnsiString.equals('\x1B[5;10H');
    });

    test('.moveRowColumn has the expected equality semantics', () {
      check(CursorPosition.moveTo(5, 10))
        ..equals(CursorPosition.moveTo(5, 10))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveTo(5, 10).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveTo(5, 10)',
        );
    });

    test('.resetRowColumn writes the expected output', () {
      check(CursorPosition.reset).writesAnsiString.equals('\x1B[1;1H');
    });

    test('.resetRowColumn has the expected equality semantics', () {
      check(CursorPosition.reset)
        ..equals(CursorPosition.reset)
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.reset.hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.reset',
        );
    });

    test('.moveColumn writes the expected output', () {
      check(CursorPosition.moveToColumn(5)).writesAnsiString.equals('\x1B[5G');
    });

    test('.moveColumn has the expected equality semantics', () {
      check(CursorPosition.moveToColumn(5))
        ..equals(CursorPosition.moveToColumn(5))
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.moveToColumn(5).hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.moveToColumn(5)',
        );
    });

    test('.resetColumn writes the expected output', () {
      check(CursorPosition.resetColumn).writesAnsiString.equals('\x1B[1G');
    });

    test('.resetColumn has the expected equality semantics', () {
      check(CursorPosition.resetColumn)
        ..equals(CursorPosition.resetColumn)
        ..has(
          (p) => p.hashCode,
          'hashCode',
        ).equals(CursorPosition.resetColumn.hashCode)
        ..has((p) => p.toString(), 'toString()').equals(
          'CursorPosition.resetColumn',
        );
    });
  });
}
