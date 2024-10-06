/// Structured YAML writer that writes structured data to a buffer or sink.
final class YamlSink {
  /// Creates a new instance of [YamlSink] that writes to the given sink.
  YamlSink.fromSink(this._sink);

  final StringSink _sink;
  var _indent = 0;

  void _writeLine(String line) {
    _sink.write('  ' * _indent);
    _sink.writeln(line);
  }

  /// Increases the indentation level.
  void indent() {
    _indent++;
  }

  /// Decreases the indentation level.
  ///
  /// The indentation level cannot be less than zero.
  void unindent() {
    if (_indent == 0) {
      throw StateError('Cannot dedent below zero.');
    }
    _indent--;
  }

  /// Writes a key without a value, i.e. for subsequent list or key-value pairs.
  ///
  /// The key is followed by a colon and a newline.
  ///
  /// Keys must be manually escaped if necessary.
  void writeKey(String key) {
    _writeLine('$key:');
  }

  /// Writes a key-value pair to the sink.
  ///
  /// The format of `$key: $value` is used, followed by a newline.
  ///
  /// Keys and values must be manually escaped if necessary.
  void writeKeyValue(String key, String value) {
    _writeLine('$key: $value');
  }

  /// Write a 1-line comment to the sink.
  ///
  /// The comment is prefixed with `# ` and followed by a newline.
  void writeComment(String comment) {
    _writeLine('# $comment');
  }

  /// Write a value (of a list) to the sink.
  ///
  /// The format of `- $value` is used, followed by a newline.
  ///
  /// Values must be manually escaped if necessary.
  void writeListValue(String value) {
    _writeLine('- $value');
  }
}
