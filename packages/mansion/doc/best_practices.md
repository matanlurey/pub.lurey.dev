Writing a comprehensive _best practices_ guide for using ANSI is hard!

However, here are some general guidelines to follow when using ANSI escape
codes, when using `package:mansion`, and possible directions for future packages
that build on top of the library.

## Avoid intermediate strings

When writing performance sensitive code, avoid converting ANSI escape codes to
strings, and instead either use `<Sequence>.writeAnsiString` or
`<Sink>.writeAnsi` directly. This will avoid the overhead of creating and
manipulating intermediate strings:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() {
  final sequence = Print('Hello, World!');
  stdout.writeAnsi(sequence);
}
```

## Use `finally` when shutting down

A `try { ... } finally { ... }` is equivalent to the `defer` keyword in Go,
or the `using` keyword in C#. It is a good way to ensure that cleanup code is
always run, even if an exception is thrown:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() {
  try {
    // ... write a bunch of colors and styles ...
  } finally {
    // avoid leaving the terminal in a weird state
    stdout.writeAnsi(SetStyles.reset);
  }
}
```

More specific advice is listed below.

### Prefer alternate screen for full screen applications

When starting an application that will make heavy use of ANSI escape codes, such
as an interactive terminal application, game, text editor, or anything that will
be effectively "full screen", prefer entering an alternate screen on startup:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsi(AsciiControl.enterAlternateScreen);
  try {
    // ... your app ...
  } finally {
    stdout.writeAnsi(AsciiControl.leaveAlternateScreen);
  }
}
```

### Disable non-standard capture when shutting down

There are many ways to signal to the terminal that you want to capture events
that are not normally emited, such as `EnableMouseCapture`, `CaptureFocus`,
`CapturePaste`, and so on.

When shutting down, disable these captures to avoid leaving the terminal in a
weird state:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() {
  try {
    stdout.writeAnsi(CursorVisibility.hide);
    stdout.writeAnsiAll(EnableMouseCapture.all);
    // ... your app ...
  } finally {
    stdout.writeAnsi(CursorVisibility.show);
    stdout.writeAnsiAll(DisableMouseCapture.all);
  }
}
```

## Use `SynchronousUpdates` for performance

When writing a lot of ANSI escape codes in a row, consider using
`SynchronousUpdates` to avoid flickering:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() {
  stdout.writeAnsiAll([
    SynchronousUpdates.start,
    // ... intermediate updates ...
    SynchronousUpdates.end,
  ]);
}
```

Or, even better, use the built-in `syncAnsiUpdate` extension on `StringSink`:

```dart
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() async {
  stdout.syncAnsiUpdate((sink) {
    // Do anything here, and it will be written atomically.
  });

  // In a real application, you likely want to block on flushing as well.
  await stdout.flush();
}
```

For example, here is how you might structure a typical "game loop":

```dart
import 'dart:async';
import 'dart:io';
import 'package:mansion/mansion.dart';

void main() async {
  late final StreamSubscription<void> sigint;
  var running = true;
  try {
    sigint = ProcessSignal.sigint.watch().listen((_) {
      running = false;
    });
    final events = <List<int>>[];

    stdout.writeAnsi(AsciiControl.enterAlternateScreen);
    stdout.writeAnsi(CursorVisibility.hide);

    while (running) {
      // Process events.
      if (events.isNotEmpty) {
        final captured = events.toList();
        events.clear();
        for (final c in captured) {
          final e = Event.tryParse(c);
          // TODO: Handle the event.
        }
      }

      // Update the game state.
      // TODO: Implement this!

      // Render the game state.
      stdout.syncAnsiUpdate((sink) {
        // Clear the screen.
        sink.writeAnsi(Clear.all);

        // Draw the game state.
        // TODO: Implement this!
      }):

      await stdout.flush();
      await _wait16ms();
    }
  } finally {
    stdout.writeAnsi(CursorVisibility.show);
    stdout.writeAnsi(AsciiControl.leaveAlternateScreen);
    await sigint.cancel();
  }
}

Future<void> _wait16ms() => Future.delayed(const Duration(milliseconds: 16));
```

---

<div style="text-align: center">

[◄ Parsing ANSI Text](Parsing%20ANSI%20Text-topic.html)

</div>
