/// Writes JSON ([RFC 8259][]) formatted output to a destination sink.
///
/// [RFC 8259]: https://tools.ietf.org/html/rfc8259
abstract final class YamlSink {
  /// Creates a YAML sink that writes to a [StringSink].
  ///
  /// The [lineTerminator] defaults to `'\n'`.
  factory YamlSink(
    StringSink sink, {
    String lineTerminator,
  }) = _StringYamlSink;

  YamlSink._({
    String lineTerminator = '\n',
  }) : _lineTerminator = lineTerminator;

  final String _lineTerminator;

  /// Writes raw string output.
  void _writeRaw(String output);

  void _writeIndent() {
    _writeRaw('  ' * _indent);
  }

  var _indent = 0;

  /// Starts an object of key-value pairs or a list of values.
  ///
  /// To quote the key, set [quote] to `true`.
  void startObjectOrList(String key, {bool? quote}) {
    _writeIndent();
    if (quote ?? false) {
      _writeRaw('"$key":');
    } else {
      _writeRaw('$key:');
    }
    _writeRaw(_lineTerminator);
    _indent++;
  }

  /// Ends the current object or list.
  ///
  /// An object or list must have been started before calling this method.
  void endObjectOrList() {
    if (_indent == 0) {
      throw StateError('Cannot end object or list without starting one.');
    }
    _indent--;
  }

  /// Writes a key-value pair to the sink.
  ///
  /// The format of `$key: $value` is used, followed by a newline.
  ///
  /// To quote the key or value, set [quoteKey] or [quoteValue] to `true`.
  void writeKeyValue(
    String key,
    String value, {
    bool? quoteKey,
    bool? quoteValue,
  }) {
    _writeIndent();
    if (quoteKey ?? false) {
      _writeRaw('"$key": ');
    } else {
      _writeRaw('$key: ');
    }
    if (quoteValue ?? false) {
      _writeRaw('"$value"');
    } else {
      _writeRaw(value);
    }
    _writeRaw(_lineTerminator);
  }

  /// Writes a list value to the sink.
  ///
  /// The format of `- $value` is used, followed by a newline.
  ///
  /// To quote the value, set [quote] to `true`.
  void writeListValue(String value, {bool? quote}) {
    _writeIndent();
    _writeRaw('- ');
    if (quote ?? false) {
      _writeRaw('"$value"');
    } else {
      _writeRaw(value);
    }
    _writeRaw(_lineTerminator);
  }

  /// Writes a list object to the sink.
  ///
  /// The format of `- $key: $value` is used, followed by a newline.
  ///
  /// To quote the key or value, set [quoteKey] or [quoteValue] to `true`.
  void writeListObject(
    String key,
    String value, {
    bool? quoteKey,
    bool? quoteValue,
  }) {
    _writeIndent();
    _writeRaw('- ');
    if (quoteKey ?? false) {
      _writeRaw('"$key": ');
    } else {
      _writeRaw('$key: ');
    }
    if (quoteValue ?? false) {
      _writeRaw('"$value"');
    } else {
      _writeRaw(value);
    }
    _writeRaw(_lineTerminator);
    _indent++;
  }

  /// Writes a comment to the sink.
  ///
  /// The comment is prefixed with `# ` and followed by a newline.
  void writeComment(String comment) {
    _writeIndent();
    _writeRaw('# $comment');
    _writeRaw(_lineTerminator);
  }

  /// Writes a newline (empty line) to the sink.
  void writeNewline() {
    _writeRaw(_lineTerminator);
  }
}

final class _StringYamlSink extends YamlSink {
  _StringYamlSink(
    this._sink, {
    super.lineTerminator,
  }) : super._();

  final StringSink _sink;

  @override
  void _writeRaw(String output) {
    _sink.write(output);
  }
}
