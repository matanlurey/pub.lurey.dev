import 'package:strink/strink.dart';

import '_prelude.dart';

void main() {
  test('writes a row field by field', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer);

    csv.writeField('Name');
    csv.writeField('Age');
    csv.endRow();
    csv.writeField('Alice');
    csv.writeField('30');
    csv.endRow();

    check(buffer.toString()).equals('Name,Age\nAlice,30\n');
  });

  test('writes a row with a field that needs quoting', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer);

    csv.writeField('Comma: ,');
    csv.writeField('Quote: "');
    csv.writeField('Newline: \n');
    csv.endRow();

    check(buffer.toString()).equals('"Comma: ,","Quote: ""","Newline: \n"\n');
  });

  test('writes a row with explicit opt-in of quoting', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer);

    csv.writeField('Name', quote: true);
    csv.endRow();

    check(buffer.toString()).equals('"Name"\n');
  });

  test('writes a row with explicit opt-out of quoting', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer);

    csv.writeField('Comma: ,', quote: false);
    csv.endRow();

    check(buffer.toString()).equals('Comma: ,\n');
  });

  test('writes a row with multiple fields', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer);

    csv.writeRow(['Name', 'Age', '"Jack & Jill"']);

    check(buffer.toString()).equals('Name,Age,"""Jack & Jill"""\n');
  });

  test('customizes the line terminator', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer, lineTerminator: '\r\n');

    csv.writeField('Name');
    csv.writeField('Age');
    csv.endRow();
    csv.writeField('Alice');
    csv.writeField('30');
    csv.endRow();

    check(buffer.toString()).equals('Name,Age\r\nAlice,30\r\n');
  });

  test('customizes the field delimiter', () {
    final buffer = StringBuffer();
    final csv = CsvSink(buffer, fieldDelimiter: ';');

    csv.writeField('Name');
    csv.writeField('Age');
    csv.endRow();
    csv.writeField('Alice');
    csv.writeField('30');
    csv.endRow();

    check(buffer.toString()).equals('Name;Age\nAlice;30\n');
  });
}
