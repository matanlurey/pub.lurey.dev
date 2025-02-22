part of '_mansion.dart';

/// A regular expression for matching escape sequences.
///
/// This matches any sequence that starts with an escape character (`\x1B`)
/// and a bracket (`[`) and ends with a letter, and matches on two groups; group
/// 1 are the parameters, including prefixes if any, and group 2 is the command.
final _csiRegExp = RegExp(r'\x1B\[(.*?)([a-zA-Z])');

/// Parses escape sequences from a string [input] and writes them to [output].
///
/// An incomplete sequence at the end of the input is returned as an
/// [Unknown], otherwise `null` if the input was fully consumed.
///
/// **NOTE**: This is internal-only API as it's sort of a mess and not meant to
/// be used outside of this library, the user-visible API is the [AnsiDecoder]
/// class.
@internal
@visibleForTesting
Unknown? parseAnsi(String input, List<Sequence> output) {
  var consumed = 0;
  void addLiteralText(int end) {
    if (consumed == end) {
      return;
    }
    assert(consumed < end, 'consumed ($consumed) >= end ($end)');
    try {
      output.add(Print.checkInvalid(input.substring(consumed, end)));
      // coverage:ignore-start
    } on FormatException catch (e) {
      throw StateError('Failed to parse literal text: $e. This is a bug!');
      // coverage:ignore-end
    }
    consumed = end;
  }

  // Iterate through the input and find all control characters and escapes.
  //
  // When we hit an ASCII control character:
  // 1. Add the text before the control character as a literal text.
  // 2. Add the control character as a literal text.
  // 3. Continue.
  //
  // When we have an escape character:
  // 1. Add the text before the escape character as a literal text.
  // 2. Parse the escape sequence.
  // 3. Continue.
  for (var i = 0; i < input.length; i++) {
    final code = input.codeUnitAt(i);
    switch (code) {
      // ASCII control characters.
      case 0x07: // Bell
      case 0x08: // Backspace
      case 0x09: // Horizontal tab
      case 0x0A: // Line feed
      case 0x0B: // Vertical tab
      case 0x0C: // Form feed
      case 0x0D: // Carriage return
        addLiteralText(i);
        output.add(AsciiControl.values[code - 0x07]);
        consumed = i + 1;
      case 0x7F: // Delete
        addLiteralText(i);
        output.add(AsciiControl.delete);
        consumed = i + 1;

      // Escape character.
      case 0x1B:
        addLiteralText(i);

        // Match the escape sequence.
        //
        // First check for EOI.
        final next = i + 1;
        if (next == input.length) {
          return Unknown(input.substring(i), offset: i);
        }

        // Next, look at the next character.
        // It could possibly be:
        // 1. A '[' for a CSI sequence.
        // 2. A ']' for an OSC sequence.
        // 3. A '7' or '8' for a privte DEC sequence.
        // 4. Anything else is an unknown escape code.
        final nextCode = input.codeUnitAt(next);
        switch (nextCode) {
          case 0x5B: // [
            // Parse the CSI sequence.
            final match = _csiRegExp.matchAsPrefix(input, i);
            if (match == null) {
              // Create an unknown escape code for the incomplete sequence.
              // i.e. the escape code and the bracket, but no command.
              final unknown = Unknown(input.substring(i, next + 1), offset: i);

              // Are we at the end of the input?
              if (next + 1 == input.length) {
                return unknown;
              }

              output.add(unknown);
              consumed = next + 1;
              break;
            }

            Unknown? unrecognizedMatch() {
              final unknown = Unknown(input.substring(i, match.end), offset: i);

              // Are we at the end of the input?
              if (match.end == input.length) {
                return unknown;
              }

              output.add(unknown);
              return null;
            }

            // Read the parameters and the command.
            final [params!, command!] = match.groups([1, 2]);

            switch (command) {
              case 'h':
                switch (params) {
                  case '?7':
                    output.add(LineWrap.enable);
                  case '?25':
                    output.add(CursorVisibility.show);
                  case '?1000':
                    output.add(EnableMouseCapture.normal);
                  case '?1002':
                    output.add(EnableMouseCapture.button);
                  case '?1003':
                    output.add(EnableMouseCapture.any);
                  case '?1006':
                    output.add(EnableMouseCapture.sgr);
                  case '?1049':
                    output.add(AlternateScreen.enter);
                  case '?2004':
                    output.add(CapturePaste.enable);
                  case '?2026':
                    output.add(SynchronousUpdates.start);
                  default:
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                }
              case 'l':
                switch (params) {
                  case '?7':
                    output.add(LineWrap.disable);
                  case '?25':
                    output.add(CursorVisibility.hide);
                  case '?1000':
                    output.add(DisableMouseCapture.normal);
                  case '?1002':
                    output.add(DisableMouseCapture.button);
                  case '?1003':
                    output.add(DisableMouseCapture.any);
                  case '?1006':
                    output.add(DisableMouseCapture.sgr);
                  case '?1049':
                    output.add(AlternateScreen.leave);
                  case '?2004':
                    output.add(CapturePaste.disable);
                  case '?2026':
                    output.add(SynchronousUpdates.end);
                  default:
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                }
              case 'm':
                if (params.isEmpty) {
                  output.add(SetStyles.reset);
                  break;
                }
                final split = params.split(';');
                final styles = <Style>{};
                for (var n = 0; n < split.length; n++) {
                  final param = int.tryParse(split[n]);
                  if (param == null) {
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                    break;
                  }

                  switch (param) {
                    case 38:
                    case 48:
                      if (n + 2 >= split.length) {
                        if (unrecognizedMatch() case final Unknown u) {
                          return u;
                        }
                        break;
                      }

                      final format = int.tryParse(split[n + 1]);
                      if (format == 5) {
                        final color = int.tryParse(split[n + 2]);
                        if (color == null) {
                          if (unrecognizedMatch() case final Unknown u) {
                            return u;
                          }
                          break;
                        }

                        final color256 = Color.from256(color);
                        if (param == 38) {
                          styles.add(Style.foreground(color256));
                        } else {
                          styles.add(Style.background(color256));
                        }
                        n += 2;
                        continue;
                      } else if (format == 2) {
                        if (n + 4 >= split.length) {
                          if (unrecognizedMatch() case final Unknown u) {
                            return u;
                          }
                          break;
                        }

                        final r = int.tryParse(split[n + 2]);
                        final g = int.tryParse(split[n + 3]);
                        final b = int.tryParse(split[n + 4]);
                        if (r == null || g == null || b == null) {
                          if (unrecognizedMatch() case final Unknown u) {
                            return u;
                          }
                          break;
                        }

                        final colorRgb = Color.fromRGB(r, g, b);
                        if (param == 38) {
                          styles.add(Style.foreground(colorRgb));
                        } else {
                          styles.add(Style.background(colorRgb));
                        }
                        n += 4;
                        continue;
                      } else {
                        if (unrecognizedMatch() case final Unknown u) {
                          return u;
                        }
                        break;
                      }
                  }

                  final sequence = _parseSgr(param);
                  if (sequence == null) {
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                    break;
                  }

                  styles.add(sequence);
                }
                output.add(SetStyles.from(styles));
              case 'q':
                switch (params) {
                  case '0':
                    output.add(CursorStyle.defaultUserShape);
                  case '1':
                    output.add(CursorStyle.blinkingBlock);
                  case '2':
                    output.add(CursorStyle.steadyBlock);
                  case '3':
                    output.add(CursorStyle.blinkingUnderline);
                  case '4':
                    output.add(CursorStyle.steadyUnderline);
                  case '5':
                    output.add(CursorStyle.blinkingBar);
                  case '6':
                    output.add(CursorStyle.steadyBar);
                  default:
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                }
              case 't':
                final split = params.split(';');
                if (split.length != 3 || split.first != '8') {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                final rows = int.tryParse(split[1]);
                final columns = int.tryParse(split[2]);
                if (rows == null || columns == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(SetSize(rows: rows, columns: columns));
              case 'A':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveUp(rows));
              case 'B':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveDown(rows));
              case 'C':
                int? cols;
                if (params.isEmpty) {
                  cols = 1;
                } else {
                  cols = int.tryParse(params);
                }
                if (cols == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveRight(cols));
              case 'D':
                int? cols;
                if (params.isEmpty) {
                  cols = 1;
                } else {
                  cols = int.tryParse(params);
                }
                if (cols == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveLeft(cols));
              case 'E':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveDown(rows, resetColumn: true));
              case 'F':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveUp(rows, resetColumn: true));
              case 'G':
                int? cols;
                if (params.isEmpty) {
                  cols = 1;
                } else {
                  cols = int.tryParse(params);
                }
                if (cols == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveToColumn(cols));
              case 'H':
                int? rows;
                int? cols;
                if (params.isEmpty) {
                  rows = cols = 1;
                } else {
                  final split = params.split(';');
                  if (split.length != 2) {
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                    break;
                  }
                  rows = int.tryParse(split[0]);
                  cols = int.tryParse(split[1]);
                }
                if (rows == null || cols == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(CursorPosition.moveTo(rows, cols));
              case 'J':
                switch (params) {
                  case '0':
                    output.add(Clear.afterCursor);
                  case '1':
                    output.add(Clear.beforeCursor);
                  case '2':
                    output.add(Clear.all);
                  case '3':
                    output.add(Clear.allAndScrollback);
                  default:
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                }
              case 'K':
                switch (params) {
                  case '0':
                    output.add(Clear.untilEndOfLine);
                  case '2':
                    output.add(Clear.currentLine);
                  default:
                    if (unrecognizedMatch() case final Unknown u) {
                      return u;
                    }
                }
              case 'S':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(ScrollUp.byRows(rows));
              case 'T':
                int? rows;
                if (params.isEmpty) {
                  rows = 1;
                } else {
                  rows = int.tryParse(params);
                }
                if (rows == null) {
                  if (unrecognizedMatch() case final Unknown u) {
                    return u;
                  }
                  break;
                }
                output.add(ScrollDown.byRows(rows));
              default:
                if (unrecognizedMatch() case final Unknown u) {
                  return u;
                }
            }

            // Regardless of the command, we consumed the entire sequence.
            consumed = match.end;
            i = consumed - 1;
          case 0x5D: // ]
            // Parse the OSC sequence.
            final end = input.indexOf('\x07', next);
            if (end == -1 ||
                end - next < 2 ||
                input.substring(next + 1, next + 3) != '0;') {
              // Are we at the end of the input?
              if (end + 1 == input.length ||
                  end == -1 && next + 1 == input.length) {
                return Unknown(input.substring(i), offset: i);
              }

              output.add(
                Unknown(input.substring(i, end == -1 ? i + 2 : end), offset: i),
              );
              consumed = next + 1;
              i = consumed - 1;
              break;
            }

            // Get the title
            final title = input.substring(next + 3, end);
            output.add(SetTitle(title));
            consumed = end + 1;
            i = consumed - 1;
          case 0x37: // 7
            output.add(CursorPosition.save);
            consumed = next + 1;
            i = consumed - 1;
          case 0x38: // 8
            output.add(CursorPosition.restore);
            consumed = next + 1;
            i = consumed - 1;
          default:
            final unknown = Unknown(input.substring(i, next), offset: i);
            consumed = next;
            output.add(unknown);
        }
    }
  }

  // Add the remaining text as a literal text.
  if (consumed < input.length) {
    addLiteralText(input.length);
  }

  return null;
}

Style? _parseSgr(int param) {
  return switch (param) {
    0 => Style.reset,
    1 => Style.bold,
    2 => Style.dim,
    3 => Style.italic,
    4 => Style.underline,
    5 => Style.blinkSlow,
    6 => Style.blinkRapid,
    7 => Style.invert,
    8 => Style.hidden,
    9 => Style.strikeThrough,
    20 => Style.fraktur,
    21 => Style.noBoldOrDoubleUnderline,
    22 => Style.noBoldOrDim,
    23 => Style.noItalicOrFraktur,
    24 => Style.noUnderline,
    25 => Style.noBlink,
    27 => Style.noReverse,
    28 => Style.noHidden,
    29 => Style.noStrikeThrough,
    30 => Style.foreground(Color4.black),
    31 => Style.foreground(Color4.red),
    32 => Style.foreground(Color4.green),
    33 => Style.foreground(Color4.yellow),
    34 => Style.foreground(Color4.blue),
    35 => Style.foreground(Color4.magenta),
    36 => Style.foreground(Color4.cyan),
    37 => Style.foreground(Color4.white),
    40 => Style.background(Color4.black),
    41 => Style.background(Color4.red),
    42 => Style.background(Color4.green),
    43 => Style.background(Color4.yellow),
    44 => Style.background(Color4.blue),
    45 => Style.background(Color4.magenta),
    46 => Style.background(Color4.cyan),
    47 => Style.background(Color4.white),
    51 => Style.framed,
    52 => Style.encircled,
    53 => Style.overlined,
    54 => Style.noFramedOrEncircled,
    55 => Style.noOverlined,
    60 => Style.ideogramUnderline,
    61 => Style.ideogramDoubleUnderline,
    62 => Style.ideogramOverline,
    63 => Style.ideogramDoubleOverline,
    64 => Style.ideogramStressMarking,
    65 => Style.noIdeogramAttributes,
    90 => Style.foreground(Color4.brightBlack),
    91 => Style.foreground(Color4.brightRed),
    92 => Style.foreground(Color4.brightGreen),
    93 => Style.foreground(Color4.brightYellow),
    94 => Style.foreground(Color4.brightBlue),
    95 => Style.foreground(Color4.brightMagenta),
    96 => Style.foreground(Color4.brightCyan),
    97 => Style.foreground(Color4.brightWhite),
    100 => Style.background(Color4.brightBlack),
    101 => Style.background(Color4.brightRed),
    102 => Style.background(Color4.brightGreen),
    103 => Style.background(Color4.brightYellow),
    104 => Style.background(Color4.brightBlue),
    105 => Style.background(Color4.brightMagenta),
    106 => Style.background(Color4.brightCyan),
    107 => Style.background(Color4.brightWhite),
    _ => null,
  };
}
