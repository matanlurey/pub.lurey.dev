import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('latest', () {
    check(SemanticVersion.latest)
      ..has((v) => v.isLatest, 'isLatest').isTrue()
      ..has((v) => v.name, 'name').equals('latest')
      ..has((v) => v.toString(), 'toString').equals('SemanticVersion.latest');
  });

  test('major.minor.patch', () {
    check(SpecificVersion(1, 2, 3))
      ..has((v) => v.major, 'major').equals(1)
      ..has((v) => v.minor, 'minor').equals(2)
      ..has((v) => v.patch, 'patch').equals(3)
      ..has((v) => v.isLatest, 'isLatest').isFalse()
      ..has((v) => v.name, 'name').equals('1.2.3')
      ..has((v) => v.toString(), 'toString').contains('(1, 2, 3)');
  });

  test('major.minor.patch-pre', () {
    check(SpecificVersion(1, 2, 3, 'pre'))
      ..has((v) => v.major, 'major').equals(1)
      ..has((v) => v.minor, 'minor').equals(2)
      ..has((v) => v.patch, 'patch').equals(3)
      ..has((v) => v.preReleaseSuffix, 'preReleaseSuffix').equals('pre')
      ..has((v) => v.isLatest, 'isLatest').isFalse()
      ..has((v) => v.name, 'name').equals('1.2.3-pre')
      ..has((v) => v.toString(), 'toString').contains('(1, 2, 3, pre)');
  });

  test('== and hashCode', () {
    check(SpecificVersion(1, 2, 3))
      ..has((v) => v == SpecificVersion(1, 2, 3), '==').isTrue()
      ..has(
        (v) => v.hashCode,
        'hashCode',
      ).equals(SpecificVersion(1, 2, 3).hashCode);
  });

  test('tryParse (success)', () {
    check(SpecificVersion.tryParse('1.2.3')).equals(SpecificVersion(1, 2, 3));
    check(
      SpecificVersion.tryParse('1.2.3-pre'),
    ).equals(SpecificVersion(1, 2, 3, 'pre'));
  });

  test('tryParse (failure)', () {
    check(SpecificVersion.tryParse('foo')).isNull();
  });

  test('from (success)', () {
    check(SpecificVersion.parse('1.2.3')).equals(SpecificVersion(1, 2, 3));
    check(
      SpecificVersion.parse('1.2.3-pre'),
    ).equals(SpecificVersion(1, 2, 3, 'pre'));
  });

  test('from (failure)', () {
    check(() => SpecificVersion.parse('foo')).throws<ArgumentError>();
  });

  test('SpecificVersion.compareTo', () {
    final versions = [
      SpecificVersion(1, 2, 3),
      SpecificVersion(1, 2, 4),
      SpecificVersion(1, 3, 3),
      SpecificVersion(2, 2, 3),
      SpecificVersion(1, 2, 3, 'pre'),
      SpecificVersion(1, 2, 3, 'pre2'),
      SpecificVersion(1, 2, 3, 'pre2.1'),
    ]..sort();

    check(versions).deepEquals([
      SpecificVersion(1, 2, 3, 'pre'),
      SpecificVersion(1, 2, 3, 'pre2'),
      SpecificVersion(1, 2, 3, 'pre2.1'),
      SpecificVersion(1, 2, 3),
      SpecificVersion(1, 2, 4),
      SpecificVersion(1, 3, 3),
      SpecificVersion(2, 2, 3),
    ]);
  });
}
