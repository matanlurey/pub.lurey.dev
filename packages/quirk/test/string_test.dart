import 'package:quirk/quirk.dart';

import '_prelude.dart';

void main() {
  group('capitalize', () {
    test('returns capitalized string', () {
      check('hello'.capitalize()).equals('Hello');
    });

    test('returns empty string if empty', () {
      check(''.capitalize()).equals('');
    });
  });

  group('splitCamelCase', () {
    test('returns words from camel case string', () {
      check('helloWorld'.splitCamelCase()).deepEquals(['hello', 'World']);
    });

    test('returns empty iterable if empty', () {
      check(''.splitCamelCase()).isEmpty();
    });
  });
}
