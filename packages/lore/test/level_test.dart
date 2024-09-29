import 'package:lore/lore.dart';

import '_prelude.dart';

void main() {
  test('Level.debug enables debug and higher levels', () {
    check(Level.debug).currentLevel.equals(Level.debug);
    check(Level.debug).isEnabled(Level.debug).isTrue();
    check(Level.debug).isEnabled(Level.status).isTrue();
    check(Level.debug).isEnabled(Level.warning).isTrue();
    check(Level.debug).isEnabled(Level.error).isTrue();
    check(Level.debug).isEnabled(Level.fatal).isTrue();
  });

  test('Level.debug has a name of "debug"', () {
    check(Level.debug).name.equals('debug');
    check(Level.debug).toString$.equals('Level.debug');
  });

  test('Level.debug is the lowest priority', () {
    check(Level.debug).equals(Level.debug);
    check(Level.debug).isLessOrEqual(Level.debug).isTrue();
    check(Level.debug).isGreaterThan(Level.debug).isFalse();
    check(Level.debug).isGreaterOrEqual(Level.debug).isTrue();

    check(Level.debug).isLessThan(Level.status).isTrue();
    check(Level.debug).isLessThan(Level.warning).isTrue();
    check(Level.debug).isLessThan(Level.error).isTrue();
    check(Level.debug).isLessThan(Level.fatal).isTrue();
  });

  test('Level.status enables status and higher levels', () {
    check(Level.status).currentLevel.equals(Level.status);
    check(Level.status).isEnabled(Level.debug).isFalse();
    check(Level.status).isEnabled(Level.status).isTrue();
    check(Level.status).isEnabled(Level.warning).isTrue();
    check(Level.status).isEnabled(Level.error).isTrue();
    check(Level.status).isEnabled(Level.fatal).isTrue();
  });

  test('Level.status has a name of "status"', () {
    check(Level.status).name.equals('status');
    check(Level.status).toString$.equals('Level.status');
  });

  test('Level.status is the second lowest priority', () {
    check(Level.status).equals(Level.status);
    check(Level.status).isLessOrEqual(Level.status).isTrue();
    check(Level.status).isGreaterThan(Level.status).isFalse();
    check(Level.status).isGreaterOrEqual(Level.status).isTrue();

    check(Level.status).isLessThan(Level.debug).isFalse();
    check(Level.status).isLessThan(Level.warning).isTrue();
    check(Level.status).isLessThan(Level.error).isTrue();
    check(Level.status).isLessThan(Level.fatal).isTrue();
  });

  test('Level.warning enables warning and higher levels', () {
    check(Level.warning).currentLevel.equals(Level.warning);
    check(Level.warning).isEnabled(Level.debug).isFalse();
    check(Level.warning).isEnabled(Level.status).isFalse();
    check(Level.warning).isEnabled(Level.warning).isTrue();
    check(Level.warning).isEnabled(Level.error).isTrue();
    check(Level.warning).isEnabled(Level.fatal).isTrue();
  });

  test('Level.warning has a name of "warning"', () {
    check(Level.warning).name.equals('warning');
    check(Level.warning).toString$.equals('Level.warning');
  });

  test('Level.warning is the third lowest priority', () {
    check(Level.warning).equals(Level.warning);
    check(Level.warning).isLessOrEqual(Level.warning).isTrue();
    check(Level.warning).isGreaterThan(Level.warning).isFalse();
    check(Level.warning).isGreaterOrEqual(Level.warning).isTrue();

    check(Level.warning).isLessThan(Level.debug).isFalse();
    check(Level.warning).isLessThan(Level.status).isFalse();
    check(Level.warning).isLessThan(Level.error).isTrue();
    check(Level.warning).isLessThan(Level.fatal).isTrue();
  });

  test('Level.error enables error and higher levels', () {
    check(Level.error).currentLevel.equals(Level.error);
    check(Level.error).isEnabled(Level.debug).isFalse();
    check(Level.error).isEnabled(Level.status).isFalse();
    check(Level.error).isEnabled(Level.warning).isFalse();
    check(Level.error).isEnabled(Level.error).isTrue();
    check(Level.error).isEnabled(Level.fatal).isTrue();
  });

  test('Level.error has a name of "error"', () {
    check(Level.error).name.equals('error');
    check(Level.error).toString$.equals('Level.error');
  });

  test('Level.error is the fourth lowest priority', () {
    check(Level.error).equals(Level.error);
    check(Level.error).isLessOrEqual(Level.error).isTrue();
    check(Level.error).isGreaterThan(Level.error).isFalse();
    check(Level.error).isGreaterOrEqual(Level.error).isTrue();

    check(Level.error).isLessThan(Level.debug).isFalse();
    check(Level.error).isLessThan(Level.status).isFalse();
    check(Level.error).isLessThan(Level.warning).isFalse();
    check(Level.error).isLessThan(Level.fatal).isTrue();
  });

  test('Level.fatal enables fatal and higher levels', () {
    check(Level.fatal).currentLevel.equals(Level.fatal);
    check(Level.fatal).isEnabled(Level.debug).isFalse();
    check(Level.fatal).isEnabled(Level.status).isFalse();
    check(Level.fatal).isEnabled(Level.warning).isFalse();
    check(Level.fatal).isEnabled(Level.error).isFalse();
    check(Level.fatal).isEnabled(Level.fatal).isTrue();
  });

  test('Level.fatal has a name of "fatal"', () {
    check(Level.fatal).name.equals('fatal');
    check(Level.fatal).toString$.equals('Level.fatal');
  });

  test('Level.fatal is the highest priority', () {
    check(Level.fatal).equals(Level.fatal);
    check(Level.fatal).isLessOrEqual(Level.fatal).isTrue();
    check(Level.fatal).isGreaterThan(Level.fatal).isFalse();
    check(Level.fatal).isGreaterOrEqual(Level.fatal).isTrue();

    check(Level.fatal).isLessThan(Level.debug).isFalse();
    check(Level.fatal).isLessThan(Level.status).isFalse();
    check(Level.fatal).isLessThan(Level.warning).isFalse();
    check(Level.fatal).isLessThan(Level.error).isFalse();
  });

  test('Level.tryParse returns a Level', () {
    check(Level.tryParse('debug')).equals(Level.debug);
    check(Level.tryParse('status')).equals(Level.status);
    check(Level.tryParse('warning')).equals(Level.warning);
    check(Level.tryParse('error')).equals(Level.error);
    check(Level.tryParse('fatal')).equals(Level.fatal);
  });

  test('Level.tryParse returns null for invalid levels', () {
    check(Level.tryParse('')).isNull();
    check(Level.tryParse('DEBUG')).isNull();
  });

  test('Level.parse returns a Level', () {
    check(Level.parse('debug')).equals(Level.debug);
    check(Level.parse('status')).equals(Level.status);
    check(Level.parse('warning')).equals(Level.warning);
    check(Level.parse('error')).equals(Level.error);
    check(Level.parse('fatal')).equals(Level.fatal);
  });

  test('Level.parse throws for invalid levels', () {
    check(() => Level.parse('')).throws<FormatException>();
    check(() => Level.parse('DEBUG')).throws<FormatException>();
  });

  test('Level.values is every level in priority order', () {
    check(Level.values).deepEquals([
      Level.debug,
      Level.status,
      Level.warning,
      Level.error,
      Level.fatal,
    ]);
  });
}
