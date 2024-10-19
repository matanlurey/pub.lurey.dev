import 'package:chore/src/internal/dart_test_config.dart';

import '_prelude.dart';

void main() {
  test('"platforms" defaults to null', () {
    final config = DartTest.parseFrom('{}');
    check(config.platforms).isNull();
  });

  test('"platforms" can be set to a list of strings', () {
    final config = DartTest.parseFrom('''
platforms:
  - vm
  - chrome''');
    check(config.platforms).isNotNull().deepEquals(['vm', 'chrome']);
  });
}
