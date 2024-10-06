An ANSI terminal allows control of the screen like a canvas or buffer, and also
provides a few other ways to interact with the terminal, such as changing the
size or title. The following sections will cover how to control the screen using
ANSI escape codes.

## Scrolling the screen

The screen can be scrolled up or down by a number of rows:

```dart
// Scrolls the screen up by 3 rows.
stdout.writeAnsi(ScrollUp.byRows(3));

// Scrolls the screen down by 3 rows.
stdout.writeAnsi(ScrollDown.byRows(3));
```

## Clearing the screen

The `Clear` enum provides variants to clear the screen; the most common are
`Clear.all` and `Clear.currentLine`:

```dart
// Clears the entire screen.
stdout.writeAnsi(Clear.all);

// Clears the current line.
stdout.writeAnsi(Clear.currentLine);
```

## Changing line wrapping

The `LineWrap` enum allows toggling line wrapping on or off:

```dart
// Turns line wrapping off.
stdout.writeAnsi(LineWrap.disable);

// Turns line wrapping on.
stdout.writeAnsi(LineWrap.enable);
```

## Changing the screen size

The `SetSize` class provides escape codes to set the screen size:

```dart
// Sets the screen size to 80 columns by 24 rows.
stdout.writeAnsi(SetSize(80, 24));
```

## Changing the screen title

The `SetTitle` class provides an escape code to set the screen title:

```dart
// Sets the screen title to "My App".
stdout.writeAnsi(SetTitle('My App'));
```

## Entering and exiting alternate screen mode

The `AlternateScreen` enum allows entering and exiting alternate screen mode:

```dart
// Enters alternate screen mode.
stdout.writeAnsi(AlternateScreen.enter);

// Exits alternate screen mode.
stdout.writeAnsi(AlternateScreen.exit);
```

It is standard practice to enter alternate screen mode when starting a program
and exit it when the program ends. This allows the program to run in a separate
screen buffer, which is useful for full-screen applications like text editors or
interactive programs.

See [best practices](Best%Practices-topic.html) for more recommendations.

## Starting and ending synchronous updates

The `SynchronousUpdate` enum allows starting and ending synchronous updates:

```dart
// Starts synchronous updates.
stdout.writeAnsi(SynchronousUpdate.start);

// Ends synchronous updates.
stdout.writeAnsi(SynchronousUpdate.end);
```

Synchronous updates are useful when you want to update the screen without
flickering or other visual artifacts. This is especially useful when updating
the screen in a loop or when updating multiple parts of the screen at once.

See [best practices](Best%Practices-topic.html) for more recommendations.

---

<div style="text-align: center">

[◄ Cursors and Positioning](Cursors%20and%20Positioning-topic.html) |
[Event Handling ►](Event%20Handling-topic.html)

</div>
