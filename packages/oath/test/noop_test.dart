import 'package:oath/src/_noop.dart';
import 'package:test/test.dart';

void main() {
  test('checks that the package resolved', () {
    expect(noop, returnsNormally);
  });
}
