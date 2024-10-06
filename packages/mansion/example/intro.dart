import 'dart:io';

import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsiAll([
    SetStyles(Style.foreground(Color.fromRGB(255, 0, 0))),
    Print('Hello, World!'),
    SetStyles.reset,
    AsciiControl.lineFeed,
  ]);
}
