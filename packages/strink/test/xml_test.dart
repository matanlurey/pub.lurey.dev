import 'package:strink/strink.dart';

import '_prelude.dart';

void main() {
  test('writes an XML header', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.writeHeader();

    check(buffer.toString()).equals('<?xml version="1.0" encoding="utf-8"?>');
  });

  test('writes an empty element', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('empty');
    xml.endOpenElement();
    xml.closeElement();

    check(buffer.toString()).equals('<empty></empty>');
  });

  test('writes a self-closing element', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('self-closing');
    xml.endOpenElement(selfClosing: true);

    check(buffer.toString()).equals('<self-closing />');
  });

  test('writes an element with an attribute', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');
    xml.writeAttribute('name', 'Alice');
    xml.endOpenElement();
    xml.closeElement();

    check(buffer.toString()).equals('<person name="Alice"></person>');
  });

  test('writes an element with multiple attributes', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');
    xml.writeAttribute('name', 'Alice');
    xml.writeAttribute('age', '30');
    xml.endOpenElement();
    xml.closeElement();

    check(buffer.toString()).equals('<person name="Alice" age="30"></person>');
  });

  test('writes an element with text content', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');
    xml.endOpenElement();
    xml.writeText('Hello, world!');
    xml.closeElement();

    check(buffer.toString()).equals('<person>Hello, world!</person>');
  });

  test('writes an element with mixed content', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');
    xml.endOpenElement();
    xml.writeText('Hello, ');
    xml.startOpenElement('em');
    xml.endOpenElement();
    xml.writeText('world');
    xml.closeElement();
    xml.closeElement();

    check(buffer.toString()).equals('<person>Hello, <em>world</em></person>');
  });

  test('writes a comment', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startComment();
    xml.writeText('This is a comment.');
    xml.endComment();

    check(buffer.toString()).equals('<!--This is a comment.-->');
  });

  test('pretty-prints', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer, pretty: true);

    xml.writeHeader();
    xml.startOpenElement('person');
    xml.writeAttribute('name', 'Alice');
    xml.endOpenElement();
    xml.writeText('Hello, world!');
    xml.closeElement();

    check(buffer.toString()).equals(
      '<?xml version="1.0" encoding="utf-8"?>\n'
      '<person name="Alice">\n  Hello, world!\n</person>',
    );
  });

  test('customizes the line terminator', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer, lineTerminator: '\r\n', pretty: true);

    xml.startOpenElement('person');
    xml.writeAttribute('name', 'Alice');
    xml.endOpenElement();
    xml.writeText('Hello, world!');
    xml.closeElement();

    check(
      buffer.toString(),
    ).equals('<person name="Alice">\r\n  Hello, world!\r\n</person>');
  });

  test('write a new line explicitly', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.writeNewLine();

    check(buffer.toString()).equals('\n');
  });

  test('cannot close an element that has not been opened', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    check(xml.closeElement).throws<StateError>();
  });

  test('cannot close an element that is still open', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');

    check(xml.closeElement).throws<StateError>();
  });

  test('cannot end an open element if an element is not open', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    check(xml.endOpenElement).throws<StateError>();
  });

  test('cannot start an open element inside an open element', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');

    check(() => xml.startOpenElement('name')).throws<StateError>();
  });

  test('cannot write text content inside an open element', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    xml.startOpenElement('person');

    check(() => xml.writeText('Hello, world!')).throws<StateError>();
  });

  test('cannot write an attribute if an element is not open', () {
    final buffer = StringBuffer();
    final xml = XmlSink(buffer);

    check(() => xml.writeAttribute('name', 'Alice')).throws<StateError>();
  });
}
