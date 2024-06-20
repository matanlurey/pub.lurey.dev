import 'dart:io';

import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsiAll([
    SetStyles(
      Style.bold,
      Style.underline,
      Style.italic,
      Style.foreground(Color.red),
      Style.background(Color.green),
    ),
    Print('Hello, World!'),
    SetStyles.reset,
    AsciiControl.lineFeed,
  ]);
}
