import 'dart:convert';

import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  const decoder = AnsiDecoder(allowInvalid: true);
  const encoder = AnsiEncoder();

  group(AnsiCodec, () {
    test('decoder is AnsiDecoder', () {
      check(AnsiCodec().decoder).identicalTo(const AnsiDecoder());
    });

    test('encoder is AnsiEncoder', () {
      check(AnsiCodec().encoder).identicalTo(const AnsiEncoder());
    });
  });

  test('decodeAnsi is an alias for decode', () {
    check(
      decodeAnsi('\x1B[31mHello, World!'),
    ).deepEquals(ansi.decode('\x1B[31mHello, World!'));
  });

  test('encodeAnsi is an alias for encode', () {
    check(
      encodeAnsi([SetStyles(Style.foreground(Color4.red))]),
    ).equals(ansi.encode([SetStyles(Style.foreground(Color4.red))]));
  });

  group('$AnsiDecoder(allowInvalid: false)', () {
    // Make this explicit for tests.
    // ignore: avoid_redundant_argument_values
    const decoder = AnsiDecoder(allowInvalid: false);

    test('convert with invalid ANSI code throws FormatException', () {
      check(() => decoder.convert('\x1B[3W')).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(0)
        ..has((e) => e.message, 'message').contains('Invalid ANSI escape code')
        ..has((e) => e.source, 'source').equals('\x1B[3W');
    });
  });

  test('$AnsiDecoder(allowInvalid: true)', () {
    final sequence = Unknown('\x1B[3W', offset: 0);
    final decoded = AnsiDecoder(allowInvalid: true).convert('\x1B[3W');

    check(decoded).deepEquals([sequence]);
  });

  group('$AnsiDecoder.startChunkedConversion', () {
    // Make this explicit for tests.
    // ignore: avoid_redundant_argument_values
    const decoder = AnsiDecoder(allowInvalid: false);

    late List<List<Sequence>> out;
    late Sink<String> sink;

    setUp(() {
      out = [];
      sink = decoder.startChunkedConversion(
        ChunkedConversionSink.withCallback(out.addAll),
      );
    });

    test('parses nothing', () {
      sink.close();

      check(out).isEmpty();
    });

    test('parses blank', () {
      sink.add('');
      sink.close();

      check(out).isEmpty();
    });

    test('parses literal text', () {
      sink.add('Hello, World!');
      sink.close();

      check(out).deepEquals([
        [Print('Hello, World!')],
      ]);
    });

    test('parses ANSI code', () {
      sink.add('\x1B[31m');
      sink.close();

      check(out).deepEquals([
        [SetStyles(Style.foreground(Color4.red))],
      ]);
    });

    test('parses ANSI code and literal text', () {
      sink.add('\x1B[31mHello, World!');
      sink.close();

      check(out).deepEquals([
        [SetStyles(Style.foreground(Color4.red)), Print('Hello, World!')],
      ]);
    });

    test('parses ANSI codes and literal text on separate chunks', () {
      sink.add('\x1B[31m');
      sink.add('Hello, World!');
      sink.close();

      check(out).deepEquals([
        [SetStyles(Style.foreground(Color4.red))],
        [Print('Hello, World!')],
      ]);
    });

    test('parses ANSI code that spans chunks', () {
      sink.add('\x1B[');
      sink.add('31mHello, World!');
      sink.close();

      check(out).deepEquals([
        [SetStyles(Style.foreground(Color4.red)), Print('Hello, World!')],
      ]);
    });

    test('throws on malformed ANSI code', () {
      check(() => sink.add('\x1B[zTHAT WILL THROW')).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(0)
        ..has((e) => e.message, 'message').contains('Invalid ANSI escape code')
        ..has((e) => e.source, 'source').equals('\x1B[zTHAT WILL THROW');

      check(out).isEmpty();
    });

    test('throws on malformed ANSI code that is the last chunk', () {
      check(() => sink.add('\x1B[z')).returnsNormally();

      check(() => sink.close()).throws<FormatException>()
        ..has((e) => e.offset, 'offset').equals(0)
        ..has((e) => e.message, 'message').contains('Invalid ANSI escape code')
        ..has((e) => e.source, 'source').equals('\x1B[z');

      check(out).isEmpty();
    });
  });

  test(Print, () {
    final sequence = Print('Hello, World!');

    final encoded = encoder.convert([sequence]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence]);
  });

  test(Unknown, () {
    final sequence = Unknown('\x1B[3W', offset: 0);

    check(() => encoder.convert([sequence])).throws<UnsupportedError>();
    final encoded = const AnsiEncoder(
      allowInvalid: true,
    ).convert([sequence, Print('Hello, World!')]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence, Print('Hello, World!')]);
  });

  group(AsciiControl, () {
    for (final code in AsciiControl.values) {
      test(code.name, () {
        final encoded = encoder.convert([code]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([code]);
      });
    }
  });

  group(SetStyles, () {
    for (final attribute in StyleText.values) {
      test(attribute.name, () {
        final encoded = encoder.convert([SetStyles(attribute)]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([SetStyles(attribute)]);
      });
    }

    for (final color in Color4.values) {
      test('foreground $color', () {
        final sequence = SetStyles(Style.foreground(color));

        final encoded = encoder.convert([sequence]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([sequence]);
      });

      test('background $color', () {
        final sequence = SetStyles(Style.background(color));

        final encoded = encoder.convert([sequence]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([sequence]);
      });
    }

    test('foreground Color256', () {
      final sequence = SetStyles(Style.foreground(Color.from256(42)));

      final encoded = encoder.convert([sequence]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([sequence]);
    });

    test('background Color256', () {
      final sequence = SetStyles(Style.background(Color.from256(42)));

      final encoded = encoder.convert([sequence]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([sequence]);
    });

    test('foreground ColorRGB', () {
      final sequence = SetStyles(
        Style.foreground(Color.fromRGB(0xAA, 0xBB, 0xCC)),
      );

      final encoded = encoder.convert([sequence]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([sequence]);
    });

    test('background ColorRGB', () {
      final sequence = SetStyles(
        Style.background(Color.fromRGB(0xAA, 0xBB, 0xCC)),
      );

      final encoded = encoder.convert([sequence]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([sequence]);
    });
  });

  group(CursorVisibility, () {
    for (final visibility in CursorVisibility.values) {
      test(visibility.name, () {
        final encoded = encoder.convert([visibility]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([visibility]);
      });
    }
  });

  group(CursorStyle, () {
    for (final style in CursorStyle.values) {
      test(style.name, () {
        final encoded = encoder.convert([style]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([style]);
      });
    }
  });

  group(CursorPosition, () {
    test(CursorPosition.save, () {
      final encoded = encoder.convert([CursorPosition.save]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.save]);
    });

    test(CursorPosition.restore, () {
      final encoded = encoder.convert([CursorPosition.restore]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.restore]);
    });

    test(CursorPosition.moveUp(5), () {
      final encoded = encoder.convert([CursorPosition.moveUp(5)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveUp(5)]);
    });

    test(CursorPosition.moveDown(5), () {
      final encoded = encoder.convert([CursorPosition.moveDown(5)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveDown(5)]);
    });

    test(CursorPosition.moveLeft(5), () {
      final encoded = encoder.convert([CursorPosition.moveLeft(5)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveLeft(5)]);
    });

    test(CursorPosition.moveRight(5), () {
      final encoded = encoder.convert([CursorPosition.moveRight(5)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveRight(5)]);
    });

    test(CursorPosition.moveTo(5, 3), () {
      final encoded = encoder.convert([CursorPosition.moveTo(5, 3)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveTo(5, 3)]);
    });

    test(CursorPosition.moveToColumn(5), () {
      final encoded = encoder.convert([CursorPosition.moveToColumn(5)]);
      final decoded = decoder.convert(encoded);

      check(decoded).deepEquals([CursorPosition.moveToColumn(5)]);
    });
  });

  group(CapturePaste, () {
    for (final state in CapturePaste.values) {
      test(state.name, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });

  group(EnableMouseCapture, () {
    for (final state in EnableMouseCapture.all) {
      test(state, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });

  group(DisableMouseCapture, () {
    for (final state in DisableMouseCapture.all) {
      test(state, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });

  test(ScrollUp, () {
    final sequence = ScrollUp.byRows(5);

    final encoded = encoder.convert([sequence]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence]);
  });

  test(ScrollDown, () {
    final sequence = ScrollDown.byRows(5);

    final encoded = encoder.convert([sequence]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence]);
  });

  group(Clear, () {
    for (final clear in Clear.values) {
      test(clear.name, () {
        final encoded = encoder.convert([clear]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([clear]);
      });
    }
  });

  test(SetSize, () {
    final sequence = SetSize(rows: 5, columns: 3);

    final encoded = encoder.convert([sequence]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence]);
  });

  test(SetTitle, () {
    final sequence = SetTitle('Hello, World!');

    final encoded = encoder.convert([sequence]);
    final decoded = decoder.convert(encoded);

    check(decoded).deepEquals([sequence]);
  });

  group(LineWrap, () {
    for (final state in LineWrap.values) {
      test(state.name, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });

  group(AlternateScreen, () {
    for (final state in AlternateScreen.values) {
      test(state.name, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });

  group(SynchronousUpdates, () {
    for (final state in SynchronousUpdates.values) {
      test(state.name, () {
        final encoded = encoder.convert([state]);
        final decoded = decoder.convert(encoded);

        check(decoded).deepEquals([state]);
      });
    }
  });
}
