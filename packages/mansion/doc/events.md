As `mansion` primarily targets producing and interpreting ANSI escape codes, it
is _not_ a fully featured event handling library. However, it does provide
support for ANSI escapes that enable/disable different kinds of input events,
as well as parsing of event codes into structured data.

## A note on "raw mode"

The default behavior of a terminal is to send input to the program as soon as
it is typed. This is called "cooked mode" or "canonical mode". However, when
the terminal is in "raw mode", input is sent to the program immediately, without
waiting for a newline character. This is useful for interactive programs that
need to respond to input in real-time.

Raw mode can be enabled programatically using the `stdin` stream from `dart:io`:

```dart
import 'dart:io';

void main() {
  stdin
    ..echoMode = false
    ..lineMode = false;

  // Read input from stdin.
  stdin.listen((event) {
    print('Received event: $event');
  });
}
```

See [best practices](Best%Practices-topic.html) for more recommendations.

## Parsing events from `stdin`

The `Event` class can parse input events from `stdin` or a similar stream.

However, given this is primarily a library for producing ANSI escape codes, it
is not a fully featured event handling library. It does not provide support for
buffering input, for example, or provide any helper functions for handling
events.

A rudimentary loop could look like this:

```dart
import 'dart:io';

import 'package:mansion/mansion.dart';

void main() async {
  late final StreamSubscription<void> listener;
  try {
    // Enable raw mode when the program starts.
    stdin
      ..echoMode = false
      ..lineMode = false;

    // Create a buffer of events.
    final buffer = <List<int>>[];
    listener = stdin.listen(buffer.add);

    while (true) {
      // Always yield to the event loop.
      await Future.delayed(const Duration(milliseconds: 100));

      // If no events are available, continue.
      if (buffer.isEmpty) {
        continue;
      }

      // Copy the events and clear the buffer.
      final captured = List.from(buffer);
      buffer.clear();

      // If we receive an "escape" key, terminate the program.
      for (final input in captured) {
        switch (Event.tryParse(input)) {
          case KeyEvent(ControlKey.escape):
            return;
          default:
            print('$input');
        }
      }
    }
  } finally {
    // Disable raw mode when the program exits.
    stdin
      ..echoMode = true
      ..lineMode = true;
  }
}
```

See [best practices](Best%Practices-topic.html) for more recommendations.

## Capturing mouse events

By default, mouse events are not captured by most terminals.

The `EnableMouseCapture` escape provides variants to enable mouse events:

```dart
// Enable specific types of mouse events.
stdout.writeAnsi(EnableMouseCapture.normal);
stdout.writeAnsi(EnableMouseCapture.button);
stdout.writeAnsi(EnableMouseCapture.any);
stdout.writeAnsi(EnableMouseCapture.sgr);

// Or all mouse events at once.
stdout.writeAnsiAll(EnableMouseCapture.all);
```

After enabling mouse events, `Event.tryParse` will capture `MouseEvent`s:

```dart
final event = Event.tryParse(input);
switch (event) {
  case MouseEvent e:
    print('Mouse event: $e');
}
```

As usual, remember to disable mouse events when you are done:

```dart
// Disable mouse events.
stdout.writeAnsiAll(DisableMouseCapture.all);
```

## Capturing paste events

By default, pasting text is treated as a series of key events.

The `CapturePaste` escape provides variants to enable and disable paste
_events_, which are easily distinguishable from key events and decoded as a
single `PasteEvent`:

```dart
// Enable paste events.
stdout.writeAnsi(BracketedPaste.enable);

// Disable paste events.
stdout.writeAnsi(BracketedPaste.disable);
```

Once enabled, `Event.tryParse` will capture `PasteEvent`s:

```dart
final event = Event.tryParse(input);
switch (event) {
  case PasteEvent e:
    print('Paste event: ${e.text}');
}
```

## Capturing focus events

By default, focus events are not captured by most terminals.

The `CaptureFocus` escape provides variants to enable and disable focus events:

```dart
// Enable focus events.
stdout.writeAnsi(CaptureFocus.enable);

// Disable focus events.
stdout.writeAnsi(CaptureFocus.disable);
```

After enabling focus events, `Event.tryParse` will capture `FocusEvent`s:

```dart
final event = Event.tryParse(input);
switch (event) {
  case FocusEvent.gained:
    print('Focus gained');
  case FocusEvent.lost:
    print('Focus lost');
}
```

---

<div style="text-align: center">

[◄ Screen Manipulation](Screen%20Manipulation-topic.html) |
[Parsing ANSI Text ►](Parsing%20ANSI%20Text-topic.html)

</div>
