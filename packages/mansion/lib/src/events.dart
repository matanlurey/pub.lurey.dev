part of '_mansion.dart';

/// An escape code that [enable]s or [disable]s capturing [PasteEvent]s.
///
/// {@category Event Handling}
enum CapturePaste implements Escape {
  /// Enables bracketed paste mode.
  ///
  /// Should be paired with [CapturePaste.disable] at the end of execution.
  enable('h'),

  /// Disables bracketed paste mode.
  disable('l');

  const CapturePaste(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?2004$_code');
  }
}

/// An escape that [enable]s or [disable]s capturing [FocusEvent]s.
///
/// {@category Event Handling}
enum CaptureFocus implements Escape {
  /// Enables focus capture events.
  ///
  /// Should be paired with [CaptureFocus.disable] at the end of execution.
  enable('h'),

  /// Disables focus capture events.
  disable('l');

  const CaptureFocus(this._code);
  final String _code;

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?1004$_code');
  }
}

/// An escape that enables capturing [MouseCaptureMode] events.
///
/// {@category Event Handling}
final class EnableMouseCapture implements Escape {
  /// All possible [EnableMouseCapture] escapes.
  ///
  /// Can be used to enable all mouse capture modes at once:
  /// ```dart
  /// stdout.writeAnsiAll(EnableMouseCapture.all);
  /// ```
  static const all = [normal, button, any, sgr];

  /// An alias for enabling [MouseCaptureMode.normal]
  static const normal = EnableMouseCapture(MouseCaptureMode.normal);

  /// An alias for enabling [MouseCaptureMode.button]
  static const button = EnableMouseCapture(MouseCaptureMode.button);

  /// An alias for enabling [MouseCaptureMode.any]
  static const any = EnableMouseCapture(MouseCaptureMode.any);

  /// An alias for enabling [MouseCaptureMode.sgr]
  static const sgr = EnableMouseCapture(MouseCaptureMode.sgr);

  /// Creates an escape that enables capturing [MouseCaptureMode] events.
  @literal
  const EnableMouseCapture(this.mode);

  /// The mode to enable.
  final MouseCaptureMode mode;

  @override
  bool operator ==(Object other) {
    return other is EnableMouseCapture && other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(EnableMouseCapture, mode);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?${mode._code}h');
  }

  @override
  String toString() {
    return switch (mode) {
      MouseCaptureMode.normal => 'EnableMouseCapture.normal',
      MouseCaptureMode.button => 'EnableMouseCapture.button',
      MouseCaptureMode.any => 'EnableMouseCapture.any',
      MouseCaptureMode.sgr => 'EnableMouseCapture.sgr',
    };
  }
}

/// An escape that disables capturing [MouseCaptureMode] events.
///
/// {@category Event Handling}
final class DisableMouseCapture implements Escape {
  /// All possible [DisableMouseCapture] escapes.
  ///
  /// Can be used to disable all mouse capture modes at once:
  /// ```dart
  /// stdout.writeAnsiAll(DisableMouseCapture.all);
  /// ```
  static const all = [normal, button, any, sgr];

  /// An alias for disabling [MouseCaptureMode.normal]
  static const normal = DisableMouseCapture(MouseCaptureMode.normal);

  /// An alias for disabling [MouseCaptureMode.button]
  static const button = DisableMouseCapture(MouseCaptureMode.button);

  /// An alias for disabling [MouseCaptureMode.any]
  static const any = DisableMouseCapture(MouseCaptureMode.any);

  /// An alias for disabling [MouseCaptureMode.sgr]
  static const sgr = DisableMouseCapture(MouseCaptureMode.sgr);

  /// Creates an escape that disables capturing [MouseCaptureMode] events.
  @literal
  const DisableMouseCapture(this.mode);

  /// The mode to disable.
  final MouseCaptureMode mode;

  @override
  bool operator ==(Object other) {
    return other is DisableMouseCapture && other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(DisableMouseCapture, mode);

  @override
  void writeAnsiString(StringSink out) {
    out.write('$_csiString?${mode._code}l');
  }

  @override
  String toString() {
    return switch (mode) {
      MouseCaptureMode.normal => 'DisableMouseCapture.normal',
      MouseCaptureMode.button => 'DisableMouseCapture.button',
      MouseCaptureMode.any => 'DisableMouseCapture.any',
      MouseCaptureMode.sgr => 'DisableMouseCapture.sgr',
    };
  }
}

/// Different modes for capturing mouse events.
///
/// {@category Event Handling}
enum MouseCaptureMode {
  /// Normal tracking mode: X & Y on button press and release.
  normal(1000),

  /// Button-event tracking: button motion events.
  button(1002),

  /// Any-event tracking: all motion events.
  any(1003),

  /// SGR mouse mode: allows mouse coordinates of >223.
  sgr(1006);

  const MouseCaptureMode(this._code);
  final int _code;
}

/// Represents an event.
///
/// {@category Event Handling}
@immutable
sealed class Event {
  /// Tries to parse a list of [codes] into an [Event]
  ///
  /// Returns `null` if the event could not be parsed.
  ///
  /// **NOTE**: This method is not as heavily tested as other parts of the
  /// library, and could be made more robust. If you encounter issues, such as
  /// events not being parsed that you'd expect to be, please file an issue.
  static Event? tryParse(List<int> codes) {
    return switch (codes) {
      [0x00] => const KeyEvent(ControlKey.null$),
      [0x0a] => const KeyEvent(ControlKey.enter),
      [0x09] => const KeyEvent(ControlKey.tab),
      [0x1b] => const KeyEvent(ControlKey.escape),
      [0x1b, 0x5b, ...final rest] => switch (rest) {
          [0x32, 0x30, 0x30, 0x7e, ...final data] => PasteEvent._tryParse(data),
          [0x32, 0x7e] => const KeyEvent(ControlKey.insert),
          [0x33, 0x7e] => const KeyEvent(ControlKey.delete),
          [0x35, 0x7e] => const KeyEvent(ControlKey.pageUp),
          [0x36, 0x7e] => const KeyEvent(ControlKey.pageDown),
          [0x3c, ...final rest] => MouseEvent._tryParseSgr(rest),
          [0x41] => const KeyEvent(ControlKey.upArrow),
          [0x42] => const KeyEvent(ControlKey.downArrow),
          [0x43] => const KeyEvent(ControlKey.rightArrow),
          [0x44] => const KeyEvent(ControlKey.leftArrow),
          [0x46] => const KeyEvent(ControlKey.end),
          [0x48] => const KeyEvent(ControlKey.home),
          [0x49] => FocusEvent.gained,
          [0x4f] => FocusEvent.lost,
          [0x5a] => const KeyEvent(ControlKey.backTab),
          _ => null,
        },
      [0x7f] => const KeyEvent(ControlKey.backspace),
      [final char]
          when char >= 32 && char <= 126 || char >= 128 && char <= 255 =>
        KeyEvent(
          CharKey(String.fromCharCode(char)),
        ),
      _ => null,
    };
  }
}

/// Represents a focus event.
///
/// {@category Event Handling}
enum FocusEvent implements Event {
  /// The terminal has gained focus.
  gained,

  /// The terminal has lost focus.
  lost;
}

/// Represents a mouse event.
///
/// # Platform support
///
/// ## Mouse buttons
///
/// Some platforms and terminals do not report which mouse button was used.
///
/// See [button] for more information.
///
/// ## Key modifiers
///
/// Some platforms and terminals do not report all key modifier combinations for
/// all mouse event types. For example, macOS reports `Ctrl` + left mouse button
/// clicks as a right mouse button click.
///
/// {@category Event Handling}
@immutable
final class MouseEvent implements Event {
  /// Creates a mouse event with the given properties.
  MouseEvent({
    required this.row,
    required this.column,
    required this.kind,
    required this.button,
  });

  static MouseEvent? _tryParseSgr(List<int> codes) {
    final parts = String.fromCharCodes(
      codes.sublist(0, codes.length - 1),
    ).split(';');
    if (parts.length != 3) {
      return null;
    }

    final [flags, x, y] = [
      int.tryParse(parts[0]),
      int.tryParse(parts[1]),
      int.tryParse(parts[2]),
    ];
    if (flags == null || x == null || y == null) {
      return null;
    }

    // Determine kind.
    final kind = switch (flags >> 2) {
      0 => MouseEventKind.down,
      8 => MouseEventKind.moved,
      _ => null,
    };
    if (kind == null) {
      return null;
    }

    // Determine button.
    final mouseButton = switch (flags & 3) {
      0 => MouseButton.left,
      1 => MouseButton.middle,
      2 => MouseButton.right,
      _ => null,
    };

    return MouseEvent(
      row: y,
      column: x,
      kind: kind,
      button: mouseButton,
    );
  }

  /// Which mouse button was used for the event.
  ///
  /// Not all events will have a cooresponding button, for example
  /// [MouseEventKind.moved] or any scrolling of the mouse wheel.
  final MouseButton? button;

  /// The kind of mouse event.
  final MouseEventKind kind;

  /// The column where the mouse event occurred.
  final int column;

  /// The row where the mouse event occurred.
  final int row;

  @override
  bool operator ==(Object other) {
    return other is MouseEvent &&
        other.row == row &&
        other.column == column &&
        other.kind == kind &&
        other.button == button;
  }

  @override
  int get hashCode => Object.hash(MouseEvent, row, column, kind, button);

  @override
  String toString() {
    return 'MouseEvent(row: $row, column: $column, kind: $kind, button: $button)';
  }
}

/// Represents a mouse button.
///
/// {@category Event Handling}
enum MouseButton {
  /// Left mouse button.
  left,

  /// Right mouse button.
  right,

  /// Middle mouse button.
  middle;
}

/// A [MouseEvent] kind.
///
/// {@category Event Handling}
enum MouseEventKind {
  /// Pressed a mouse button.
  down,

  /// Moved the mouse cursor without pressing a button.
  moved;
}

const _shiftKey = /*0b0000_0001*/ 0x01;
const _controlKey = /*0b0000_0010*/ 0x02;
const _altKey = /*0b0000_0100*/ 0x04;

/// Represents key modifiers (shift, control, alt, etc).
///
/// {@category Event Handling}
@immutable
final class KeyModifiers {
  /// Creates a set of key modifiers.
  @literal
  const KeyModifiers({
    bool shiftKey = false,
    bool controlKey = false,
    bool altKey = false,
  }) : _flags = 0x00 |
            (shiftKey ? _shiftKey : 0) |
            (controlKey ? _controlKey : 0) |
            (altKey ? _altKey : 0);

  /// A set of key modifiers with no flags set.
  static const none = KeyModifiers._fromFlags(0);

  const KeyModifiers._fromFlags(this._flags);

  final int _flags;

  /// Whether the shift key is pressed.
  bool get shiftKey => _flags & _shiftKey != 0;

  /// Whether the control key is pressed.
  bool get controlKey => _flags & _controlKey != 0;

  /// Whether the alt key is pressed.
  bool get altKey => _flags & _altKey != 0;

  @override
  bool operator ==(Object other) {
    return other is KeyModifiers && _flags == other._flags;
  }

  @override
  int get hashCode => Object.hash(KeyModifiers, _flags);

  @override
  String toString() {
    if (_flags == 0) {
      return 'KeyModifiers.none';
    }
    final flags = <String>[];
    if (shiftKey) {
      flags.add('shiftKey');
    }
    if (controlKey) {
      flags.add('controlKey');
    }
    if (altKey) {
      flags.add('altKey');
    }
    return 'KeyModifiers(${flags.join(', ')})';
  }
}

/// Represents a key event.
///
/// {@category Event Handling}
final class KeyEvent implements Event {
  /// Creates a key event with the given properties.
  @literal
  const KeyEvent(
    this.key, {
    this.modifiers = KeyModifiers.none,
  });

  /// The key itself.
  final Key key;

  /// Additional key modifiers.
  final KeyModifiers modifiers;

  @override
  bool operator ==(Object other) {
    return other is KeyEvent &&
        other.key == key &&
        other.modifiers == modifiers;
  }

  @override
  int get hashCode => Object.hash(KeyEvent, key, modifiers);

  @override
  String toString() {
    final buffer = StringBuffer('KeyEvent($key');
    if (modifiers != KeyModifiers.none) {
      buffer.write(', modifiers: $modifiers');
    }
    buffer.write(')');
    return buffer.toString();
  }
}

/// Represents a key.
///
/// {@category Event Handling}
@immutable
sealed class Key {}

/// Represents a control key.
///
/// {@category Event Handling}
enum ControlKey implements Key {
  /// Backspace key.
  backspace,

  /// Enter key.
  enter,

  /// Left arrow key.
  leftArrow,

  /// Right arrow key.
  rightArrow,

  /// Up arrow key.
  upArrow,

  /// Down arrow key.
  downArrow,

  /// Home key.
  home,

  /// End key.
  end,

  /// Page up key.
  pageUp,

  /// Page down key.
  pageDown,

  /// Tab key.
  tab,

  /// Back tab key (Shift + Tab).
  backTab,

  /// Delete key.
  delete,

  /// Insert key.
  insert,

  /// Null key.
  null$,

  /// Escape key.
  escape;
}

/// A character key code, representing a single [character] key.
///
/// This is used for printable characters, such as `a`, `-`, `?`, etc.
///
/// {@category Event Handling}
final class CharKey implements Key {
  /// Creates a character key code with the given character.
  @literal
  const CharKey(this.character);

  /// The character for the key code.
  final String character;

  @override
  bool operator ==(Object other) {
    return other is CharKey && other.character == character;
  }

  @override
  int get hashCode => Object.hash(CharKey, character);

  @override
  String toString() => 'CharKeyCode($character)';
}

/// A string that was pasted into the terminal.
///
/// Only emitted if bracketed paste mode is enabled.
///
/// {@category Event Handling}
final class PasteEvent implements Event {
  static PasteEvent? _tryParse(List<int> codes) {
    // Parse until '0x1b' (ESC).
    final escapeIndex = codes.indexOf(0x1b);
    if (escapeIndex == -1) {
      return null;
    }
    return PasteEvent(
      String.fromCharCodes(codes.sublist(0, escapeIndex)),
    );
  }

  /// Creates a paste event with the given [text].
  @literal
  const PasteEvent(this.text);

  /// The text that was pasted.
  final String text;

  @override
  bool operator ==(Object other) {
    return other is PasteEvent && other.text == text;
  }

  @override
  int get hashCode => Object.hash(PasteEvent, text);

  @override
  String toString() => 'PasteEvent($text)';
}
