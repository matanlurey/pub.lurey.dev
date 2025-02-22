import 'package:mansion/mansion.dart';

import 'prelude.dart';

void main() {
  test('AsciiEscapeCode writes the expected output', () {
    check(AsciiControl.values).writesAnsiStrings.deepEquals({
      AsciiControl.terminalBell: '\x07',
      AsciiControl.backspace: '\x08',
      AsciiControl.horizontalTab: '\x09',
      AsciiControl.lineFeed: '\x0A',
      AsciiControl.verticalTab: '\x0B',
      AsciiControl.formFeed: '\x0C',
      AsciiControl.carriageReturn: '\x0D',
      AsciiControl.delete: '\x7F',
    });
  });
}
