Most of the library so far has been about _producing_ ANSI escape codes. This
section is about _consuming_ and _interpreting_ them. If you are not building a
terminal emulator or a similar program, you can safely skip this section.

> [!TIP]
> Parsing ANSI could also be a viable way to test your program's output, but you
> will probably need more than is provided here, i.e. a virtual screen buffer
> and helper functions to compare it with expected output.

## Parsing ANSI escape codes

The easiest way to parse ANSI escape codes is to use `ansi.decode`:

```dart
import 'package:mansion/mansion.dart';

void main() {
  final codes = ansi.decode('\x1b[31mHello World!');
  print(codes); // [SetStyles(Style.foreground(Color.red)), Print('Hello World!')]
}
```

Note that both escape codes _and_ plain-text (`Print`) are returned.

If using the name `ansi` is incovenient (due to shadowing or other reasons), you
can also use the top-level function `decodeAnsi(...)`, which is identical to
`ansi.decode(...)`.

## Parsing streaming input

One problematic aspect of parsing ANSI escape codes is that there typically is
not a guarantee that a complete sequence will be received in a single event.

For example, imagine each line is a different event:

```txt
\x1b[
31mHello
```

If you used `ansi.decode`, the first event would be `'\x1b['`, which is not a
valid sequence. The next event would be `31mHello`, which _is_ valid, but would
be interpreted as plain text.

To handle this, you can use the _chunked_ capability of `AnsiDecoder`.

Below is a sample program that _simulates_ streaming input:

```dart
import 'dart:convert';

import 'package:mansion/mansion.dart';

void main() {
  final decoder = AnsiDecoder();
  final output = <List<Sequence>>[];
  final ansiSink = decoder.startChunkedConversion(
    ChunkedConversionSink.withCallback(output.addAll),
  );

  // Simulate streaming input.
  ansiSink.add('\x1b[');
  ansiSink.add('31mHello');
  ansiSink.close();

  print(output); // [[SetStyles(Style.foreground(Color.red)), Print('Hello')]]
}
```

## Dealing with invalid sequences

By default, decoding will throw a `FormatException` if an invalid sequence is
encountered. However, it's possible you might want to ignore invalid sequences,
or handle them in some other way (escape them, log them, file a bug against this
library, etc.).

To do this, create a custom `AnsiDecoder` with `allowInvalid: true`:

```dart
import 'package:mansion/mansion.dart';

void main() {
  final decoder = AnsiDecoder(allowInvalid: true);
  final output = decoder.convert('\x1b[invalid');

  print(output); // [Unknown('\x1b[invalid', offset: 0)]
}
```

With `allowInvalid: true`, invalid sequences are returned as `Unknown`
sequences, including the content and offset where the sequence started. This
allows you to handle them as you see fit.

---

<div style="text-align: center">

[◄ Event Handling](Event%20Handling-topic.html) |
[Best Practices ►](Best%20Practices-topic.html)

</div>
