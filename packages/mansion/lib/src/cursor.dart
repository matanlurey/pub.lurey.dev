part of '_mansion.dart';

/// An escape code that [show]s or [hide]s the cursor.
///
/// {@category Cursors and Positioning}
enum CursorVisibility implements Escape {
  /// Shows the cursor.
  show('h'),

  /// Hides the cursor.
  hide('l');

  const CursorVisibility(this._char);
  final String _char;

  @override
  void writeAnsiString(StringSink out) {
    return out.write('$_csiString?25$_char');
  }
}

/// An escape code that sets the cursor style.
///
/// > [!NOTE]
/// > Not all terminals support all cursor styles. If a style is not supported,
/// > the terminal will use the default cursor style.
///
/// {@category Cursors and Positioning}
enum CursorStyle implements Escape {
  /// Default cursor shape configured by the user.
  ///
  /// This is often the same as [blinkingBlock].
  defaultUserShape('0'),

  /// A blinking block (`■`) cursor shape.
  ///
  /// This is often the same as [defaultUserShape].
  blinkingBlock('1'),

  /// A non-blinking block (`■`) cursor shape.
  ///
  /// The inverse of [blinkingBlock].
  steadyBlock('2'),

  /// A blinking underline (`_`) cursor shape.
  blinkingUnderline('3'),

  /// A non-blinking underline (`_`) cursor shape.
  ///
  /// The inverse of [blinkingUnderline].
  steadyUnderline('4'),

  /// A blinking bar (`|`) cursor shape.
  blinkingBar('5'),

  /// A non-blinking bar (`|`) cursor shape.
  ///
  /// The inverse of [blinkingBar].
  steadyBar('6');

  const CursorStyle(this._char);
  final String _char;

  @override
  void writeAnsiString(StringSink out) {
    return out.write('$_csiString${_char}q');
  }
}

/// An escape code that sets the cursor position, either relative or absolute.
///
/// The cursor position is 1-based, with the top-left corner being `(1, 1)`, and
/// the bottom-right corner being `(rows, columns)`. The cursor position is
/// stored globally, and can be [save]d and [restore]d if needed.
///
/// ## Relative Movement
///
/// The cursor can be:
///
/// - [CursorPosition.moveUp] by a given number of `rows`.
/// - [CursorPosition.moveDown] by a given number of `rows`.
/// - [CursorPosition.moveLeft] by a given number of `columns`.
/// - [CursorPosition.moveRight] by a given number of `columns`.
///
/// When moving up or down, the column position can be reset to the left-most
/// column by setting `resetColumn` to `true`, which is similar to using a
/// [AsciiControl.carriageReturn] after moving up or down.
///
/// If the cursor is moved beyond the left, top, right, or bottom edge of the
/// terminal, the behavior is dependent on the terminal. Some terminals will
/// wrap the cursor around to the opposite edge, while others will keep the
/// cursor at the edge. Scrollback regions may also affect the cursor position.
///
/// ## Absolute Movement
///
/// The cursor can be moved to an absolute position with [CursorPosition.moveTo]
/// or [CursorPosition.moveToColumn]. The cursor can also be reset to the
/// top-left corner with [CursorPosition.reset] or [CursorPosition.resetColumn].
///
/// If the cursor is moved beyond the left, top, right, or bottom edge of the
/// terminal, the behavior is dependent on the terminal. Some terminals will
/// wrap the cursor around to the opposite edge, while others will keep the
/// cursor at the edge. Scrollback regions may also affect the cursor position.
///
/// For example, one popular technique for reading the dimensions of a terminal
/// is to move the cursor to an impossible position, such as `(999, 999)`, and
/// then query the cursor position.
///
/// {@category Cursors and Positioning}
sealed class CursorPosition implements Escape {
  /// An escape code that saves the current cursor position.
  ///
  /// The cursor position is stored globally, and can be restored with
  /// [CursorPosition.restore]. When the cursor is saved, it is saved as an
  /// absolute position, not a relative position.
  static const CursorPosition save = SaveCursor._();

  /// An escape code that restores a previously [save]d cursor position.
  static const CursorPosition restore = RestoreCursor._();

  /// Creates an escape code that moves the cursor up by [rows].
  ///
  /// If [resetColumn] is `true`, the column position is reset to the left-most
  /// column after moving up, similar to using a [AsciiControl.carriageReturn].
  @literal
  const factory CursorPosition.moveUp(int rows, {bool resetColumn}) = MoveUp._;

  /// Creates an escape code that moves the cursor down by [rows].
  ///
  /// If [resetColumn] is `true`, the column position is reset to the left-most
  /// column after moving down, similar to using a
  /// [AsciiControl.carriageReturn].
  @literal
  const factory CursorPosition.moveDown(int rows, {bool resetColumn}) =
      MoveDown._;

  /// Creates an escape code that moves the cursor left by [columns].
  @literal
  const factory CursorPosition.moveLeft(int columns) = MoveLeft._;

  /// Creates an escape code that moves the cursor right by [columns].
  @literal
  const factory CursorPosition.moveRight(int columns) = MoveRight._;

  /// Creates an escape code that moves the cursor to ([row], [column]).
  ///
  /// Both [row] and [column] are 1-based, with the top-left corner being
  /// `(1, 1)`, and the default value being the top edge and left-most column
  /// respectively.
  ///
  /// See also [CursorPosition.reset] and [CursorPosition.resetColumn].
  @literal
  const factory CursorPosition.moveTo([int row, int column]) = MoveTo._;

  /// An escape code that moves the cursor to the top-left corner.
  ///
  /// This is equivalent to `CursorPosition.moveTo(1, 1)`.
  ///
  /// See also [CursorPosition.moveTo].
  static const CursorPosition reset = MoveTo._();

  /// Creates an escape code that moves the cursor to the given [column].
  ///
  /// The column is 1-based, with the left-most column being 1.
  ///
  /// See also [CursorPosition.resetColumn].
  @literal
  const factory CursorPosition.moveToColumn([int column]) = MoveToColumn._;

  /// An escape code that moves the cursor to the left-most column.
  ///
  /// This is equivalent to `CursorPosition.moveToColumn(1)`.
  ///
  /// See also [CursorPosition.moveToColumn].
  static const CursorPosition resetColumn = MoveToColumn._();
}

/// An escape code that saves the current cursor position.
///
/// The single instance and more information is [CursorPosition.save].
final class SaveCursor implements CursorPosition {
  @literal
  const SaveCursor._();

  @override
  bool operator ==(Object other) => other is SaveCursor;

  @override
  int get hashCode => (SaveCursor).hashCode;

  @override
  void writeAnsiString(StringSink out) {
    return out.write('${_escString}7');
  }

  @override
  String toString() => 'CursorPosition.save';
}

/// An escape code that restores a previously saved cursor position.
///
/// The single instance and more information is [CursorPosition.restore].
final class RestoreCursor implements CursorPosition {
  /// Creates a [RestoreCursor] escape code.
  @literal
  const RestoreCursor._();

  @override
  bool operator ==(Object other) => other is RestoreCursor;

  @override
  int get hashCode => (RestoreCursor).hashCode;

  @override
  void writeAnsiString(StringSink out) => out.write('${_escString}8');

  @override
  String toString() => 'CursorPosition.restore';
}

/// An escape code that moves the cursor a given number of [rows] up.
///
/// Create a [MoveUp] escape code with [CursorPosition.moveUp].
///
/// {@category Cursors and Positioning}
final class MoveUp implements CursorPosition {
  @literal
  const MoveUp._(this.rows, {this.resetColumn = false});

  /// The number of rows to move the cursor up.
  final int rows;

  /// Whether to reset the column position after moving up.
  final bool resetColumn;

  @override
  bool operator ==(Object other) {
    return other is MoveUp &&
        other.rows == rows &&
        other.resetColumn == resetColumn;
  }

  @override
  int get hashCode => Object.hash(MoveUp, rows, resetColumn);

  @override
  void writeAnsiString(StringSink out) {
    if (resetColumn) {
      out.write('$_csiString${rows}F');
    } else {
      out.write('$_csiString${rows}A');
    }
  }

  @override
  String toString() {
    if (resetColumn) {
      return 'CursorPosition.moveUp($rows, resetColumn: true)';
    } else {
      return 'CursorPosition.moveUp($rows)';
    }
  }
}

/// An escape code that moves the cursor a given number of [rows] down.
///
/// Create a [MoveDown] escape code with [CursorPosition.moveDown].
///
/// {@category Cursors and Positioning}
final class MoveDown implements CursorPosition {
  @literal
  const MoveDown._(this.rows, {this.resetColumn = false});

  /// The number of rows to move the cursor down.
  final int rows;

  /// Whether to reset the column position after moving down.
  final bool resetColumn;

  @override
  bool operator ==(Object other) {
    return other is MoveDown &&
        other.rows == rows &&
        other.resetColumn == resetColumn;
  }

  @override
  int get hashCode => Object.hash(MoveDown, rows, resetColumn);

  @override
  void writeAnsiString(StringSink out) {
    if (resetColumn) {
      out.write('$_csiString${rows}E');
    } else {
      out.write('$_csiString${rows}B');
    }
  }

  @override
  String toString() {
    if (resetColumn) {
      return 'CursorPosition.moveDown($rows, resetColumn: true)';
    } else {
      return 'CursorPosition.moveDown($rows)';
    }
  }
}

/// An escape code that moves the cursor a given number of [columns] left.
///
/// Create a [MoveLeft] escape code with [CursorPosition.moveLeft].
///
/// {@category Cursors and Positioning}
final class MoveLeft implements CursorPosition {
  @literal
  const MoveLeft._(this.columns);

  /// The number of columns to move the cursor left.
  final int columns;

  @override
  bool operator ==(Object other) {
    return other is MoveLeft && other.columns == columns;
  }

  @override
  int get hashCode => Object.hash(MoveLeft, columns);

  @override
  void writeAnsiString(StringSink out) {
    return out.write('$_csiString${columns}D');
  }

  @override
  String toString() => 'CursorPosition.moveLeft($columns)';
}

/// An escape code that moves the cursor a given number of [columns] right.
///
/// Create a [MoveRight] escape code with [CursorPosition.moveRight].
///
/// {@category Cursors and Positioning}
final class MoveRight implements CursorPosition {
  @literal
  const MoveRight._(this.columns);

  /// The number of columns to move the cursor right.
  final int columns;

  @override
  bool operator ==(Object other) {
    return other is MoveRight && other.columns == columns;
  }

  @override
  int get hashCode => Object.hash(MoveRight, columns);

  @override
  void writeAnsiString(StringSink out) {
    return out.write('$_csiString${columns}C');
  }

  @override
  String toString() => 'CursorPosition.moveRight($columns)';
}

/// An escape code that moves the cursor to the given ([row], [column]).
///
/// Create a [MoveTo] escape code with [CursorPosition.moveTo].
///
/// {@category Cursors and Positioning}
final class MoveTo implements CursorPosition {
  /// Creates a [MoveTo] escape code.
  @literal
  const MoveTo._([this.row = 1, this.column = 1]);

  /// The row to move the cursor to.
  final int row;

  /// The column to move the cursor to.
  final int column;

  @override
  bool operator ==(Object other) {
    return other is MoveTo && other.row == row && other.column == column;
  }

  @override
  int get hashCode => Object.hash(MoveTo, row, column);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString$row;${column}H');
  }

  @override
  String toString() {
    if (row == 1 && column == 1) {
      return 'CursorPosition.reset';
    } else {
      return 'CursorPosition.moveTo($row, $column)';
    }
  }
}

/// An escape code that moves the cursor to the given [column].
///
/// Create a [MoveToColumn] escape code with [CursorPosition.moveToColumn].
///
/// {@category Cursors and Positioning}
final class MoveToColumn implements CursorPosition {
  /// Creates a [MoveToColumn] escape code.
  @literal
  const MoveToColumn._([this.column = 1]);

  /// The column to move the cursor to.
  final int column;

  @override
  bool operator ==(Object other) {
    return other is MoveToColumn && other.column == column;
  }

  @override
  int get hashCode => Object.hash(MoveToColumn, column);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString${column}G');
  }

  @override
  String toString() {
    if (column == 1) {
      return 'CursorPosition.resetColumn';
    } else {
      return 'CursorPosition.moveToColumn($column)';
    }
  }
}
