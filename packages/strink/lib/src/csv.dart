/// Writes CSV ([RFC 4180][]) formatted output to a destination sink.
///
/// [RFC 4180]: https://tools.ietf.org/html/rfc4180
///
/// ## Example
///
/// ```dart
/// final buffer = StringBuffer();
/// final csv = CsvSink(buffer);
///
/// csv.writeField('Name');
/// csv.writeField('Age');
/// csv.endRow();
/// csv.writeField('Alice');
/// csv.writeField('30');
/// csv.endRow();
///
/// print(buffer.toString());
/// ```
///
/// This example writes the following CSV output:
///
/// ```txt
/// Name,Age
/// Alice,30
/// ```
abstract final class CsvSink {
  /// Creates a CSV sink that writes to a [StringSink].
  ///
  /// The [lineTerminator] and [fieldDelimiter] parameters can be used to
  /// customize the CSV format. By default, the line terminator is `'\n'` and
  /// the field delimiter is `','`.
  factory CsvSink(
    StringSink sink, {
    String lineTerminator,
    String fieldDelimiter,
  }) = _StringCsvSink;

  CsvSink._({String lineTerminator = '\n', String fieldDelimiter = ','})
    : _lineTerminator = lineTerminator,
      _fieldDelimiter = fieldDelimiter;

  /// Writes raw string output.
  void _writeRaw(String output);

  /// Ends the current row.
  ///
  /// If the current row is empty, this method writes an empty row.
  ///
  /// ## Example
  ///
  /// ```dart
  /// csv.writeField('Name');
  /// csv.writeField('Age');
  /// csv.endRow();
  /// csv.writeField('Alice');
  /// csv.writeField('30');
  /// csv.endRow();
  /// ```
  void endRow() {
    _writeRaw(_lineTerminator);
    _startedRow = false;
  }

  final String _lineTerminator;

  /// Writes a field value.
  ///
  /// By default, the field is quoted if it contains a comma, double quote, or
  /// newline. If [quote] is `true`, the field is always quoted. If [quote] is
  /// `false`, the field is never quoted.
  ///
  /// ## Example
  ///
  /// ```dart
  /// csv.writeField('Alice');
  /// csv.writeField('30');
  /// csv.writeField('"Jack & Jill"');
  /// csv.writeField('40', quote: true);
  void writeField(String value, {bool? quote}) {
    if (_startedRow) {
      _writeRaw(_fieldDelimiter);
    } else {
      _startedRow = true;
    }
    quote ??= value.contains(_needsQuoting);
    if (quote) {
      _writeRaw('"');
      _writeRaw(value.replaceAll('"', '""'));
      _writeRaw('"');
    } else {
      _writeRaw(value);
    }
  }

  var _startedRow = false;
  final String _fieldDelimiter;
  late final _needsQuoting = RegExp('[$_fieldDelimiter"\\n]');

  /// Writes a row of field values.
  ///
  /// Equivalent to calling [writeField] for each value in [values], followed
  /// by [endRow].
  ///
  /// ## Example
  ///
  /// ```dart
  /// csv.writeRow(['Alice', '30']);
  /// ```
  void writeRow(Iterable<String> values) {
    for (final value in values) {
      writeField(value);
    }
    endRow();
  }
}

final class _StringCsvSink extends CsvSink {
  _StringCsvSink(this._sink, {super.lineTerminator, super.fieldDelimiter})
    : super._();

  final StringSink _sink;

  @override
  void _writeRaw(String output) {
    _sink.write(output);
  }
}
