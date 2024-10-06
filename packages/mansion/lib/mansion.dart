/// A stately library for crafting and deciphering ANSI escape codes/sequences.
///
/// This library provides a cross-platform abstraction for working with ANSI
/// escape codes, a standard for [in-band signaling][1] to control
/// [CursorPosition], [Color], font styling, and other options on video text
/// terminals and terminal emulators.
///
/// [1]: https://en.wikipedia.org/wiki/In-band_signaling
///
/// # Features
///
/// The base type for all sequences is [Sequence], which represents either a
/// [Print] without escape codes, or a sub-type of [Escape] that
/// represents a specific ANSI escape code.
///
/// Sequences can be converted to/from strings using a variety of methods:
/// - [Sequence.writeAnsiString] writes to a [StringSink].
/// - [AnsiStringSink], extension methods for writing to a [StringSink].
/// - [AnsiCodec], a [Codec] for encoding/decoding sequences.
///
/// ## Cursor
///
/// - Visibility: [CursorVisibility].
/// - Appearance: [CursorStyle].
/// - Position: [CursorPosition] and subtypes (see factory constructors).
///
/// ## Events
///
/// - Keyboard: [CapturePaste].
/// - Mouse: [EnableMouseCapture], [MouseCaptureMode].
///
/// ## Style
///
/// - Styles: [SetStyles].
/// - Colors: [Color].
/// - Attributes: [StyleText].
///
/// ## Screen
///
/// - Scrolling: [ScrollUp], [ScrollDown].
/// - Miscellaneous: [Clear], [SetSize], [SetTitle], [LineWrap].
/// - Alternate screen: [AlternateScreen], [SynchronousUpdates].
library;

import 'dart:convert';

import 'package:mansion/mansion.dart';

export 'src/_mansion.dart' hide parseAnsi;
