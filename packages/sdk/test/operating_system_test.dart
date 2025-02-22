import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('linux', () {
    check(OperatingSystem.linux)
      ..has((os) => os.isSupported, 'isSupported').isTrue()
      ..has((os) => os.name, 'name').equals('linux')
      ..has((os) => os.toString(), 'toString').equals('OperatingSystem.linux');
  });

  test('macos', () {
    check(OperatingSystem.macos)
      ..has((os) => os.isSupported, 'isSupported').isTrue()
      ..has((os) => os.name, 'name').equals('macos')
      ..has((os) => os.toString(), 'toString').equals('OperatingSystem.macos');
  });

  test('windows', () {
    check(OperatingSystem.windows)
      ..has((os) => os.isSupported, 'isSupported').isTrue()
      ..has((os) => os.name, 'name').equals('windows')
      ..has(
        (os) => os.toString(),
        'toString',
      ).equals('OperatingSystem.windows');
  });

  test('unsupported', () {
    check(OperatingSystem.unsupported('foo'))
      ..has((os) => os.isSupported, 'isSupported').isFalse()
      ..has((os) => os.name, 'name').equals('foo')
      ..has(
        (os) => os.toString(),
        'toString',
      ).equals('OperatingSystem.unsupported(foo)');
  });

  test('== and hashCode', () {
    check(OperatingSystem.linux)
      ..has((os) => os == OperatingSystem.linux, '==').isTrue()
      ..has(
        (os) => os.hashCode,
        'hashCode',
      ).equals(OperatingSystem.linux.hashCode);
  });
}
