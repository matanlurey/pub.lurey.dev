import 'dart:convert';

/// Writes XML ([RFC 3470][]) formatted output to a destination sink.
///
/// [RFC 3470]: https://tools.ietf.org/html/rfc3470
///
/// ## Example
///
/// ```dart
/// final buffer = StringBuffer();
/// final xml = XmlSink(buffer);
///
/// xml.startOpenElement('person');
/// xml.writeAttribute('name', 'Alice');
/// xml.endOpenElement();
/// xml.writeText('Hello, world!');
/// xml.closeElement();
///
/// print(buffer.toString());
/// ```
///
/// This example writes the following XML output:
///
/// ```xml
/// <person name="Alice">Hello, world!</person>
/// ```
abstract final class XmlSink {
  /// Creates an XML sink that writes to a [StringSink].
  ///
  /// The [lineTerminator] parameter can be used to customize the XML format.
  /// By default, the line terminator is `'\n'`.
  ///
  /// The [pretty] parameter can be used to enable pretty-printing. By default,
  /// pretty-printing is disabled.
  factory XmlSink(
    StringSink sink, {
    String lineTerminator,
    bool pretty,
  }) = _StringXmlSink;

  XmlSink._({
    String lineTerminator = '\n',
    bool pretty = false,
  })  : _lineTerminator = lineTerminator,
        _pretty = pretty;

  final String _lineTerminator;
  final bool _pretty;

  /// Writes raw string output.
  void _writeRaw(String output);
  void _indentIfPretty() {
    if (!_pretty || _stack.isEmpty) {
      return;
    }
    _writeRaw(_lineTerminator);
    _writeRaw('  ' * _stack.length);
  }

  /// Writes a header with the given [version] and [encoding].
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.writeHeader();
  /// ```
  void writeHeader({String version = '1.0', String encoding = 'utf-8'}) {
    _writeRaw('<?xml version="$version" encoding="$encoding"?>');
    if (_pretty) {
      _writeRaw(_lineTerminator);
    }
  }

  /// Starts and opens an element with the given [name].
  ///
  /// An element must not be open before calling this method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.startOpenElement('person');
  /// ```
  void startOpenElement(String name) {
    if (_openElement) {
      throw StateError('An element is already open.');
    }
    _indentIfPretty();
    _writeRaw('<$name');
    _openElement = true;
    _stack.add(name);
  }

  final _stack = <String>[];
  var _openElement = false;

  /// Writes an attribute with the given [name], and optionally, a [value].
  ///
  /// If [value] is `null`, the attribute is written without a value.
  ///
  /// [value] is automatically HTML-escaped.
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.writeAttribute('name', 'Alice');
  /// xml.writeAttribute('age', '30');
  /// xml.writeAttribute('awesome');
  /// ```
  void writeAttribute(String name, [String? value]) {
    if (!_openElement) {
      throw StateError('No element is open.');
    }
    _writeRaw(' $name');
    if (value != null) {
      _writeRaw('="${htmlEscape.convert(value)}"');
    }
  }

  /// Ends an open element.
  ///
  /// An element must be open before calling this method.
  ///
  /// May be called with [selfClosing] set to `true` to close the element
  /// immediately.
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.startOpenElement('person');
  /// xml.writeAttribute('name', 'Alice');
  /// xml.endOpenElement();
  /// ```
  void endOpenElement({bool selfClosing = false}) {
    if (!_openElement) {
      throw StateError('No element is open.');
    }
    if (selfClosing) {
      _writeRaw(' />');
      _stack.removeLast();
    } else {
      _writeRaw('>');
    }
    _openElement = false;
  }

  /// Writes a text node.
  ///
  /// The text is automatically HTML-escaped.
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.startOpenElement('person');
  /// xml.writeAttribute('name', 'Alice');
  /// xml.endOpenElement();
  /// xml.writeText('Hello, world!');
  /// ```
  void writeText(String text) {
    if (_openElement) {
      throw StateError('An element is still open.');
    }
    _indentIfPretty();
    _writeRaw(htmlEscape.convert(text));
  }

  /// Closes the current element.
  ///
  /// An element must be open before calling this method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// xml.startOpenElement('person');
  /// xml.writeAttribute('name', 'Alice');
  /// xml.endOpenElement();
  /// xml.closeElement();
  /// ```
  void closeElement() {
    if (_openElement) {
      throw StateError('An element is still open.');
    }
    if (_stack.isEmpty) {
      throw StateError('No element is open.');
    }
    if (_pretty) {
      _writeRaw(_lineTerminator);
    }
    final name = _stack.removeLast();
    _writeRaw('</$name>');
  }

  /// Adds a new line to the output.
  void writeNewLine() {
    _writeRaw(_lineTerminator);
  }

  /// Starts a comment.
  void startComment() {
    _indentIfPretty();
    _writeRaw('<!--');
  }

  /// Ends a comment.
  void endComment() {
    _writeRaw('-->');
  }
}

final class _StringXmlSink extends XmlSink {
  _StringXmlSink(
    this._sink, {
    super.lineTerminator,
    super.pretty,
  }) : super._();

  final StringSink _sink;

  @override
  void _writeRaw(String output) {
    _sink.write(output);
  }
}
