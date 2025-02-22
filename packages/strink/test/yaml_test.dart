import 'package:strink/strink.dart';

import '_prelude.dart';

void main() {
  test('writes a key-value pair', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeKeyValue('name', 'Alice');
    yaml.writeKeyValue('age', '30');

    check(buffer.toString()).equals('name: Alice\nage: 30\n');
  });

  test('writes a key-value pair with quoting', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeKeyValue('name', 'Alice', quoteKey: true, quoteValue: true);
    yaml.writeKeyValue('age', '30', quoteKey: true, quoteValue: true);

    check(buffer.toString()).equals('"name": "Alice"\n"age": "30"\n');
  });

  test('writes a list value', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeListValue('Alice');
    yaml.writeListValue('Bob');

    check(buffer.toString()).equals('- Alice\n- Bob\n');
  });

  test('writes a list value with quoting', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeListValue('Alice', quote: true);
    yaml.writeListValue('Bob', quote: true);

    check(buffer.toString()).equals('- "Alice"\n- "Bob"\n');
  });

  test('writes a comment', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeComment('This is a comment');

    check(buffer.toString()).equals('# This is a comment\n');
  });

  test('writes a newline', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.writeNewline();

    check(buffer.toString()).equals('\n');
  });

  test('starts and writes a nested object', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.startObjectOrList('person');
    yaml.writeKeyValue('name', 'Alice');
    yaml.writeKeyValue('age', '30');
    yaml.endObjectOrList();

    check(buffer.toString()).equals('person:\n  name: Alice\n  age: 30\n');
  });

  test('starts and writes a nested object with quoting', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.startObjectOrList('person', quote: true);
    yaml.writeKeyValue('name', 'Alice', quoteKey: true, quoteValue: true);
    yaml.writeKeyValue('age', '30', quoteKey: true, quoteValue: true);
    yaml.endObjectOrList();

    check(
      buffer.toString(),
    ).equals('"person":\n  "name": "Alice"\n  "age": "30"\n');
  });

  test('starts and writes a nested list', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    yaml.startObjectOrList('people');
    yaml.writeListValue('Alice');
    yaml.writeListValue('Bob');
    yaml.endObjectOrList();

    check(buffer.toString()).equals('people:\n  - Alice\n  - Bob\n');
  });

  test('cannot end an object or list without starting one', () {
    final buffer = StringBuffer();
    final yaml = YamlSink(buffer);

    check(yaml.endObjectOrList).throws<StateError>();
  });
}
