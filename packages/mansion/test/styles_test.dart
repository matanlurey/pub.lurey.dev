import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  group('SetAttribute has expected output', () {
    final expected = {
      StyleText.bold: '\x1B[1m',
      StyleText.dim: '\x1B[2m',
      StyleText.italic: '\x1B[3m',
      StyleText.underline: '\x1B[4m',
      StyleText.blinkSlow: '\x1B[5m',
      StyleText.blinkRapid: '\x1B[6m',
      StyleText.invert: '\x1B[7m',
      StyleText.hidden: '\x1B[8m',
      StyleText.strikeThrough: '\x1B[9m',
      StyleText.fraktur: '\x1B[20m',
      StyleText.noBoldOrDoubleUnderline: '\x1B[21m',
      StyleText.noBoldOrDim: '\x1B[22m',
      StyleText.noItalicOrFraktur: '\x1B[23m',
      StyleText.noUnderline: '\x1B[24m',
      StyleText.noBlink: '\x1B[25m',
      StyleText.noReverse: '\x1B[27m',
      StyleText.noHidden: '\x1B[28m',
      StyleText.noStrikeThrough: '\x1B[29m',
      StyleText.framed: '\x1B[51m',
      StyleText.overlined: '\x1B[53m',
      StyleText.encircled: '\x1B[52m',
      StyleText.noFramedOrEncircled: '\x1B[54m',
      StyleText.noOverlined: '\x1B[55m',
      StyleText.ideogramUnderline: '\x1B[60m',
      StyleText.ideogramDoubleUnderline: '\x1B[61m',
      StyleText.ideogramOverline: '\x1B[62m',
      StyleText.ideogramDoubleOverline: '\x1B[63m',
      StyleText.ideogramStressMarking: '\x1B[64m',
      StyleText.noIdeogramAttributes: '\x1B[65m',
    };

    for (final attr in StyleText.values) {
      test('with Attribute.${attr.name}', () {
        final value = expected[attr];
        if (value == null) {
          fail('Missing expected output for $attr');
        }
        check(SetStyles(attr)).writesAnsiString.equals(value);
      });
    }
  });

  test('$SetStyles has expected equality semantics', () {
    check(SetStyles(StyleText.bold))
      ..equals(SetStyles(StyleText.bold))
      ..has((a) => a.hashCode, 'hashCode')
          .equals(SetStyles(StyleText.bold).hashCode)
      ..has((a) => a.toString(), 'toString()').equals('SetStyles(Style.bold)');
  });

  test('$SetStyles goes up to 10 styles', () {
    final styles = SetStyles(
      StyleText.bold,
      StyleText.dim,
      StyleText.italic,
      StyleText.underline,
      StyleText.blinkSlow,
      StyleText.blinkRapid,
      StyleText.invert,
      StyleText.hidden,
      StyleText.strikeThrough,
      StyleText.fraktur,
    );

    check(
      styles,
    ).writesAnsiString.equals('\x1B[1;2;3;4;5;6;7;8;9;20m');
  });

  test('$StyleReset has expected equality semantics', () {
    check(Style.reset)
      ..equals(Style.reset)
      ..has((a) => a.hashCode, 'hashCode').equals(Style.reset.hashCode)
      ..has((a) => a.toString(), 'toString()').equals('Style.reset');
    check(SetStyles.reset)
      ..equals(SetStyles.reset)
      ..has((a) => a.hashCode, 'hashCode').equals(SetStyles.reset.hashCode)
      ..has((a) => a.toString(), 'toString()').equals('SetStyles.reset');
  });
}
