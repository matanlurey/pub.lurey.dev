part of '_mansion.dart';

/// An escape code that scrolls the screen up by [rows].
///
/// Unlike [CursorPosition.moveUp], [ScrollUp] scrolls the entire screen up by
/// [rows] rows, instead of moving the cursor up by [rows] rows, including the
/// content of the screen (i.e. scrollback buffer).
///
/// > [!NOTE]
/// > This escape code is not widely supported by all terminals.
///
/// {@category Screen Manipulation}
final class ScrollUp implements Escape {
  /// Creates an escape code that scrolls the screen up by [rows].
  @literal
  const ScrollUp.byRows([this.rows = 1]);

  /// The number of rows to scroll up.
  final int rows;

  @override
  bool operator ==(Object other) {
    return other is ScrollUp && other.rows == rows;
  }

  @override
  int get hashCode => Object.hash(ScrollUp, rows);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString${rows}S');
  }

  @override
  String toString() {
    return 'ScrollUp.byRows($rows)';
  }
}

/// An escape code that scrolls the screen down by [rows].
///
/// Unlike [CursorPosition.moveDown], [ScrollDown] scrolls the entire screen
/// down by [rows] rows, instead of moving the cursor down by [rows] rows,
/// including the content of the screen (i.e. scrollback buffer).
///
/// > [!NOTE]
/// > This escape code is not widely supported by all terminals.
///
/// {@category Screen Manipulation}
final class ScrollDown implements Escape {
  /// Creates an escape code that scrolls the screen down by [rows].
  @literal
  const ScrollDown.byRows([this.rows = 1]);

  /// The number of rows to scroll down.
  final int rows;

  @override
  bool operator ==(Object other) {
    return other is ScrollDown && other.rows == rows;
  }

  @override
  int get hashCode => Object.hash(ScrollDown, rows);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString${rows}T');
  }

  @override
  String toString() {
    return 'ScrollDown.byRows($rows)';
  }
}

/// An escape that clears all or part of the screen.
///
/// This escape code can be used to clear the entire screen, the current line,
/// or the screen from the cursor up or down. Note that the cursor position is
/// _not_ changed by clearing the screen.
///
/// {@category Screen Manipulation}
enum Clear implements Escape {
  /// Clears the entire screen (all cells).
  ///
  /// The cursor position is not changed.
  all('2J'),

  /// Clears the entire screen (all cells) and scrollback buffer (history).
  ///
  /// The cursor position is not changed.
  allAndScrollback('3J'),

  /// Clears the screen from the cursor down.
  ///
  /// This clears the screen from the cursor's row to the end of the screen.
  ///
  /// The cursor position is not changed.
  afterCursor('0J'),

  /// Clears the screen from the cursor up.
  ///
  /// This clears the screen from the cursor's row to the top of the screen.
  ///
  /// The cursor position is not changed.
  beforeCursor('1J'),

  /// Clears the current line (all cells at the cursor's row).
  ///
  /// The cursor position is not changed.
  currentLine('2K'),

  /// Clears all current line after the cursor.
  ///
  /// This clears all cells from the cursor to the end of the current line.
  ///
  /// The cursor position is not changed.
  untilEndOfLine('0K');

  const Clear(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString$_code');
  }
}

/// An escape code that sets the screen size to [rows] by [columns].
///
/// The window size does not change, only the buffer size is changed.
///
/// {@category Screen Manipulation}
final class SetSize implements Escape {
  /// Creates an escape code that sets the screen size to [rows] by [columns].
  @literal
  const SetSize({
    required this.rows,
    required this.columns,
  });

  /// The number of rows in the screen.
  final int rows;

  /// The number of columns in the screen.
  final int columns;

  @override
  bool operator ==(Object other) {
    return other is SetSize && other.rows == rows && other.columns == columns;
  }

  @override
  int get hashCode => Object.hash(SetSize, rows, columns);

  @override
  void writeAnsiString(StringSink out) {
    out.write('${_csiString}8;$rows;${columns}t');
  }

  @override
  String toString() {
    return 'SetSize(rows: $rows, columns: $columns)';
  }
}

/// An escape code that sets the screen title to [title].
///
/// The title is displayed in the terminal's title bar.
///
/// {@category Screen Manipulation}
final class SetTitle implements Escape {
  /// Creates an escape code that sets the screen title to [title].
  SetTitle(String title) : title = Print.escape(title);

  /// The title to set.
  final String title;

  @override
  bool operator ==(Object other) {
    return other is SetTitle && other.title == title;
  }

  @override
  int get hashCode => Object.hash(SetTitle, title);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_escString${Escape.osiString}0;$title\x07');
  }

  @override
  String toString() {
    return 'SetTitle($title)';
  }
}

/// An escape code that [enable]s or [disable]s line wrapping.
///
/// {@category Screen Manipulation}
enum LineWrap implements Escape {
  /// Enables line wrapping.
  ///
  /// When line wrapping is enabled, text that reaches the right edge of the
  /// screen will wrap to the next line. The cursor will move to the next line
  /// when it reaches the right edge of the screen.
  ///
  /// This is the default behavior.
  enable('h'),

  /// Disables line wrapping.
  ///
  /// When line wrapping is disabled, text that reaches the right edge of the
  /// screen will not wrap to the next line. The cursor will remain at the right
  /// edge of the screen.
  ///
  /// This is useful for terminals that do not support line wrapping.
  ///
  /// > [!NOTE]
  /// > Disabling line wrapping may cause text to be truncated if it reaches the
  /// > right edge of the screen.
  disable('l');

  const LineWrap(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?7$_code');
  }
}

/// An escape code that [enter]s or [leave]s the alternate screen buffer.
///
/// The alternate screen buffer is a separate screen buffer that can be used to
/// display a different screen. When the alternate screen buffer is entered, the
/// current screen is saved and the alternate screen is displayed. When the
/// alternate screen buffer is left, the original screen is restored.
///
/// This can be used to display a different screen, such as a full-screen
/// editor, without modifying the current screen. It is good practice to leave
/// the alternate screen buffer when the editor is closed to restore the
/// original screen.
///
/// {@category Screen Manipulation}
/// {@category Best Practices}
enum AlternateScreen implements Escape {
  /// Enters the alternate screen buffer.
  ///
  /// The current screen is saved and the alternate screen is displayed.
  enter('h'),

  /// Leaves the alternate screen buffer.
  ///
  /// The original screen is restored.
  leave('l');

  const AlternateScreen(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?1049$_code');
  }
}

/// An escape code that [start]s or [end]s synchronous updates.
///
/// When synchronous updates are started, the terminal will not update the
/// screen until the updates are ended. This can be used to prevent flickering
/// when making multiple updates.
///
/// {@category Screen Manipulation}
/// {@category Best Practices}
enum SynchronousUpdates implements Escape {
  /// Starts synchronous updates.
  ///
  /// The terminal will not update the screen until synchronous updates are
  /// [end]ed.
  start('h'),

  /// Ends synchronous updates.
  ///
  /// Where supported, it typically makes sense to flush the output buffer
  /// after ending synchronous updates to ensure the updates are displayed.
  ///
  /// ```dart
  /// stdout.write(SynchronousUpdates.end);
  /// await stdout.flush();
  /// ```
  end('l');

  const SynchronousUpdates(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?2026$_code');
  }
}
