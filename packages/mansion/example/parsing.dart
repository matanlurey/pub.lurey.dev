import 'dart:convert';
import 'dart:io' as io;

import 'package:mansion/mansion.dart';

void main() {
  final decoder = const AnsiDecoder();
  final output = <List<Sequence>>[];
  final ansiSink = decoder.startChunkedConversion(
    ChunkedConversionSink.withCallback(output.addAll),
  );

  // Simulate streaming input.
  ansiSink.add('\x1b[');
  ansiSink.add('31mHello');
  ansiSink.close();

  // [[SetStyles(Style.foreground(Color.red)), Print('Hello')]]
  io.stdout.writeln(output);
}
