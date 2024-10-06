If you are using this library entirely to append text, you may never need to
move the cursor. However, if you are building a terminal application, game, or
other interactive program, you will need to move the cursor around the screen.
Fortunately, this is easy to do with ANSI escape codes.

## Moving the cursor

The cursor can either be moved _relative_ to its current position or _absolute_
in the viewport. In both cases the `CursorPosition` class provides all of the
necessary escape codes via it's static fields and constructors.

### Relative movement

Use `CursorPosition.moveUp`, `.moveDown`, `.moveRight`, and `.moveLeft`:

```dart
// Moves the cursor up 3 rows and right 5 columns.
stdout.writeAnsi(CursorPosition.moveUp(3));
stdout.writeAnsi(CursorPosition.moveRight(5));
```

If the amount of rows or columns is omitted, the cursor will move by one:

```dart
// Moves the cursor down one row.
stdout.writeAnsi(CursorPosition.moveDown());
```

### Absolute movement

The cursor can be moved to an absolute position using `CursorPosition.moveTo`:

```dart
// Row 5, column 10.
stdout.writeAnsi(CursorPosition.moveTo(5, 10));
```

Or, reset the cursor to the top-left corner of the viewport:

```dart
// Alias for CursorPosition.moveTo(1, 1).
stdout.writeAnsi(CursorPosition.reset);
```

To move just the column:

```dart
// Column 10.
stdout.writeAnsi(CursorPosition.moveToColumn(10));
```

Or reset the column to the left edge of the viewport:

```dart
// Alias for CursorPosition.moveToColumn(1).
stdout.writeAnsi(CursorPosition.resetColumn);
```
  
### Saving and restoring the cursor position

Sometimes the user will have control over the cursor position, and it is
important to restore the cursor to its original position after moving it. This
can be done using `CursorPosition.save` and `CursorPosition.restore`:

```dart
stdout.writeAnsi(CursorPosition.save);
// .. operations that move the cursor ..
stdout.writeAnsi(CursorPosition.restore);
```

## Changing the cursor style

The cursor can be changed to a block, underline, or vertical bar using
`CursorStyle`:

```dart
// Changes the cursor to an underline.
stdout.writeAnsi(CursorStyle.underline);
```

## Hiding the cursor

The cursor can be hidden or made visible using `CursorVisibility`:

```dart
// Hides the cursor.
stdout.writeAnsi(CursorVisibility.hide);
```

It is good practice to hide the cursor when you will be moving it around the
screen, and show it when you are done.

---

<div style="text-align: center">

[◄ Styles and Colors](Styles%20and%20Colors-topic.html) |
[Screen Manipulation ►](Screen%20Manipulation-topic.html)

</div>
